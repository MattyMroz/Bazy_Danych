# 06 — Function & API Design

> **Cel:** Kompletne reguły projektowania funkcji, sygnatur i publicznych API w Pythonie — od filozofii SRP po deprecation i egzekucję ruff.
> **Scope:** Uniwersalny — Python ≥3.10, `from __future__ import annotations`, ruff 120 chars, mypy strict, pydantic.

---

## Spis treści

1. [Filozofia projektowania funkcji](#1-filozofia-projektowania-funkcji)
2. [Parametry — tabela decyzyjna](#2-parametry--tabela-decyzyjna)
3. [Typy zwracane — tabela decyzyjna](#3-typy-zwracane--tabela-decyzyjna)
4. [Kompozycja i pure functions](#4-kompozycja-i-pure-functions)
5. [Sygnatura jako kontrakt](#5-sygnatura-jako-kontrakt)
6. [Public API i interfejs modułu](#6-public-api-i-interfejs-modułu)
7. [Deprecation i ewolucja API](#7-deprecation-i-ewolucja-api)
8. [Antypatterny](#8-antypatterny)
9. [Egzekucja ruff](#9-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła | Wartość |
|---|--------|---------|
| 1 | Max linii ciała funkcji | 30 (sweet spot: 15–20) |
| 2 | Max parametrów | 5 → powyżej config object |
| 3 | Max zagnieżdżeń | 2 |
| 4 | Boolean params | ZAWSZE keyword-only |
| 5 | Mutable defaults | NIGDY → `None` + check |
| 6 | Raw tuple return | NIGDY → `NamedTuple` |
| 7 | Bare dict return | NIGDY → typed (TypedDict/dataclass/pydantic) |
| 8 | `@overload` warianty | Max 2–3; więcej → osobne funkcje |
| 9 | `__all__` | ZAWSZE w library/package modules |
| 10 | `warnings.warn` stacklevel | ZAWSZE `2` |
| 11 | Deprecation message | ZAWSZE: co użyć zamiast + wersja removal |
| 12 | Side effects | TYLKO na brzegach; core logic = pure functions |
| 13 | Docstring | PRZED implementacją (doc-driven design) |
| 14 | `from __future__ import annotations` | KAŻDY moduł, pierwsza linia |

---

## 1. Filozofia projektowania funkcji

### 1.1 Single Responsibility — jedna funkcja, jedno zadanie

| Reguła | Wartość | Dlaczego | Kiedy NIE |
|--------|---------|----------|-----------|
| Max linii ciała | **30** (hard limit) | Dłuższa → gorzej testowalna, trudniejsza do review | Nigdy nie przekraczaj — rozbij na helpery |
| Sweet spot | **15–20 linii** | Mieści się na ekranie, łatwe do zrozumienia w 10s | — |
| Max parametrów | **5** | Google Style Guide; więcej → config object | Wewnętrzne helpery mogą mieć 6 jeśli delegują |
| Max zagnieżdżeń | **2 poziomy** | Głębsze → extract inner block do osobnej funkcji | — |
| Max return types | **1 kształt** | `str | None` to OK (1 kształt + brak); `str | int | list` → overload lub redesign | `@overload` gdy 2–3 distinct shapes |

> **Linie vs statements:** 30 linii to limit **czytelności** (human readability, mieści się na ekranie). ruff `PLR0915` mierzy **statements** (logiczne instrukcje) — to inny wymiar. Funkcja 20 linii może mieć 15 statements (gęsta logika) albo 8 (docstring + spacing). Oba limity obowiązują niezależnie: max 30 linii **I** max 30 statements (nasz próg, patrz sekcja 9.3).

### 1.2 Sygnały że funkcja jest za duża

| Sygnał | Dlaczego to problem | Akcja |
|--------|---------------------|-------|
| >5 parametrów | Zbyt wiele odpowiedzialności | Refactor → dataclass/pydantic config |
| >2 poziomy zagnieżdżenia | Trudna do śledzenia logika | Extract inner block → osobna funkcja |
| >1 logiczny return type | Funkcja robi różne rzeczy | Split na dwie funkcje lub `@overload` |
| Komentarze "step 1", "step 2" | Ukryte podfunkcje | Każdy step → osobna funkcja |
| `# TODO: refactor` wewnątrz | Dług techniczny | Refaktoruj teraz, nie "kiedyś" |
| Mieszanie I/O z logiką | Nietestowalna czysta logika | Wydziel pure function + thin I/O wrapper |
| Scrollowanie by zobaczyć koniec | Za długa na ekran | Rozbij — sweet spot to 15–20 linii |

### 1.3 Doc-driven design

Napisz docstring **ZANIM** napiszesz implementację. Docstring jest kontraktem — jeśli nie potrafisz go napisać w 3 zdaniach, funkcja robi za dużo.

```python
# ✅ Doc-driven: kontrakt PRZED implementacją
from __future__ import annotations

def normalize_page_dimensions(
    width: int,
    height: int,
    *,
    max_size: int = 4096,
) -> tuple[int, int]:
    """Skaluj wymiary strony proporcjonalnie do max_size.

    Args:
        width: Szerokość w pikselach (>0).
        height: Wysokość w pikselach (>0).
        max_size: Maksymalny wymiar dłuższego boku.

    Returns:
        Para (new_width, new_height) zachowująca proporcje.

    Raises:
        ValueError: Gdy width lub height ≤ 0.
    """
    if width <= 0 or height <= 0:
        msg = f"Dimensions must be positive, got {width}x{height}"
        raise ValueError(msg)
    scale = min(max_size / max(width, height), 1.0)
    return round(width * scale), round(height * scale)
```

```python
# ❌ Implementacja bez kontraktu — nikt nie wie co funkcja robi
from __future__ import annotations

def norm(w, h, m=4096):
    s = min(m / max(w, h), 1.0)
    return round(w * s), round(h * s)
```

---

## 2. Parametry — tabela decyzyjna

### 2.1 Główna tabela typów parametrów

| Typ parametru | Syntax | KIEDY | KIEDY NIE | Przykład |
|---------------|--------|-------|-----------|----------|
| Positional-only | `param, /` | Stable public API; nazwy mogą się zmienić | Internal code, mało parametrów | `def len(obj, /)` |
| Keyword-only | `*, param` | Boolean flags, opcje konfiguracyjne, clarity | Jedyny wymagany parametr | `def fetch(url, *, timeout: int = 30)` |
| Default value (immutable) | `param: int = 0` | Sensowna wartość domyślna istnieje | Brak logicznego default | `max_retries: int = 3` |
| Default `None` (sentinel) | `param: X \| None = None` | "Brak wartości" ma semantykę; mutowalny type hint | Wartość jest zawsze wymagana | `callback: Callable \| None = None` |
| `*args` | `*args: str` | Homogeniczna sekwencja, delegation do innej funkcji | Heterogeniczne typy; >1 *args | `def log(*messages: str)` |
| `**kwargs` | `**kwargs: Any` | Forwarding do warstwy niżej (framework, decorator) | Jako "worek na wszystko" — użyj explicit params | `def wrapper(**kwargs: Any)` |

### 2.2 Kolejność parametrów — konwencja

```
def func(
    required_positional,       # 1. Wymagane pozycyjne
    optional_positional=None,  # 2. Opcjonalne pozycyjne z default
    /,                         # 3. Positional-only marker
    regular_param,             # 4. Normalne (positional-or-keyword)
    *,                         # 5. Keyword-only marker
    keyword_only=False,        # 6. Keyword-only z default
    **kwargs,                  # 7. Reszta
) -> Result:
```

### 2.3 Mutable defaults — TRAP

| Wzorzec | Bezpieczny? | Dlaczego |
|---------|-------------|----------|
| `def f(items: list[str] = [])` | ❌ **NIE** | Lista jest współdzielona między wywołaniami — mutacja persystuje |
| `def f(items: list[str] \| None = None)` | ✅ TAK | `None` → nowa lista w ciele funkcji |
| `def f(items: Sequence[str] = ())` | ✅ TAK | Tuple jest immutable — bezpieczny default |

```python
# ✅ Bezpieczny wzorzec z None sentinel
from __future__ import annotations

def process_pages(
    pages: list[int] | None = None,
    *,
    reverse: bool = False,
) -> list[int]:
    """Przetwórz listę numerów stron."""
    effective_pages = pages if pages is not None else []
    return sorted(effective_pages, reverse=reverse)
```

```python
# ❌ Mutable default — współdzielony obiekt między wywołaniami
from __future__ import annotations

def process_pages(
    pages: list[int] = [],  # noqa: B006 — ruff to złapie
    reverse: bool = False,
) -> list[int]:
    return sorted(pages, reverse=reverse)
```

### 2.4 Parametry boolean — reguły

| Reguła | Dlaczego | Przykład |
|--------|----------|---------|
| Boolean param → **ZAWSZE** keyword-only | `fetch(url, True)` jest nieczytelne | `def fetch(url: str, *, verbose: bool = False)` |
| >1 boolean w funkcji → refactor | Kombinatoryczna eksplozja zachowań | Użyj enum lub config dataclass |
| Nazewnictwo: prefix `is_`, `has_`, `should_`, `enable_` | Czytelność predykatu | `enable_cache: bool = True` |

```python
# ✅ Boolean jako keyword-only z jasną nazwą
from __future__ import annotations

def download_model(
    url: str,
    dest: Path,
    *,
    overwrite_existing: bool = False,
    verify_hash: bool = True,
) -> Path:
    """Pobierz model do dest."""
    ...
```

```python
# ❌ Boolean jako positional — nikt nie wie co True znaczy
from __future__ import annotations

def download_model(url: str, dest: Path, overwrite: bool, verify: bool) -> Path:
    ...

# Wywołanie: download_model(url, dest, True, False)  — ???
```

### 2.5 >5 parametrów → config object

```python
# ✅ Config object zamiast god-signature
from __future__ import annotations

from pydantic import BaseModel, Field

class TranslationConfig(BaseModel):
    source_lang: str = "ja"
    target_lang: str = "pl"
    max_tokens: int = Field(default=2048, gt=0)
    temperature: float = Field(default=0.3, ge=0.0, le=2.0)
    retry_count: int = Field(default=3, ge=0)
    timeout_seconds: float = Field(default=30.0, gt=0)

def translate_text(text: str, *, config: TranslationConfig | None = None) -> str:
    """Translacja tekstu z konfiguracją."""
    cfg = config or TranslationConfig()
    ...
```

```python
# ❌ God-signature — 8 parametrów, nieczytelne wywołanie
from __future__ import annotations

def translate_text(
    text: str,
    source_lang: str = "ja",
    target_lang: str = "pl",
    max_tokens: int = 2048,
    temperature: float = 0.3,
    retry_count: int = 3,
    timeout: float = 30.0,
    model: str = "gpt-4",
) -> str:
    ...
```

---

## 3. Typy zwracane — tabela decyzyjna

### 3.1 Główna tabela

| Sytuacja | Typ zwracany | Dlaczego | Kiedy NIE | Przykład |
|----------|-------------|-----|----------|---------|
| Pojedyncza wartość | Explicit annotation | Czytelność, mypy check | — | `-> str` |
| Kilka wartości | `NamedTuple` | Nazwy pól > indeksy; destrukturyzacja | NIGDY raw `tuple` | `-> PageDimensions` |
| Brak wyniku (side effect) | `-> None` | Explicit intent | — | `-> None` |
| Opcjonalny wynik | `X \| None` | "Nie znaleziono" jest poprawnym stanem | Gdy brak = błąd → raise | `-> Page \| None` |
| Wynik lub error | Raise exception | Caller MUSI obsłużyć; nie ignoruje jak `None` | Gdy brak wyniku jest normalny | `raise PageNotFoundError` |
| Duża kolekcja / lazy | `Iterator[X]` / `Generator` | Memory efficient; lazy evaluation | Gdy caller potrzebuje random access | `-> Iterator[Page]` |
| Dict-like | `TypedDict` / dataclass / pydantic | Typed keys, IDE support, validation | NIGDY bare `dict` | `-> PageMetadata` |
| Predykat | `-> bool` | Jasny TAK/NIE | NIE jako "czy się udało" — rzuć wyjątek | `-> bool` (`is_valid()`) |

### 3.2 NamedTuple zamiast raw tuple

```python
# ✅ NamedTuple — czytelna destrukturyzacja, type-safe
from __future__ import annotations

from typing import NamedTuple

class BBoxResult(NamedTuple):
    x: int
    y: int
    width: int
    height: int

def detect_panel(image: np.ndarray) -> BBoxResult:
    """Wykryj panel na stronie mangi."""
    ...
    return BBoxResult(x=10, y=20, width=300, height=400)

# Użycie: czytelne
result = detect_panel(img)
print(result.width, result.height)
```

```python
# ❌ Raw tuple — co jest pod indeksem 2?
from __future__ import annotations

def detect_panel(image: np.ndarray) -> tuple[int, int, int, int]:
    ...
    return (10, 20, 300, 400)

# Użycie: nikt nie wie co to jest
result = detect_panel(img)
print(result[2], result[3])  # ???
```

### 3.3 Generator vs Lista — tabela decyzyjna

| Kryterium | `list` | `Iterator` / `Generator` | Dlaczego |
|-----------|--------|--------------------------|----------|
| Rozmiar danych | Mały / znany | Duży / nieznany / potencjalnie nieskończony | Memory: lista alokuje wszystko naraz |
| Random access potrzebny? | TAK → list | NIE → iterator | Iterator jest forward-only |
| Wielokrotna iteracja? | TAK → list | NIE → iterator | Iterator wyczerpuje się po jednym przebiegu |
| Lazy processing pipeline | NIE | TAK → generator | Chain generatorów = zero intermediate lists |
| Caller oczekuje `len()`? | TAK → list | NIE → iterator | Iterator nie ma długości |

```python
# ✅ Generator dla pipeline — zero alokacji intermediate list
from __future__ import annotations

from collections.abc import Iterator
from pathlib import Path

def iter_manga_pages(directory: Path) -> Iterator[Path]:
    """Lazy iterator po plikach stron mangi."""
    for path in sorted(directory.iterdir()):
        if path.suffix.lower() in {".png", ".jpg", ".webp"}:
            yield path
```

```python
# ❌ Lista gdy nie trzeba — alokuje całość do pamięci
from __future__ import annotations

from pathlib import Path

def get_manga_pages(directory: Path) -> list[Path]:
    """Ładuje WSZYSTKO do pamięci nawet dla 10 000 plików."""
    result = []
    for path in sorted(directory.iterdir()):
        if path.suffix.lower() in {".png", ".jpg", ".webp"}:
            result.append(path)
    return result
```

### 3.4 Spójny return — NIGDY nie mieszaj

| Wzorzec | OK? | Dlaczego |
|---------|-----|----------|
| Zawsze zwraca wartość | ✅ | Caller ma spójny kontrakt |
| Zawsze rzuca wyjątek przy braku | ✅ | Explicit error handling |
| Czasem zwraca, czasem `None`, czasem rzuca | ❌ | Caller nie wie czego się spodziewać |

```python
# ✅ Spójny kontrakt: zawsze zwraca lub ZAWSZE rzuca
from __future__ import annotations

def get_page_or_raise(page_id: int) -> Page:
    """Zwróć stronę lub rzuć PageNotFoundError."""
    page = _repo.find(page_id)
    if page is None:
        raise PageNotFoundError(page_id)
    return page

def find_page(page_id: int) -> Page | None:
    """Zwróć stronę lub None jeśli nie istnieje."""
    return _repo.find(page_id)
```

```python
# ❌ Niespójny return — caller musi obsłużyć None I wyjątek
from __future__ import annotations

def get_page(page_id: int) -> Page | None:
    if page_id < 0:
        raise ValueError("negative id")  # Rzuca!
    return _repo.find(page_id)  # Ale tu zwraca None!
```

> **Powiązane:** `@property` jako accessor — patrz [07-class-protocol-design.md](07-class-protocol-design.md) sekcja 7.

---

## 4. Kompozycja i pure functions

### 4.1 Pure vs Impure — tabela decyzyjna

| Cecha | Pure function | Impure function |
|-------|---------------|-----------------|
| Side effects | ZERO | I/O, mutacja stanu, logi |
| Determinism | Same input → same output | Wynik zależy od czasu, sieci, stanu |
| Testowalność | Trywialna — assert in/out | Wymaga mock/patch |
| Gdzie stosować | Logika biznesowa, transformacje, walidacja | Granice systemu: I/O, HTTP, DB |
| Cacheable? | TAK — `functools.cache` bezpieczny | NIE — wynik się zmienia |

### 4.2 Wzorzec: side effects na brzegach

```
Read (impure) → Compute (pure) → Write (impure)
```

| Warstwa | Typ | Odpowiedzialność | Testowanie |
|---------|-----|------------------|------------|
| **Read** | Impure | Pobierz dane z I/O | Integration test |
| **Compute** | Pure | Transformuj, waliduj, oblicz | Unit test (trivial) |
| **Write** | Impure | Zapisz wynik do I/O | Integration test |

```python
# ✅ Separacja: pure compute + impure I/O na brzegach
from __future__ import annotations

from pathlib import Path

# Pure — łatwo testowalna bez I/O
def compute_output_path(input_path: Path, *, suffix: str = "_translated") -> Path:
    """Oblicz ścieżkę wyjściową na podstawie wejściowej."""
    return input_path.with_stem(f"{input_path.stem}{suffix}")

# Impure — thin wrapper, logika minimalna
def save_translated_page(input_path: Path, data: bytes) -> Path:
    """Zapisz przetłumaczoną stronę do computed path."""
    output = compute_output_path(input_path)
    output.write_bytes(data)
    return output
```

```python
# ❌ Pure logic spleciona z I/O — nie da się unit-testować compute
from __future__ import annotations

from pathlib import Path

def save_translated_page(input_path: Path, data: bytes) -> Path:
    output = input_path.with_stem(f"{input_path.stem}_translated")  # logika
    output.write_bytes(data)  # I/O
    if not output.exists():  # I/O
        raise RuntimeError("Save failed")
    return output
```

### 4.3 Dependency Injection zamiast globali

```python
# ✅ Inject dependency — testowalne, wymienne
from __future__ import annotations

from collections.abc import Callable

def retry_operation(
    operation: Callable[[], str],
    *,
    max_attempts: int = 3,
    sleep_fn: Callable[[float], None] = time.sleep,
) -> str:
    """Ponów operację z injected sleep (testowalne)."""
    for attempt in range(max_attempts):
        try:
            return operation()
        except TransientError:
            if attempt == max_attempts - 1:
                raise
            sleep_fn(2 ** attempt)
    raise RuntimeError("unreachable")
```

```python
# ❌ Hardcoded dependency — nie da się podmienić w teście
from __future__ import annotations

import time

def retry_operation(operation):
    for attempt in range(3):
        try:
            return operation()
        except Exception:
            time.sleep(2 ** attempt)  # Hardcoded — test czeka realnie
```

```python
# ✅ Async variant — DI dla async context
from __future__ import annotations

import asyncio
from collections.abc import Awaitable, Callable

async def async_retry_operation(
    operation: Callable[[], Awaitable[str]],
    *,
    max_attempts: int = 3,
    sleep_fn: Callable[[float], Awaitable[None]] = asyncio.sleep,
) -> str:
    """Ponów async operację z injected async sleep (testowalne)."""
    for attempt in range(max_attempts):
        try:
            return await operation()
        except TransientError:
            if attempt == max_attempts - 1:
                raise
            await sleep_fn(2 ** attempt)
    raise RuntimeError("unreachable")
```

### 4.4 Wzorce kompozycji

| Wzorzec | Kiedy | Struktura |
|---------|-------|-----------|
| **Extract → Transform → Load** | Data pipeline | `raw = read(src)` → `clean = transform(raw)` → `write(dest, clean)` |
| **Validate → Process → Format** | Request handling | `valid = validate(input)` → `result = process(valid)` → `output = format(result)` |
| **Chain (pipe)** | Sekwencyjne transformacje | `result = f3(f2(f1(data)))` lub `reduce(apply, fns, data)` |

```python
# ✅ Composable pipeline — każda faza to osobna testowalna funkcja
from __future__ import annotations

def process_document(raw_data: bytes) -> ProcessedResult:
    """Pipeline: decode → parse → transform → render."""
    data = decode_input(raw_data)
    records = find_records(data)
    transformed = transform_records(records)
    return render_output(data, transformed)
```

---

## 5. Sygnatura jako kontrakt

### 5.1 `@overload` — tabela decyzyjna

| Kryterium | Użyj `@overload` | NIE używaj |
|-----------|-------------------|------------|
| Liczba wariantów | 2–3 distinct input shapes | >3 → refactor na osobne funkcje |
| Typ zależy od flagi | `Literal[True]` → `bytes`, `Literal[False]` → `str` | Gdy nie ma jasnego mapowania flag→typ |
| Typ return zależy od input | `str` input → `str` output, `Path` input → `Path` output | Gdy return jest zawsze ten sam |
| Implementacja jest wspólna | TAK — DRY | Gdy warianty mają zupełnie inną logikę → osobne functions |

```python
# ✅ @overload — mypy wie że raw=True → bytes, raw=False → str
from __future__ import annotations

from typing import Literal, overload

@overload
def fetch_page(url: str, *, raw: Literal[True]) -> bytes: ...
@overload
def fetch_page(url: str, *, raw: Literal[False] = ...) -> str: ...

def fetch_page(url: str, *, raw: bool = False) -> bytes | str:
    """Pobierz stronę — jako bytes (raw=True) lub decoded str."""
    data = _http_get(url)
    return data if raw else data.decode("utf-8")
```

```python
# ❌ Bez overload — mypy widzi bytes | str, caller musi castować
from __future__ import annotations

def fetch_page(url: str, *, raw: bool = False) -> bytes | str:
    data = _http_get(url)
    return data if raw else data.decode("utf-8")

# Caller: result = fetch_page(url, raw=True)
# mypy: result is bytes | str — musi assert isinstance()
```

```python
# ✅ @overload — 3 warianty: input type → output type
from __future__ import annotations

from typing import overload

@overload
def convert_data(data: str, *, strict: bool = ...) -> str: ...
@overload
def convert_data(data: bytes, *, strict: bool = ...) -> bytes: ...
@overload
def convert_data(data: None, *, strict: bool = ...) -> None: ...

def convert_data(data: str | bytes | None, *, strict: bool = True) -> str | bytes | None:
    """Konwertuj dane zachowując typ input → output."""
    if data is None:
        return None
    if isinstance(data, bytes):
        return data.decode("utf-8").encode("utf-8") if strict else data
    return data.encode("utf-8").decode("utf-8") if strict else data
```

### 5.2 `Protocol` vs `Callable` — tabela decyzyjna

| Kryterium | `Callable[[X], Y]` | `Protocol` z `__call__` |
|-----------|--------------------|-----------------------|
| Prosta sygnatura | ✅ Wystarczy | Overkill |
| Keyword args w sygnaturze | ❌ Nie wspiera | ✅ Pełna kontrola |
| Metody + callable | ❌ Nie wspiera | ✅ Może wymagać atrybutów |
| Czytelność dla >2 args | Słaba | ✅ Nazwy w Protocol |
| mypy strict compat | ✅ | ✅ |

```python
# ✅ Protocol gdy callback ma keyword args lub jest złożony
from __future__ import annotations

from typing import Protocol, runtime_checkable

@runtime_checkable
class TextProcessor(Protocol):
    def __call__(self, text: str, *, lang: str = "ja") -> str: ...

def apply_processor(text: str, processor: TextProcessor) -> str:
    """Zastosuj procesor tekstu z pełną kontrolą typów."""
    return processor(text, lang="pl")
```

```python
# ❌ Callable z wieloma args — nieczytelne, brak nazw parametrów
from __future__ import annotations

from collections.abc import Callable

def apply_processor(
    text: str,
    processor: Callable[[str, str, bool, int], str],  # Co to jest???
) -> str:
    return processor(text, "pl", True, 3)
```

### 5.3 Zawężanie typów bez `@overload`

| Technika | KIEDY | Przykład |
|----------|-------|---------|
| `TypeGuard` | Custom predicate zwęża typ | `def is_manga_page(p: Path) -> TypeGuard[MangaPage]` |
| `assert isinstance()` | Debug-only narrowing | `assert isinstance(result, str)` |
| `typing.cast()` | Wiesz lepiej niż mypy (RZADKO) | `cast(str, value)` — zero runtime check |
| Pattern matching (`match`) | Discriminated union | `match event: case Click(): ...` |

---

## 6. Public API i interfejs modułu

### 6.1 `__all__` — tabela decyzyjna

| Sytuacja | Użyj `__all__` | Dlaczego |
|----------|-----------------|----------|
| Library / package module | ✅ ZAWSZE | Kontrola `from module import *`; dokumentuje public API |
| `__init__.py` z re-exportami | ✅ ZAWSZE | Jednoznaczne co jest publiczne |
| Internal module (`_utils.py`) | ❌ NIE | Prefiks `_` wystarczy; `__all__` dodaje szum |
| Script / entrypoint | ❌ NIE | Nie jest importowany |

```python
# ✅ __init__.py z jawnym public API
from __future__ import annotations

from .analyzer import RecordAnalyzer
from .models import BBox, AnalysisResult
from .pipeline import find_records

__all__ = [
    "BBox",
    "AnalysisResult",
    "RecordAnalyzer",
    "find_records",
]
```

```python
# ❌ __init__.py bez __all__ — wildcard import ciągnie WSZYSTKO
from __future__ import annotations

from .analyzer import RecordAnalyzer, _internal_helper  # Leak!
from .models import BBox, AnalysisResult
from .pipeline import find_records
# Brak __all__ → from package import * → _internal_helper jest publiczny
```

### 6.2 Funkcja vs metoda — tabela decyzyjna

| Kryterium | Free function | Method na klasie |
|-----------|---------------|------------------|
| Potrzebuje stanu między wywołaniami? | NIE → free function | TAK → method |
| Operuje na danych klasy? | NIE | TAK |
| Reusable poza kontekstem klasy? | TAK → free function | NIE |
| Zależności do inject? | 0–1 → free function, parametry | >1 → klasa jako container |
| Testowanie | Proste: call z args | Wymaga instancji (setup) |

```python
# ✅ Free function — brak stanu, reusable
from __future__ import annotations

def compute_iou(box_a: BBox, box_b: BBox) -> float:
    """Oblicz Intersection over Union dwóch bounding boxów."""
    inter = _intersection_area(box_a, box_b)
    union = box_a.area + box_b.area - inter
    return inter / union if union > 0 else 0.0
```

```python
# ❌ Niepotrzebna klasa — zero stanu, mogłaby być free function
from __future__ import annotations

class IoUCalculator:
    def compute(self, box_a: BBox, box_b: BBox) -> float:
        inter = self._intersection_area(box_a, box_b)
        union = box_a.area + box_b.area - inter
        return inter / union if union > 0 else 0.0
```

### 6.3 Segregacja interfejsu — małe moduły

| Reguła | Wartość | Dlaczego |
|--------|---------|----------|
| Linie na moduł | ≤400 | Duży moduł = wiele powodów do zmiany → split |
| Public symbols na moduł | ≤10 | Więcej → god module; split by domain |
| Import depth | ≤3 warstwy | `a.b.c.d.e` → zbyt głębokie nesting |

### 6.4 Wzorzec re-export

| Wzorzec | Kiedy | Syntax |
|---------|-------|--------|
| Re-export via `__init__` | Package public API | `from .module import PublicThing` + `__all__` |
| Lazy import | Heavy deps (torch, cv2) | `importlib.import_module` w runtime |
| Conditional import | Optional dependency | `try: import X except ImportError: X = None` |

---

## 7. Deprecation i ewolucja API

### 7.1 Wzorzec — `warnings.warn`

| Element | Wartość | Dlaczego |
|---------|---------|----------|
| Klasa ostrzeżenia | `DeprecationWarning` | Filtrowane w production, widoczne w dev |
| `stacklevel` | `2` (ZAWSZE) | Ostrzeżenie wskazuje na CALLER, nie na wnętrze deprecated fn |
| Wersja usunięcia | Wpisz w message | Caller wie kiedy musi migrować |
| Nowa forma | Wpisz w message | Caller wie NA CO migrować |

```python
# ✅ Poprawna deprecation z migracją i wersją
from __future__ import annotations

import warnings

def old_translate(text: str) -> str:
    """Deprecated: użyj translate_text()."""
    warnings.warn(
        "old_translate() is deprecated since v2.1, will be removed in v3.0. "
        "Use translate_text() instead.",
        DeprecationWarning,
        stacklevel=2,
    )
    return translate_text(text)
```

```python
# ❌ Brak stacklevel, brak wersji, brak alternatywy
from __future__ import annotations

import warnings

def old_translate(text: str) -> str:
    warnings.warn("deprecated")  # stacklevel=1 → wskazuje tu, nie na callera
    return translate_text(text)
```

### 7.2 `typing.deprecated` (Python 3.13+ / typing_extensions)

```python
# ✅ Decorator-based deprecation — mypy + IDE ostrzeżą
from __future__ import annotations

from typing_extensions import deprecated

@deprecated("Use translate_text() instead. Removal in v3.0.")
def old_translate(text: str) -> str:
    return translate_text(text)
```

### 7.3 Kompatybilne wstecz zmiany sygnatur

| Zmiana | Bezpieczna? | Wzorzec |
|--------|-------------|---------|
| Dodaj keyword-only param z default | ✅ TAK | `*, new_param: int = 0` — existing callers nie muszą zmieniać |
| Zmień default wartość | ⚠️ OSTROŻNIE | Może zmienić zachowanie — deprecate stary default |
| Dodaj required param | ❌ NIE | Breaking change — major version bump |
| Usuń param | ❌ NIE | Breaking change — deprecate najpierw, usuń w next major |
| Zmień typ param | ❌ NIE | Breaking change — accept both via `@overload` w transitional period |

```python
# ✅ Bezpieczna ewolucja: nowy keyword-only z default
from __future__ import annotations

# v2.1: dodajemy model param — existing callers nie łamią się
def translate_text(
    text: str,
    *,
    source_lang: str = "ja",
    target_lang: str = "pl",
    model: str = "gpt-4o-mini",  # Nowy w v2.1 — default = no breaking change
) -> str:
    ...
```

---

## 8. Antypatterny

### 8.1 Tabela antypatternów

| Antypattern | Problem | Waga | Naprawa |
|-------------|---------|------|---------|
| **Flag argument** (bool switch) | `process(data, True)` — co robi `True`? | 🔴 HIGH | Keyword-only: `*, verbose: bool` LUB osobne funkcje |
| **God function** (>30 linii) | Nietestowalna, nieczytelna, wiele powodów do zmian | 🔴 HIGH | Split na mniejsze, single-purpose functions |
| **Output argument** (mutacja wejścia) | `def process(items: list) → items.append(x)` — ukryty side effect | 🔴 HIGH | Zwróć nową kolekcję; nie mutuj argumentu callera |
| **Hidden side effect** | `get_user()` pisze do pliku — nazwa kłamie | 🔴 HIGH | Nazwa MUSI odzwierciedlać efekt: `save_and_get_user()` |
| **Inconsistent return** | Czasem `None`, czasem raise, czasem wartość | 🟡 MEDIUM | Jeden kontrakt: albo ZAWSZE zwraca, albo ZAWSZE rzuca |
| **Bare `dict` return** | `-> dict` — caller nie ma IDE support, brak typed keys | 🟡 MEDIUM | `TypedDict`, `dataclass`, lub pydantic model |
| **Stringly typed params** | `mode: str` where enum fits | 🟡 MEDIUM | `mode: ProcessingMode` (enum / `Literal`) |
| **Mutable default** | `items: list = []` | 🔴 HIGH | `items: list \| None = None` + check w ciele |
| **Implicit coupling** | Funkcja czyta moduł-level `CONFIG` | 🟡 MEDIUM | Inject dependency jako parametr |
| **Bare `*args, **kwargs`** | Forwarding bez type info — mypy jest ślepy | 🟡 MEDIUM | Użyj `ParamSpec` lub explicit params |
| **Nested def abuse** | Helper zdefiniowany w ciele, utrudnia testowanie | 🟡 MEDIUM | Extract do module-level `_helper()` |
| **Return in finally** | `finally: return x` — maskuje wyjątki | 🔴 HIGH | NIGDY nie return w finally |

### 8.2 Kanoniczne przykłady antypatternów

```python
# ❌ Output argument — mutacja wejścia przez caller
from __future__ import annotations

def add_metadata(pages: list[Page], meta: Metadata) -> None:
    for page in pages:
        page.metadata = meta  # Mutuje obiekty callera bez zwrotu!
```

```python
# ✅ Zwróć nową kolekcję — immutability principe
from __future__ import annotations

def with_metadata(pages: list[Page], meta: Metadata) -> list[Page]:
    """Zwróć kopie stron z przypisaną metadatą."""
    return [page.model_copy(update={"metadata": meta}) for page in pages]
```

```python
# ❌ Stringly typed — nie wiadomo jakie wartości są poprawne
from __future__ import annotations

def process_image(image: np.ndarray, mode: str = "resize") -> np.ndarray:
    if mode == "resize":
        ...
    elif mode == "crop":
        ...
    # Co jeśli mode="resiez" (literówka)? → Silent bug
```

```python
# ✅ Literal / Enum — mypy + IDE pilnują poprawnych wartości
from __future__ import annotations

from typing import Literal

ProcessingMode = Literal["resize", "crop", "pad"]

def process_image(image: np.ndarray, mode: ProcessingMode = "resize") -> np.ndarray:
    ...
```

```python
# ❌ Hidden side effect — nazwa sugeruje "get" (read-only), ale pisze do pliku
from __future__ import annotations

def get_config() -> Config:
    config = _load_from_env()
    Path("last_config.json").write_text(config.model_dump_json())  # HIDDEN!
    return config
```

```python
# ✅ Nazwy odzwierciedlają zachowanie — "load" i osobna "save"
from __future__ import annotations

def load_config() -> Config:
    """Załaduj config z env — pure read, zero side effects."""
    return _load_from_env()

def save_config_snapshot(config: Config, path: Path) -> None:
    """Zapisz snapshot configa do pliku."""
    path.write_text(config.model_dump_json())
```

---

## 9. Egzekucja ruff

### 9.1 Reguły związane z projektowaniem funkcji

| Reguła ruff | ID | Co wykrywa | Auto-fix? | Waga |
|-------------|----|-----------|-----------|------|
| Mutable default argument | `B006` | `def f(x=[])` | ❌ | 🔴 ERROR |
| Unused function argument | `ARG001` | Parametr nigdy nie użyty w ciele | ❌ | 🟡 WARN |
| Too many arguments | `PLR0913` | >5 parametrów w sygnaturze | ❌ | 🟡 WARN |
| Too many return statements | `PLR0911` | >6 return w jednej funkcji | ❌ | 🟡 WARN |
| Too many branches | `PLR0912` | >12 branches (if/elif/else) | ❌ | 🟡 WARN |
| Too many statements | `PLR0915` | >50 statements w jednej funkcji | ❌ | 🟡 WARN |
| Boolean positional arg | `FBT001` | `def f(flag: bool)` bez keyword-only | ❌ | 🟡 WARN |
| Boolean default in positional | `FBT002` | `def f(flag=True)` bez keyword-only | ❌ | 🟡 WARN |
| Unnecessary `return None` | `RET501` | Explicit `return None` na końcu | ✅ | 🟢 INFO |
| Superfluous `else` after `return` | `RET505` | `if: return ... else:` → flat | ✅ | 🟢 INFO |
| Implicit return in function | `RET503` | Brakuje `return` na jednej ścieżce | ❌ | 🟡 WARN |
| Unnecessary `pass` | `PIE790` | `pass` w niepustym bloku | ✅ | 🟢 INFO |
| No explicit `stacklevel` | `B028` | `warnings.warn()` bez `stacklevel` | ❌ | 🟡 WARN |
| Use of `functools.lru_cache(maxsize=None)` | `B019` | Powinien być `@cache` w ≥3.9 | ✅ | 🟢 INFO |
| Star-arg unpacking in call | `PIE804` | Unnecessary `**{"key": val}` | ✅ | 🟢 INFO |

### 9.2 Rekomendowana konfiguracja w `pyproject.toml`

```toml
[tool.ruff.lint]
select = [
    "B006",    # mutable-argument-default
    "B028",    # no-explicit-stacklevel
    "ARG",     # flake8-unused-arguments
    "PLR0913", # too-many-arguments
    "PLR0911", # too-many-return-statements
    "FBT",     # flake8-boolean-trap
    "RET",     # flake8-return
]

[tool.ruff.lint.pylint]
max-args = 5
max-returns = 6
max-branches = 12
max-statements = 50
```

### 9.3 Progi — tabela decyzyjna

| Metryka | Próg domyślny ruff | Nasz standard | Dlaczego |
|---------|---------------------|---------------|----------|
| Max arguments | 5 | **5** | Google Style Guide; więcej → config object |
| Max returns | 6 | **6** | Więcej → złożona logika, split |
| Max branches | 12 | **10** | Niższy niż default — wymusza extraction |
| Max statements | 50 | **30** | Odpowiada naszej regule 30 linii |
| Line length | 88 | **120** | Projekt standard — szersze ekrany |

---
## Źródła

- [PEP 8 — Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations)
- [Google Python Style Guide — Functions and Methods](https://google.github.io/styleguide/pyguide.html#24-function-and-method-definitions)
- [Google Python Style Guide — Default Argument Values](https://google.github.io/styleguide/pyguide.html#212-default-argument-values)
- [PEP 544 — Protocols: Structural subtyping](https://peps.python.org/pep-0544/)
- [PEP 702 — typing.deprecated](https://peps.python.org/pep-0702/)
- [ruff PLR0913 too-many-arguments](https://docs.astral.sh/ruff/rules/too-many-arguments/)
- [ruff FBT001 boolean-positional-arg](https://docs.astral.sh/ruff/rules/boolean-type-hint-positional-argument/)
- [ruff B006 mutable-argument-default](https://docs.astral.sh/ruff/rules/mutable-argument-default/)