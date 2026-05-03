---
applyTo: "**/*.py"
---

# Python Master Instructions

> **Skill:** `.github/skills/python/SKILL.md` — meta-plik ze strukturą, opisami sekcji i nawigacją.
> Skondensowana wiedza z 14 sekcji referencyjnych (`python/references/00-15`).
> Hasłowe reguły — pełny kontekst w odpowiedniej sekcji `references/XX-*.md`.

---

## 00 — uv & Tooling

- **Python ≥3.10** — `match/case`, `X | Y` unions, `from __future__ import annotations`
- **`uv`** — jedyny package manager (zastępuje pip, poetry, pipenv, pyenv). NIGDY `pip install`

### uv — Komendy

- **Repo rule:** przed dodaniem dependency użyj `.github/instructions/dependency-workflow.instructions.md`; gołe `uv add <pkg>` tylko dla lekkiego core CLI/config/network.
- **`uv add <pkg>`** — dodaj do `[project.dependencies]` (NIGDY ręczna edycja pyproject.toml)
- **`uv add --dev <pkg>`** — dev tools → `[dependency-groups.dev]`
- **`uv add --optional <extra> <pkg>`** — feature extras → `[project.optional-dependencies]`
- **`uv sync`** — instaluj lockfile do `.venv` (po `git pull`)
- **`uv run <cmd>`** — uruchom w kontekście projektu (auto-sync)
- **`uv lock`** — aktualizuj `uv.lock`
- **`uv python pin <ver>`** — pin wersji Pythona → `.python-version`
- **Commituj:** `pyproject.toml`, `uv.lock`, `.python-version` ✅ · `.venv/` → `.gitignore` ❌

### pyproject.toml

- **`[project]`** — metadata: `name`, `version`, `requires-python`, `dependencies`
- **`[project.optional-dependencies]`** — feature extras: `cuda = [...]`, `web = [...]`, `all = [...]`
- **`[dependency-groups]`** (PEP 735) — dev groups: `dev`, `lint`, `test`, `type`, `docs`
- **`[tool.uv]`** — uv config + `[tool.uv.sources]` dla path/git overrides
- **`[build-system]`** — tylko library: `requires = ["hatchling"]`

### ruff — Linter & Formatter

- **ruff** — 10-100x szybszy od flake8+black+isort; line-length=120, target py310
- **Tier 1 🔴 MUSISZ:** `F`, `E`, `W`, `I`, `N`, `UP`, `B`, `S`, `BLE`, `G`, `T20`, `RUF` — bugi, security
- **Tier 2 🟡 POWINIENEŚ:** `C4`, `SIM`, `RET`, `PTH`, `PT`, `TRY`, `PERF`, `PL`, `LOG` — jakość
- **Tier 3 🟢 FAJNIE:** `D`, `ANN`, `TC`, `ASYNC`, `DTZ` — domain-specific
- **Nauka reguł:** `uv run ruff rule <CODE>` — opis + przykłady
- **Config:** `select`, `ignore`, `per-file-ignores` (tests, scripts, migrations)

### mypy — Type Checker

- **`strict = true`** — ~15 flag: `disallow_untyped_defs`, `disallow_any_generics`, `strict_equality`
- **Overrides 3rd party:** `ignore_missing_imports = true` (brak type stubów)
- **Overrides tests:** `disallow_untyped_defs = false` (fixtures bez typów OK)
- **`uv run mypy --install-types`** — auto-instaluj brakujące stuby

### Pylance — IDE Type Checker

- **Zero Pylance errors** — po KAŻDEJ edycji `.py` sprawdź `get_errors` i napraw ZANIM uznasz task za skończony
- **Nie ignoruj** — Pylance łapie to, czego ruff i mypy nie widzą (np. Literal narrowing, unbound vars)
- **Workflow:** edytuj → `get_errors` → napraw → dopiero wtedy commituj

### pre-commit & CI

- **pre-commit** — ruff check --fix + ruff format + mypy automatycznie przed commitem
- **CI:** `uv sync --frozen --all-groups` (fail jeśli lockfile outdated) → ruff → mypy → pytest

### Dev Workflow

| Etap | Komenda |
|------|---------|
| Dodaj package | `uv add <pkg>` |
| Po git pull | `uv sync` |
| Lint + autofix | `uv run ruff check --fix .` |
| Format | `uv run ruff format .` |
| Type check | `uv run mypy src/` |
| Testy | `uv run pytest` |

---

## 01 — Docstrings & Comments

**Styl:** Google-style. Jeden styl, zero wyjątków. DRY z type hints — NIE powtarzaj typów w docstringu.

### Kiedy pisać docstring

| Element | Docstring? | Format |
|---------|-----------|--------|
| **Moduł** | ✅ Public/złożony | Opis + `Usage:` example |
| **Klasa publiczna** | ✅ ZAWSZE | Czym jest + Attributes (public fields) |
| **`__init__`** | ⚠️ Gdy ma logikę/params | Args + Raises; class docstring pokrywa summary |
| **Metoda/funkcja publiczna** | ✅ ZAWSZE | Summary + Args + Returns + (Raises/Yields) |
| **`@property`** | ⚠️ Gdy complex | One-liner z semantyką |
| **Dekorator** | ✅ ZAWSZE | Czym jest + kiedy użyć + side effects |
| **Context manager** | ✅ ZAWSZE | Co acquireuje; Yields; wyjątki |
| **`Final` const** | ✅ ZAWSZE | One-liner: czym jest |
| **`_private` helper** | ❌ | Wystarczy `# WHY` komentarz jeśli potrzeba |
| **Test function** | ❌ | Nazwa testu = opis: `test_login_fails_with_wrong_password` |

### Sekcje Google-style

| Sekcja | Kiedy | Format |
|--------|-------|--------|
| **Args** | Funkcja ma params | `name: Opis (bez typu).` |
| **Returns** | Coś zwraca (nie `None`) | Opis wartości; bullet list dla complex |
| **Yields** | Generator / `yield` | Opis yielded wartości |
| **Raises** | Rzuca exceptions | `ExceptionType: Kiedy rzuca.` |
| **Warns** | `warnings.warn()` | `WarningType: Kiedy emituje.` |
| **Attributes** | Public fields klasy | `name: Opis (bez typu).` |
| **Example** | Public API | `>>>` doctest (sync) / indented block (async/multi-step) |

### Format

- **One-liner:** `"""Imperative mood with period."""`
- **Multi-liner:** Pusta linia między summary i body
- **Typy w docstring** — NIGDY (są w signature)
- **`>>>`** doctest: sync, 1-3 linie; **indented block**: async lub >5 linii

### Comments

- **WHY, nie WHAT** — kod pokazuje WHAT, komentarz wyjaśnia DLACZEGO
- **Block comment** — NAD kodem; **inline** — ta sama linia (krótko)
- **Section separators** — `# ── Nazwa ──────────` (em dash) dla modułów >200 linii. **Całkowita długość: 80 znaków.** Formuła: `─` × (80 − len(`# ── Nazwa `)).
- **TODO:** `# TODO(username): Opis. #issue`
- **FIXME:** `# FIXME(username): Opis bugu.` (FIXME > TODO dla bugów)
- **HACK:** `# HACK(username): Workaround. Remove after vX.Y.`

### ruff D config

