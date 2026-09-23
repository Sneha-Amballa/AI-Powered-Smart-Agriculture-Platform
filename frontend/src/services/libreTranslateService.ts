import React, { useState, useEffect } from 'react';
import { LanguageCode } from '../types';

/**
 * Cache storage key in localStorage
 */
const CACHE_STORAGE_KEY = 'kisan_libretranslate_cache';

/**
 * Public LibreTranslate endpoints with fallback mirrors.
 * Can be overridden via VITE_LIBRETRANSLATE_URL environment variable.
 */
const LIBRETRANSLATE_ENDPOINTS = [
  (import.meta as any).env?.VITE_LIBRETRANSLATE_URL,
  'https://translate.terraprint.co/translate',
  'https://translate.argosopentech.com/translate',
  'https://libretranslate.de/translate',
  'https://libretranslate.com/translate',
].filter(Boolean) as string[];

/**
 * In-memory cache backed by localStorage to avoid repeated localStorage parsing
 */
let memoryCache: Record<string, string> = {};

function initCache(): Record<string, string> {
  if (typeof window === 'undefined') return {};
  try {
    const raw = localStorage.getItem(CACHE_STORAGE_KEY);
    if (raw) {
      return JSON.parse(raw);
    }
  } catch (e) {
    console.warn('Failed to parse LibreTranslate localStorage cache:', e);
  }
  return {};
}

// Initialize memory cache
memoryCache = initCache();

function saveToStorageCache(cache: Record<string, string>) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(CACHE_STORAGE_KEY, JSON.stringify(cache));
  } catch (e) {
    // If quota exceeded, clear older entries or log warning
    console.warn('Failed to save to localStorage translation cache:', e);
  }
}

/**
 * Generate a deterministic cache key for a given target language and source text
 */
function getCacheKey(text: string, targetLang: LanguageCode): string {
  return `${targetLang}:${text.trim()}`;
}

/**
 * Get synchronously cached translation if available
 */
export function getCachedTranslation(text: string, targetLang: LanguageCode): string | null {
  if (!text || !text.trim() || targetLang === 'en') {
    return text;
  }
  const key = getCacheKey(text, targetLang);
  return memoryCache[key] || null;
}

/**
 * Set translation into in-memory and localStorage cache
 */
export function setCachedTranslation(text: string, targetLang: LanguageCode, translated: string) {
  if (!text || !text.trim() || targetLang === 'en' || !translated) return;
  const key = getCacheKey(text, targetLang);
  memoryCache[key] = translated;
  saveToStorageCache(memoryCache);
}

/**
 * Clear translation cache if needed
 */
export function clearTranslationCache() {
  memoryCache = {};
  if (typeof window !== 'undefined') {
    localStorage.removeItem(CACHE_STORAGE_KEY);
  }
}

/**
 * Request translation from LibreTranslate API with timeout and endpoint fallback.
 * Falls back safely to English text if all endpoints fail or time out.
 */
async function fetchTranslationFromAPI(
  text: string,
  targetLang: LanguageCode,
  sourceLang: string = 'en'
): Promise<string> {
  for (const endpoint of LIBRETRANSLATE_ENDPOINTS) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 3500); // 3.5s timeout per mirror

      const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
        },
        body: JSON.stringify({
          q: text,
          source: sourceLang,
          target: targetLang,
          format: 'text',
          api_key: '',
        }),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        continue; // Try next endpoint
      }

      const data = await response.json();
      if (data && typeof data.translatedText === 'string' && data.translatedText.trim()) {
        return data.translatedText;
      }
    } catch {
      // Aborted or network failed on this endpoint, try next mirror
      continue;
    }
  }

  // If all LibreTranslate mirrors are unavailable or fail, fall back to original English text
  return text;
}

/**
 * Translate a string using LibreTranslate with localStorage caching and English fallback.
 *
 * @param text The English text to translate
 * @param targetLang The language code ('en', 'te', 'hi')
 * @param sourceLang Optional source language (defaults to 'en')
 * @returns Translated text or original text as fallback
 */
export async function translateText(
  text: string,
  targetLang: LanguageCode,
  sourceLang: string = 'en'
): Promise<string> {
  const trimmed = text?.trim();
  if (!trimmed) return text;

  // If target language is English or matches source, return text directly
  if (targetLang === 'en' || targetLang === sourceLang) {
    return text;
  }

  // Check localStorage cache first
  const cached = getCachedTranslation(trimmed, targetLang);
  if (cached) {
    return cached;
  }

  try {
    const translated = await fetchTranslationFromAPI(trimmed, targetLang, sourceLang);
    if (translated && translated !== trimmed) {
      setCachedTranslation(trimmed, targetLang, translated);
      return translated;
    }
    return text;
  } catch (err) {
    console.warn(`Translation to ${targetLang} failed. Falling back to English:`, err);
    return text;
  }
}

/**
 * Translate a batch of strings in parallel with caching
 */
export async function translateBatch(
  texts: string[],
  targetLang: LanguageCode,
  sourceLang: string = 'en'
): Promise<string[]> {
  if (targetLang === 'en') return texts;

  return Promise.all(
    texts.map((item) => translateText(item, targetLang, sourceLang))
  );
}

/**
 * Reusable React Hook for dynamic translation with immediate cache retrieval,
 * automatic fallback to English, and background fetching if not cached.
 */
export function useDynamicTranslation(
  text: string,
  targetLang: LanguageCode
): { translated: string; loading: boolean } {
  const cached = getCachedTranslation(text, targetLang);
  const [translated, setTranslated] = useState<string>(cached || text);
  const [loading, setLoading] = useState<boolean>(!cached && targetLang !== 'en');

  useEffect(() => {
    if (!text) {
      setTranslated('');
      setLoading(false);
      return;
    }

    if (targetLang === 'en') {
      setTranslated(text);
      setLoading(false);
      return;
    }

    const currentCached = getCachedTranslation(text, targetLang);
    if (currentCached) {
      setTranslated(currentCached);
      setLoading(false);
      return;
    }

    let isMounted = true;
    setLoading(true);

    translateText(text, targetLang)
      .then((res) => {
        if (isMounted) {
          setTranslated(res);
          setLoading(false);
        }
      })
      .catch(() => {
        if (isMounted) {
          setTranslated(text);
          setLoading(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [text, targetLang]);

  return { translated, loading };
}

/**
 * Simple, reusable, farmer-friendly component for dynamic translations.
 * Renders English immediately and gracefully transitions to translated text once available.
 * If LibreTranslate fails or is offline, English text is preserved without breaking the UI.
 *
 * Example:
 * <Translate text="Soil moisture is adequate. No irrigation needed today." targetLang={currentLanguage} />
 */
export const Translate: React.FC<{
  text: string;
  targetLang: LanguageCode;
  className?: string;
  as?: React.ElementType;
}> = ({ text, targetLang, className, as: Component = 'span' }) => {
  const { translated } = useDynamicTranslation(text, targetLang);
  return React.createElement(Component, { className }, translated);
};
