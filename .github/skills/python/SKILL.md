---
name: python
description: "Kompletny, przenośny Python coding standard. 16 sekcji referencyjnych (00-15, ~12 450 linii). Źródło prawdy dla pisania, review i refaktoringu kodu Python ≥3.10. Generyczne — zero zależności od konkretnego projektu."
---

## Kiedy używać

Gdy piszesz, reviewujesz lub refaktoryzujesz kod Python — ten skill definiuje **jak** pisać.

### Typowe triggery

- `python` — ogólne pytanie o coding standard
- Piszesz nowy moduł / serwis / CLI
- Reviewujesz PR pod kątem coding standard
- Nie wiesz jaki pattern użyć (dataclass vs Pydantic, sync vs async, Protocol vs ABC, itp.)
- Potrzebujesz decyzji architektonicznej na poziomie kodu (nie systemu — do tego `brainstorm`)

### Nie używaj do ❌

- **Decyzji architektonicznych systemu** (→ `brainstorm` skill)
- **Frontend / TypeScript** (→ `frontend` skill)
- **Jednorazowych quick-fixów** gdzie wystarczy `ruff check --fix`
- **Porównań z innymi językami** (standard dotyczy tylko Pythona ≥3.10)

---

## Stack & Assumptions

Każda sekcja zakłada ten sam bazowy stack:

| Element | Wartość |
|---------|---------|
| Python | **≥3.10** (`match/case`, `X \| Y` unions) |
| Future imports | `from __future__ import annotations` — ZAWSZE |
| Package manager | **uv** (NIGDY `pip`) |
| Linter + formatter | **ruff** — line-length 120, target py310 |
| Type checker | **mypy** — strict mode, pydantic plugin |
| Logger | **loguru** — `{}` placeholders, `logger.opt(exception=exc)` |
| Data models | **pydantic ≥2.0**, **pydantic-settings ≥2.0** |
| Testing | **pytest ≥8.0**, pytest-asyncio, pytest-cov, hypothesis |
| Docstrings | **Google-style** — jeden styl, zero wyjątków |

> ⚠️ Jeśli sekcja używa feature ≥3.11 / ≥3.12 / ≥3.14, jest to jawnie oznaczone w tekście.

---

## Struktura plików

```
python/
├── SKILL.md                         ← ten plik — meta, spis treści, workflow
└── references/                      ← 16 sekcji standardu (1 plik = 1 temat)
    ├── 00-uv-tooling.md             (707 L)
    ├── 01-docstrings.md             (795 L)
    ├── 02-type-hints.md             (922 L)
    ├── 03-imports.md                (481 L)
    ├── 04-naming.md                 (430 L)
    ├── 05-code-patterns.md          (1012 L)
    ├── 06-function-api-design.md    (902 L)
    ├── 07-class-protocol-design.md  (1099 L)
    ├── 08-error-handling.md         (1099 L)
    ├── 09-design-patterns.md        (1504 L)
    ├── 10-config-data.md            (616 L)
    ├── 11-logging.md                (458 L)
    ├── 12-testing.md                (554 L)
    ├── 13-async-concurrency.md      (1031 L)
    ├── 14-api-design.md             (~950 L)
    ├── 15-database-acid.md          (~900 L)
    └── examples/
        └── showcase.py
```

**Razem:** ~12 460 linii dokumentacji.

---

## Sekcje Referencyjne — Spis Treści

Kolejność = priorytet — od fundamentów (tooling, docstrings) po zaawansowane (async, design patterns).
Każdy plik jest **self-contained** — czytany osobno, bez zależności od innych sekcji.

### 00 — uv & Tooling · `00-uv-tooling.md` · 707 L

> Package management, dev workflow i konfiguracja narzędzi.