- **Convention:** `convention = "google"` (auto: D211+D212 ON, D203+D213 OFF)
- **Ignore:** `D100` (moduł), `D104` (__init__), `D105` (magic), `D107` (__init__ docstring)
- **Per-file-ignores:** `"tests/**" = ["D"]`, `"scripts/**" = ["D"]`
- **Częste błędy:** D200, D205, D212, D400, D403, D417

---

## 02 — Type Hints

**Zasada:** Typuj WSZYSTKO — parametry, returny, zmienne, atrybuty. Zero wyjątków. Typ hints = dokumentacja weryfikowana narzędziami.

### Setup

- `from __future__ import annotations` — linia 1 KAŻDEGO modułu (forward refs, `X | Y` na 3.9+)
- **Lowercase generics:** `list[str]`, `dict[K, V]`, `tuple[X, ...]` — NIGDY `List`, `Dict`, `Tuple`
- **Union syntax:** `X | Y` — NIGDY `Union[X, Y]`; `X | None` — NIGDY `Optional[X]`
- **Return `None` jawnie:** `def setup() -> None:`
- **Puste kolekcje typuj:** `items: list[str] = []` (mypy nie wyinferuje)

### Kolekcje — co kiedy

| Typ | Użyj | Kiedy |
|-----|------|-------|
| `list[X]` | Zmienna długość | mutable sequence |
| `tuple[X, Y, Z]` | Stała długość | heterogeneous |
| `tuple[X, ...]` | Wariacyjna | homogeneous |
| `dict[K, V]` | Klucz-wartość | mutable mapping |
| `set[X]` / `frozenset[X]` | Unikalne | mutable / immutable |
| `Sequence[X]` | Read-only param | `def f(items: Sequence[int])` |
| `Mapping[K, V]` | Read-only dict param | `def f(cfg: Mapping[str, str])` |
| `Callable[[P1, P2], R]` | Callback/handler | `handler: Callable[[str], bool]` |

### Zaawansowane typy

- **`TypeVar`** — generics z consistency: `T = TypeVar("T")` → `list[T] -> T`
- **`ParamSpec`** — dekoratory zachowujące sygnaturę (ZAWSZE zamiast `Any` w decorator)
- **`Protocol`** — structural subtyping (duck typing z typami, bez inheritance)
- **`@overload`** — różne sygnatury per typ parametru (max 2-3 warianty)
- **`TypeGuard`** — custom type narrowing: `def is_str_list(x) -> TypeGuard[list[str]]`
- **`Final`** — stałe: `MAX_RETRIES: Final[int] = 5`
- **`Literal`** — ograniczone wartości: `mode: Literal["fast", "accurate"]`
- **`TypeAlias`** — nazwy złożonym typom (3.10); `type X = ...` (3.12+)
- **`Self`** (3.11+) — builder/fluent API return type
- **`Never`** — funkcja nigdy nie wraca (raises, infinite loop)
- **`NamedTuple`** — immutable tuple z nazwami pól

### TYPE_CHECKING block

- Heavy imports (`numpy`, `torch`) i circular deps → `if TYPE_CHECKING:` (runtime=noop, mypy=active)
- `Final`, `Literal` NIGDY do TYPE_CHECKING — są runtime-accessible
- Ruff `TCH001`/`TCH002`/`TCH003` — auto-detect importy do przeniesienia

### mypy & escape hatches

- **`strict = true`** — wymusza type hints na WSZYSTKIM
- **`cast()`** — zero runtime cost, zmiana typu dla mypy
- **`# type: ignore[code]`** — ZAWSZE z kodem błędu, nigdy gołe `# type: ignore`
- **`Any`** — last resort, unikaj

### Version-gated

- **3.10+:** `X | Y`, `zip(strict=True)`, `match/case`
- **3.11+:** `Self`, `NotRequired`, `ExceptionGroup`
- **3.12+:** `type X = ...` syntax, `TypeVarTuple`

---

## 03 — Imports & Exports

### Import order (ruff I001)

**5 grup**, każda oddzielona pustą linią, sorted wewnątrz:
1. **Future:** `from __future__ import annotations` — ZAWSZE linia 1
2. **stdlib** — `os`, `sys`, `pathlib`, `typing`
3. **third-party** — `pydantic`, `loguru`, `httpx`
4. **project** — absolute: `from myapp.services import UserService`
5. **relative** — `from .module import X` (max 1 poziom `..`)

### `from X import Y` vs `import X`

- **`from x import Y`** — klasa/funkcja używana wielokrotnie
- **`import x`** — moduł wielosubmodułowy (np. `os.path`, `json`)
- **Multi-line** — gdy >3-4 importów z tego samego modułu

### `__all__`

- **KAŻDY publiczny moduł i `__init__.py` MUSI mieć `__all__`**
- Lista stringów: sorted, trailing comma
- Importy re-exportowane bez `__all__` → `# noqa: F401`

### Star imports

- **NIGDY `from x import *`** — namespace pollution, shadowing
- Zawsze jawne listy importów

### TYPE_CHECKING block

- Heavy deps (`numpy`, `torch`), `collections.abc`, circular refs → `if TYPE_CHECKING:`
- Runtime=noop, mypy/Pylance=active
- Ruff `TCH001`/`TCH002`/`TCH003` wymuszają automatycznie

### Circular imports — 4 strategie

1. **`TYPE_CHECKING`** — annotation-only imports (najczęstsze)
2. **Wydziel typy** do osobnego modułu (`types.py` / `interfaces.py`)
3. **Import w function body** — ostateczność, z komentarzem dlaczego
4. **Refaktor architektury** — jeśli circular jest objawem złego designu

### Lazy imports

- Heavy optional deps (`torch`, `cv2`) → import w function body z komentarzem **dlaczego**
- Cel: startup time
- Unikaj side effects na module level

### Aliasy standardowe

- `np`, `pd`, `plt`, `tf` — używaj konwencji; NIGDY nie wymyślaj własnych

### ruff rules

- **I001** — sort imports
- **F401** — unused imports
- **TCH001-003** — TYPE_CHECKING enforcement
- **E402** — import not at top
- Config: `known-first-party`, `required-imports = ["from __future__ import annotations"]`

---

## 04 — Naming Conventions

### Konwencje per element

| Element | Convention | Przykład |
|---------|-----------|---------|
| Zmienne, funkcje, moduły | `snake_case` | `page_count`, `load_config()`, `panel_detector.py` |
| Klasy, TypeVar, Enum, Protocol | `PascalCase` | `UserService`, `T`, `Processable` |
| Stałe (module-level) | `SCREAMING_SNAKE` + `Final` | `MAX_DIM: Final[int] = 1024` |
| Prywatne API | prefix `_` | `_load_model()`, `_cache` |
| NamedTuple, TypeAlias | `PascalCase` | `TimingInfo`, `JsonDict` |
| Exceptions | `PascalCase` + suffix `Error` | `ModelNotFoundError` (ruff N818) |

### Funkcje — czasowniki

- **`verb_noun`** — default: `find_records`, `load_config`
- **Bool predykaty:** `is_valid`, `has_gpu`, `can_retry`, `should_retry`
- **Accessor:** `get_user()` (może rzucić)
- **Fabryka:** `create_session()`, `build_pipeline()`
- **Konwersja:** `to_json()`, `from_file()` (classmethod)
- **Bool params → ZAWSZE keyword-only (`*`)** dla jasności

### Magic numbers → Named constants

