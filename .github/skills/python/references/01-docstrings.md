# 01 — Docstrings & Comments

> **Cel:** Source of truth dla docstringów, komentarzy i dokumentowania kodu Python.
> **Styl:** Google-style. Jeden styl, zero wyjątków.
> **Scope:** Uniwersalny — pasuje do każdego projektu Python. Nie zawiera konfiguracji specyficznej dla konkretnego repo.

---

## Spis treści

1. [Styl — Google-style](#1-styl--google-style)
2. [Format na szybko](#2-format-na-szybko)
3. [Przykłady — 3 skale](#3-przykłady--3-skale)
4. [Kiedy pisać, kiedy nie](#4-kiedy-pisać-kiedy-nie)
5. [Comments — inline i block](#5-comments--inline-i-block)
6. [TODO / FIXME / HACK](#6-todo--fixme--hack)
7. [D rules — konfiguracja ruff](#7-d-rules--konfiguracja-ruff)


## 📋 Quick Reference (ściąga)

```python
ONE-LINER:
"""Return True if the user is active."""

STANDARD:
"""Download file from URL to local path.

Extended description if needed.

Args:
    url: Source URL.
    dest: Destination path.

Returns:
    Path to downloaded file.

Raises:
    ValueError: If URL is invalid.
"""

CLASS:
"""User account with authentication.

Attributes:
    email: User email address.
    is_active: Whether account is enabled.
"""

PROPERTY:
"""Whether the model is loaded."""

MODULE CONSTANT:
MAX_RETRIES: Final[int] = 3
"""Maximum number of retry attempts."""

CONTEXT MANAGER:
"""Create a temporary directory that is removed on exit.

Yields:
    Path to the temporary directory.
"""

COMPLEX RETURN:
"""Parse header into value and parameters.

Returns:
    Tuple of:
        - Main header value.
        - Dict of parameters.
"""

WARNS:
"""Run the migration with safety checks.

Warns:
    DeprecationWarning: If using legacy schema.
"""

DEPRECATED:
"""Load config from legacy format.

.. deprecated: 2.0
    Use :func:`load_config` instead.
"""

SEE ALSO:
See Also:
    load_config: For TOML-based configuration.
    validate: Input validation before processing.

TODO IN DOCSTRING:
Todo:
    * Support YAML format (#123).
    * Add schema validation.

COMMENTS:
# WHY, nie WHAT. Kod = WHAT, komentarz = WHY.

TODO:
# TODO(username): Opis. #issue
```

---

## 1. Styl — Google-style

**Wybór: Google-style.** Dlaczego?
- Zwięzły — mniej linii niż NumPy
- DRY z type hints — nie powtarzamy typów w docstringu (są w sygnaturze)
- Dominuje w web/ML ekosystemie
- Natywne wsparcie ruff: `convention = "google"`

> NumPy-style to jedyna realna alternatywa (popularny w scientific Python). Jeśli dołączasz do projektu NumPy-style — przestrzegaj JEGO reguł. Ale w nowych projektach: **Google**.

---

## 2. Format na szybko

```python
def func(arg1: str, arg2: int = 10) -> bool:
    """One-line summary w imperative mood, kończy się kropką.

    Opcjonalny dłuższy opis. Oddzielony pustą linią od summary.
    Wyjaśnia CO i DLACZEGO, nie JAK (jak = kod).

    Args:
        arg1: Opis argumentu. Bez typu — typ jest w sygnaturze.
        arg2: Opis z default. Wieloliniowy opis kontynuuj
            z 4-spacjowym wcięciem.

    Returns:
        Opis tego co zwraca. True jeśli X, False jeśli Y.

    Raises:
        ValueError: Gdy arg1 jest pusty.
        TimeoutError: Gdy operacja przekroczy limit czasu.

    Warns:
        DeprecationWarning: Gdy arg2 < 1.

    Example:
        >>> func("hello", 5)
        True

    Note:
        Dodatkowe uwagi, ograniczenia, ważne informacje.
    """
```

### Wszystkie sekcje Google-style

| Sekcja | Kiedy używasz | Format |
|--------|---------------|--------|
| **Args** | Funkcja ma parametry | `name: Opis.` |
| **Returns** | Coś zwraca (nie `None`) | Opis wartości |
| **Yields** | Generator / `yield` | Opis yielded wartości |
| **Raises** | Rzuca wyjątki | `ExceptionType: Kiedy.` |
| **Warns** | Emituje warnings (`warnings.warn`) | `WarningType: Kiedy.` |
| **Example** | Public API | `>>>` doctest format |
| **Note** | Ważne zastrzeżenia | Tekst |
| **Attributes** | Klasa — publiczne atrybuty | `name: Opis.` |
| **See Also** | Powiązane API | Referencje |
| **Todo** | Planowane zmiany | Lista |
| **Deprecated** | Funkcja/klasa do usunięcia | Wersja + alternatywa |

### PEP 257 — reguły bazowe

| Reguła | Przykład |
|--------|---------|
| Summary: imperative mood | `"""Return the user name."""` nie `"""Returns the name."""` |
| Summary: wielka litera + kropka | `"""Process the image."""` |
| One-liner: `"""` w jednej linii | `"""Return True if valid."""` |
| Multi-liner: `"""` na osobnej linii | Closing `"""` na nowej linii |
| Pusta linia między summary a body | Obowiązkowa |
| NIE parafrazuj sygnatury | `"""Translate text."""` nie `"""Translate text from source to target."""` jeśli args to mówią |

---

## 3. Przykłady — 3 skale

### 🟢 MINI — Utils, properties, one-linery

Dla prostych funkcji wystarczy one-liner. **Nie rób rozbudowanych docstringów tam, gdzie kod mówi sam za siebie.**

```python
def clamp(value: float, low: float, high: float) -> float:
    """Clamp value to [low, high] range."""
    return max(low, min(high, value))


def is_valid_email(email: str) -> bool:
    """Return True if email matches basic RFC 5322 pattern."""
    return bool(re.match(r"^[^@]+@[^@]+\.[^@]+$", email))


@property
def is_loaded(self) -> bool:
    """Whether the model weights are loaded into memory."""
    return self._model is not None


@property
def name(self) -> str:
    """User-facing display name."""
    return self._name
```

> 💡 **Tip:** Jeśli funkcja ma ≤3 linii, typ jest w sygnaturze, a nazwa mówi co robi → one-liner docstring wystarczy.

### 🟡 STANDARD — Normalne funkcje, dataclassy, async

Typowy kod produkcyjny — docstring z Args, Returns, Raises.

```python
def download_file(
    url: str,
    dest: Path,
    *,
    timeout: float = 30.0,
    retries: int = 3,
) -> Path:
    """Download a file from URL to local path.

    Supports HTTP/HTTPS with automatic retry on transient failures.
    Creates parent directories if they don't exist.

    Args:
        url: Full URL to download from.
        dest: Local destination path.
        timeout: Request timeout in seconds.
        retries: Number of retry attempts on failure.

    Returns:
        Path to the downloaded file (same as dest).

    Raises:
        ValueError: If URL scheme is not http/https.
        DownloadError: If all retries are exhausted.
    """
```

```python
@dataclass(frozen=True)
class BoundingBox:
    """Axis-aligned bounding box in pixel coordinates.

    Attributes:
        x: Left edge X coordinate.
        y: Top edge Y coordinate.
        width: Box width in pixels.
        height: Box height in pixels.
        confidence: Detection confidence, 0.0-1.0.
    """

    x: int
    y: int
    width: int
    height: int
    confidence: float = 1.0

    @property
    def area(self) -> int:
        """Total area in pixels."""
        return self.width * self.height

    def contains(self, px: int, py: int) -> bool:
        """Return True if point (px, py) is inside the box."""
        return self.x <= px < self.x + self.width and self.y <= py < self.y + self.height
```

```python
async def fetch_translations(
    texts: list[str],
    target_lang: str,
    *,
    batch_size: int = 10,
) -> list[str]:
    """Translate a batch of texts concurrently.

    Splits input into batches and translates in parallel via asyncio.
    Preserves input order in results.

    Args:
        texts: Source texts to translate.
        target_lang: ISO 639-1 target language code (e.g., "pl").
        batch_size: Max concurrent translations.

    Returns:
        Translated texts in same order as input.

    Raises:
        ProcessingError: If any batch fails after retries.
    """
```

> 💡 **Tip:** Standard docstring = Summary + Args + Returns + (opcjonalnie Raises/Example). Nie dodawaj sekcji "bo trzeba" — dodawaj gdy wnoszą wartość.

### 🟡 STANDARD — Dodatkowe wzorce

Wzorce, które pojawiają się rzadziej, ale muszą być spójne.

```python
# ── Context Manager ───────────────────────────────────────────────────

from contextlib import contextmanager

@contextmanager
def temporary_directory(prefix: str = "tmp") -> Iterator[Path]:
    """Create a temporary directory that is removed on exit.

    Yields:
        Path to the temporary directory.

    Example:
        >>> with temporary_directory("build") as tmp:
        ...     (tmp / "out.txt").write_text("ok")
    """
    path = Path(tempfile.mkdtemp(prefix=prefix))
    try:
        yield path
    finally:
        shutil.rmtree(path, ignore_errors=True)


class DatabaseConnection:
    """Context manager for database connections.

    Commits on clean exit, rolls back on exception.

    Example:
        >>> with DatabaseConnection(url) as conn:
        ...     conn.execute("SELECT 1")
    """

    def __enter__(self) -> DatabaseConnection:
        """Open connection and return self."""
        self._conn = self._connect()
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: object,
    ) -> None:
        """Commit if no exception, rollback otherwise."""
        if exc_type is None:
            self._conn.commit()
        else:
            self._conn.rollback()
        self._conn.close()


# ── Module-level constants ────────────────────────────────────────────

MAX_RETRIES: Final[int] = 3
"""Maximum number of retry attempts before giving up."""

DEFAULT_TIMEOUT: Final[float] = 30.0
"""Default request timeout in seconds."""

SUPPORTED_FORMATS: Final[frozenset[str]] = frozenset({".jpg", ".png", ".webp"})
"""Image formats accepted by the pipeline."""


# ── Decorator ─────────────────────────────────────────────────────────

def retry(max_attempts: int = 3, delay: float = 1.0) -> Callable[[F], F]:
    """Retry a function on exception with exponential backoff.

    Args:
        max_attempts: Total attempts (1 = no retry).
        delay: Initial delay between attempts in seconds. Doubles each retry.

    Returns:
        Decorated function with retry behavior.

    Example:
        >>> @retry(max_attempts=3, delay=0.5)
        ... def fetch(url: str) -> bytes: ...
    """


# ── Complex returns ───────────────────────────────────────────────────

def parse_header(raw: str) -> tuple[str, dict[str, str]]:
    """Parse an HTTP-style header into value and parameters.

    Args:
        raw: Raw header string, e.g. ``"text/html; charset=utf-8"``.

    Returns:
        Tuple of:
            - Main header value (e.g. ``"text/html"``).
            - Dict of parameters (e.g. ``{"charset": "utf-8"}``).
    """


def get_user_stats(user_id: int) -> dict[str, int | float]:
    """Fetch aggregated stats for a user.

    Args:
        user_id: Unique user identifier.

    Returns:
        Dict with keys:
            - ``"total_tasks"``: Number of completed tasks.
            - ``"avg_duration"``: Average task duration in seconds.
            - ``"success_rate"``: Completion ratio, 0.0-1.0.
    """


# ── Deprecated ────────────────────────────────────────────────────────

def load_config_legacy(path: str) -> dict[str, object]:
    """Load configuration from legacy INI format.

    .. deprecated: 2.0
        Use :func:`load_config` with TOML format instead.

    Args:
        path: Path to INI config file.

    Returns:
        Parsed configuration dict.
    """
```

### 🔴 BIG — Moduł, klasa z lifecycle, wiele metod

Pokaz spójności w dużym programie. **Ten sam styl, ta sama głębokość — bez względu na rozmiar pliku.**

```python
"""Image processing pipeline for document scanning.

Provides the Pipeline class that orchestrates multiple processing
stages: input validation, perspective correction, enhancement,
and OCR. Each stage is independently configurable.

Typical usage:

    pipeline = Pipeline(config=PipelineConfig())
    result = pipeline.process(image_path)
    result.save("output/")

Note:
    Requires OpenCV and Tesseract to be installed.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from pathlib import Path
from typing import TYPE_CHECKING, Iterator

if TYPE_CHECKING:
    import numpy as np

logger = logging.getLogger(__name__)


# ── Konfiguracja ──────────────────────────────────────────────────────


@dataclass
class StageConfig:
    """Configuration for a single processing stage.

    Attributes:
        enabled: Whether this stage runs. Defaults to True.
        timeout: Max execution time in seconds. 0 = no limit.
    """

    enabled: bool = True
    timeout: float = 0.0


@dataclass
class PipelineConfig:
    """Full pipeline configuration.

    Attributes:
        input_dir: Directory with source images.
        output_dir: Directory for processed results.
        stages: Per-stage configuration overrides.
        max_resolution: Max image dimension (longer side).
    """

    input_dir: Path = Path("input")
    output_dir: Path = Path("output")
    stages: dict[str, StageConfig] = field(default_factory=dict)
    max_resolution: int = 4096


# ── Wyniki ────────────────────────────────────────────────────────────


@dataclass
class StageResult:
    """Result from a single processing stage.

    Attributes:
        name: Stage identifier.
        success: Whether stage completed without errors.
        duration_ms: Execution time in milliseconds.
        metadata: Arbitrary stage-specific metadata.
    """

    name: str
    success: bool
    duration_ms: float
    metadata: dict[str, object] = field(default_factory=dict)


@dataclass
class PipelineResult:
    """Aggregated result from all pipeline stages.

    Attributes:
        image_path: Path to the source image.
        stages: Results from each stage, in execution order.
        output_path: Path to final output (None if failed).
    """

    image_path: Path
    stages: list[StageResult] = field(default_factory=list)
    output_path: Path | None = None

    @property
    def success(self) -> bool:
        """Whether all stages completed successfully."""
        return all(s.success for s in self.stages)

    @property
    def total_duration_ms(self) -> float:
        """Total processing time across all stages."""
        return sum(s.duration_ms for s in self.stages)


# ── Pipeline ──────────────────────────────────────────────────────────


class Pipeline:
    """Multi-stage image processing pipeline.

    Executes a configurable sequence of processing stages on images.
    Each stage can be enabled/disabled and has independent timeout.

    Attributes:
        config: Pipeline configuration.

    Example:
        >>> pipeline = Pipeline(PipelineConfig(max_resolution=2048))
        >>> result = pipeline.process(Path("scan.jpg"))
        >>> result.success
        True
    """

    def __init__(self, config: PipelineConfig | None = None) -> None:
        """Initialize pipeline with configuration.

        Args:
            config: Pipeline configuration. Uses defaults if None.
        """
        self.config = config or PipelineConfig()
        self._stages: list[str] = ["validate", "correct", "enhance", "ocr"]
        logger.info("Pipeline initialized with %d stages", len(self._stages))

    def process(self, image_path: Path) -> PipelineResult:
        """Process a single image through all enabled stages.

        Stages execute in order. If a stage fails, subsequent stages
        are skipped and the result is marked as failed.

        Args:
            image_path: Path to source image. Must exist.

        Returns:
            PipelineResult with per-stage details and output path.

        Raises:
            FileNotFoundError: If image_path doesn't exist.
            ValueError: If image format is unsupported.
        """
        if not image_path.exists():
            msg = f"Image not found: {image_path}"
            raise FileNotFoundError(msg)

        result = PipelineResult(image_path=image_path)
        # ... processing logic ...
        return result

    def process_batch(self, image_dir: Path) -> Iterator[PipelineResult]:
        """Process all images in a directory.

        Yields results as each image completes (streaming, not batched).

        Args:
            image_dir: Directory containing images.

        Yields:
            PipelineResult for each processed image.
        """
        for path in sorted(image_dir.glob("*")):
            if path.suffix.lower() in {".jpg", ".jpeg", ".png", ".webp"}:
                yield self.process(path)

    def _validate_image(self, image: np.ndarray) -> bool:
        """Check if image meets minimum quality requirements."""
        # Private method — one-liner docstring wystarczy
        return image.shape[0] >= 100 and image.shape[1] >= 100
```

> **Co widzisz:** moduł docstring → section separatory → dataclass z Attributes → klasa z `__init__` → public metody (Args/Returns/Raises/Yields) → private one-liner → properties. Spójność od góry do dołu.

---

## 4. Kiedy pisać, kiedy nie

### ✅ PISZ docstring

| Co | Dlaczego |
|----|----------|
| Public moduł | Co ten plik robi i dlaczego istnieje |
| Public klasa | Co reprezentuje + Attributes |
| `__init__` z parametrami | Args — raz, nie w class docstring |
| Public metoda/funkcja | Co robi, Args, Returns, wyjątki |
| Abstrakcyjna metoda | Kontrakt dla implementacji |
| Dekorator | Co dekorator robi, side effects, kiedy go użyć |
| Context manager | Lifecycle: co acquireuje, co releasuje, zachowanie przy wyjątku |
| Skomplikowana logika | Algorytm, heurystyka, non-obvious |

### ❌ NIE pisz docstringa

| Co | Dlaczego |
|----|----------|
| Oczywisty one-liner | `get_name()`, `to_dict()` — nazwa wystarczy |
| Private helper `_x()` | Używany w jednym miejscu, zmienny, wewnętrzne detale |
| Test function | Nazwa testu = opis: `test_login_fails_with_wrong_password()`. ruff D100-D107 OFF w `tests/` |
| `__repr__`, `__str__`, `__eq__` | Konwencja — oczywiste/magiczne |
| Override bez zmian | Docstring jest w base class. Dziedziczysz automatycznie |
| Prosty `@property` | Jeśli nazwa mówi wszystko |
| `__init__` (gdy class docstring istnieje) | Attributes są już w class docstring — powtarzanie to DRY violation |

### 🟡 Twój judgment call

| Sytuacja | Wskazówka |
|----------|-----------|
| `__init__` trywialny (1-2 params) | D107 OFF — class docstring wystarczy |
| Internal module (`_internal.py`) | Krótki docstring OK, ale nie wymuszaj D100 |
| Dataclass z typowymi polami | Attributes w class docstring, nie per-field |
| Overloaded funkcja (`@overload`) | Docstring na implementacji, nie na overloadach |

---

## 5. Comments — inline i block

### Złota zasada: **WHY, nie WHAT**

Komentarz wyjaśnia **DLACZEGO** kod jest taki, nie CO robi (co = kod mówi sam).

```python
# ✅ GOOD — explains WHY
mask = cv2.dilate(mask, kernel, iterations=3)  # expand to cover anti-aliased edges

# ✅ GOOD — workaround with reference
# Workaround for numpy bug: https://github.com/numpy/numpy/issues/12345
result = np.ascontiguousarray(result)

# ✅ GOOD — non-obvious constant
BATCH_SIZE = 32  # empirically tuned; 64 causes OOM on 8GB VRAM

# ❌ BAD — paraphrasing code
total = sum(prices)  # sum all prices

# ❌ BAD — commented-out code (use git, not comments)
# old_result = process_v1(data)
```

### Lokalizacja

```python
# Block comment — NAD kodem którego dotyczy.
# Dłuższe wyjaśnienie, może span multiple lines.
# Pusta linia przed block comment oddziela od poprzedniego kodu.
mask = cv2.dilate(mask, kernel, iterations=3)

result = heavy_function()  # Inline — krótkie, na tej samej linii.
```

### Zakomentowany kod

**USUŃ.** Zawsze. Git śledzi historię. ruff rule `ERA001` to łapie.

### Section separators

Wizualny podział długiego pliku na logiczne sekcje. **Czysta estetyka dla człowieka** — Python i narzędzia to ignorują. Używaj tylko gdy plik jest na tyle duży, że pomaga orientacja.

```python
# ── Konfiguracja ──────────────────────────────────────────────────────────────

# ── Wyniki ────────────────────────────────────────────────────────────────────

# ── Pipeline ──────────────────────────────────────────────────────────────────
```

Format: `# ── Nazwa ` + em dash (`─`, U+2500) do wypełnienia. **Całkowita długość linii: 80 znaków.**
Formuła: `trailing = 80 - len("# ── Nazwa ")`, czyli `─` × (80 - len(prefix)).
Jeden styl, nie mieszaj z `===` / `---`.

> **Metoda weryfikacji:** `python -c "s='# ── Nazwa ...'; print(len(s))"` — powinno wyjść 80.
> Separator wewnątrz klasy/metody (z wcięciem 4 spacji): sam tekst separatora = 76 znaków
> (4 spacje wcięcia + 76 treści = 80 znaków łącznej długości linii).

---

## 6. TODO / FIXME / HACK

```python
# TODO(username): Opis co trzeba zrobić. #issue-number
# TODO(mateusz): Add retry logic for rate-limited API calls. #42

# FIXME(username): Opis buga.
# FIXME(mateusz): Race condition when two workers process same page.

# HACK(username): Dlaczego hack istnieje. Kiedy usunąć.
# HACK(mateusz): Monkey-patch for compat. Remove after lib v2.5.
```

| Tag | Znaczenie | Kiedy |
|-----|-----------|-------|
| **TODO** | Planowane ulepszenie | Feature/refactor do zrobienia |
| **FIXME** | Znany bug | FIXME > TODO dla bugów |
| **HACK** | Tymczasowy workaround | Zawsze z warunkiem usunięcia |

**Reguły:**
- ZAWSZE `(username)` — kto jest odpowiedzialny
- ZAWSZE opis — nigdy goły `# TODO`
- Opcjonalnie `#issue-number` — link do trackera

**ruff rules:** `TD002` (missing author), `TD003` (missing issue), `FIX001` (FIXME found), `FIX002` (TODO found)

---

## 7. D rules — konfiguracja ruff

### Konfiguracja

```toml
[tool.ruff.lint]
select = ["D"]           # Włącz pydocstyle

[tool.ruff.lint.pydocstyle]
convention = "google"    # Auto: D211+D212 ON, D203+D213 OFF

[tool.ruff.lint.per-file-ignores]
"tests/**" = ["D"]       # Testy nie potrzebują docstringów
"scripts/**" = ["D"]     # Skrypty CLI też nie
```

### Rekomendowane ignores (global)

| Rule | Co robi | Dlaczego OFF |
|------|---------|-------------|
| `D100` | Missing module docstring | Nie każdy moduł potrzebuje, zwłaszcza `__init__.py` |
| `D104` | Missing `__init__.py` docstring | Prawie nigdy nie ma sensu |
| `D105` | Missing magic method docstring | `__repr__`, `__str__` — oczywiste |
| `D107` | Missing `__init__` docstring | Gdy class docstring wystarczy |
| `D401` | Imperative mood w summary | Opcjonalne — PEP 257 wymaga imperative ("Return" nie "Returns"), ale D401 ma fałszywe alarmy (np. "Deprecated" flagowane). Zależy od dyscypliny w zespole |

```toml
ignore = [
    "D100",   # module docstring — nie wszędzie
    "D104",   # __init__.py docstring — prawie nigdy
    "D105",   # magic method docstring — oczywiste
    "D107",   # __init__ docstring — class docstring wystarczy
    # "D401", # imperative mood — włącz jeśli chcesz strict enforcement
]
```

### Najczęściej widziane D errors

| Rule | Problem | Fix |
|------|---------|-----|
| D200 | One-liner nie mieści się w jednej linii | Skróć lub zmień na multi-liner |
| D205 | Brak pustej linii po summary | Dodaj blank line |
| D212 | Summary nie na pierwszej linii `"""` | Przenieś: `"""Summary.` nie `"""\nSummary.` |
| D400 | Summary nie kończy się kropką | Dodaj `.` |
| D403 | Pierwsze słowo nie capitalized | `"""return X."""` → `"""Return X."""` |
| D417 | Missing Args documentation | Dodaj brakujące Args |

---
## Źródła

- [Google Python Style Guide — Docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
- [PEP 257 — Docstring Conventions](https://peps.python.org/pep-0257/)
- [Sphinx Napoleon — Google-style parsing](https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html)
- [ruff pydocstyle rules](https://docs.astral.sh/ruff/rules/#pydocstyle-d)