**Kluczowe tematy:** `uv add/sync/run/lock`, `pyproject.toml` anatomy (project, ruff, mypy, pytest), ruff config & najważniejsze rule sets (UP, C4, B, PT, PERF, SIM, RET, PTH, T20, G, LOG, TRY, ASYNC), mypy strict mode, pre-commit hooks, CI pipeline, editorconfig.

**Szukaj tu gdy:** konfigurujesz nowy projekt, dodajesz dependency, ustawiasz linter/formatter, CI.

---

### 01 — Docstrings & Comments · `01-docstrings.md` · 795 L

> Google-style docstrings — kiedy pisać, co pisać, czego NIE pisać.

**Kluczowe tematy:** moduł/klasa/metoda/function docstrings, `Args`/`Returns`/`Raises`/`Yields`/`Usage`, doctest vs indented block, `Example:` placement, inline comments (dlaczego > co), `# TODO(user): ...`, section separators, decision table „kiedy co pisać".

**Szukaj tu gdy:** piszesz docstring, nie wiesz czy element tego wymaga, chcesz sprawdzić format.

---

### 02 — Type Hints · `02-type-hints.md` · 922 L

> Kompletny poradnik typowania — od basics po zaawansowane generics.

**Kluczowe tematy:** `from __future__ import annotations`, lowercase generics (`list[X]`, `dict[K,V]`), `X | None` zamiast `Optional`, `Callable`, `TypeVar`, `ParamSpec`, `TypeVarTuple`, `@overload`, `TYPE_CHECKING` block, `TypeAlias` / `type` statement (3.12+), `TypeGuard`, `Never`, `Self`, `Unpack`, `TypedDict`, mypy strict config, ruff UP rules, pydantic model typing.

**Szukaj tu gdy:** typujesz złożoną sygnaturę, piszesz generic, łączysz mypy z pydantic.

---

### 03 — Imports & Exports · `03-imports.md` · 481 L

> Porządek importów, public API, circular imports, lazy loading.

**Kluczowe tematy:** import order (stdlib → third-party → local), `__all__` explicit exports, `TYPE_CHECKING` conditional imports, lazy import patterns (`importlib`), circular import resolution (restructure > defer > TYPE_CHECKING), relative vs absolute imports, ruff I/TID rules.

**Szukaj tu gdy:** masz circular import, nie wiesz jak zdefiniować public API, porządkujesz importy.

---

### 04 — Naming Conventions · `04-naming.md` · 430 L

> Jednoznaczne reguły nazewnictwa dla każdego elementu kodu.

**Kluczowe tematy:** `snake_case` (zmienne, funkcje, moduły), `PascalCase` (klasy, TypeVar), `SCREAMING_SNAKE` (stałe), `_private` prefix, naming table per element type, magic numbers → named constants, boolean naming (`is_`/`has_`/`can_`/`should_`), abbreviation rules, ruff N rules.

**Szukaj tu gdy:** nazywasz nowy moduł/klasę/zmienną, refaktoryzujesz nazwy, wyciągasz magic numbers.

---

### 05 — Code Patterns & Pythonic Idioms · `05-code-patterns.md` · 1012 L

> Idiomatyczny Python — decyzje kiedy użyć jakiego wzorca.

**Kluczowe tematy:** `pathlib.Path` vs `os.path`, early return vs nested if, comprehension vs loop vs `map/filter`, walrus operator `:=`, `match/case` (structural pattern matching), ternary vs if/else, context managers, `itertools`/`functools` patterns, string formatting (f-string > `.format()` > `%`), truthiness, `__slots__`, `Enum`, ruff rules (C4, SIM, PERF, RET, PTH, UP).

**Szukaj tu gdy:** nie wiesz jaki idiom wybrać, chcesz zrefaktoryzować code smell, sprawdzasz best practice.

---

### 06 — Function & API Design · `06-function-api-design.md` · 902 L

> Projektowanie funkcji, sygnatur i publicznych API.