- **OK inline:** `0`, `1`, `-1`, `2` (indeksy), `100` (procenty), `""`, `[]`, `{}`
- **Reszta:** `Final` constants — `MAX_SIZE`, `TIMEOUT_SEC`, `DEFAULT_DPI`

### Akronimy

- **PascalCase = capitalize-first-only:** `OcrEngine`, `TtsService`, `HttpClient` (NIE `OCREngine`)

### Moduły & pakiety

- **Pliki:** `snake_case.py`; prywatne: `_compat.py`
- **Foldery:** `snake_case` (krótkie bez `_` gdy możliwe: `services/`, `utils/`)
- **Testy:** `test_*.py` (pytest discovery)

### Typy

- **TypeVar:** krótkie PascalCase: `T`, `_R`, `_KT`, `_VT`
- **Protocol:** PascalCase + `-able`/`-ible`: `Processable`, `Serializable`
- **Enum:** klasa `PascalCase`, members `SCREAMING_SNAKE`

### Prywatne API

- **`_name`** — konwencja (IDE + ruff ostrzegają)
- **`__name`** — name mangling (rzadko, tylko conflict z subclass)
- **Moduły:** `_internals.py`, `_compat.py`

### ruff N rules (N801-N816)

- Wymuszają PascalCase/snake_case/SCREAMING_SNAKE per element
- Auto-fix: NIE — naming wymaga ludzkiej intencji, ale ruff łapie naruszenia

---

## 05 — Code Patterns & Pythonic Idioms

### Tabele decyzyjne

| Wybór A | Wybór B | Kiedy A | Kiedy B |
|---------|---------|---------|---------|
| `pathlib.Path` | `os.path` | **ZAWSZE** (ruff PTH) | ❌ Legacy |
| Comprehension | Loop | Proste 1-2 `for`, bez side effects | Side effects, logika, ≥3 `for` |
| `dataclass` | `pydantic` | Internal DTO, frozen value objects | API + walidacja + serialization |
| `match/case` | `if/elif` | ≥3 warianty lub destructuring | 1-2 proste warunki |
| `f-string` | `.format()` / `%s` | Interpolacja (ruff UP031/UP032) | ❌ Legacy |
| `isinstance(x, T)` | `type(x) == T` | **ZAWSZE** (respektuje inheritance, E721) | ❌ Nigdy |

### String formatting hierarchy

1. **f-string** — interpolacja w kodzie
2. **loguru `{}`** — `logger.info("x: {val}", val=x)` — lazy eval, NIGDY f-string w logu (G004)
3. **`%s`** — TYLKO stdlib logging legacy (nie loguru)

### Control flow

- **Early return + guard clauses** — waliduj na wejściu → raise/return → happy path bez zagnieżdżeń
- **Max 2 poziomy zagnieżdżeń** — głębsze → extract helper
- **`match/case`** — Enum dispatch, destructuring (tuple, dataclass, dict), ≥3 warianty
- **Walrus `:=`** — regex match (`if (m := re.match(...))`), while read, filter+capture; NIGDY zwykłe assignment

### Zasoby & cleanup

- **Context managers** — KAŻDY zasób (pliki, połączenia, locki) → `with` statement
- **Custom:** `@contextmanager` + try/finally lub class `__enter__`/`__exit__`

### Truthiness & type checks

- **Empty check:** `if not items:` (lista pusta), NIE `if len(items) == 0`
- **None check:** `if x is None:` (identity), NIE `if x == None`
- **Type check:** `isinstance(x, (int, float))` — NIGDY `type(x) == T`

### Data structures

- **`__slots__`** — `@dataclass(frozen=True, slots=True)` dla value objects (pamięć + szybkość)
- **`Enum`** — closed set of values + match/case dispatch
- **Mutable defaults = BUG:** ❌ `def f(x=[])` (shared); ✅ `def f(x: list | None = None)` + factory (B006, RUF009)

### itertools / functools key patterns

- **`chain.from_iterable()`** — flatten nested iterables
- **`batched()`** (3.12+) — chunking
- **`@lru_cache`** — memoize pure functions
- **`@cached_property`** — lazy computed attribute
- **`partial()`** — currying / pre-fill args

### ruff enforcement

- **PTH** — pathlib; **C4** — comprehensions; **SIM** — simplify; **RET** — early return
- **PERF** — performance; **UP** — modernize (`|` union, f-string, match)

---

## 06 — Function & API Design

### Hard limits

| Metryka | Limit | Sweet spot |
|---------|-------|------------|
| Ciało funkcji | max 30 LOC | 15-20 LOC |
| Parametry | max 5 | 3 (powyżej → config object) |
| Zagnieżdżenie | max 2 poziomy | 1 |

### SRP (Single Responsibility)

- **Jedna funkcja = jedno zadanie** — komentarz "step 1/2" → osobna funkcja
- **Docstring PRZED implementacją** — doc-driven design
- **>5 parametrów** → Pydantic `BaseModel` jako config object

### Parametry

- **Boolean → ZAWSZE keyword-only:** `def fetch(*, verbose: bool = False)`
- **Mutable defaults NIGDY:** ❌ `def f(x=[])` → ✅ `def f(x: list | None = None)` (B006)
- **Keyword-only (`*`)** — dla clarity i forward compatibility

### Return types

- **Spójny kontrakt** — albo ZAWSZE wartość, albo ZAWSZE raise
- **Raw `tuple` NIE** → `NamedTuple` lub `dataclass`
- **Bare `dict` NIE** → `TypedDict` / dataclass / pydantic
- **`X | None`** — gdy brak wyniku jest legalne; brak → `raise`

### Pure vs impure

- **Core logic → pure functions** (zero side effects, testowalne)
- **I/O na brzegach:** Read (impure) → Compute (pure) → Write (impure)
- **Dependency injection** zamiast globali

### @overload

- **Max 2-3 warianty** — więcej → osobne funkcje
- **`TypeGuard`** dla custom predicates

### Deprecation

- **`warnings.warn(msg, DeprecationWarning, stacklevel=2)`**
- Message: co użyć ZAMIAST + wersja removal
- Backcompat: nowy keyword-only param z default = bezpieczny

### ruff rules

- **B006** — mutable-argument-default
- **B028** — no-explicit-stacklevel
- **PLR0913** — too-many-args (max 5)
- **PLR0911** — too-many-returns
- **FBT** — boolean-trap
- **RET** — inconsistent returns
- **ARG** — unused arguments

---

## 07 — Class & Protocol Design

### Kiedy klasa?

- **TAK:** mutable shared state, lifecycle (`__enter__`/`__exit__`), polimorfizm
- **NIE:** bez stanu → free function; `@staticmethod` → module function
- **Limits:** inheritance ≤2 levels, max 2 mixiny (stateless behaviour)

### Tabela decyzyjna

| Use case | Typ |
|----------|-----|
| Interface (brak enforcement) | `Protocol` (structural subtyping) |
| Enforce + default impl | `ABC` + `@abstractmethod` |
| Internal data, no validation | `dataclass(slots=True, frozen=True)` |
| API boundary, validation | `pydantic.BaseModel` |
| Immutable record, hashable | `NamedTuple` |
| Dict interop, JSON schema | `TypedDict` |

### Protocol

- **Structural subtyping** — zero runtime overhead, duck typing z typami
- **`@runtime_checkable`** — TYLKO gdy potrzebujesz `isinstance()` (plugin registry)
- **ISP:** 1-3 metody max per Protocol (Interface Segregation)

### ABC

