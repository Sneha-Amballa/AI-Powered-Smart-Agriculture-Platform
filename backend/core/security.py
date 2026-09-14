import os
import secrets
from datetime import datetime, timedelta, timezone
from typing import Any, Optional, Union
import jwt

try:
    import bcrypt

    HAS_BCRYPT = True
except ImportError:
    HAS_BCRYPT = False
    import hashlib

from backend.core.config import settings


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify plain password against hashed password."""
    if HAS_BCRYPT:
        try:
            return bcrypt.checkpw(
                plain_password.encode("utf-8"), hashed_password.encode("utf-8")
            )
        except Exception:
            return False
    else:
        # Fallback to PBKDF2
        try:
            salt_hex, key_hex = hashed_password.split("$")
            salt = bytes.fromhex(salt_hex)
            computed_key = hashlib.pbkdf2_hmac(
                "sha256", plain_password.encode("utf-8"), salt, 100000
            )
            return secrets.compare_digest(computed_key.hex(), key_hex)
        except Exception:
            return False


def get_password_hash(password: str) -> str:
    """Generate secure hash for password."""
    if HAS_BCRYPT:
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(password.encode("utf-8"), salt)
        return hashed.decode("utf-8")
    else:
        # Fallback to PBKDF2
        salt = os.urandom(16)
        key = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, 100000)
        return f"{salt.hex()}${key.hex()}"


def create_access_token(
    subject: Union[str, Any], expires_delta: Optional[timedelta] = None
) -> str:
    """Create signed JWT access token for authentication."""
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )

    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(
        to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM
    )
    return encoded_jwt


def decode_access_token(token: str) -> Optional[dict]:
    """Decode and validate a JWT access token."""
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        return payload
    except Exception:
        return None