**Kluczowe tematy:** SRP (Single Responsibility), max 5 params (3 ideal), `*` keyword-only separator, `@overload` for API clarity, default argument pitfalls (mutable defaults), return consistency (single type), `None` vs `raise` for errors, result types, function length (max 50 LOC, max complexity 15), deprecation pattern (`@deprecated` / warnings), builder pattern for complex config, ruff B/RET/PLR rules.

**Szukaj tu gdy:** projektujesz API, refaktoryzujesz funkcję, decydujesz o return types.

---

### 07 — Class & Protocol Design · `07-class-protocol-design.md` · 1099 L

> Klasy, Protocol, ABC, composition — kiedy co użyć.

**Kluczowe tematy:** decision table (dataclass vs Pydantic vs NamedTuple vs TypedDict vs Protocol vs ABC), `@dataclass` idiomy (frozen, slots, field), `Protocol` (structural subtyping, runtime_checkable), ABC (only when enforcement needed), composition > inheritance, mixin rules (max 2), `__init__` patterns, `__repr__`/`__eq__`/`__hash__`, class hierarchy depth (max 3), Descriptor protocol, `__init_subclass__`, ruff rules.

**Szukaj tu gdy:** decydujesz między dataclass/Pydantic/Protocol/ABC, projektujesz hierarchięclass.

---

### 08 — Error Handling · `08-error-handling.md` · 1099 L

> Obsługa błędów — od filozofii po retry patterns.

**Kluczowe tematy:** EAFP vs LBYL, exception hierarchy design (AppError base, domain → infra → validation split), `raise ... from e` (chaining), specific `except` (NIGDY bare `except:`), ExceptionGroup (3.11+), error boundaries (service layer catches, API layer maps), retry patterns (tenacity, exponential backoff), async exception handling, logging exceptions (`logger.opt(exception=exc)`), testing exceptions, ruff B/TRY/EM rules.

**Szukaj tu gdy:** projektujesz hierarchię wyjątków, piszesz retry logic, łapiesz/logujesz błędy.

---

### 09 — Design Patterns w Pythonie · `09-design-patterns.md` · 1504 L

> 23 wzorce GoF + 8 Pythonic — z perspektywy Pythona, nie Javy.

**Kluczowe tematy:** frequency ranking (top: Factory, Strategy/Protocol, Repository, Observer, Decorator — bottom: Singleton, Abstract Factory, Flyweight), **Creational** (Factory Function, Builder, Singleton-as-module), **Structural** (Adapter/Protocol, Decorator, Facade, Proxy, Composite), **Behavioral** (Strategy/Protocol, Observer/Event, Command, Chain of Responsibility, Template Method, State, Iterator, Mediator, Visitor), **Pythonic/App** (Repository, Unit of Work, Event Bus, Plugin/Registry, Context Manager, Dependency Injection, Result Type, Pipeline).

**Szukaj tu gdy:** nie wiesz jaki pattern pasuje, chcesz Pythonic implementację wzorca, porównujesz podejścia.

---

### 10 — Config & Data Management · `10-config-data.md` · 616 L

> Konfiguracja, env vars, walidacja, serializacja.

**Kluczowe tematy:** `BaseSettings` (pydantic-settings), `.env` files, env var naming, `model_config` (env_prefix, env_file, case_sensitive), validators (`@field_validator`, `@model_validator`), computed fields, secrets management (`SecretStr`), dataclass vs Pydantic decision, serialization (`model_dump`, `model_dump_json`), config layers (env > file > defaults), immutability (frozen models).

**Szukaj tu gdy:** konfigurujesz aplikację, zarządzasz env vars, walidusz dane wejściowe.

---

### 11 — Logging · `11-logging.md` · 458 L

> Loguru standards — levels, structured logging, security.