- **Nominal subtyping** — `TypeError` na instantiation bez `@abstractmethod`
- **Użyj gdy:** wymuszony kontrakt (framework), default implementation (Template Method)
- **`@classmethod` + `@abstractmethod`:** outer `@classmethod`, inner `@abstractmethod`

### Composition > Inheritance

- **has-a > is-a** — klasa A zawiera B, nie extends B
- **MRO hell → STOP** — refaktor na composition

### `__init__`

- **TYLKO validate + assign** — zero I/O, zero heavy computation
- **I/O → factory:** `@classmethod` `cls.from_file()`, lazy property, explicit `.load()`
- **NIGDY `class Foo: items = []`** — shared mutable state; state per-instance w `__init__`

### `@property`

- **O(1), deterministic, zero side effects** — droga operacja → metoda
- **Setter** — tylko z uzasadnioną walidacją, nie "bo Java"

### `__slots__`

- **>1000 instancji lub memory-critical** → `@dataclass(slots=True)`
- **Z inheritance:** parent MUSI mieć `__slots__` (inaczej zero savings)

### ruff rules

- **B006** — mutable default; **RUF012** — mutable class attr bez `ClassVar`
- **PLW1641** — `__eq__` bez `__hash__`; **B024** — ABC bez `@abstractmethod`

---

## 08 — Error Handling

### Filozofia

- **Raise early, catch late** — waliduj na wejściu, łap na boundary
- **3-level hierarchy:** `AppError` → Domain (`StorageError`, `PaymentError`) → Specific (`StorageConnectionError`)
- **Mixiny cross-cutting:** `TransientError` (retryable), `FatalError` (non-retryable)

### EAFP vs LBYL

| EAFP (try/except) | LBYL (if check) |
|---|---|
| `dict[]`, otwarcie pliku, konwersja typów | Operacje z side effects |
| Race-free operacje | Częste błędy (>25%) |
| Rzadkie wyjątki (21% szybsze) | Operacje nieodwracalne |

### Exception chaining

- **ZAWSZE `raise X from exc`** w except — nigdy implicit chaining
- **`from None`** — świadome suppress kontekstu
- **Bare `raise`** — re-raise z oryginalnym traceback

### Message format

- **`msg = f"..."; raise X(msg)`** — ruff EM101/102/103 karze inline f-string/raw/format w `raise`
- **Structured:** `ErrorContext(code=ErrorCode.X, message=msg, details={...})`

### Try/except/else/finally

- **Try** — MINIMALNY kod który może rzucić target exception
- **Else** — happy path (nie zabezpieczony przez except)
- **Finally** — cleanup; **NIGDY** `return`/`break`/`continue` w finally (SIM107)

### Specific except

- **NIGDY bare `except:`** (E722)
- **NIGDY `except Exception: pass`** (blind swallow)
- **`except SpecificError:`** lub `except (Error1, Error2):`
- **`except AppError:`** — TYLKO na boundary

### Error boundaries (jedyne miejsce na catch)

- **API** — status code mapping
- **CLI** — return code
- **Worker** — log + retry/fail
- Wszędzie indziej: **propaguj**

### Retry patterns

- **Tenacity** + `retry_if_exception_type(TransientError)` (NIE wszystkie)
- **`stop_after_attempt(N)`** + **`wait_exponential() + wait_random()`** (jitter)
- **`reraise=True`** — nie połykaj po wyczerpaniu
- **`before_sleep`** callback — log przed retry

### Async exceptions

- **`asyncio.CancelledError`** = `BaseException` — ZAWSZE re-raise
- **`TaskGroup` → `ExceptionGroup`** + `except*` (3.11+)
- **Cleanup MUSI być `await`-owany**

### Logging exceptions

- **`logger.opt(exception=exc).error("msg: {code}", code=...)`** — loguru best practice
- **Nie mieszaj log + raise** — podwójne logowanie (TRY401)

### Testing

- **`pytest.raises(SpecificError, match=r"pattern")`** — nigdy ogólne `pytest.raises(Exception)` (B017)
- **`exc_info.value.context`** — test structured metadata

### ruff rules 🔴

- **E722** — bare except; **B904** — raise-without-from; **B012** — return-in-finally
- **EM101/102/103** — msg in raise; **N818** — error naming suffix
- **TRY002/003/201/400/401** — exception antipatterns

---

## 09 — Design Patterns

**Zasada nadrzędna:** Python feature > GoF pattern. First-class functions, `Protocol` i composition zastępują 80% GoF.

### Pythonic replacements — GoF → Python

| GoF Pattern | Pythonic | Powód |
|-------------|----------|-------|
| Iterator class | `yield`, `itertools`, generator expr | Lazy evaluation |
| Strategy class | `Callable`, dict dispatch | First-class functions |
| Adapter ABC | `Protocol` + composition | Structural subtyping |
| Factory hierarchy | `type[T]` callable, dict dispatch | Callable objects |
| Singleton metaclass | Module-level instance, `lru_cache(1)` | ⚠️ Anti-pattern |
| Builder fluent API | `@dataclass` + `**kwargs` | Keyword arguments |
| Visitor | `@functools.singledispatch`, `match/case` | Runtime dispatch |
| State classes | `match/case` + `Enum` (≤5 stanów) | Pattern matching |

### Creational

- **Factory:** `type[T]` callable, dict dispatch, entry_points (plugins)
- **Builder:** `@dataclass` + defaults; fluent API → TYLKO gdy ≥6 optional params
- **Singleton:** ⚠️ Anti-pattern — moduł Python (import raz), `lru_cache(maxsize=1)` lazy; NIGDY metaclass
- **Abstract Factory:** Constructor injection + `Callable[..., T]` family

### Structural

- **Adapter:** `Protocol` + wrapper composition (nie ABC inheritance)
- **Facade:** Moduł Python / `__init__.py` re-export (nie klasa)
- **Proxy:** `@property` / `@cached_property` / `__getattr__` (lazy, access control)
- **Decorator (GoF):** `__getattr__` wrapper (nie mylić z `@decorator` syntax)
- **Composite:** Recursive `list[Self]` w dataclass (drzewa, UI, AST)

### Behavioral

- **Iterator:** `yield`, `yield from` — NIGDY klasa `__iter__/__next__`
- **Strategy:** `Callable`, dict dispatch
- **Observer:** Callback list (proste) lub `blinker` (production)
- **Command:** `functools.partial` + Protocol z undo
- **State:** `match/case` + `Enum` (≤5 stanów); Protocol-based dla złożonych FSM
- **Chain of Responsibility:** Lista callables (middleware stack)
- **Template Method:** ABC + hooks (`run()` fixed, `extract()`/`transform()` abstract)

### Pythonic / App

- **Context Manager:** `@contextmanager` (100% przypadków); klasa → więcej kontroli
- **Registry:** `__init_subclass__(cls, *, name=...)` — auto-rejestracja; entry_points dla plugins
- **DI:** Constructor injection (testy bez framework); `Depends()` dla dużych systemów
- **Repository:** `Protocol` + ORM; `InMemoryRepository` do testów
- **Unit of Work:** Context manager grupujący operacje w transakcję
- **Pipeline:** Generator chain `yield from` (lazy); `functools.reduce` dla compose
- **Event Bus:** Mediator (Publisher-Subscriber) dla decoupling
- **Null Object:** No-op implementation z interfejsem → eliminuje `if x is None`

### Decision guide

