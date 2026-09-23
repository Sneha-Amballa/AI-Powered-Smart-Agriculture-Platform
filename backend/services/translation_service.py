"""
Centralized Translation Service for KisanAI backend.

Uses LibreTranslate (free/open-source) for dynamic content translation.
- Configurable endpoint via LIBRETRANSLATE_URL
- Optional API key via LIBRETRANSLATE_API_KEY
- In-memory LRU cache for repeated translations
- Graceful fallback: returns original text on failure
- Skips translation if target_lang == source_lang == "en"
"""

import logging
from collections import OrderedDict
from typing import Dict, List, Optional, Tuple

import httpx

from backend.core.config import settings

logger = logging.getLogger(__name__)

# Language code mapping: app codes → LibreTranslate codes
# LibreTranslate uses ISO 639-1 codes; most Indian languages use the same.
LIBRETRANSLATE_LANG_MAP: Dict[str, str] = {
    "en": "en",
    "hi": "hi",
    "te": "te",
    "ta": "ta",
    "kn": "kn",
    "mr": "mr",
    "bn": "bn",
    "gu": "gu",
    "pa": "pa",
    "ml": "ml",
    "or": "or",
}

# Languages confirmed available on most LibreTranslate instances
# Others may not be supported; we handle this gracefully
WELL_SUPPORTED_LANGS = {"en", "hi"}


class LRUCache:
    """Simple LRU cache with max size for translation caching."""

    def __init__(self, max_size: int = 1000):
        self._cache: OrderedDict[str, str] = OrderedDict()
        self._max_size = max_size

    def get(self, key: str) -> Optional[str]:
        if key in self._cache:
            self._cache.move_to_end(key)
            return self._cache[key]
        return None

    def put(self, key: str, value: str) -> None:
        if key in self._cache:
            self._cache.move_to_end(key)
        else:
            if len(self._cache) >= self._max_size:
                self._cache.popitem(last=False)
        self._cache[key] = value


class TranslationService:
    """Centralized translation service using LibreTranslate.

    Usage:
        service = TranslationService()
        translated = await service.translate("Hello farmer", target_lang="hi")
        batch = await service.translate_batch(["Hello", "Weather is clear"], target_lang="te")
    """

    def __init__(
        self,
        base_url: Optional[str] = None,
        api_key: Optional[str] = None,
        cache_size: int = 1000,
        timeout: float = 10.0,
    ):
        self.base_url = (base_url or settings.LIBRETRANSLATE_URL).rstrip("/")
        self.api_key = api_key or settings.LIBRETRANSLATE_API_KEY
        self._cache = LRUCache(max_size=cache_size)
        self._timeout = timeout
        self._supported_langs: Optional[set] = None

    def _cache_key(self, text: str, source: str, target: str) -> str:
        return f"{source}:{target}:{text}"

    async def _check_language_support(self, lang: str) -> bool:
        """Check if LibreTranslate instance supports the given language."""
        if self._supported_langs is not None:
            return lang in self._supported_langs

        try:
            async with httpx.AsyncClient(timeout=self._timeout) as client:
                resp = await client.get(f"{self.base_url}/languages")
                if resp.status_code == 200:
                    langs_data = resp.json()
                    self._supported_langs = {
                        item.get("code", "") for item in langs_data
                    }
                    return lang in self._supported_langs
        except Exception as e:
            logger.warning(f"TranslationService: Could not fetch supported languages: {e}")

        # Fallback: assume well-known languages are supported
        return lang in WELL_SUPPORTED_LANGS

    async def translate(
        self,
        text: str,
        target_lang: str,
        source_lang: str = "en",
    ) -> str:
        """Translate a single text string.

        Returns the original text if:
        - target_lang == source_lang
        - translation fails
        - target language is not supported
        """
        if not text or not text.strip():
            return text

        # No translation needed
        if target_lang == source_lang:
            return text

        # Map to LibreTranslate language code
        lt_target = LIBRETRANSLATE_LANG_MAP.get(target_lang, target_lang)
        lt_source = LIBRETRANSLATE_LANG_MAP.get(source_lang, source_lang)

        # Check cache
        cache_key = self._cache_key(text, lt_source, lt_target)
        cached = self._cache.get(cache_key)
        if cached is not None:
            return cached

        # Check language support
        if not await self._check_language_support(lt_target):
            logger.info(
                f"TranslationService: Language '{lt_target}' not supported. Returning original text."
            )
            return text

        # Call LibreTranslate
        try:
            payload = {
                "q": text,
                "source": lt_source,
                "target": lt_target,
                "format": "text",
            }
            if self.api_key:
                payload["api_key"] = self.api_key

            async with httpx.AsyncClient(timeout=self._timeout) as client:
                resp = await client.post(
                    f"{self.base_url}/translate",
                    json=payload,
                )

                if resp.status_code == 200:
                    data = resp.json()
                    translated = data.get("translatedText", text)
                    self._cache.put(cache_key, translated)
                    return translated
                else:
                    logger.warning(
                        f"TranslationService: LibreTranslate returned {resp.status_code}: {resp.text[:200]}"
                    )
                    return text

        except Exception as e:
            logger.warning(f"TranslationService: Translation failed for '{text[:50]}...': {e}")
            return text

    async def translate_batch(
        self,
        texts: List[str],
        target_lang: str,
        source_lang: str = "en",
    ) -> List[str]:
        """Translate multiple text strings.

        Optimizes by:
        - Skipping empty strings
        - Using cache for already-translated strings
        - Batching remaining strings into individual calls
          (LibreTranslate doesn't support native batching in all instances)
        """
        if not texts:
            return []

        if target_lang == source_lang:
            return list(texts)

        results: List[str] = []
        for text in texts:
            translated = await self.translate(
                text, target_lang=target_lang, source_lang=source_lang
            )
            results.append(translated)

        return results


# Module-level singleton
translation_service = TranslationService()