**Kluczowe tematy:** loguru setup (sink, format, rotation, retention), log levels (TRACE/DEBUG/INFO/SUCCESS/WARNING/ERROR/CRITICAL), `{}` placeholders (NIGDY `%s`, NIGDY f-string w log calls), structured fields (`logger.bind()`), exception logging (`logger.opt(exception=exc)`), sensitive data filtering, log context (correlation_id), performance (lazy evaluation), JSON output (`.serialize()`), testing logs, ruff LOG/G rules.

**Szukaj tu gdy:** konfigurujesz logowanie, logujesz wyjątek, potrzebujesz structured logging.

---

### 12 — Testing · `12-testing.md` · 554 L

> pytest conventions, fixtures, mocking, coverage.

**Kluczowe tematy:** file/function naming (`test_*.py`, `test_<unit>_<scenario>_<expected>`), fixtures (scope, conftest.py, factory pattern, autouse), `@pytest.mark.parametrize`, markers (slow, integration, asyncio), Pylance type-checking (`reportPossiblyUnbound`), mocking via Protocols (nie `unittest.mock` where avoidable), `tmp_path`/`monkeypatch`, async testing (`pytest-asyncio`, `anyio`), coverage config (min 80%, fail_under), hypothesis (property-based), snapshot testing, ruff PT rules.

**Szukaj tu gdy:** piszesz test, konfigurujesz pytest, potrzebujesz fixture pattern, masz type-check error w teście.

---

### 13 — Async & Concurrency · `13-async-concurrency.md` · 1031 L

> asyncio / threads / processes — kiedy co użyć.

**Kluczowe tematy:** decision table (I/O-bound → asyncio, CPU-light threading → ThreadPoolExecutor, CPU-heavy → ProcessPoolExecutor), GIL wyjaśnienie, `asyncio.run()` entry point, `asyncio.TaskGroup` (≥3.11), `asyncio.timeout()` (≥3.11), cancellation/shielding, `asyncio.Queue` producer/consumer, `concurrent.futures` (Thread/Process/InterpreterPool with 3.14 guard), bridge async↔sync (`asyncio.to_thread`, `run_in_executor`, `run_coroutine_threadsafe`), multiprocessing (Queue, SharedMemory, start methods), synchronization (Lock, Semaphore, Event), 8 antipatterns, ruff ASYNC rules.

**Szukaj tu gdy:** decydujesz async vs threads vs processes, piszesz concurrent code, mixujesz sync z async.

---

### 14 — API Design · `14-api-design.md` · ~950 L

> FastAPI + Pydantic v2 — warstwowa architektura API, od routera po observability.

**Kluczowe tematy:** warstwy (Router → Service → Repository), `create_app` factory + `lifespan` (zamiast `@app.on_event`), middleware order, Pydantic v2 Request/Response separation (`extra="forbid"`, `from_attributes`, discriminated unions), DI (`Annotated[X, Depends(fn)]`, `app.dependency_overrides` w testach), `APIRouter` prefix/tags, OpenAPI customization (`responses=`, examples, security schemes), versioning (URL path + `Deprecation`/`Sunset` headers), auth (OAuth2PasswordBearer + JWT HS256/RS256, scopes, refresh w HttpOnly cookie), error handling (AppError → `HTTPException` mapping, RFC 7807), observability (correlation ID, Prometheus metrics, OpenTelemetry), health checks (live/ready/startup split), rate limiting (slowapi + Redis), security headers (CSP, HSTS, X-Frame-Options), streaming (SSE, WebSocket, chunked UploadFile), `BackgroundTasks` vs external queue, `httpx.AsyncClient` w lifespan, testing (`httpx.AsyncClient(transport=ASGITransport)`, snapshot OpenAPI, SSE stream tests), antypatterny i ruff ASYNC/FAST/S/B/TRY/N rules.

**Szukaj tu gdy:** projektujesz endpoint, decydujesz o versioning/auth, mapujesz błędy domeny na HTTP, dodajesz streaming/health/observability, piszesz testy API.

---

### 15 — Database & ACID · `15-database-acid.md` · ~900 L