1. **Python feature istnieje?** → Pythonic alternatywa (80% przypadków)
2. **≤2 warianty?** → `if/else` lub dict, NIGDY wzorzec (YAGNI)
3. **Jedna metoda?** → `Callable` zamiast klasy
4. **Resource lifecycle?** → `@contextmanager`
5. **Loose coupling?** → Callback + signal bus
6. **Hierarchy >2 levels?** → Composition > inheritance

---

## 10 — Config & Data Management

### BaseSettings vs BaseModel

| Typ | Kiedy |
|-----|-------|
| `BaseSettings` | App-level config z env vars, `.env` |
| `BaseModel` | DTO, API models, domain objects |
| `dataclass(frozen=True)` | Immutable value objects (internal) |

### Environment variables

- **`env_prefix`** — namespace isolation: `DB_`, `REDIS_`, `API_`
- **`env_nested_delimiter="__"`** — nested config z env vars
- **`env_file=".env"`** — w `SettingsConfigDict`
- **`.env` w `.gitignore`** ZAWSZE — commituj `.env.example` z placeholderami
- **Precedence:** defaults < `.env` < `os.environ` < runtime overrides

### Secrets

- **`SecretStr`** dla api_key, password — Pydantic auto-maskuje w `repr`
- **NIGDY nie loguj** `.get_secret_value()`

### Walidacja

- **`@field_validator`** — per-field (format, transformacja); `mode="before"` do parsowania
- **`@model_validator(mode="after")`** — cross-field zależności (pool_size ≥ replicas)
- **Computed fields** — `@computed_field` dla derived values

### Immutability

- **`frozen=True`** na global settings — immutable po załadowaniu
- **`model_copy(update={...})`** — testy i overrides

### Injection

- **Constructor injection** — pass config do services w init
- **NIE global import** — testability, loose coupling

### Serialization (Pydantic v2)

- **`.model_dump()`** → dict; **`.model_dump_json()`** → string
- **`.model_validate()`** z dict; **`.model_validate_json()`** z JSON
- **NIGDY** `.dict()`, `.parse_obj()` (v1 legacy)

### Safety

- **`yaml.safe_load()`** ZAWSZE — NIGDY `yaml.load()` (RCE!)
- **`model_post_init`** — side effects po załadowaniu (mkdir, setup)

---

## 11 — Logging

### Setup

- **loguru** — jedyny logger. NIGDY `print()` (T201), NIGDY stdlib `logging`
- **Konfiguruj RAZ w entrypoint:** `logger.remove()` + `logger.add()`
- **DEV:** stderr + `dev.log` (FORMAT + DEBUG)
- **PROD:** `app.log.jsonl` + `errors.log.jsonl` (JSON + ENQUEUE)

### Placeholder rule

- **`logger.info("x: {val}", val=x)`** — `{}` named kwargs
- **NIGDY f-string w logu** (G004 — eager eval)
- **NIGDY `%s`** — to stdlib pattern
- **Lazy eval** — argumenty nie są ewaluowane gdy level wyłączony

### Exception logging

- **W `except`:** `logger.exception("msg")` — auto-traceback z `sys.exc_info()`
- **Z exc variable:** `logger.opt(exception=exc).error("msg")`
- **NIGDY `logger.error()` w except** — traceback stracony (TRY400)

### Context

- **`logger.bind(request_id=rid, service="auth")`** — context injection
- **`logger.contextualize()`** — context manager (auto-cleanup)

### Level semantics

| Level | Kiedy | Produkcja |
|-------|-------|-----------|
| TRACE | Ultra-detail | ❌ |
| DEBUG | Deweloperskie | ❌ |
| INFO | Biznesowe milestones | ✅ |
| SUCCESS | Operacja sukces | ✅ |
| WARNING | Recoverable problem | ✅ |
| ERROR | Operacja failed | ✅ |
| CRITICAL | System nie kontynuuje | ✅ |

### Konfiguracja

- **`serialize=True`** — JSON output (machine-readable)
- **`enqueue=True`** — thread-safe queue (produkcja!)
- **`rotation="100 MB"`**, **`retention="30 days"`**, **`compression="gz"`**

### InterceptHandler (stdlib bridge)

- Klasa łapiąca stdlib `logging` → loguru
- Użyj gdy biblioteki (uvicorn, httpx) używają stdlib

### Security

- **NIGDY nie loguj:** passwords, API keys, tokens, PII (emails, imiona)
- **OK loguj:** request_id (int), method/path, status, timing
- **Maskuj** wrażliwe dane lub użyj `SecretStr`

### ruff rules

- **T201** — print; **G001-G004** — logging format issues
- **TRY400** — error → exception; **TRY401** — redundant exc stringify
- **LOG015** — root logger call

---

## 12 — Testing

### Naming

- **Files:** `test_*.py`
- **Functions:** `test_<unit>_<scenario>_<expected>()` — `class Test*` (bez `__init__`)
- **AAA pattern:** Arrange → Act → Assert w każdym teście

### Fixtures

- **`conftest.py`** — dependency injection (zamiast setup/teardown)
- **Scopes:** `"function"` (default), `"class"`, `"module"`, `"session"`
- **Factory pattern** — fixtures jako factory functions
- **`yield`** do cleanup
- **Lokalizacja:** globalne w `tests/`, per-moduł w subdirs

### @parametrize

- **`pytest.param(..., id="label")`** — czytelne nazwy w output
- **Multi-parametrize** = cartesian product
- Zamiast duplikowania testów

### Markers

- **`--strict-markers`** w `addopts` (pyproject.toml) — wyłap literówki
- **Custom:** `@pytest.mark.slow`, `@pytest.mark.integration`, `@pytest.mark.gpu`
- **Run:** `pytest -m "not slow"`

### Mocking strategy

- **Protocol + Fake > `unittest.mock.patch`** — type-safe, IDE support
- **`monkeypatch.setenv()`** — env vars
- **`tmp_path`** — filesystem operations
- **`pytest.raises(SpecificError, match=r"regex")`** — nigdy ogólne `Exception` (B017)

### Async testing

- **`asyncio_mode = "auto"`** — auto-detect `async def test_*`
- **Async fixtures:** `async def` + `AsyncIterator`

### Coverage

- **`fail_under = 30`** (min %)
- **`--cov=module --cov-report=term-missing`**
- **Exclude:** `TYPE_CHECKING`, `__main__`, overloads

### ruff PT rules

- **PT001** — fixture parentheses; **PT006** — parametrize names
- **PT011** — raises too broad; **PT023** — mark parentheses
- **`per-file-ignores`:** `"tests/**" = ["S101"]` (assert OK w testach)

### Pylance — zero errors w testach

- **Po KAŻDEJ edycji testu** → `get_errors` → napraw ZANIM commitujesz
- **`str` vs `Literal`:** `@parametrize` z `mode: str` gdy API oczekuje `Literal[...]` → zaimportuj alias typu
- **`reportPossiblyUnbound`:** zmienna w `with` wewnątrz `pytest.raises` → zadeklaruj PRZED blokiem
- **Workflow:** edytuj → `get_errors` → napraw → ruff → pytest → commit

---

## 13 — Async & Concurrency

### Decision table

