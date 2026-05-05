# 08 — Error Handling

> **Cel:** Kompletne reguły obsługi błędów w Pythonie ≥3.10 — od filozofii EAFP/LBYL, przez projektowanie hierarchii wyjątków, po retry patterns i error boundaries.
> **Scope:** Exception design, propagation, chaining, boundaries, async, retry, logging, testing, ruff enforcement.
> **Zasada nadrzędna:** Raise early, catch late. Nigdy bare `except:`. Każdy `raise` w except block wymaga `from`.

---

## Spis treści

1. [EAFP vs LBYL — tabela decyzyjna](#1-eafp-vs-lbyl--tabela-decyzyjna)
2. [Hierarchia wyjątków — projektowanie](#2-hierarchia-wyjątków--projektowanie)
3. [Raise early, catch late — strategia granic](#3-raise-early-catch-late--strategia-granic)
4. [Exception chaining — `raise from`](#4-exception-chaining--raise-from)
5. [Custom exceptions — reguły projektowania](#5-custom-exceptions--reguły-projektowania)
6. [Error propagation — `try`/`except`/`else`/`finally`](#6-error-propagation--tryexceptelsefinally)
7. [Error boundaries — API, CLI, worker](#7-error-boundaries--api-cli-worker)
8. [Context manager i async error handling](#8-context-manager-i-async-error-handling)
9. [Retry patterns — `tenacity`](#9-retry-patterns--tenacity)
10. [Logowanie i testowanie wyjątków](#10-logowanie-i-testowanie-wyjątków)
11. [Antypatterny](#11-antypatterny)
12. [Egzekucja ruff](#12-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | **EAFP > LBYL** (z wyjątkiem: side effects, częste errors, operacje nieodwracalne) |
| 2 | **3-level hierarchy:** `AppError → DomainError → SpecificError` + mixiny `TransientError`/`FatalError` |
| 3 | **Raise early** — waliduj na wejściu ZANIM zaczniesz przetwarzanie |
| 4 | **Catch late** — error boundary (API/CLI/worker) to jedyne miejsce na `except AppError` |
| 5 | **ZAWSZE `raise X from exc`** w except block — NIGDY implicit chaining |
| 6 | **Message w zmiennej:** `msg = f"..."; raise X(msg)` — NIGDY `raise X(f"...")` |
| 7 | **Minimalny try body** — tylko kod który może rzucić target exception |
| 8 | **`else` = happy path** niezabezpieczony przez except |
| 9 | **NIGDY `return`/`break`/`continue` w `finally`** |
| 10 | **Specific except** — NIGDY bare `except:`, unikaj `except Exception` (chyba że boundary) |
| 11 | **Log OR raise** — nigdy oba (podwójne logowanie) |
| 12 | **`contextlib.suppress(X)`** zamiast `try/except X: pass` |
| 13 | **Retry = TYLKO `TransientError`** + exponential backoff + jitter + stop + reraise |
| 14 | **`pytest.raises(X, match=r"...")`** — specific exception + match pattern |
| 15 | **Exception name ends with `Error`** — ruff `N818` |
| 16 | **NIGDY `eval()`/`exec()`** — `ast.literal_eval()` lub `lark` |
| 17 | **NIGDY `assert` w produkcji** — usunięte przez `python -O` |
| 18 | **CancelledError = BaseException** — ZAWSZE re-raise w async |
| 19 | **ExceptionGroup + `except*`** dla TaskGroup errors (Python 3.11+) |
| 20 | **Structured `ErrorContext`** z `ErrorCode(StrEnum)` + `suggestion` + `details` |

---

> **Powiązane sekcje:**
> - `06-function-api-design.md` — walidacja parametrów, `@overload`, early return
> - `07-class-protocol-design.md` — Protocol vs ABC, `__init__` design
> - `09-design-patterns.md` — Context Manager (§6.1), Registry (§6.2), Null Object (§6.8)
> - `04-naming.md` — konwencje nazw wyjątków (`XError`, `ErrorCode`)

---

## 1. EAFP vs LBYL — tabela decyzyjna

Python preferuje **EAFP** (Easier to Ask Forgiveness than Permission) nad **LBYL** (Look Before You Leap) — ale NIE jest to absolutna zasada. Guido van Rossum: _"I disagree with the position that EAFP is better than LBYL, or generally recommended by Python."_

### 1.1 Kiedy który styl

| Sytuacja | Styl | Dlaczego |
|----------|------|----------|
| Dostęp do dict key (zwykle istnieje) | **EAFP** | Rzadki miss, brak race condition |
| Otwarcie pliku | **EAFP** | TOCTOU race — plik usunięty między `exists()` a `open()` |
| Konwersja `str` → `int` | **EAFP** | `int()` wewnętrznie robi pełną walidację — nie duplikuj |
| DB connection / network call | **EAFP** | Connection drop między check a use |
| Duck typing (`hasattr` vs just use) | **EAFP** | Pythonic — rely on behavior, not type |
| Dane z ~50% error rate | **LBYL** | Koszt wyjątków > koszt `if` |
| Operacja z side effects (zapis do pliku) | **LBYL** | Side effect zaszedł PRZED wyjątkiem — rollback trudny |
| Prosta walidacja (`x > 0`) | **LBYL** | Tańsze niż `try/except`, czytelniejsze |
| Operacja nieodwracalna (delete) | **LBYL** | Nie da się cofnąć po partial execution |
| Multi-threaded shared resource | **EAFP** | TOCTOU race w LBYL |

### 1.2 Performance

- Python 3.11+: **zero-cost exceptions** — `try` block z 0 wyjątków jest praktycznie free
- EAFP **szybsze ~21%** gdy wyjątki rzadkie (char frequency benchmark)
- LBYL **szybsze ~211%** gdy wyjątki częste (word frequency benchmark)
- **Empiry:** Użyj `cProfile` lub `timeit` przy wątpliwościach — nie optymalizuj na oko

### 1.3 Snippety

```python
# ✅ EAFP — dict access (rzadki miss)
try:
    value = data["key"]
except KeyError:
    value = default

# ✅ EAFP — file access (race-free)
try:
    with open(path) as f:
        content = f.read()
except FileNotFoundError:
    content = ""
```

```python
# ❌ LBYL z race condition
if path.exists():           # plik może być usunięty TUTAJ
    with open(path) as f:   # FileNotFoundError!
        content = f.read()

# ❌ LBYL z duplikacją walidacji
if value.isdigit():         # nie łapie "-42" ani "3.14"!
    return int(value)       # int() i tak robi pełną walidację

# ❌ EAFP z side effects
try:
    file.write("Good\n")
    file.write(moments[index])  # IndexError — ale "Good\n" już zapisane!
except IndexError:
    pass
```

```python
# ✅ LBYL dla side effects
if index < len(items):
    file.write(items[index])
```

> **Powiązane:** `09-design-patterns.md` §1 — Pythonic design i mapowanie idiomów na wzorce GoF.

---

## 2. Hierarchia wyjątków — projektowanie

### 2.1 Zasada 3 poziomów

| Poziom | Rola | Przykład |
|--------|------|---------|
| 1. **Base** | Catch-all dla CAŁEJ aplikacji | `AppError` |
| 2. **Domain** | Catch per domena / moduł | `StorageError`, `PaymentError` |
| 3. **Specific** | Konkretni sprawcy | `StorageConnectionError`, `PaymentRateLimitError` |

**Mixiny** na cross-cutting classification:

| Mixin | Semantyka | Retry? |
|-------|-----------|--------|
| `TransientError` | Tymczasowy (network, rate-limit, timeout) | ✅ TAK |
| `FatalError` | Permanentny (bad config, missing model, invalid input) | ❌ NIE |

### 2.2 Drzewo wbudowanych wyjątków Pythona (kluczowy fragment)

```
BaseException                          ← NIGDY nie łap (chyba że KeyboardInterrupt)
├── GeneratorExit
├── KeyboardInterrupt
├── SystemExit
└── Exception                          ← root user-catchable
    ├── ArithmeticError (ZeroDivisionError, OverflowError)
    ├── AttributeError
    ├── LookupError (IndexError, KeyError)
    ├── OSError (FileNotFoundError, PermissionError, TimeoutError)
    ├── RuntimeError (NotImplementedError, RecursionError)
    ├── StopIteration
    ├── TypeError
    ├── ValueError (UnicodeError)
    └── ExceptionGroup (Python 3.11+)
```

> ⚠️ **NIGDY nie dziedzicz po `BaseException`** — `except Exception` go nie złapie, a `except BaseException` łapie `KeyboardInterrupt` i `SystemExit`.

### 2.3 Wzorzec hierarchii — przykład aplikacji

```python
# ✅ 3-level hierarchy + mixins
from __future__ import annotations

import sys
from dataclasses import dataclass, field
from typing import Any

# Python 3.11+ ma StrEnum wbudowany; dla 3.10 backport inline
if sys.version_info >= (3, 11):
    from enum import StrEnum
else:
    from enum import Enum

    class StrEnum(str, Enum):  # noqa: SLOT000
        """Backport — `str` mixin daje `.value` jako `str`."""


class ErrorCode(StrEnum):
    """Machine-readable error codes — loggable, matchowalne."""

    UNKNOWN = "UNKNOWN"
    STORAGE_FAILED = "STORAGE_FAILED"
    CONNECTION_FAILED = "CONNECTION_FAILED"
    RATE_LIMITED = "RATE_LIMITED"


@dataclass(frozen=True, slots=True)
class ErrorContext:
    """Structured error metadata — NIE formatuj message inline w raise."""

    code: ErrorCode
    message: str
    suggestion: str = ""
    details: dict[str, Any] = field(default_factory=dict)


# ── Poziom 1: Base ──
class AppError(Exception):
    """Catch-all — `except AppError` łapie WSZYSTKO z aplikacji."""

    def __init__(
        self,
        message: str = "",
        *,
        context: ErrorContext | None = None,
    ) -> None:
        if context and not message:
            message = context.message
        super().__init__(message)
        self.context = context or ErrorContext(
            code=ErrorCode.UNKNOWN,
            message=message,
        )


# ── Mixiny (cross-cutting) ──
class TransientError(AppError):
    """Retryable — tenacity retry na isinstance(e, TransientError)."""


class FatalError(AppError):
    """Non-retryable — wymaga interwencji usera."""


# ── Poziom 2: Domain (1 klasa per moduł/bounded context) ──
class StorageError(AppError):
    """Domena: storage / data layer."""


class PaymentError(AppError):
    """Domena: payment / external integrations."""


class WorkflowError(AppError):
    """Domena: workflow / orchestration."""

# W realnym projekcie: tyle klas domenowych ile modułów
# (np. AuthError, NotificationError, AnalyticsError... — 7+ domen)


# ── Poziom 3: Specific (domain + opcjonalnie mixin) ──
class StorageConnectionError(StorageError, FatalError):
    """Nie można połączyć z DB — FATAL (MRO: StorageError → FatalError → AppError)."""


class PaymentNetworkError(PaymentError, TransientError):
    """API call failed — TRANSIENT, retry OK."""


class PaymentRateLimitError(PaymentError, TransientError):
    """Rate limited — TRANSIENT, backoff retry."""
```

```python
# ❌ Flat hierarchy — nie da się łapać per domena
class Error1(Exception): ...
class Error2(Exception): ...
class Error3(Exception): ...
# → except ??? wymusza łapanie KAŻDEGO osobno

# ❌ Inheriting from BaseException
class MyError(BaseException): ...  # except Exception go NIE złapie!
```

> **Powiązane:** `07-class-protocol-design.md` §5 — composition vs inheritance w hierarchii wyjątków.

---

## 3. Raise early, catch late — strategia granic

### 3.1 Zasada

| Warstwa | Co robić | Dlaczego |
|---------|----------|----------|
| **Wejście** (boundary) | `raise` najwcześniej jak się da | Szybki feedback, czysty stack trace |
| **Środek** (domain logic) | **Propaguj** — nie łap jeśli nie wiesz co zrobić | Uniknij ukrywania błędów |
| **Wyjście** (boundary) | `except` + log + user-facing response | Kontekst do sensownej obsługi |

### 3.2 Raise early

```python
# ✅ Walidacja na granicy — ZANIM zaczniemy pracę
def process_image(path: Path) -> ProcessedImage:
    if not path.exists():
        msg = f"Image not found: {path}"
        raise FileNotFoundError(msg)
    if path.suffix not in {".jpg", ".png", ".webp"}:
        msg = f"Unsupported format: {path.suffix}"
        raise ValueError(msg)
    # Dopiero teraz — kosztowne przetwarzanie
    return _internal_process(path)
```

```python
# ❌ Raise too late — po side effects
def process_and_save(path: Path, output: Path) -> None:
    result = expensive_process(path)   # 10s GPU → już się stało
    if not output.parent.exists():     # Powinno być PRZED processing!
        msg = f"Output dir missing: {output.parent}"
        raise FileNotFoundError(msg)
```

### 3.3 Catch late

```python
# ✅ Handler na granicy API
@app.exception_handler(AppError)
async def handle_error(request: Request, exc: AppError) -> JSONResponse:
    status_code = _resolve_status(exc)
    logger.opt(exception=exc).error(
        "Request failed: {code}",
        code=exc.context.code,
    )
    return JSONResponse(
        status_code=status_code,
        content={"error": str(exc.context.code), "message": exc.context.message},
    )
```

```python
# ❌ Catch too early — caller nie wie o błędzie
def _internal_process(path: Path) -> ProcessedImage | None:
    try:
        model = load_model()
    except StorageConnectionError:
        return None  # Caller dostaje None bez kontekstu!
```

---

## 4. Exception chaining — `raise from`

### 4.1 Trzy formy

| Forma | Atrybut | Komunikat w traceback | Kiedy |
|-------|---------|----------------------|-------|
| `raise X from Y` | `__cause__ = Y` | _"The above exception was the **direct cause**…"_ | Zamieniasz wyjątek w except |
| `raise X from None` | `__suppress_context__ = True` | Brak oryginalnego traceback | Świadomie ukrywasz oryginalny wyjątek |
| `raise X` (w except) | `__context__ = Y` (implicit) | _"During handling… another exception occurred"_ | ❌ Unikaj — implicit chaining jest myląca |

### 4.2 Snippety

```python
# ✅ Explicit chaining — wrap lower-level exception
try:
    conn = database.connect(url)
except sqlite3.OperationalError as exc:
    msg = f"Cannot connect to {url}"
    raise DatabaseConnectionError(msg) from exc

# ✅ Suppress context — oryginalny wyjątek jest misleading
try:
    value = complex_lookup(key)
except (KeyError, IndexError):
    msg = f"Missing config: {key}"
    raise ConfigError(msg) from None

# ✅ Use case: konwersja low-level exception → domain exception
try:
    config_file = Path("/etc/app.conf")
    content = config_file.read_text()
except FileNotFoundError:
    # FileNotFoundError nie mówi o domenie — konwertujemy
    msg = f"Config file missing: {config_file}"
    raise ConfigMissingError(msg) from None

# ✅ Re-raise same exception — bare raise (zachowuje traceback)
try:
    result = compute()
except ValueError:
    logger.warning("Computation failed, retrying...")
    raise  # Zachowuje ORYGINALNY traceback
```

```python
# ❌ B904: raise bez from w except — implicit chaining, myląca
try:
    data = json.loads(raw)
except json.JSONDecodeError:
    raise ValidationError("Invalid JSON")  # Brak `from exc`!

# ❌ TRY201: verbose re-raise — użyj bare raise
try:
    result = compute()
except ValueError as exc:
    raise exc  # → użyj `raise` (bez `exc`)
```

> **Ruff:** `B904` (raise-without-from-inside-except), `TRY201` (verbose-raise).
> **PEP:** [PEP 3134](https://peps.python.org/pep-3134/) — Exception Chaining and Embedded Tracebacks.

---

## 5. Custom exceptions — reguły projektowania

### 5.1 Reguły nazewnictwa i struktury

| Reguła | Dlaczego | Ruff |
|--------|----------|------|
| Nazwa kończy się na `Error` | Konwencja, czytelność | `N818` |
| Dziedziczy po `Exception` (nie `BaseException`) | `except Exception` musi łapać | — |
| Wywołuje `super().__init__()` | Poprawna inicjalizacja `args` | — |
| NIGDY raw/f-string/`.format()` bezpośrednio w `raise` | Koszt alokacji + duplikacja w traceback | `EM101`/`EM102`/`EM103` |
| Nie `raise Exception("...")` | Użyj custom hierarchy | `TRY002` |
| Nie zbyt długi message w `raise ValueError(...)` | Powinno być custom exception z atrybutami | `TRY003` |

### 5.2 Message w zmiennej — reguła EM

```python
# ✅ Message w zmiennej
msg = f"Cannot connect to storage: {db_url}"
raise StorageConnectionError(msg)

# ✅ Structured context (najlepsza opcja dla dużych systemów)
raise StorageError(
    context=ErrorContext(
        code=ErrorCode.STORAGE_FAILED,
        message=f"Storage backend {backend_name} failed",
        suggestion="Check connection settings",
        details={"backend": backend_name},
    ),
)
```

```python
# ❌ EM101: raw string w raise
raise ValueError("Invalid input")

# ❌ EM102: f-string w raise
raise ValueError(f"Invalid input: {value}")

# ❌ EM103: .format() w raise
raise ValueError("Invalid input: {}".format(value))

# ❌ TRY002: raise vanilla Exception
raise Exception("something failed")

# ❌ PLW0133: exception bez raise (literówka!)
ValueError("this does nothing")  # Zapomniany `raise`!
```

### 5.3 Kiedy klasa vs tuple args

| Sytuacja | Forma | Przykład |
|----------|-------|---------|
| Prosty walidacyjny błąd | `msg = ...; raise ValueError(msg)` | `raise ValueError(msg)` |
| Domenowy błąd z kontekstem | Custom exception + atrybuty | `raise StorageConnectionError(msg, url=u)` |
| Błąd z metadanymi (code, suggestion) | Custom exception + `ErrorContext` | `raise X(context=ErrorContext(...))` |
| ≥3 informacje w message | Custom exception — nie mega-string | `TRY003` violation |

---

## 6. Error propagation — `try`/`except`/`else`/`finally`

### 6.1 Semantyka bloków

| Blok | Kiedy się wykonuje | Co tu DAĆ |
|------|--------------------|-----------| 
| `try` | Zawsze | **MINIMALNY** kod który może rzucić target exception |
| `except X` | Gdy `try` rzucił `X` | Handler na **KONKRETNY** wyjątek |
| `else` | Gdy `try` **NIE** rzucił | Happy path — KOD NIEZABEZPIECZONY przez except |
| `finally` | **ZAWSZE** — nawet przy `return` w try/except | Cleanup — NIE dawaj tu `return`/`break`/`continue` |

### 6.2 Snippety

```python
# ✅ Poprawne użycie else — happy path niezabezpieczony
try:
    file = open(path)
except FileNotFoundError:
    logger.warning("File not found: {path}", path=path)
    content = ""
else:
    # Wykonuje się TYLKO jeśli open() się powiodło
    # NIE jest chroniony przez except — bug w parse() nie zostanie ukryty
    content = file.read()
    result = parse(content)
finally:
    if "file" in locals():
        file.close()

# ✅ Jeszcze lepiej — context manager eliminuje finally
try:
    with open(path) as file:
        content = file.read()
except FileNotFoundError:
    content = ""
```

```python
# ❌ Za duży try body — który plik nie istnieje?
try:
    config = load_config()         # FileNotFoundError?
    model = init_model(config)     # FileNotFoundError?
    data = load_data()             # FileNotFoundError?
    result = process(model, data)
    save(result)                   # FileNotFoundError?
except FileNotFoundError:
    logger.error("File not found")  # Który???

# ❌ SIM107: return w try+finally — finally nadpisuje!
def get_value() -> int:
    try:
        return compute()
    except ValueError:
        return 0
    finally:
        return -1  # ZAWSZE nadpisze! Bug!

# ❌ B012: jump statement w finally
try:
    result = compute()
finally:
    return result  # Połknie KAŻDY wyjątek z try!
```

### 6.3 Tabela decyzyjna: łapać, propagować, opakowywać?

| Sytuacja | Decyzja | Wzorzec |
|----------|---------|---------|
| Wiesz CO zrobić z wyjątkiem | **Łap** | `except X: handle()` |
| Nie wiesz — jesteś w środku stosu | **Propaguj** | Nie dodawaj `try/except` |
| Chcesz dodać kontekst z wyższej warstwy | **Opakuj** | `raise DomainError(...) from exc` |
| Musisz zlogować i przepuścić | `raise` po logu | `except X: logger.warning(...); raise` |
| Musisz zamienić na user-facing response | **Error boundary** | Patrz §7 |

> **Ruff:** `TRY203` (useless-try-except — re-raise bez modyfikacji → usuń `try/except`), `TRY300` (try-consider-else), `TRY301` (raise-within-try).

---

## 7. Error boundaries — API, CLI, worker

Error boundary = **jedyne miejsce** gdzie `except AppError` / `except Exception` jest akceptowalne. Wewnątrz systemu: propaguj, nie łap.

### 7.1 API boundary (FastAPI)

```python
# ✅ Centralized error handler — JEDYNE miejsce z except AppError
from myapp.errors import ErrorCode, FatalError, AppError, TransientError

_CODE_TO_STATUS: dict[ErrorCode, int] = {
    ErrorCode.INVALID_INPUT: 400,
    ErrorCode.NOT_FOUND: 404,
    ErrorCode.CONFIG_INVALID: 422,
    ErrorCode.RATE_LIMITED: 429,
    ErrorCode.TIMEOUT: 504,
    ErrorCode.SERVICE_UNAVAILABLE: 503,
}


def _resolve_status(exc: AppError) -> int:
    if exc.context:
        mapped = _CODE_TO_STATUS.get(exc.context.code)
        if mapped:
            return mapped
    if isinstance(exc, TransientError):
        return 503
    if isinstance(exc, FatalError):
        return 500
    return 500


@app.exception_handler(AppError)
async def app_error_handler(
    request: Request,
    exc: AppError,
) -> JSONResponse:
    status_code = _resolve_status(exc)
    logger.opt(exception=exc).error(
        "Domain error: {code}",
        code=exc.context.code,
    )
    return JSONResponse(
        status_code=status_code,
        content={
            "status": "error",
            "error": {
                "code": str(exc.context.code),
                "message": exc.context.message,
                "suggestion": exc.context.suggestion or None,
            },
        },
    )
```

### 7.2 CLI boundary

```python
# ✅ CLI entrypoint — top-level handler
def main() -> int:
    try:
        run_workflow()
        return 0
    except AppError as exc:
        click.echo(
            f"Error [{exc.context.code}]: {exc.context.message}",
            err=True,
        )
        if exc.context.suggestion:
            click.echo(f"Suggestion: {exc.context.suggestion}", err=True)
        return 1
    except KeyboardInterrupt:
        click.echo("\nCancelled.", err=True)
        return 130
    except Exception:
        logger.exception("Unexpected error")
        return 2
```

### 7.3 Background worker boundary

```python
# ✅ Worker task — log + retry transient, fail fatal
async def worker_task(job: Job) -> JobResult:
    try:
        return await process_job(job)
    except TransientError as exc:
        logger.warning(
            "Transient error in job {job_id}, will retry: {code}",
            job_id=job.id,
            code=exc.context.code,
        )
        raise  # Retry framework (Celery/ARQ) obsłuży retry
    except FatalError as exc:
        logger.opt(exception=exc).error(
            "Fatal error in job {job_id}: {code}",
            job_id=job.id,
            code=exc.context.code,
        )
        return JobResult(status="failed", error=exc.context)
    except Exception:
        logger.exception("Unexpected error in job {job_id}", job_id=job.id)
        return JobResult(status="failed", error=ErrorContext(
            code=ErrorCode.UNKNOWN,
            message="Unexpected internal error",
        ))
```

### 7.4 Tabela decyzyjna: mapping wyjątków na HTTP

| Typ wyjątku | HTTP Status | Retry? |
|-------------|-------------|--------|
| Walidacja inputu, `ValueError` | 400 Bad Request | ❌ |
| Resource not found | 404 Not Found | ❌ |
| Config invalid | 422 Unprocessable Entity | ❌ |
| Rate limited | 429 Too Many Requests | ✅ (after backoff) |
| `TransientError` (network, timeout) | 503 Service Unavailable | ✅ |
| Timeout | 504 Gateway Timeout | ✅ |
| `FatalError` (model, config) | 500 Internal Server Error | ❌ |
| Unexpected `Exception` | 500 Internal Server Error | ❌ |

---

## 8. Context manager i async error handling

### 8.1 Context manager — `contextlib.suppress`

```python
from contextlib import suppress, ExitStack

# ✅ suppress zamiast try/except/pass
with suppress(FileNotFoundError):
    os.remove(tmpfile)

# ❌ SIM105: suppressible-exception — użyj suppress()
try:
    os.remove(tmpfile)
except FileNotFoundError:
    pass
```

### 8.2 `__exit__` — return value

```python
# ✅ Context manager z cleanup (NIE suppress)
class ManagedConnection:
    def __enter__(self) -> ManagedConnection:
        self._conn = connect(self._url)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        self._conn.close()
        # return None (default) → exception propagates
```

```python
# ❌ Context manager połykający WSZYSTKIE wyjątki
class BadContext:
    def __exit__(self, *exc: object) -> bool:
        return True  # Połyka KAŻDY wyjątek — niebezpieczne!
```

### 8.3 `ExitStack` — dynamiczna liczba resources

```python
# ✅ ExitStack — gdy nie znasz liczby resources z góry
from contextlib import ExitStack

with ExitStack() as stack:
    files = [stack.enter_context(open(f)) for f in file_list]
    process_all(files)
```

### 8.4 Async error handling

**Kluczowe różnice:**
- `asyncio.CancelledError` dziedziczy po `BaseException` (Python 3.9+) — `except Exception` go NIE łapie ✅
- `TaskGroup` zbiera wyjątki z wielu tasków → `ExceptionGroup`
- Cleanup MUSI być `await`-owany

> ⚠️ **Python 3.11+:** `except*` i `ExceptionGroup` wymagają Python 3.11+. Na 3.10 ten kod się nie sparsuje — użyj `exceptiongroup` backport lub zwykłego `try/except` z ręcznym zbieraniem wyjątków.

```python
# ✅ TaskGroup z ExceptionGroup (Python 3.11+)
import asyncio

async def process_batch(items: list[str]) -> list[Result]:
    results: list[Result] = []
    try:
        async with asyncio.TaskGroup() as tg:
            tasks = [tg.create_task(process(item)) for item in items]
    except* ValueError as eg:
        # except* — łapie TYLKO ValueError z grupy
        for exc in eg.exceptions:
            logger.warning("Validation error: {exc}", exc=exc)
    except* ConnectionError as eg:
        msg = "Network errors in batch"
        raise TransientError(msg) from eg
    return [t.result() for t in tasks if not t.cancelled()]
```

```python
# ✅ Graceful cancellation — ZAWSZE re-raise CancelledError
async def worker(queue: asyncio.Queue[str]) -> None:
    try:
        while True:
            item = await queue.get()
            await process(item)
    except asyncio.CancelledError:
        logger.info("Worker cancelled, cleaning up...")
        raise  # ZAWSZE re-raise!
```

```python
# ❌ Połykanie CancelledError — task nigdy nie zostanie anulowany
async def bad_worker() -> None:
    try:
        await do_work()
    except BaseException:  # Łapie CancelledError!
        pass

# ❌ Sync cleanup w async context
async def bad_cleanup() -> None:
    conn = await connect()
    try:
        yield conn
    finally:
        conn.close()  # NIE jest awaited → resource leak!
        # → await conn.close()
```

> **PEP:** [PEP 654](https://peps.python.org/pep-0654/) — Exception Groups and `except*`.

---

## 9. Retry patterns — `tenacity`

### 9.1 Reguły retry

| Reguła | Dlaczego |
|--------|----------|
| Retry TYLKO `TransientError` | `FatalError` się NIE naprawi — retry = strata czasu |
| ZAWSZE `stop` (max attempts/delay) | Bez limitu = infinite loop |
| ZAWSZE exponential backoff + jitter | Bez backoff = thundering herd, DDoS |
| `reraise=True` | Oryginalny exception w traceback, nie `RetryError` |
| Loguj przed retry | Visibility — wiesz że retry się dzieje |

### 9.2 Production retry pattern

```python
# ✅ Production-grade retry z tenacity
from tenacity import (
    RetryCallState,
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
    wait_random,
)
from loguru import logger


def _log_before_retry(state: RetryCallState) -> None:
    """Custom callback — loguru zamiast stdlib before_sleep_log."""
    logger.warning(
        "Retry attempt {attempt} for {func}",
        attempt=state.attempt_number,
        func=state.fn.__name__ if state.fn else "unknown",
    )


@retry(
    retry=retry_if_exception_type(TransientError),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=30) + wait_random(0, 2),
    reraise=True,
    before_sleep=_log_before_retry,
)
async def call_api(url: str, client: httpx.AsyncClient) -> dict[str, Any]:
    response = await client.get(url)
    if response.status_code == 429:
        msg = "Rate limited"
        raise PaymentRateLimitError(msg)
    if response.status_code >= 500:
        msg = f"Server error: {response.status_code}"
        raise TransientError(msg)
    return response.json()


# ✅ Async retry z AsyncRetrying (context manager)
from tenacity import AsyncRetrying

async def call_with_retry(url: str, client: httpx.AsyncClient) -> dict[str, Any]:
    async for attempt in AsyncRetrying(
        stop=stop_after_attempt(3),
        wait=wait_exponential(min=1, max=10),
        reraise=True,
    ):
        with attempt:
            response = await client.get(url)
            return response.json()
```

### 9.3 Retry context manager (dla bloków kodu)

```python
# ✅ Retry jako context manager
from tenacity import Retrying

for attempt in Retrying(
    stop=stop_after_attempt(3),
    wait=wait_exponential(min=1, max=10),
    reraise=True,
):
    with attempt:
        conn = database.connect(url)
```

```python
# ❌ Retry bez stop — infinite loop
@retry
def might_fail() -> None:
    raise IOError("always fails")  # Nieskończona pętla!

# ❌ Retry BEZ backoff — thundering herd
@retry(stop=stop_after_attempt(10))
def call_api() -> None: ...  # 10 natychmiastowych requestów do API!

# ❌ Retry ALL exceptions (łącznie z FatalError!)
@retry(stop=stop_after_attempt(3))
def process() -> None:
    validate_config()  # ConfigError NIE powinno być retried!

# ❌ Manual retry loop (reinventing the wheel)
for i in range(3):
    try:
        result = call_api()
        break
    except Exception:
        if i == 2:
            raise
        time.sleep(2**i)  # Brak jitter, brak logging, brak klasyfikacji
```

---

## 10. Logowanie i testowanie wyjątków

### 10.1 Logowanie — reguły

| Reguła | Dobrze | Źle | Ruff |
|--------|--------|-----|------|
| Traceback w except | `logger.exception("msg")` | `logger.error(str(exc))` | `TRY400` |
| Nie powtarzaj `exc` w message | `logger.exception("Failed")` | `logger.exception(f"Failed: {exc}")` | `TRY401` |
| loguru: `{}` placeholders | `logger.error("x: {val}", val=val)` | `logger.error(f"x: {val}")` | — |
| stdlib: nie używaj f-string | `logging.error("x: %s", val)` | `logging.error(f"x: {val}")` | `G004` |
| stdlib: nie używaj `.format()` / `+` | `logging.error("x: %s", val)` | `logging.error("x: " + str(val))` | `G003` |

> ⚠️ **loguru vs stdlib:** `G001`–`G004` dotyczą TYLKO stdlib `logging`. loguru natywnie używa `{}` placeholders — `logger.info("x: {val}", val=val)`. Nie mieszaj konwencji! loguru = preferowany logger (`from loguru import logger`).

```python
# ✅ loguru w except block
from loguru import logger

try:
    result = process(data)
except AppError as exc:
    logger.opt(exception=exc).error(
        "Processing failed: {code}",
        code=exc.context.code,
    )
    raise
except Exception:
    logger.exception("Unexpected error")  # Pełny traceback
    raise
```

```python
# ❌ TRY400: error zamiast exception — brak traceback!
logger.error("Failed: %s", exc)

# ❌ TRY401: redundantny exc w message
logger.exception(f"Failed: {exc}")  # exc jest JUŻ w traceback!
```

### 10.2 Log OR raise — nigdy oba

> ℹ️ **Structured logging:** Przy użyciu `ErrorContext` (sekcja 5) loguj error jako JSON-serializable dict — ułatwia agregację w CloudWatch/ELK:
> ```python
> error_dict = {"code": str(exc.context.code), "message": exc.context.message}
> logger.opt(exception=exc).error("Domain error: {error}", error=error_dict)
> ```

```python
# ❌ Log AND raise — podwójne logowanie
try:
    process()
except ProcessError as exc:
    logger.exception("Failed")  # Zalogowane TUTAJ...
    raise  # ...i zalogowane PONOWNIE na error boundary!

# ✅ Wybierz jedno: albo zaloguj, albo przepuść na boundary
# Opcja A: log + handle locally
except ProcessError as exc:
    logger.warning("Failed, using fallback")
    return fallback_value

# Opcja B: propagate to boundary (boundary zaloguje)
except ProcessError:
    raise
```

### 10.3 Testowanie wyjątków — pytest

```python
# ✅ Specific exception + message match
def test_invalid_config_raises() -> None:
    with pytest.raises(ConfigError, match=r"Missing required field"):
        load_config({})

# ✅ Test exception attributes
def test_error_context() -> None:
    with pytest.raises(StorageError) as exc_info:
        store(bad_data)
    assert exc_info.value.context.code == ErrorCode.STORAGE_FAILED
    assert "engine" in exc_info.value.context.details

# ✅ Parametrize error cases
@pytest.mark.parametrize(
    ("input_data", "expected_error", "match"),
    [
        ({}, ConfigError, r"Missing"),
        ({"x": -1}, ValueError, r"positive"),
    ],
)
def test_validation_errors(
    input_data: dict[str, Any],
    expected_error: type[Exception],
    match: str,
) -> None:
    with pytest.raises(expected_error, match=match):
        validate(input_data)
```

```python
# ❌ PT011: pytest.raises bez match — który ValueError?
with pytest.raises(ValueError):  # Brak match!
    process(data)

# ❌ B017: pytest.raises(Exception) — za szerokie
with pytest.raises(Exception):  # Łapie WSZYSTKO!
    do_work()

# ❌ PT012: wiele statements w pytest.raises body
with pytest.raises(ValueError):
    x = setup()     # Co jeśli TO rzuci ValueError?
    process(x)      # Chcieliśmy testować TO
```

> **Ruff:** `PT010`, `PT011`, `PT012`, `PT017`, `B017`.
> **Powiązane:** `06-function-api-design.md` §8 — antypatterny API.

---

## 11. Antypatterny

| # | Antypattern | Waga | Dlaczego źle | Naprawa |
|---|-------------|------|-------------|---------|
| 1 | **Bare `except:`** | 🔴 CRITICAL | Łapie `KeyboardInterrupt`, `SystemExit` | `except SpecificError:` |
| 2 | **Pokemon handling** (`except Exception: pass`) | 🔴 CRITICAL | Ukrywa WSZYSTKIE bugi | Specific except + handle/re-raise |
| 3 | **`raise` bez `from`** w except | 🔴 CRITICAL | Implicit chaining myląca | `raise X from exc` |
| 4 | **Return `None` on error** | 🟡 HIGH | Caller nie wie czemu `None` | Propaguj wyjątek |
| 5 | **Log AND raise** | 🟡 HIGH | Podwójne logowanie | Log LUB raise — boundary loguje |
| 6 | **Too broad try body** | 🟡 HIGH | Nie wiesz KTÓRE call rzuciło | Minimalizuj try body |
| 7 | **`return` w `finally`** | 🔴 CRITICAL | Nadpisuje return z try/except | Nigdy `return`/`break`/`continue` w finally |
| 8 | **Exception w `__del__`** | 🟡 HIGH | Silently swallowed przez GC | Context manager (`__enter__`/`__exit__`) |
| 9 | **`assert` w produkcji** | 🟡 HIGH | Usunięte przez `python -O` | `if not x: raise ValueError(msg)` |
| 10 | **Mutable default w exception `__init__`** | 🟢 MEDIUM | Shared state | `None` sentinel, `field(default_factory=...)` |
| 11 | **`eval()`/`exec()` zamiast parsera** | 🔴 CRITICAL | Arbitrary code execution | `ast.literal_eval()`, `lark`, `pyparsing` |
| 12 | **Retry bez klasyfikacji** | 🟡 HIGH | Retryuje `FatalError` | `retry_if_exception_type(TransientError)` |

---

## 12. Egzekucja ruff

Kompletna mapa reguł ruff dotyczących error handling:

### 12.1 Priorytet: 🔴 CRITICAL — zawsze włączaj

| Reguła | Opis |
|--------|------|
| `E722` | Bare `except:` — nigdy |
| `B904` | `raise` bez `from` w except block |
| `B012` | `return`/`break`/`continue` w `finally` |
| `B029` | `except` z pustą krotką `except ():` |
| `BLE001` | `except Exception` bez re-raise (blind except) |
| `EM101` | Raw string w `raise` |
| `EM102` | f-string w `raise` |
| `EM103` | `.format()` w `raise` |
| `N818` | Exception class bez suffixu `Error` |
| `PLW0133` | Exception statement bez `raise` |
| `PLW0711` | `except A or B` → `except (A, B)` |
| `SIM107` | `return` w `try` + `finally` |
| `S307` | `eval()` — NIGDY |
| `S102` | `exec()` — NIGDY |

### 12.2 Priorytet: 🟡 HIGH — rekomendowane

| Reguła | Opis |
|--------|------|
| `TRY002` | `raise Exception(...)` — użyj custom hierarchy |
| `TRY003` | Zbyt długi message w vanilla `raise ValueError(...)` |
| `TRY004` | `isinstance` check → `raise TypeError` |
| `TRY201` | `raise exc` → bare `raise` |
| `TRY203` | Useless try/except (re-raise bez modyfikacji) |
| `TRY300` | Kod w `try` → powinien być w `else` |
| `TRY301` | `raise` w `try` → powinien być w `except` |
| `TRY400` | `logger.error()` w except → `logger.exception()` |
| `TRY401` | `logger.exception(f"{exc}")` — redundantne |
| `S110` | `try`/`except`/`pass` (security) |
| `S112` | `try`/`except`/`continue` (security) |
| `S101` | `assert` w produkcyjnym kodzie |
| `B017` | `pytest.raises(Exception)` — za szerokie |
| `B025` | Duplikat exception w `except` |
| `PT010` | `pytest.raises()` bez exception class |
| `PT011` | `pytest.raises` bez `match` |
| `PT012` | Wiele statements w `pytest.raises` body |
| `PT017` | `assert` w `except` block |

### 12.3 Priorytet: 🟢 NICE-TO-HAVE

| Reguła | Opis |
|--------|------|
| `SIM105` | `try`/`except`/`pass` → `contextlib.suppress()` |
| `PERF203` | `try`/`except` w tight loop → performance hit |
| `RSE102` | `raise X()` bez args → `raise X` |
| `RET506` | `else` po `raise` → zbędne |
| `DOC502` | Udokumentowany wyjątek, który nie jest rzucany |
| `LOG001` | `Logger()` bezpośrednio — użyj `getLogger()` |
| `LOG002` | `getLogger()` bez `__name__` |
| `LOG007` | `logging.exception()` z falsy `exc_info` |
| `LOG009` | `logging.WARN` → `logging.WARNING` |
| `LOG014` | `exc_info=` poza except handler |
| `LOG015` | `logging.info()` na root — użyj `logger.info()` |
| `G001` | `.format()` w logging |
| `G002` | `%` operator w logging |
| `G003` | Concatenation w logging |
| `G004` | f-string w logging |
| `G010` | `.warn()` → `.warning()` |
| `G201` | `.error(exc_info=True)` → `.exception()` |

> ⚠️ **loguru:** Reguły `G001`/`G002` dotyczą TYLKO stdlib `logging`. loguru natywnie używa `{}` placeholders.

---
## Źródła

- [Python Tutorial: Errors and Exceptions](https://docs.python.org/3/tutorial/errors.html) — oficjalna dokumentacja
- [Python Library: Built-in Exceptions](https://docs.python.org/3/library/exceptions.html) — pełna hierarchia wbudowanych wyjątków
- [PEP 3134 — Exception Chaining and Embedded Tracebacks](https://peps.python.org/pep-3134/) — `raise from`, `__cause__`, `__context__`
- [PEP 654 — Exception Groups and `except*`](https://peps.python.org/pep-0654/) — `ExceptionGroup`, `TaskGroup`
- [RealPython: LBYL vs EAFP](https://realpython.com/python-lbyl-vs-eafp/) — porównanie stylów z benchmarkami
- [RealPython: Python Exceptions](https://realpython.com/python-exceptions/) — praktyczny poradnik exception handling
- [Python contextlib documentation](https://docs.python.org/3/library/contextlib.html) — `suppress`, `ExitStack`, `@contextmanager`
- [Tenacity documentation](https://tenacity.readthedocs.io/en/latest/) — retry patterns, exponential backoff
- [Architecture Patterns with Python — Percival & Gregory](https://www.cosmicpython.com/) — Repository, UoW, error boundaries
- [Ruff Rules — Error Handling](https://docs.astral.sh/ruff/rules/) — EM, TRY, B, SIM, PT, BLE, S