> SQLite + SQLAlchemy 2.0 + Alembic — ACID od fundamentów po migrację do Postgres.

**Kluczowe tematy:** ACID w praktyce (commit = kontrakt biznesowy), SQLite vs Postgres decision, obowiązkowe PRAGMAs per connection (`journal_mode=WAL`, `foreign_keys=ON`, `synchronous=NORMAL`, `busy_timeout=5000`, `mmap_size`, `cache_size`), SQLAlchemy 2.0 basics (`Mapped[T]` + `mapped_column`, `select()` zamiast `session.query`, `DeclarativeBase` + `type_annotation_map`), async SQLAlchemy (`create_async_engine`, `aiosqlite`, `expire_on_commit=False`, explicit `selectinload`/`joinedload`, session-per-task), schema design (UUID7 PK, audit mixiny, `ondelete=CASCADE`, composite/expression indexes, `CheckConstraint`, optimistic locking `version_id_col`, `Numeric` dla pieniędzy, JSON rules), transakcje (`session.begin()`, SAVEPOINT `begin_nested`, retry na `OperationalError`, outbox pattern zamiast HTTP w transakcji), Alembic migrations (`render_as_batch=True` SQLite critical, `compare_type`, co autogenerate NIE wykrywa, zero-downtime 3-release pattern, CI upgrade/downgrade test), Repository + Unit of Work (Protocol-based, in-memory fakes), performance (bulk insert, `EXPLAIN QUERY PLAN`, keyset pagination, batch flush + expunge), security (parameterized queries, `SecretStr`, row-level predicates, encryption at rest, IDOR prevention), testing (in-memory SQLite, rollback-per-test, factory functions, migration round-trip), observability (slow query hook, OTel SQLAlchemyInstrumentor, metrics), backup (SQLite online backup, Litestream, pgloader migracja do Postgres), antypatterny i ruff S608/B008/PERF401/ASYNC110.

**Szukaj tu gdy:** projektujesz schemę/PK/index, piszesz migrację Alembic, decydujesz o transakcji/isolation, dodajesz Repository, migrujesz SQLite → Postgres, testujesz kod z DB, analizujesz slow query.

---

## Powiązane pliki

| Plik | Rola |
|------|------|
| `.github/instructions/python.instructions.md` | **Skondensowana master instruction** — hasłowa wiedza z 00-13, wstrzykiwana automatycznie do `**/*.py` |
| `references/engine-refactor-scope.md` | Audyt LOC — specyficzny dla repo, nie część standardu |
| `references/examples/showcase.py` | Wzorcowy plik Python łączący reguły z wielu sekcji |

---

## Jak używać tego skilla

### Jako AI agent (Copilot / orchestrator)

1. **Szybkie pytanie** → przeczytaj odpowiednią sekcję z `references/` (patrz „Szukaj tu gdy")
2. **Code review** → załaduj sekcje pasujące do reviewowanego kodu
3. **Nowy moduł** → załaduj 00 (tooling), 01 (docstrings), 02 (type hints), 04 (naming) + sekcje domenowe
4. **Refaktor** → załaduj sekcje pasujące do problemu (np. 05+06 dla function refactor, 07+09 dla class redesign)

### Jako developer

1. Przeczytaj `python.instructions.md` — skondensowany overview
2. Dla głębszego kontekstu → odpowiednia sekcja w `references/`
3. Traktuj `references/` jak podręcznik — wracaj po potrzebie, nie czytaj od A do Z

### Zasady sekcji referencyjnych

- Każdy plik jest **self-contained** — czytany osobno, bez wymaganych zależności
- Format: H1 tytuł + blockquote intro → TOC → numerowane sekcje → Quick Reference → Źródła
- Wszystkie przykłady są **generyczne** — `AppError`, `UserService`, `myapp.*` — zero nazw projektowych
- Język: **polski + angielskie terminy techniczne**
- ✅/❌ code snippety — zawsze para: dobrze vs źle