| Problem | Rozwiązanie | Moduł |
|---------|------------|-------|
| **I/O-bound** + async lib | `asyncio` | `asyncio` |
| **I/O-bound** + blocking lib | `ThreadPoolExecutor` | `concurrent.futures` |
| **CPU-bound** | `ProcessPoolExecutor` | `concurrent.futures` |
| **Mixed** async + blocking | `asyncio.to_thread()` | `asyncio` |
| **Mixed** async + CPU | `loop.run_in_executor(ProcessPool)` | `asyncio` + `concurrent.futures` |
| ⚠️ CPU-bound per-interpreter GIL | `InterpreterPoolExecutor` | ⚠️ **≥3.14 only** |

Reguła kciuka: *asyncio when you can, threading when you must, multiprocessing when you need CPU parallelism.*

### GIL — implikacje praktyczne

- **GIL** pozwala tylko jednemu wątkowi wykonywać bytecode — threads NIE przyspieszają CPU-bound
- GIL jest **zwalniany podczas I/O** — threads działają dla I/O
- C extensions (NumPy, PIL, OpenCV) mogą zwalniać GIL wewnętrznie
- ⚠️ **≥3.13:** eksperymentalne free-threading (`--disable-gil`), nie production-ready
- ⚠️ **≥3.14:** `InterpreterPoolExecutor` — per-interpreter GIL, lżejszy niż procesy

### asyncio basics

- **Jeden `asyncio.run()`** na top-level — entry point do async world
- `asyncio.get_event_loop()` **deprecated** od 3.10 — używaj `asyncio.run()` + `asyncio.get_running_loop()`
- **`create_task()`** — zawsze trzymaj referencję! Event loop ma weak refs → dangling task = GC
- **Fire-and-manage:** `_bg_tasks: set[asyncio.Task] = set()`, `task.add_done_callback(_bg_tasks.discard)`
- **`asyncio.gather()`** — `return_exceptions=True` dla bulk ops
- **`asyncio.Queue(maxsize=N)`** — async producer/consumer z bounded buffer

### TaskGroup — structured concurrency ⚠️ ≥3.11

- **Preferuj `TaskGroup`** nad `gather()` — auto-cancel przy failure, gwarantowane cleanup
- Exceptions → `ExceptionGroup`, przechwytuj z `except* ValueError as eg:`
- Po wyjściu z `async with TaskGroup() as tg:` wszystkie taski done lub cancelled

### Timeouts & cancellation

- ⚠️ **≥3.11:** `async with asyncio.timeout(5.0):` — preferowany sposób
- **≥3.10 fallback:** `await asyncio.wait_for(coro, timeout=5.0)`
- **NIGDY nie połykaj `CancelledError`** — cleanup → `raise`

### concurrent.futures

- **`ThreadPoolExecutor`** — blocking I/O. `max_workers` default = `min(32, os.cpu_count() + 4)`
- **`ProcessPoolExecutor`** — CPU-bound. `max_workers` default = `os.cpu_count()`
- **`executor.map(fn, iterable)`** — batch, wyniki w kolejności
- **`executor.submit(fn)`** → `Future` — cancel, callback, `as_completed()`
- **`if __name__ == "__main__":`** — WYMAGANE dla ProcessPool na Windows

### Mixing async + sync

- **`asyncio.to_thread(blocking_fn)`** — offload blocking I/O do thread pool
- **`loop.run_in_executor(pool, fn)`** — custom executor, zwraca awaitable

### Synchronizacja

- **asyncio** → `asyncio.Lock()`, `Semaphore(n)`, `Event()` — single-threaded, rzadko potrzebne
- **threading** → `threading.Lock()` — zawsze `with lock:` dla mutable shared state
- **multiprocessing** → IPC: `Queue`, `Pipe`, `SharedMemory`
- **`asyncio.Semaphore(N)`** — rate limiting (limit jednoczesnych requestów)

### Antypatterny

- **Blocking w async** — `time.sleep()`, `requests.get()`, `open()` blokuje CAŁY event loop
- **Fire-and-forget** — `create_task()` bez referencji → task znika (GC)
- **Połykanie `CancelledError`** — łamie structured concurrency
- **`asyncio.run()` wewnątrz async** — RuntimeError (nested event loop)
- **Threads dla CPU-bound** — GIL serializes, brak speedup

### Ruff rules

| Reguła | Problem |
|--------|---------|
| `ASYNC210` | Blocking HTTP w async |
| `ASYNC230` | `open()` w async — użyj `aiofiles` / `to_thread` |
| `ASYNC251` | `time.sleep()` w async — użyj `asyncio.sleep()` |
| `ASYNC100` | Timeout context bez `await` |
| `RUF006` | `create_task()` bez referencji |
| `RUF029` | `async def` bez `await` — niepotrzebne async |

---

## 14 — API Design (FastAPI + Pydantic v2)

**Zasada nadrzędna:** Router = thin delegation. Walidacja na wejściu (Pydantic), mapping błędów na wyjściu (exception handler). Biznes logika NIGDY w routerze.

### Warstwy

```
Middleware → Router → Service → Repository → DB
```

- **Router:** `response_model`, `Depends`, delegacja do service
- **Service:** biznes logika (HTTP-agnostic, zero `Request`/`HTTPException`)
- **Repository:** DB access (→09 §Repository)
- Router limit: ≤15 LOC; >2 I/O calls → wyciągnij do service

### App factory + lifespan

- **`create_app(settings)`** — factory zamiast global `app = FastAPI()` (testowalność)
- **`lifespan` context manager** — ZAWSZE zamiast `@app.on_event` (deprecated od 0.93)
- **Middleware order (last added = first exec):** CORS → Security → Logging → RateLimit → Auth → Route

### Pydantic v2 dla API

- **Request ≠ Response model** — ZAWSZE osobne klasy (`JobCreateRequest` vs `JobResponse`)
- **`response_model=Schema`** — ZAWSZE, zero bare `dict` / `Any`
- **`model_config = ConfigDict(extra="forbid")`** — odrzucaj nieznane pola (hardened input)
- **`from_attributes=True`** — mapping z ORM (`JobResponse.model_validate(orm_job)`)
- **`Field(min_length=..., max_length=..., pattern=...)`** — walidacja deklaratywna; zero `if not ...` w routerze
- **Discriminated unions:** `Annotated[A | B, Discriminator("kind")]` — polymorphic payloads

### Dependency Injection

- **`Depends()` > globale** — session, settings, service, user
- **`Annotated[X, Depends(fn)]`** type alias (FastAPI ≥0.95) — DRY, IDE-friendly
- **`@lru_cache(maxsize=1)`** — singleton settings
- **`app.dependency_overrides`** — swap w testach; ZAWSZE `clear()` w cleanup
- **Class-based deps** — `PaginationParams(BaseModel)` z `Depends(pagination)`

### Routery

- **`APIRouter(prefix="/jobs", tags=["jobs"])`** — jeden router = jedna domena
- **Zagnieżdżone:** `v1 = APIRouter(prefix="/api/v1")` → `v1.include_router(jobs_router)`
- **REST naming:** plural (`/jobs`), kebab-case (`/manga-pages`), UUID zamiast INT (IDOR)
- **Status codes:** POST create → 201, async job → 202 + `Location`, DELETE → 204

### OpenAPI

- **Per endpoint:** `summary`, `description`, `responses={404: {"model": ErrorResponse}}`, `status_code`
- **Examples:** `Field(examples=[...])` lub `ConfigDict(json_schema_extra={"examples": [...]})`
- **Customizacja:** `app.openapi = lambda: custom_openapi(app)` — dodaj `securitySchemes` (BearerAuth)

### Versioning

- **Default: URL path prefix** (`/api/v1/...`) — najprostsze, cacheable, discoverable
- **Header / content negotiation** — tylko dla dużych API publicznych
- **Deprecation:** `deprecated=True` + headers `Deprecation: true` + `Sunset: <HTTP-date>` + `Link: <url>; rel="successor-version"`
- **Migracja:** v1 + v2 równolegle ≥3 miesiące

### Auth (OAuth2 + JWT)

- **OAuth2PasswordBearer + JWT** — standard dla desktop/mobile/SPA
- **HS256** — monolit (jeden secret); **RS256** — multi-service (public key distribution)
- **Access token TTL:** 5-15 min; **Refresh TTL:** 7-30 dni + rotacja
- **Refresh w HttpOnly cookie** — anti-XSS (nigdy localStorage!)
- **Scopes:** `Depends(require_scopes(["jobs:delete"]))` — fine-grained authz
- **`passlib[bcrypt]`** do password hashing; **NIGDY** plain MD5/SHA256

### Error handling API

- **Exception handler central:** `AppError → HTTPException` mapping przez `_STATUS_MAP: dict[type[AppError], int]`
- **RFC 7807 format:** `{type, title, status, code, detail, instance, request_id, details}`
- **Validation errors:** custom handler dla `RequestValidationError` → czytelne `field/type/message`
- **Security:** NIGDY traceback w prod; `request_id` w każdej odpowiedzi; `details` bez PII/secrets
- **Error code** = część kontraktu (stabilny między wersjami)

### Observability

- **Correlation ID middleware:** `X-Request-ID` propagowany (generuj jeśli brak) + `logger.contextualize(request_id=...)`
- **Metrics (Prometheus):** `Counter("api_requests_total")`, `Histogram("api_request_duration_seconds")`, endpoint `/metrics`
- **Tracing:** `FastAPIInstrumentor.instrument_app(app)` + `HTTPXClientInstrumentor` + `SQLAlchemyInstrumentor`

### Health checks — split

- **`/health/live`** — proces żyje (K8s restart przy fail)
- **`/health/ready`** — DB/cache/model OK (K8s wyjmij z LB)
- **`/health/startup`** — lifespan skończony
- Zwracaj 503 (nie 200) gdy `ready` = degraded

### Rate limiting & security

- **slowapi + Redis** — `storage_uri="redis://..."`, `strategy="moving-window"` (multi-worker wymaga Redis)
- **Security headers:** `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Strict-Transport-Security`, `Content-Security-Policy`, `Referrer-Policy`
- **CORS:** NIGDY `allow_origins=["*"]` z `allow_credentials=True` (browser blocks); explicit whitelist

### Streaming

- **SSE (`StreamingResponse`, `text/event-stream`)** — progress, one-way push, HTTP-native reconnect
- **WebSocket (`@router.websocket`)** — bidirectional; close z proper code (`WS_1000_NORMAL_CLOSURE` / `WS_1011_INTERNAL_ERROR`)
- **`UploadFile` chunked:** `while chunk := await file.read(1MB):` — NIGDY `await file.read()` (OOM)
- **SSE headers:** `Cache-Control: no-cache`, `X-Accel-Buffering: no` (disable nginx buffering)

### Async, background tasks, pools

- **`async def` default** dla endpointów I/O; `def` tylko dla pure CPU ≤10ms
- **`BackgroundTasks`** — lightweight post-response (email, audit log); limit <5s
- **Długie zadania** → external queue (Celery/ARQ/Dramatiq) + status endpoint `/jobs/{id}` + SSE `/jobs/{id}/events`
- **`httpx.AsyncClient` w lifespan:** reuse connection pool (`max_connections=100`, `keepalive=20`); NIGDY per-request

### Testing API

- **`httpx.AsyncClient(transport=ASGITransport(app=app))`** — async TestClient (lifespan auto via ctx)
- **`app.dependency_overrides[get_X] = fake`** w fixture + `clear()` w cleanup
- **Snapshot testing OpenAPI:** `tests/snapshots/openapi.json` — wykryj breaking changes
- **SSE test:** `async with client.stream("GET", ...)` + `aiter_lines()`

### Top antypatterny

- Global `db = SessionLocal()` (nie per-request) → `Depends(get_db_session)`
- `return {"id": x}` (bare dict) → `response_model=Schema`
- Biznes logika w routerze → service
- `except Exception:` w endpoincie → specific + handler
- `time.sleep(...)` w `async def` → `await asyncio.sleep(...)`
- Manualna walidacja `if "x" not in body` → Pydantic `BaseModel`
- `HTTPException(500, str(exc))` → `raise AppError(...)` + handler
- JWT w localStorage → HttpOnly cookie
- `@app.on_event(...)` → `lifespan`
- `allow_origins=["*"]` + `credentials=True` → explicit whitelist

### Ruff rules 🔴

- **ASYNC100/210** — blocking w async (`time.sleep`, `requests`)
- **FAST002** — old `x: X = Depends(...)` → `Annotated[X, Depends(...)]`
- **S101** — `assert` w prod → `raise AppError`
- **S105/106/107** — hardcoded password/secret → `SecretStr` + env
- **B008** — mutable default w arg → `Field(default_factory=list)`
- **B904** — `raise` bez `from` w except
- **TRY400** — `logger.error` zamiast `logger.exception`
- **N818** — Exception class bez `Error` suffix

---

## 15 — Database & ACID (SQLite + SQLAlchemy 2.0)

**Zasada nadrzędna:** Transakcja to kontrakt biznesowy. Commit = prawda. ORM to narzędzie, nie magia — znaj co emituje.

### ACID w praktyce

- **Atomicity:** `async with session.begin():` — all-or-nothing; NIGDY wiele commitów tam gdzie potrzebna jedna transakcja
- **Consistency:** FK + Check constraints wymuszają invariants DB-level (nie tylko w kodzie)
- **Isolation:** SQLite WAL = Serializable; Postgres default = Read Committed
- **Durability:** `synchronous=NORMAL` przy WAL (kompromis speed/safety); `FULL` dla finansów

### SQLite PRAGMAs — OBOWIĄZKOWE per connection

```python
@event.listens_for(Engine, "connect")
def _sqlite_pragmas(conn, _):
    cur = conn.cursor()
    cur.execute("PRAGMA journal_mode=WAL")        # Readers ≠ writers nie blokują
    cur.execute("PRAGMA synchronous=NORMAL")       # Speed + durability
    cur.execute("PRAGMA foreign_keys=ON")          # ⚠️ DEFAULT OFF — MUSISZ włączyć
    cur.execute("PRAGMA busy_timeout=5000")        # Retry 5s zamiast crash
    cur.execute("PRAGMA temp_store=MEMORY")
    cur.execute("PRAGMA cache_size=-64000")        # 64 MB
    cur.execute("PRAGMA mmap_size=268435456")      # 256 MB read cache
```

### SQLite vs Postgres — decision

- **SQLite:** desktop, CLI, embedded, <100 writes/s, tests, single-writer
- **Postgres:** wielu writers, JSONB + index, full-text >GB, horizontal scaling
- **Migracja trigger:** >100 writes/s TRWALE, wiele procesów piszących, JSONB z indexem

### SQLAlchemy 2.0 basics

- **`Mapped[T]` + `mapped_column(...)`** — zawsze (type-safe); NIGDY legacy `Column(...)` bez `Mapped[T]`
- **`select(X).where(...)`** — 2.0 style; NIGDY `session.query(...)` (1.x legacy)
- **`DeclarativeBase`** + `type_annotation_map = {datetime: DateTime(timezone=True), UUID: Uuid(native_uuid=False), dict: JSON}`
- **Engine:** jeden per proces, `pool_pre_ping=True`, `pool_recycle=3600`

### Async SQLAlchemy

- **`create_async_engine("sqlite+aiosqlite:///...")`** — aiosqlite driver
- **`async_sessionmaker(expire_on_commit=False)`** — KRYTYCZNE (inaczej lazy load po commit = crash)
- **Sesja per-task** — NIGDY shared session w `asyncio.gather` (race condition)
- **`async with session.begin():`** — automatyczny commit/rollback
- **`selectinload` / `joinedload`** EXPLICIT — NIGDY lazy loading w async (`lazy="raise"` w dev łapie N+1)

### Schema design

- **PK:** UUID7 (time-ordered, unguessable) > BIGINT autoincrement > UUID4
- **Timestamps:** `DateTime(timezone=True)` + `server_default=func.now()` + `onupdate=func.now()` — ZAWSZE UTC
- **Audit mixin:** `TimestampMixin` + `SoftDeleteMixin(deleted_at NULL)` — `AuditedBase(TimestampMixin, SoftDeleteMixin)`
- **FK cascades:** `ForeignKey(..., ondelete="CASCADE")` — jawnie (default NO ACTION)
- **Indeksy:** composite dla `WHERE a=? AND b=?`, expression index dla `WHERE lower(email)=?`, partial (Postgres) / composite z flagą
- **Constraints:** `CheckConstraint("balance >= 0", name="ck_...")`, `UniqueConstraint(...)` — DB-level invariants
- **Optimistic locking:** `__mapper_args__ = {"version_id_col": "version"}` — anti-stale write
- **Pieniądze:** `Numeric(precision=18, scale=2)` — NIGDY `float` (drift!)
- **JSON:** tylko metadata/rzadkie odczyty; NIE dla pól filtrowanych/agregowanych

### Transakcje

- **`async with session.begin():`** — scope + auto commit/rollback
- **Nested (SAVEPOINT):** `async with session.begin_nested():` — partial rollback w obrębie większej transakcji
- **Retry na `OperationalError` / `SQLITE_BUSY`** — `@retry_async(max=3, backoff=exponential, retry_on=(OperationalError,))`
- **NIGDY zewnętrzne I/O (HTTP) w transakcji** → outbox pattern (commit lokalnie → event → publisher)

### Alembic migrations

- **`alembic init --template async alembic_db`** — async template
- **`render_as_batch=True` dla SQLite** — KRYTYCZNE (SQLite nie obsługuje `ALTER TABLE DROP COLUMN`)
- **`compare_type=True`, `compare_server_default=True`** — lepsza detekcja zmian
- **Autogenerate NIE wykrywa:** rename column/table, check constraint change, data migrations, funcyjne indexy → ręcznie
- **Workflow:** change model → `alembic revision --autogenerate -m "..."` → **REVIEW manualnie** → `alembic upgrade head`
- **Zero-downtime:** dodaj → backfill → usuń (3 releases, każda backward-compat)
- **Test migracji w CI:** `upgrade head` + `downgrade base` round-trip

### Repository + Unit of Work

- **`class JobRepository(Protocol):`** — swap-able, testowalne (in-memory fake)
- **`SqlJobRepository(session)`** — impl trzyma `AsyncSession`
- **UoW:** context manager grupujący operacje w transakcję + agreguje repozytoria
- **Kiedy NIE abstrahować:** <5 modeli, jedno backend → session bezpośrednio OK

### Performance

- **Bulk:** `session.execute(insert(Job), [payload1, ...])` — 100x szybsze niż pętla `add() + commit()`
- **`EXPLAIN QUERY PLAN`** — sprawdzaj każde nowe query przed merge (`SCAN TABLE` = brak indeksu)
- **Keyset pagination:** `WHERE id > last_seen` — stały koszt, lepsze niż `OFFSET` (slow dla dużych)
- **Batch flush:** `session.flush()` co 1000 + `session.expunge_all()` — zwalnia pamięć
- **`SELECT specific_columns`** gdy potrzebujesz 2 pola — NIE `select(User)` (full row)

### Security

- **Parameterized queries** zawsze (SQLAlchemy robi auto); `text(...)` tylko z `bindparams(...)` — NIGDY f-string
- **`SecretStr`** dla `database_url` — nie wycieknie do logów (→10)
- **Row-level access:** dependency wstrzykuje `current_user_id` → predicate `WHERE owner_id = ?` w każdym query
- **Encryption at rest:** FS encryption (LUKS/APFS/BitLocker) zawsze w prod; SQLCipher dla mobile
- **IDOR prevention:** UUID zamiast autoincrement INT w publicznych URLach

### Testing

- **In-memory SQLite** per test: `sqlite+aiosqlite:///:memory:` + `Base.metadata.create_all` → drop
- **Rollback-per-test** (faster): shared session-scoped engine + transakcja per-test → rollback
- **Factory funkcje:** `make_user(**overrides)` zamiast `factory_boy` (mniejsze deps)
- **Test migracji:** `command.upgrade(cfg, "head")` + `command.downgrade(cfg, "base")` na `tmp_path`

### Observability

- **Slow query log:** `event.listen(Engine, "before_cursor_execute" / "after_cursor_execute")` → loguj >100ms
- **OpenTelemetry:** `SQLAlchemyInstrumentor().instrument(engine=engine, enable_commenter=True)` — SQL comment z trace_id
- **Metryki:** `db_query_duration_seconds{op}` histogram, `db_connections_active` gauge, `db_transactions_rolled_back_total` counter

### Backup & migration

- **SQLite online backup:** `sqlite3.Connection.backup(dst)` — nie blokuje writes
- **Litestream:** WAL streaming do S3 (RPO <1s)
- **SQLite → Postgres:** `pgloader sqlite:///app.db postgres://...` + migracja schemy przez Alembic

### Top antypatterny

- `foreign_keys` nie włączone → FK ignorowane cicho
- Shared session w `asyncio.gather` → race condition
- `expire_on_commit=True` w async → lazy load po commit = crash
- `lazy=True` (default) w async models → N+1 + crash
- `session.query(...)` (1.x) → `select(...)` (2.0)
- String concat w `text(...)` → SQL injection
- `float` dla pieniędzy → `Decimal(Numeric(18,2))`
- Brak `render_as_batch` w Alembic/SQLite → ALTER TABLE crash
- Commit w pętli (1 per row) → flush batchami + jeden commit
- Transakcja z HTTP w środku → outbox pattern
- Autoincrement PK publicznie → UUID7 (IDOR)

### Ruff rules 🔴

- **S608** — hardcoded SQL (injection) → `text().bindparams()`
- **B008** — `Depends()` jako default arg w routerze → `Annotated[...]`
- **PERF401** — lista comprehension filtruje zamiast WHERE → push do SQL
- **ASYNC110** — `time.sleep` w async DB scope → `asyncio.sleep`

---

> **Skill:** `.github/skills/python/SKILL.md` — struktura, opisy sekcji, nawigacja.
> **Pełna dokumentacja:** `.github/skills/python/references/XX-*.md` (~12 200 linii, 16 sekcji).
