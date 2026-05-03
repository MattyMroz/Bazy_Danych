# 14 — API Design (FastAPI + Pydantic v2)

> **Cel:** Kompletne reguły projektowania HTTP API w Pythonie — struktura projektu, routery, DI, OpenAPI, auth, error handling, streaming, observability, testing.
> **Scope:** Uniwersalny — Python ≥3.10, FastAPI ≥0.115, Pydantic ≥2.6, Starlette, httpx.
> **NIE duplikuje:** sygnatury funkcji (→06), error hierarchy (→08 `AppError`), config/secrets (→10 `BaseSettings`), async patterns (→13), pattern Repository (→09), logging (→11 loguru), testing basics (→12).
> **Zasada nadrzędna:** Router = thin delegation. Walidacja na wejściu, mapping błędów na wyjściu. Biznes logika NIGDY w routerze.
> **Powiązane:** [06-function-api-design.md](06-function-api-design.md) §6 (sygnatury), [08-error-handling.md](08-error-handling.md) (AppError), [09-design-patterns.md](09-design-patterns.md) §6 (Repository/UoW), [10-config-data.md](10-config-data.md) §1–2 (BaseSettings, SecretStr), [11-logging.md](11-logging.md) §1–2 (loguru, correlation), [12-testing.md](12-testing.md) (pytest), [13-async-concurrency.md](13-async-concurrency.md) §3–4 (asyncio, timeouts).
> **Powiązane:** [06-function-api-design.md](06-function-api-design.md) §6 (sygnatury), [08-error-handling.md](08-error-handling.md) (AppError), [09-design-patterns.md](09-design-patterns.md) §6 (Repository/UoW), [10-config-data.md](10-config-data.md) §1–2 (BaseSettings, SecretStr), [11-logging.md](11-logging.md) §1–2 (loguru, correlation), [12-testing.md](12-testing.md) (pytest), [13-async-concurrency.md](13-async-concurrency.md) §3–4 (asyncio, timeouts).

---

## Spis treści

1. [Filozofia i warstwy API](#1-filozofia-i-warstwy-api)
2. [Struktura projektu (folderowa)](#2-struktura-projektu-folderowa)
3. [App factory + lifespan + middleware order](#3-app-factory--lifespan--middleware-order)
4. [Routery (APIRouter, prefix, tags)](#4-routery-apirouter-prefix-tags)
5. [Pydantic v2 dla API — Request/Response](#5-pydantic-v2-dla-api--requestresponse)
6. [Dependency Injection (`Depends`, `Annotated`)](#6-dependency-injection-depends-annotated)
7. [OpenAPI — dokumentacja jako kontrakt](#7-openapi--dokumentacja-jako-kontrakt)
8. [Versioning & deprecation](#8-versioning--deprecation)
9. [Auth (OAuth2 + JWT, scopes)](#9-auth-oauth2--jwt-scopes)
10. [Error handling w API (RFC 7807)](#10-error-handling-w-api-rfc-7807)
11. [Observability (correlation ID, metrics, tracing)](#11-observability-correlation-id-metrics-tracing)
12. [Health checks (liveness vs readiness)](#12-health-checks-liveness-vs-readiness)
13. [Rate limiting i security headers](#13-rate-limiting-i-security-headers)
14. [Streaming — SSE, WebSocket, UploadFile](#14-streaming--sse-websocket-uploadfile)
15. [Async, background tasks, connection pools](#15-async-background-tasks-connection-pools)
16. [Testing API](#16-testing-api)
17. [Antypatterny](#17-antypatterny)
18. [Egzekucja ruff](#18-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła | Wartość |
|---|--------|---------|
| 1 | **Router = thin delegation** | Endpoint ≤15 linii: walidacja → service → response |
| 2 | **Lifespan > `@app.on_event`** | `on_event` deprecated od FastAPI 0.93 |
| 3 | **Request ≠ Response model** | ZAWSZE osobne klasy Pydantic |
| 4 | **`response_model=...`** | ZAWSZE — zero nagich `dict` / `Any` |
| 5 | **`async def` endpoints** | Domyślnie; sync tylko dla pure CPU ≤10ms |
| 6 | **DI przez `Depends()`** | Nigdy global session / config w module |
| 7 | **Versioning** | URL path: `/api/v1/...` (najprostsze, cacheable) |
| 8 | **Structured errors** | RFC 7807 + mapping `AppError → HTTPException` |
| 9 | **Correlation ID** | `X-Request-ID` middleware na każdym requeście |
| 10 | **Rate limit** | slowapi + Redis dla >1 worker |
| 11 | **Auth** | OAuth2 + JWT (RS256 dla wielu usług, HS256 dla monolitu) |
| 12 | **SSE dla progressu** | WebSocket tylko gdy two-way |
| 13 | **Tests = TestClient + `dependency_overrides`** | Nigdy nie modyfikuj `app` globalnie |
| 14 | **Idempotency-Key** dla POST tworzących zasoby | Deduplikacja retry (RFC 9110) |
| 16 | **CSRF** dla cookie-based auth | SameSite=Strict + state token |
| 17 | **ETag / 304** dla GET cacheowalnych | Klient oszczędza pasmo |
| 18 | **Pagination** | Cursor (≥10k), limit/offset (reszta) |
| 19 | **WebSocket auth** | Token w query lub cookie; weryfikuj PRZED `accept()` |
| 20 | **Health checks split** | `/health/live` + `/health/ready` |
| 15 | **Idempotency-Key** dla POST tworzących zasoby | Deduplikacja retry (RFC 9110) |
| 16 | **CSRF** dla cookie-based auth | SameSite=Strict + state token |
| 17 | **ETag / 304** dla GET cacheowalnych | Klient oszczędza pasmo |
| 18 | **Pagination** | Cursor (≥10k), limit/offset (reszta) |
| 19 | **WebSocket auth** | Token w query lub cookie; weryfikuj PRZED `accept()` |
| 20 | **Ruff:** `ASYNC`, `S`, `B`, `TRY`, `N818` — zawsze włączone |

---

## 1. Filozofia i warstwy API

### 1.1 Warstwy odpowiedzialności

```
Client (HTTP)
   ↓
┌─ Middleware  ← correlation ID, logging, CORS, auth, rate limit
│     ↓
├─ Router      ← walidacja (Pydantic) → delegacja do service
│     ↓
├─ Service     ← biznes logika (NIE HTTP-aware)
│     ↓
├─ Repository  ← dostęp do DB/cache (→09 §6)
│     ↓
└─ Model/DB    ← storage (→15)
```

| Warstwa | Co tu TAK | Co tu NIE |
|---------|-----------|-----------|
| Middleware | Cross-cutting (logging, auth, CORS) | Biznes logika, walidacja domenowa |
| Router | `response_model`, `Depends`, delegacja | `for`, `if` z logiką, I/O do DB, pętle |
| Service | Orkiestracja, domenowe wyjątki | `Request`, `Response`, `HTTPException` |
| Repository | SELECT/INSERT, mapping ORM → Entity | Logika walidacji domenowej |

### 1.2 Reguła: router jest thin

```python
# ✅ Thin router — delegation
@router.post(
    "/jobs",
    response_model=JobResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
async def create_job(
    request: JobCreateRequest,
    service: Annotated[JobService, Depends(get_job_service)],
    user: Annotated[User, Depends(get_current_user)],
) -> JobResponse:
    """Zaplanuj job. Zwraca 202 + job_id do pollingu."""
    job = await service.enqueue(request.to_domain(), owner_id=user.id)
    return JobResponse.from_domain(job)
```

```python
# ❌ Fat router — biznes logika + I/O w endpoincie
@router.post("/jobs")
async def create_job(request: dict, db: Session = Depends(get_db)) -> dict:
    if "title" not in request:                      # walidacja ręczna
        raise HTTPException(400, "title required")
    job = Job(title=request["title"], status="new") # ORM w routerze
    db.add(job)
    db.commit()                                      # transakcja w routerze
    queue.publish({"job_id": job.id})               # integracja w routerze
    return {"id": job.id, "status": "new"}          # bare dict
```

### 1.3 Sygnały że router jest za gruby

| Sygnał | Fix |
|--------|-----|
| Więcej niż 2 wywołania I/O | Wyciągnij do `service` |
| Conditional logic (if/else na biznes) | Service method z domain enum/result |
| Transakcja DB (commit/rollback) | Unit of Work w service (→09 §6.2) |
| Mapping ORM ↔ DTO | Metody `.from_domain()` / `.to_domain()` |
| Łapanie wyjątków domenowych | Exception handler (→§10) |

---

## 2. Struktura projektu (folderowa)

### 2.1 Rekomendowana struktura

```
myapp/
├── api/
│   ├── __init__.py
│   ├── main.py                # FastAPI() factory, lifespan
│   ├── settings.py            # ApiSettings (BaseSettings, →10)
│   ├── deps/                  # Dependency providers
│   │   ├── __init__.py
│   │   ├── auth.py            # get_current_user, require_scope
│   │   ├── db.py              # get_db_session
│   │   └── services.py        # get_job_service, ...
│   ├── middleware/
│   │   ├── __init__.py
│   │   ├── logging.py         # correlation ID, access log
│   │   └── security.py        # security headers
│   ├── routers/               # Jeden plik = jeden domen-resource
│   │   ├── __init__.py
│   │   ├── health.py          # /health, /ready
│   │   ├── auth.py            # /auth/login, /auth/refresh
│   │   └── jobs.py            # /jobs, /jobs/{id}
│   ├── schemas/               # Pydantic DTOs (nie domen models!)
│   │   ├── __init__.py
│   │   ├── common.py          # ErrorResponse, Pagination, PageMeta
│   │   ├── auth.py
│   │   └── jobs.py
│   ├── errors/
│   │   ├── __init__.py
│   │   └── handlers.py        # AppError → JSONResponse mapping
│   └── openapi.py             # Custom schema generation (opcjonalnie)
├── services/                  # Domain services (HTTP-agnostic)
│   └── jobs.py
├── repositories/              # DB access (→09, →15)
│   └── jobs.py
└── models/                    # Domain entities / ORM mapping
    └── jobs.py
```

### 2.2 Reguły organizacyjne

| Reguła | Dlaczego |
|--------|----------|
| 1 router = 1 domena / resource | Nie mieszaj `/users` i `/jobs` w jednym pliku |
| `schemas/` ≠ `models/` | Request/Response DTO to NIE to samo co domain entity |
| `deps/` = tylko providers | Zero logiki biznesowej w `Depends(...)` |
| `main.py` ≤ 100 linii | Tylko app factory + register middleware/routery/handlers |

### 2.3 App factory pattern

```python
# ✅ Testable — funkcja zwraca app, nie global
from __future__ import annotations

from fastapi import FastAPI

from myapp.api import routers
from myapp.api.errors.handlers import register_exception_handlers
from myapp.api.middleware.logging import LoggingMiddleware
from myapp.api.middleware.security import SecurityHeadersMiddleware
from myapp.api.settings import ApiSettings


def create_app(settings: ApiSettings | None = None) -> FastAPI:
    """Factory — testy wołają `create_app(test_settings)`."""
    settings = settings or ApiSettings()
    app = FastAPI(
        title=settings.app_name,
        version=settings.version,
        lifespan=_lifespan,
        docs_url="/docs" if settings.enable_docs else None,
        redoc_url="/redoc" if settings.enable_docs else None,
    )
    app.state.settings = settings

    _register_middleware(app, settings)
    register_exception_handlers(app)
    _register_routers(app)
    return app
```

```python
# ❌ Global app — nietestowalne, tight coupling
from fastapi import FastAPI

app = FastAPI()  # Settings hardcoded, brak izolacji testów
```

---

## 3. App factory + lifespan + middleware order

### 3.1 Lifespan zamiast `on_event`

> ⚠️ **`@app.on_event("startup")` i `"shutdown"` deprecated** od FastAPI 0.93. Jedyny supported pattern to `lifespan`.

```python
# ✅ Lifespan context manager
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from loguru import logger


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Startup + shutdown — wywoływane dokładnie raz."""
    # Startup
    logger.info("Starting {name} v{version}", name=app.title, version=app.version)
    app.state.http_client = httpx.AsyncClient(timeout=30.0)
    app.state.db_pool = await create_db_pool(app.state.settings.database_url)
    logger.success("Ready")

    yield  # Aplikacja żyje tutaj

    # Shutdown
    logger.info("Shutting down")
    await app.state.http_client.aclose()
    await app.state.db_pool.close()


app = FastAPI(lifespan=lifespan)
```

```python
# ❌ Deprecated — nie używać
@app.on_event("startup")
async def startup() -> None:
    ...
```

### 3.2 Middleware — kolejność MA znaczenie

FastAPI dodaje middleware w kolejności odwrotnej niż rejestracja — **ostatni dodany = pierwszy wywołany**.

| Kolejność wywołania (od request) | Middleware | Po co |
|-----|-----------|-------|
| 1 | CORS | Preflight OPTIONS nie zużywa auth |
| 2 | Security headers | HSTS, CSP, X-Content-Type-Options |
| 3 | Logging / correlation ID | Każdy log musi mieć `request_id` |
| 4 | Rate limit | Przed cięższym processingiem |
| 5 | Auth | Walidacja tokena |
| 6 | Route handler | Endpoint |

```python
# ✅ Rejestracja: OSTATNIA rejestracja = PIERWSZE wywołanie
def _register_middleware(app: FastAPI, settings: ApiSettings) -> None:
    # 6. Auth (opcjonalnie — częściej per-endpoint przez Depends)
    # 5. Rate limit
    app.add_middleware(RateLimitMiddleware, requests_per_minute=60)
    # 4. Logging + correlation ID
    app.add_middleware(LoggingMiddleware)
    # 3. Security headers
    app.add_middleware(SecurityHeadersMiddleware)
    # 2. CORS — ZAWSZE last added, first executed
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_allow_origins,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
        allow_headers=["Authorization", "Content-Type", "X-Request-ID"],
        expose_headers=["X-Request-ID"],
        max_age=600,
    )
```

---

## 4. Routery (APIRouter, prefix, tags)

### 4.1 Podział na routery

```python
# ✅ Jeden router per resource
from fastapi import APIRouter

router = APIRouter(
    prefix="/jobs",
    tags=["jobs"],
    responses={
        404: {"model": ErrorResponse, "description": "Job not found"},
        500: {"model": ErrorResponse, "description": "Server error"},
    },
)


@router.get("/{job_id}", response_model=JobResponse)
async def get_job(job_id: UUID, service: Annotated[JobService, Depends(get_job_service)]) -> JobResponse:
    job = await service.get(job_id)
    return JobResponse.from_domain(job)
```

### 4.2 Zagnieżdżone routery (hierarchia)

```python
# ✅ Root -> v1 -> resource
v1 = APIRouter(prefix="/api/v1")
v1.include_router(auth_router)       # /api/v1/auth/*
v1.include_router(jobs_router)       # /api/v1/jobs/*

v2 = APIRouter(prefix="/api/v2")
v2.include_router(jobs_router_v2)    # /api/v2/jobs/*

app.include_router(v1)
app.include_router(v2)
app.include_router(health_router)    # /health (nie versioned)
```

### 4.3 Reguły nazewnictwa endpointów

| Reguła | Przykład ✅ | Anty-przykład ❌ |
|--------|------------|------------------|
| REST nouns + HTTP verbs | `POST /jobs`, `GET /jobs/{id}` | `POST /createJob` |
| Plural dla kolekcji | `/jobs`, `/users` | `/job`, `/user` |
| Kebab-case dla segmentów wielowyrazowych | `/manga-pages` | `/manga_pages`, `/mangaPages` |
| UUID / slug zamiast ID | `/jobs/{job_id}` z typem `UUID` | `/jobs/{id}` z `int` (enumeracja) |
| Akcje jako sub-resource | `POST /jobs/{id}/cancel` | `POST /cancelJob?id=...` |
| Filtry w query | `GET /jobs?status=running` | `GET /jobs/running` |

### 4.4 Status code per metodę

| Metoda | Success | Typowe error |
|--------|---------|--------------|
| `GET` | `200 OK` | `404 Not Found`, `403 Forbidden` |
| `POST` (create) | `201 Created` + `Location` header | `409 Conflict`, `422` |
| `POST` (action) | `200 OK` lub `202 Accepted` | — |
| `PUT` / `PATCH` | `200 OK` lub `204 No Content` | `409`, `422` |
| `DELETE` | `204 No Content` | `404`, `409` |
| Async job scheduled | `202 Accepted` + `Location: /jobs/{id}` | — |

---

## 5. Pydantic v2 dla API — Request/Response

> Powiązane: [10-config-data.md](10-config-data.md) §5 (serializacja), [02-type-hints.md](02-type-hints.md) (Annotated, Literal).

### 5.1 Reguła: Request ≠ Response

| Typ | Zawiera | NIE zawiera |
|-----|---------|-------------|
| **Request** | Pola edytowalne przez klienta | `id`, `created_at`, `updated_at`, `status` (readonly) |
| **Response** | Wszystko co user może zobaczyć | `password_hash`, `internal_notes`, secret fields |
| **Domain entity** | Pełny stan + zachowanie | Nic HTTP-specific (`url_path`, `request_id`) |

```python
# ✅ Separate request/response models
from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class JobCreateRequest(BaseModel):
    """Payload od klienta."""

    model_config = ConfigDict(
        str_strip_whitespace=True,
        extra="forbid",  # Odrzuć nieznane pola (hardened input)
    )

    title: str = Field(min_length=1, max_length=200)
    priority: int = Field(default=5, ge=1, le=10)
    options: dict[str, str] = Field(default_factory=dict)


class JobResponse(BaseModel):
    """Odpowiedź do klienta."""

    model_config = ConfigDict(from_attributes=True)  # Mapping z ORM

    id: UUID
    title: str
    status: str
    priority: int
    created_at: datetime
    updated_at: datetime

    @classmethod
    def from_domain(cls, job: Job) -> JobResponse:
        """Mapping Domain → DTO. Zostaje w kontrolerze."""
        return cls.model_validate(job)
```

### 5.2 Walidacja na wejściu

```python
# ✅ Pydantic robi robotę — zero manualnych if-ów
from typing import Annotated

from pydantic import AfterValidator, Field, StringConstraints


def _lowercase(v: str) -> str:
    return v.lower()


Lang = Annotated[
    str,
    StringConstraints(pattern=r"^[a-z]{2}(-[A-Z]{2})?$"),
    AfterValidator(_lowercase),
]


class TranslationRequest(BaseModel):
    text: str = Field(min_length=1, max_length=10_000)
    source_lang: Lang
    target_lang: Lang
    model: str = Field(pattern=r"^(gpt-4o|claude-3-5|gemini-2)$")
```

```python
# ❌ Manualna walidacja w endpoincie
@router.post("/translate")
async def translate(payload: dict) -> dict:
    if "text" not in payload:
        raise HTTPException(422, "text required")
    if not isinstance(payload["text"], str):
        raise HTTPException(422, "text must be string")
    if len(payload["text"]) > 10_000:
        raise HTTPException(422, "text too long")
    ...
```

### 5.3 Discriminated unions (polymorphic payloads)

```python
# ✅ Type-safe polymorphic request
from typing import Annotated, Literal

from pydantic import BaseModel, Field, Tag, Discriminator


class ImageSource(BaseModel):
    kind: Literal["image"] = "image"
    image_base64: str


class UrlSource(BaseModel):
    kind: Literal["url"] = "url"
    url: str = Field(pattern=r"^https?://")


Source = Annotated[ImageSource | UrlSource, Discriminator("kind")]


class OcrRequest(BaseModel):
    source: Source
    lang: str = "auto"


# Pydantic rozróżnia variant po polu `kind` — zero if/else w kodzie
```

### 5.4 Response model z filtrowaniem

```python
@router.get(
    "/users/{user_id}",
    response_model=UserResponse,
    response_model_exclude_none=True,   # Pomija None
    response_model_exclude_defaults=False,
)
async def get_user(user_id: UUID, ...) -> UserResponse:
    ...
```

### 5.5 Pagination — limit/offset vs cursor

| Wzór | Kiedy | Plusy | Minusy |
|------|-------|-------|--------|
| **limit/offset** | Listy ≤10k, stabilny zbiór | Proste, `page`+`per_page` naturalne dla UI | Drift przy insertach, O(N) offset w DB |
| **Keyset (cursor)** | Listy ≥10k, feedy, infinite scroll | Stały koszt, spojny przy insertach | Brak „idzie do strony N”; cursor opaque |
| **Page token (cursor base64)** | Publiczne API | Stabilny kontrakt | Wymaga kodowania stanu |

```python
# ✅ Cursor pagination (keyset) — stabilne O(1) na stronie
from base64 import urlsafe_b64decode, urlsafe_b64encode


class JobPage(BaseModel):
    items: list[JobResponse]
    next_cursor: str | None = None


def _encode_cursor(last_id: UUID, last_created: datetime) -> str:
    raw = f"{last_created.isoformat()}|{last_id}".encode()
    return urlsafe_b64encode(raw).decode()


@router.get("/jobs", response_model=JobPage)
async def list_jobs(
    service: Annotated[JobService, Depends(get_job_service)],
    limit: int = Query(20, ge=1, le=100),
    cursor: str | None = Query(default=None),
) -> JobPage:
    after = _decode_cursor(cursor) if cursor else None
    jobs = await service.list_after(after=after, limit=limit + 1)
    has_more = len(jobs) > limit
    items = jobs[:limit]
    next_cur = _encode_cursor(items[-1].id, items[-1].created_at) if has_more else None
    return JobPage(items=[JobResponse.from_domain(j) for j in items], next_cursor=next_cur)
```

### 5.6 Conditional requests — ETag / 304 Not Modified

```python
# ✅ ETag + If-None-Match — klient cache'uje, serwer oszczędza
import hashlib


@router.get("/jobs/{job_id}", response_model=JobResponse)
async def get_job(
    job_id: UUID,
    request: Request,
    response: Response,
    service: Annotated[JobService, Depends(get_job_service)],
) -> JobResponse | Response:
    job = await service.get(job_id)
    etag = f'W/"{hashlib.sha256(f"{job.id}:{job.updated_at.timestamp()}".encode()).hexdigest()[:16]}"'
    if request.headers.get("If-None-Match") == etag:
        return Response(status_code=status.HTTP_304_NOT_MODIFIED, headers={"ETag": etag})
    response.headers["ETag"] = etag
    response.headers["Cache-Control"] = "private, max-age=0, must-revalidate"
    return JobResponse.from_domain(job)
```

| Nagłówek | Kiedy |
|----------|-------|
| `ETag: W/"hash"` | Weak ETag — wystarczy do cache porownania semantycznego |
| `Last-Modified` | Gdy masz precyzyjny timestamp zmiany |
| `Cache-Control: no-store` | Dane wrażliwe (auth, PII) — NIGDY nie cache'uj |

---

## 6. Dependency Injection (`Depends`, `Annotated`)

### 6.1 Reguła: DI > globale

| Zasób | Sposób dostarczenia |
|-------|---------------------|
| DB session | `Depends(get_db_session)` (per-request) |
| Current user | `Depends(get_current_user)` |
| Service | `Depends(get_job_service)` |
| Settings (read-only) | `Depends(get_settings)` + `@lru_cache` |
| Pagination params | `Depends(PaginationParams)` |

### 6.2 `Annotated` dependency (FastAPI ≥0.95)

```python
# ✅ Type alias — DRY, IDE friendly
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession


async def get_db_session(request: Request) -> AsyncIterator[AsyncSession]:
    async with request.app.state.db_pool() as session:
        yield session


DbSession = Annotated[AsyncSession, Depends(get_db_session)]
CurrentUser = Annotated[User, Depends(get_current_user)]


@router.get("/profile")
async def get_profile(db: DbSession, user: CurrentUser) -> UserResponse:
    return await user_service.get_profile(db, user.id)
```

```python
# ❌ Stary styl — `= Depends(...)` jako default
async def get_profile(
    db: AsyncSession = Depends(get_db_session),
    user: User = Depends(get_current_user),
) -> UserResponse:
    ...
# Działa, ale ruff `FAST002` (patrz §18.2) wymusza `Annotated[X, Depends(...)]` —
# type alias jest reużywalny i nie gubi informacji o typie w *args wiele razy.
```

### 6.3 Class-based dependencies (parametryzacja)

```python
# ✅ Config jako dependency (np. pagination)
from fastapi import Depends, Query
from pydantic import BaseModel, Field


class PaginationParams(BaseModel):
    limit: int = Field(default=20, ge=1, le=100)
    offset: int = Field(default=0, ge=0)


def pagination(
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
) -> PaginationParams:
    return PaginationParams(limit=limit, offset=offset)


Pagination = Annotated[PaginationParams, Depends(pagination)]


@router.get("/jobs")
async def list_jobs(pg: Pagination, service: Annotated[JobService, Depends(get_job_service)]) -> list[JobResponse]:
    jobs = await service.list(limit=pg.limit, offset=pg.offset)
    return [JobResponse.from_domain(j) for j in jobs]
```

### 6.4 Cached dependencies

```python
# ✅ Settings — jedna instancja per process
from functools import lru_cache


@lru_cache(maxsize=1)
def get_settings() -> ApiSettings:
    return ApiSettings()


Settings = Annotated[ApiSettings, Depends(get_settings)]
```

### 6.5 Dependency overrides w testach

```python
# tests/conftest.py
@pytest.fixture
def app_with_overrides() -> Iterator[FastAPI]:
    app = create_app(settings=TEST_SETTINGS)

    async def _fake_db() -> AsyncIterator[AsyncSession]:
        async with test_session_factory() as s:
            yield s

    app.dependency_overrides[get_db_session] = _fake_db
    yield app
    app.dependency_overrides.clear()   # cleanup zawsze
```

---

## 7. OpenAPI — dokumentacja jako kontrakt

### 7.1 Obowiązkowe pola per endpoint

```python
# ✅ Rich metadata — OpenAPI się samo zbuduje
@router.post(
    "/jobs",
    response_model=JobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    summary="Zaplanuj nowy job",
    description=(
        "Rejestruje job w kolejce i zwraca `job_id`. "
        "Status sprawdzaj na `GET /jobs/{id}` albo SSE `GET /jobs/{id}/events`."
    ),
    responses={
        202: {"description": "Zarejestrowany", "model": JobResponse},
        409: {"description": "Duplikat", "model": ErrorResponse},
        422: {"description": "Walidacja", "model": ErrorResponse},
        429: {"description": "Rate limited", "model": ErrorResponse},
    },
    openapi_extra={
        "x-owner": "team-pipeline",
    },
)
async def create_job(...): ...
```

### 7.2 Przykłady w schema (examples)

```python
class JobCreateRequest(BaseModel):
    title: str = Field(min_length=1, examples=["Translate chapter 42"])
    priority: int = Field(default=5, ge=1, le=10, examples=[1, 5, 10])

    model_config = ConfigDict(
        json_schema_extra={
            "examples": [
                {"title": "Translate chapter 42", "priority": 10},
                {"title": "Upscale cover", "priority": 3},
            ],
        },
    )
```

### 7.3 Customizacja OpenAPI schemy

```python
from fastapi.openapi.utils import get_openapi


def custom_openapi(app: FastAPI) -> dict[str, Any]:
    if app.openapi_schema:
        return app.openapi_schema
    schema = get_openapi(
        title=app.title,
        version=app.version,
        description="MangaShift internal API",
        routes=app.routes,
    )
    schema["components"]["securitySchemes"] = {
        "BearerAuth": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
    }
    schema["security"] = [{"BearerAuth": []}]
    app.openapi_schema = schema
    return schema


app.openapi = lambda: custom_openapi(app)
```

---

## 8. Versioning & deprecation

### 8.1 Strategia wersjonowania

| Styl | Przykład | Pros | Cons |
|------|----------|------|------|
| **URI path** (rekomendowane) | `/api/v1/jobs`, `/api/v2/jobs` | Proste, cacheowalne, łatwy routing | Rozproszenie routerów |
| **Header** | `Accept: application/vnd.myapp.v2+json` | Czysty URI | Trudniejsze debugowanie, cache keys |
| **Query param** | `/api/jobs?version=2` | Łatwe testy | Łamie konwencje REST |

```python
# ✅ Równoległe wersje przez prefix
app.include_router(jobs_v1.router, prefix="/api/v1")
app.include_router(jobs_v2.router, prefix="/api/v2", deprecated=False)

# Stara wersja z Deprecation headers
@v1_router.get("/jobs/{job_id}", deprecated=True)
async def get_job_v1(job_id: UUID, response: Response) -> JobResponseV1:
    response.headers["Deprecation"] = "true"
    response.headers["Sunset"] = "Wed, 31 Dec 2025 23:59:59 GMT"
    response.headers["Link"] = '</api/v2/jobs/{job_id}>; rel="successor-version"'
    return ...
```

### 8.2 Deprecation headers (RFC 9745 / 8594 / 8288)

| Header | RFC | Semantyka |
|--------|-----|-----------|
| `Deprecation: true` | RFC 9745 | Endpoint oznaczony jako deprecated |
| `Sunset: <HTTP-date>` | RFC 8594 | Data po której endpoint zniknie |
| `Link: <url>; rel="successor-version"` | RFC 8288 | Wskazuje następcę |

### 8.3 Idempotency-Key — deduplikacja POST

Retry klienta (sieć flapnęła) NIE powinien tworzyć duplikatów. Standard: klient generuje UUID w nagłówku `Idempotency-Key`, serwer cache'uje `(key, request_hash) → response` na TTL.

```python
# ✅ Middleware / dependency — Redis jako storage
import hashlib

from redis.asyncio import Redis

_IDEMPOTENCY_TTL = 86_400   # 24h per RFC draft


async def idempotency_guard(
    request: Request,
    redis: Annotated[Redis, Depends(get_redis)],
) -> None:
    key = request.headers.get("Idempotency-Key")
    if not key or request.method not in {"POST", "PATCH"}:
        return
    body = await request.body()
    req_hash = hashlib.sha256(body).hexdigest()
    stored = await redis.get(f"idem:{key}")
    if stored and stored.decode() != req_hash:
        raise AppError(ErrorCode.CONFLICT, "Idempotency-Key reused with different body")
    await redis.setex(f"idem:{key}", _IDEMPOTENCY_TTL, req_hash)
```

| Reguła | Dlaczego |
|--------|----------|
| Klient generuje UUID per operację | Stabilny przy retry, unikalny per intencja |
| Serwer waliduje `hash(body)` match | Inny body + ten sam key = 409 Conflict |
| TTL 24h (RFC HTTP idempotency draft) | Balance pamięć vs okno retry |
| Tylko POST/PATCH (mutating) | GET/PUT/DELETE są już idempotentne HTTP-level |

---

## 9. Auth (OAuth2 + JWT, scopes)

### 9.1 Decision table

| Scenariusz | Auth | Powód |
|-----------|------|-------|
| Desktop / mobile → backend | OAuth2 Password Flow + JWT | Standard, stateless |
| SPA + backend | OAuth2 Authorization Code + PKCE | Token nie jest w JS (HttpOnly cookie) |
| Service → service | OAuth2 Client Credentials / mTLS | Brak usera |
| Internal (VPN, same repo) | API key + HMAC | Overhead OAuth2 zbędny |
| Public API | OAuth2 + rate limit per client | Skalowalne |

### 9.2 OAuth2 + JWT — implementacja

```python
# ✅ HS256 monolit / RS256 między usługami
from datetime import datetime, timedelta, timezone
from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from passlib.context import CryptContext
from pydantic import BaseModel, SecretStr

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")


class AuthSettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="AUTH_")
    jwt_secret: SecretStr                 # HS256: shared; RS256: prywatny klucz PEM
    jwt_public_key: SecretStr | None = None  # RS256 only
    jwt_algorithm: Literal["HS256", "RS256"] = "HS256"
    jwt_key_id: str = "primary"           # `kid` header — dla rotacji klucza
    jwt_issuer: str = "myapp"             # `iss` claim — anti-confusion
    jwt_audience: str = "myapp-api"       # `aud` claim
    access_ttl_minutes: int = 15
    refresh_ttl_days: int = 30


class TokenPayload(BaseModel):
    sub: str                  # user ID
    iss: str                  # issuer
    aud: str                  # audience
    iat: int                  # issued at
    exp: int                  # expires at
    jti: str                  # unique token ID (dla revocation list)
    scopes: list[str] = []
    token_type: Literal["access", "refresh"] = "access"


def create_access_token(user_id: str, *, scopes: list[str], settings: AuthSettings) -> str:
    now = datetime.now(tz=timezone.utc)
    payload = TokenPayload(
        sub=user_id,
        iss=settings.jwt_issuer,
        aud=settings.jwt_audience,
        iat=int(now.timestamp()),
        exp=int((now + timedelta(minutes=settings.access_ttl_minutes)).timestamp()),
        jti=str(uuid.uuid4()),
        scopes=scopes,
        token_type="access",
    )
    # `kid` w nagłówku — pozwala zweryfikować właściwym kluczem publicznym (rotacja)
    return jwt.encode(
        payload.model_dump(),
        settings.jwt_secret.get_secret_value(),
        algorithm=settings.jwt_algorithm,
        headers={"kid": settings.jwt_key_id},
    )


async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    settings: Settings,
) -> User:
    try:
        # KRYTYCZNE: algorithms=[...] MUSI być whitelist — inaczej atak algorithm-confusion
        # (klient ślę `alg: none` albo HS256 z public key jako secret)
        key = (
            settings.auth.jwt_public_key.get_secret_value()
            if settings.auth.jwt_algorithm == "RS256"
            else settings.auth.jwt_secret.get_secret_value()
        )
        raw = jwt.decode(
            token,
            key,
            algorithms=[settings.auth.jwt_algorithm],   # whitelist — NIGDY None
            issuer=settings.auth.jwt_issuer,
            audience=settings.auth.jwt_audience,
        )
    except jwt.ExpiredSignatureError as exc:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Token expired") from exc
    except jwt.InvalidTokenError as exc:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Invalid token") from exc

    payload = TokenPayload.model_validate(raw)
    if payload.token_type != "access":
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Wrong token type")
    return await user_repo.get_by_id(payload.sub)
```

### 9.2.1 HS256 vs RS256 — kiedy co

| Kryterium | HS256 (symmetric) | RS256 (asymmetric) |
|-----------|-------------------|--------------------|
| Klucz | Jeden shared secret | Para: private (podpis) + public (weryfikacja) |
| Rozmiar tokenu | Mniejszy | Większy (~30% więcej) |
| CPU podpisu/weryfikacji | Szybki | Wolniejszy (RSA) |
| Distribution | Wszyscy mają sekret — risk | Tylko signer ma private, reszta public |
| Kiedy użyć | **Monolit** (jedna usługa) | **Multi-service**, third-party weryfikuje |
| Key rotation | Trudne (wszystkie usługi na raz) | Łatwe (`kid` + JWKS endpoint) |
| `kid` header | Opcjonalny | **WYMAGANY** w praktyce |

### 9.2.2 Top JWT pitfalls

| Atak | Obrona |
|------|--------|
| **`alg: none`** attack | `algorithms=[...]` whitelist — NIGDY `None` / brak parametru |
| **Algorithm confusion** (HS256 z public RSA key) | Osobne settings dla HS256/RS256; sprawdź `header["alg"]` przed decode |
| **`kid` path injection** (`../keys/weak.pem`) | Whitelist `kid` wartości; nigdy nie używaj jako ścieżki pliku |
| **Brak `exp`** | Zawsze `exp`; reject jeśli brak |
| **Brak `aud`/`iss`** | Waliduj `audience=`, `issuer=` w `jwt.decode` |
| **JWT w localStorage** | HttpOnly cookie z `SameSite=Strict` + CSRF token |
| **Long-lived access token** | Max 15 min; refresh → access rotation |

### 9.2.3 JWKS endpoint — distribution klucza publicznego (RS256)

W multi-service setupie signer trzyma private key, konsumenci pobierają public key z JWKS. Standard: `/.well-known/jwks.json` (RFC 7517).

```python
# ✅ JWKS endpoint — eksponuje public key w formacie JWK
from cryptography.hazmat.primitives.serialization import load_pem_public_key
from jwt.algorithms import RSAAlgorithm


@router.get("/.well-known/jwks.json", include_in_schema=False)
async def jwks(settings: Settings) -> dict[str, list[dict[str, Any]]]:
    public_pem = settings.auth.jwt_public_key.get_secret_value()
    jwk = json.loads(RSAAlgorithm.to_jwk(load_pem_public_key(public_pem.encode())))
    jwk["kid"] = settings.auth.jwt_key_id
    jwk["use"] = "sig"
    jwk["alg"] = "RS256"
    return {"keys": [jwk]}
```

```python
# ✅ Konsument — cache JWKS, wybierz klucz po `kid`
from jwt import PyJWKClient

_jwks_client = PyJWKClient("https://auth.myapp.dev/.well-known/jwks.json", cache_keys=True)


async def verify_rs256(token: str, *, issuer: str, audience: str) -> dict[str, Any]:
    signing_key = _jwks_client.get_signing_key_from_jwt(token)   # używa `kid` z headera
    return jwt.decode(token, signing_key.key, algorithms=["RS256"], issuer=issuer, audience=audience)
```

| Element | Rola |
|---------|------|
| `/.well-known/jwks.json` | Standardowa ścieżka (RFC 8615 + RFC 7517) |
| `kid` w JWK + w JWT header | Konsument wybiera klucz z listy |
| `use: "sig"` | Klucz do podpisu (NIE szyfrowania) |
| Cache TTL | 1-24h; rotacja = dodaj nowy `kid` zanim wycofasz stary |
| HTTPS only | Zawsze — MITM = podmiana klucza = RCE tokenu |

### 9.3 Scopes (fine-grained authorization)

| CORS preflight (`OPTIONS`) odrzucone | Zwraca 403/204 bez body — NIE RFC 7807 (browser nie widzi body) |
| Security-sensitive errors (401/403) | Generyczne `detail` — nie ujawniaj czy konto istnieje (user enumeration) |
FastAPI używa `Security()` (wrapper nad `Depends()`) by zebrać scope requirements do OpenAPI + wstrzyknąć `SecurityScopes` zawierający żądane przez aktualnego callera.

```python
# ✅ Factory dependency — domyka scope w closure
from fastapi import Security
from fastapi.security import SecurityScopes


def require_scopes(*required: str) -> Callable[..., Awaitable[User]]:
    async def _check(
        security_scopes: SecurityScopes,
        token: Annotated[str, Depends(oauth2_scheme)],
        settings: Settings,
    ) -> User:
        user = await get_current_user(token, settings)
        # Scope z dekoratora (statyczny) + scope z OpenAPI security (dynamic)
        needed = set(required) | set(security_scopes.scopes)
        missing = needed - set(user.scopes)
        if missing:
            raise HTTPException(
                status.HTTP_403_FORBIDDEN,
                detail=f"Missing scopes: {sorted(missing)}",
                headers={"WWW-Authenticate": f'Bearer scope="{" ".join(needed)}"'},
            )
        return user
    return _check


# Użycie — Security() zamiast Depends() propaguje scopes do OpenAPI
@router.delete("/jobs/{job_id}")
async def delete_job(
    job_id: UUID,
    user: Annotated[User, Security(require_scopes("jobs:delete"))],
) -> Response:
    await job_service.delete(job_id, by_user=user)
    return Response(status_code=status.HTTP_204_NO_CONTENT)
```

### 9.4 Refresh tokens

| Reguła | Dlaczego |
|--------|----------|
| Access token TTL: 5-15 min | Kompromitacja = krótkie okno ataku |
| Refresh token TTL: 7-30 dni | Balans UX vs bezpieczeństwo |
| Refresh token rotacja (rotation on use) | Stary refresh unieważniany przy użyciu; kradzież → detekcja |
| Refresh token w HttpOnly cookie | JS nie ma dostępu → XSS mitigation |
| Endpoint `/auth/logout` odwołuje refresh | DB flag `revoked_at` + `jti` blacklist (Redis) |
| Reuse detection | Użyty stary refresh → invalidate całą rodzinę (sygnał kradzieży) |

### 9.5 CSRF protection (cookie-based auth)

Gdy auth trzymasz w HttpOnly cookie (zalecane), musisz zabezpieczyć się przed Cross-Site Request Forgery.

| Warstwa | Mechanizm |
|---------|-----------|
| Cookie attrs | `SameSite=Strict` (lub `Lax` dla top-level nav) + `Secure` + `HttpOnly` |
| Double-submit token | Token w cookie `csrf_token` + w nagłówku `X-CSRF-Token`; serwer porównuje |
| Origin / Referer check | Dla mutating requests (`POST`/`PUT`/`DELETE`/`PATCH`) |
| Custom header | `X-Requested-With: XMLHttpRequest` wymusza preflight (CORS) |

```python
# ✅ Dependency wymagająca double-submit CSRF
import secrets


async def csrf_protect(request: Request) -> None:
    if request.method in {"GET", "HEAD", "OPTIONS"}:
        return
    cookie_tok = request.cookies.get("csrf_token")
    header_tok = request.headers.get("X-CSRF-Token")
    if not cookie_tok or not header_tok or not secrets.compare_digest(cookie_tok, header_tok):
        raise HTTPException(status.HTTP_403_FORBIDDEN, detail="CSRF token mismatch")
```

> JWT w `Authorization: Bearer` (nie w cookie) → CSRF nie dotyczy. Wybierz jeden model; nie mieszaj.

---

## 10. Error handling w API (RFC 7807)

> Powiązane: [08-error-handling.md](08-error-handling.md) — `AppError`, `ErrorContext`, chain `raise ... from`.

### 10.1 Mapping AppError → HTTP

```python
# ✅ Central exception handler — jedno miejsce, cała aplikacja
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError

from myapp.errors import AppError, FatalError, TransientError


# Mapowanie klas domen → status HTTP
_STATUS_MAP: dict[type[AppError], int] = {
    ValidationError: status.HTTP_422_UNPROCESSABLE_ENTITY,
    NotFoundError: status.HTTP_404_NOT_FOUND,
    ConflictError: status.HTTP_409_CONFLICT,
    AuthenticationError: status.HTTP_401_UNAUTHORIZED,
    AuthorizationError: status.HTTP_403_FORBIDDEN,
    RateLimitError: status.HTTP_429_TOO_MANY_REQUESTS,
    TransientError: status.HTTP_503_SERVICE_UNAVAILABLE,
    FatalError: status.HTTP_500_INTERNAL_SERVER_ERROR,
}


def _resolve_status(exc: AppError) -> int:
    for klass in type(exc).__mro__:
        if klass in _STATUS_MAP:
            return _STATUS_MAP[klass]
    return status.HTTP_500_INTERNAL_SERVER_ERROR


async def handle_app_error(request: Request, exc: AppError) -> JSONResponse:
    status_code = _resolve_status(exc)
    logger.opt(exception=exc).log(
        "WARNING" if status_code < 500 else "ERROR",
        "API error {code} on {path}",
        code=exc.context.code,
        path=request.url.path,
    )
    return JSONResponse(
        status_code=status_code,
        content=ErrorResponse.from_app_error(
            exc, request_id=request.state.request_id,
        ).model_dump(),
    )


def register_exception_handlers(app: FastAPI) -> None:
    app.add_exception_handler(AppError, handle_app_error)
    app.add_exception_handler(RequestValidationError, handle_validation_error)
    app.add_exception_handler(Exception, handle_unhandled)
```

### 10.2 Format błędu (inspiracja RFC 7807)

```python
# ✅ Structured error — machine- + human-readable
class ErrorResponse(BaseModel):
    type: str = Field(description="URI klasyfikujące error")
    title: str = Field(description="Krótki, ludzki tytuł")
    status: int = Field(description="HTTP status")
    code: str = Field(description="Machine-readable kod (ErrorCode)")
    detail: str = Field(description="Długi opis tego konkretnego przypadku")
    instance: str | None = Field(default=None, description="URI konkretnego wystąpienia")
    request_id: str
    details: dict[str, Any] = Field(default_factory=dict)

    @classmethod
    def from_app_error(cls, exc: AppError, *, request_id: str) -> ErrorResponse:
        ctx = exc.context
        return cls(
            type=f"https://errors.myapp.dev/{ctx.code}",
            title=exc.__class__.__name__,
            status=_resolve_status(exc),
            code=str(ctx.code),
            detail=ctx.message,
            request_id=request_id,
            details=ctx.details,
        )
```

### 10.3 Walidacja — customizacja komunikatów

```python
async def handle_validation_error(request: Request, exc: RequestValidationError) -> JSONResponse:
    errors = [
        {
            "field": ".".join(str(p) for p in err["loc"][1:]),   # [1:] pomija prefix 'body'/'query'/'path'
            "type": err["type"],
            "message": err["msg"],
        }
        for err in exc.errors()
    ]
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=ErrorResponse(
            type="https://errors.myapp.dev/VALIDATION",
            title="Validation failed",
            status=422,
            code="VALIDATION",
            detail="One or more fields failed validation",
            request_id=request.state.request_id,
            details={"errors": errors},
        ).model_dump(),
    )
```

### 10.4 Reguły bezpieczeństwa błędów

| Reguła | Dlaczego |
|--------|----------|
| Nie leakuj traceback w produkcji | Information disclosure |
| `request_id` ZAWSZE w response | Korelacja z logami |
| 500: generic message, szczegóły w logach | Nie ujawniaj stack trace |
| `details` nie zawiera PII/secrets | GDPR / security |
| Error code stabilny (część kontraktu) | Klienci polegają na nim |
| CORS preflight (`OPTIONS`) odrzucone | Zwraca 403/204 bez body — NIE RFC 7807 (browser nie widzi body) |
| Security-sensitive errors (401/403) | Generyczne `detail` — nie ujawniaj czy konto istnieje (user enumeration) |

---

## 11. Observability (correlation ID, metrics, tracing)

### 11.1 Correlation ID middleware

```python
# ✅ Generuj lub propaguj X-Request-ID
import uuid
from starlette.middleware.base import BaseHTTPMiddleware


class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
        request.state.request_id = request_id

        with logger.contextualize(request_id=request_id, path=request.url.path):
            response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        return response
```

### 11.2 Metrics (Prometheus)

```python
# ✅ prometheus-client + starlette-exporter
from starlette_exporter import PrometheusMiddleware, handle_metrics

app.add_middleware(
    PrometheusMiddleware,
    app_name="myapp",
    group_paths=True,               # /jobs/{id} → /jobs/{id} (nie /jobs/abc123)
    filter_unhandled_paths=True,
    buckets=(0.01, 0.05, 0.1, 0.5, 1.0, 2.5, 5.0, 10.0),
)
app.add_route("/metrics", handle_metrics)
```

| Metryka (standard) | Label cardinality | Alert PromQL |
|--------------------|-------------------|--------------|
| `http_requests_total{method,path,status}` | niska (grupuj paths) | `rate(...{status=~"5.."}[5m]) > 1` |
| `http_request_duration_seconds_bucket{...}` | niska | `histogram_quantile(0.95, ...) > 1.0` |
| `http_requests_in_progress{...}` | niska | saturacja workerów |

> **Nigdy** nie daj user ID / UUID jako label — cardinality explosion = Prometheus OOM.

### 11.3 Tracing (OpenTelemetry)

```python
# ✅ Auto-instrumentation FastAPI + httpx + SQLAlchemy
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor

FastAPIInstrumentor.instrument_app(app, excluded_urls="/health/.*,/metrics")
HTTPXClientInstrumentor().instrument()
SQLAlchemyInstrumentor().instrument(engine=engine)

tracer = trace.get_tracer(__name__)

# Custom span wewnątrz endpointu
with tracer.start_as_current_span("process_job", attributes={"job.id": str(job_id)}):
    await job_service.process(job_id)
```

| Aspekt | Reguła |
|--------|--------|
| Exporter | OTLP (gRPC) → Tempo/Jaeger/Honeycomb |
| Sampling | Production: `ParentBased(TraceIdRatioBased(0.1))` — 10% |
| Trace propagation | `traceparent` header (W3C) — httpx i FastAPI auto |
| Sensitive attrs | NIGDY: tokens, passwords, PII. Enum `span.set_attribute("user.id", hash)` |
| Correlation log↔trace | Loguru: `logger.bind(trace_id=trace.get_current_span().get_span_context().trace_id)` |

---

## 12. Health checks (liveness vs readiness)

### 12.1 Semantyka

| Endpoint | Znaczenie | Sprawdza | Co robi K8s gdy fail |
|----------|-----------|----------|----------------------|
| `/health/live` | Proces żyje? | Tylko że proces odpowiada | Restart pod (`livenessProbe`) |
| `/health/ready` | Gotowy na ruch? | DB, cache, external deps | Wyłącz z LB (`readinessProbe`) |
| `/health/startup` (opcjonalne) | Dla wolnego startu | Migracje zakończone, modele załadowane | Czeka przed live/ready (`startupProbe`) |

> **Zasada:** liveness NIGDY nie sprawdza zewnętrznych zależności. Flapping DB = cascading restart = brak mocy naprawczej.

### 12.2 Implementacja

```python
# ✅ Separate endpoints
from fastapi import APIRouter, status
from pydantic import BaseModel


router = APIRouter(tags=["health"])


class HealthStatus(BaseModel):
    status: Literal["ok", "degraded", "down"]
    checks: dict[str, Literal["ok", "fail"]] = {}


@router.get("/health/live", response_model=HealthStatus)
async def liveness() -> HealthStatus:
    # Tylko sygnał że proces żyje
    return HealthStatus(status="ok")


@router.get(
    "/health/ready",
    response_model=HealthStatus,
    responses={503: {"model": HealthStatus, "description": "Not ready"}},
)
async def readiness(
    response: Response,
    db: DbSession,
    cache: Annotated[CacheClient, Depends(get_cache)],
) -> HealthStatus:
    checks: dict[str, Literal["ok", "fail"]] = {}
    try:
        await db.execute(text("SELECT 1"))
        checks["db"] = "ok"
    except Exception:
        checks["db"] = "fail"
    try:
        await cache.ping()
        checks["cache"] = "ok"
    except Exception:
        checks["cache"] = "fail"

    overall: Literal["ok", "degraded", "down"] = "ok" if all(v == "ok" for v in checks.values()) else "down"
    # Ustawiamy status przez `response`, zachowując `response_model=` — OpenAPI ma jedno źródło prawdy
    if overall != "ok":
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE
    return HealthStatus(status=overall, checks=checks)
```

---

## 13. Rate limiting i security headers

### 13.1 Rate limiting — strategie

| Storage | Kiedy | Pros | Cons |
|---------|-------|------|------|
| In-memory (slowapi default) | 1 worker, dev | Zero deps | Nie działa w multi-worker |
| Redis | ≥2 workery / horyzontalne skalowanie | Accurate, shared state | Dependency |
| Token bucket | Burst traffic OK | Smooth | Złożona implementacja |
| Fixed window | Proste limity | Łatwe | Skoki na granicy |
| Sliding window | Strict limits | Accurate | Większe zużycie pamięci |

### 13.2 slowapi + Redis

```python
# ✅ Distributed rate limit
from slowapi import Limiter
from slowapi.util import get_remote_address


limiter = Limiter(
    key_func=get_remote_address,
    storage_uri="redis://localhost:6379/0",
    strategy="moving-window",
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_handler)


@router.post("/jobs")
@limiter.limit("10/minute")
async def create_job(request: Request, payload: JobCreateRequest, ...): ...
```

### 13.2.1 Key function — per-IP / per-user / per-API-key

| `key_func` | Scenariusz | Pros | Cons |
|-----------|-----------|------|------|
| `get_remote_address` | Public endpoint (login, signup) | Proste | Bypass — NAT/VPN/Tor; wymaga `X-Forwarded-For` trust |
| `lambda r: r.state.user_id` | Authenticated API | Fair per-user | Nie dla anonymous |
| `lambda r: r.headers.get("X-API-Key")` | Machine-to-machine | Per-tenant quota | Wymaga pre-auth middleware |
| Composite (`user || ip`) | Mixed traffic | Pokrycie całości | Kompleks |

```python
# ✅ Per-user gdy auth, fallback na IP
def key_by_user_or_ip(request: Request) -> str:
    return getattr(request.state, "user_id", None) or get_remote_address(request)


limiter = Limiter(key_func=key_by_user_or_ip, storage_uri="redis://...")
```

> **Uwaga:** przy proxy (nginx, ALB) ustaw `forwarded_allow_ips="..."` w uvicorn — inaczej `X-Forwarded-For` = spoofable.

### 13.3 Security headers middleware

```python
# ✅ Baseline headers (OWASP)
class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        response = await call_next(request)
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "DENY")
        response.headers.setdefault("Referrer-Policy", "strict-origin-when-cross-origin")
        response.headers.setdefault("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        response.headers.setdefault("Content-Security-Policy", "default-src 'self'")
        return response
```

| Header | Po co |
|--------|-------|
| `X-Content-Type-Options: nosniff` | Blokuje MIME sniffing |
| `X-Frame-Options: DENY` | Anti-clickjacking |
| `Strict-Transport-Security` | Wymuś HTTPS (HSTS) |
| `Referrer-Policy` | Ogranicza wyciek URL-i |
| `Content-Security-Policy` | Anti-XSS |

### 13.4 CORS — reguły

| ✅ | ❌ |
|----|----|
| Explicit `allow_origins=[...]` | `allow_origins=["*"]` z `allow_credentials=True` (niedozwolone) |
| Minimal `allow_methods` | `allow_methods=["*"]` w produkcji |
| Explicit `expose_headers=[...]` | Zakładanie że klient zobaczy `X-Request-ID` |
| `max_age=600` | Brak — preflight na każdy request |

---

## 14. Streaming — SSE, WebSocket, UploadFile

### 14.1 Decision table: streaming

| Potrzeba | Użyj | Dlaczego |
|----------|------|----------|
| Progress long-running job | **SSE** | HTTP-native, reconnect auto, prosty |
| Chat / two-way real-time | **WebSocket** | Bidirectional |
| Duży plik down | `StreamingResponse` | Memory-safe |
| Duży plik up | `UploadFile` + chunked read | Bez OOM |
| Server push rzadkie eventy | **SSE** | Lekki, HTTP/2 compatible |
| >10k concurrent | **WebSocket** | Lower overhead per connection |

### 14.2 Server-Sent Events (SSE)

SSE ma wbudowany reconnect: klient zapisuje ostatni `id:` i przy rozerwaniu połączenia ślę go w nagłówku `Last-Event-ID`. Serwer MUSI ten nagłówek respektować i backfillować eventy po tym punkcie.

```python
# ✅ SSE progress stream z id + heartbeat + reconnect
import asyncio
import json
from collections.abc import AsyncIterator

from fastapi.responses import StreamingResponse

_HEARTBEAT_EVERY = 15.0  # seconds — anti proxy idle timeout (≥30s typical)


async def _event_stream(
    job_id: UUID,
    service: JobService,
    last_event_id: str | None,
) -> AsyncIterator[str]:
    # Backfill od ostatniego event-id (reconnect) — źródło prawdy w DB/queue
    async for event in service.watch(job_id, after_event_id=last_event_id):
        payload = json.dumps(event.model_dump(), default=str)
        # id: — klient zapisze i poda przy reconnect jako Last-Event-ID
        yield f"id: {event.id}\nevent: {event.kind}\ndata: {payload}\n\n"


async def _with_heartbeat(inner: AsyncIterator[str]) -> AsyncIterator[str]:
    """Wsuń `: heartbeat` co N sekund jeśli brak realnych eventów."""
    queue: asyncio.Queue[str | None] = asyncio.Queue()

    async def _pump() -> None:
        async for chunk in inner:
            await queue.put(chunk)
        await queue.put(None)

    task = asyncio.create_task(_pump())
    try:
        while True:
| 21 | WebSocket bez auth przed `accept()` | Weryfikuj token → close 1008 jeśli fail | Open socket = koszt resources |
| 22 | SSE bez `id:` + brak obsługi `Last-Event-ID` | `id: N` per event + backfill | Utracone eventy przy reconnect |
| 23 | SSE bez heartbeat | `: keepalive\n\n` co 15s | Proxy zamknie idle connection |
| 24 | Upload: trust `content_type` | Magic bytes (`libmagic`) | Klient wysyła co chce — XSS via SVG |
| 25 | JWT `algorithms=None` / brak parametru | `algorithms=["RS256"]` whitelist | Atak `alg: none` |
| 26 | Brak `iss`/`aud` w JWT | Waliduj `issuer=`, `audience=` | Token reuse cross-service |
| 27 | Long-lived access token (godziny) | ≤15 min + refresh | Kompromitacja = długie okno |
| 28 | Cookie auth bez CSRF protection | `SameSite=Strict` + double-submit token | CSRF attack |
| 29 | Rate limit per-IP za NAT/proxy | Per-user gdy auth, IP tylko fallback | Bypass via shared IP |
| 30 | OFFSET pagination dla 100k+ rows | Keyset/cursor | O(N) scan per request |
            try:
                chunk = await asyncio.wait_for(queue.get(), timeout=_HEARTBEAT_EVERY)
            except TimeoutError:
                yield ": keepalive\n\n"   # komentarz SSE — klient ignoruje, proxy nie zamknie
                continue
            if chunk is None:
                break
            yield chunk
    finally:
        task.cancel()


@router.get("/jobs/{job_id}/events")
async def stream_job(
    job_id: UUID,
    request: Request,
    service: Annotated[JobService, Depends(get_job_service)],
) -> StreamingResponse:
    last_id = request.headers.get("Last-Event-ID")
    return StreamingResponse(
        _with_heartbeat(_event_stream(job_id, service, last_id)),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",   # Disable nginx buffering
            "Connection": "keep-alive",
        },
    )
```

| Element | Po co |
|---------|-------|
| `id: N` per event | Klient zapamiętuje → `Last-Event-ID` przy reconnect |
| Serwer czyta `Last-Event-ID` header | Backfill od momentu zerwania |
| `: heartbeat\n\n` co 15s | Proxy/LB nie zamknie idle (typowy timeout 30-60s) |
| `retry: N\n\n` (opcjonalnie) | Instrukcja dla klienta ile ms czekać przed retry |
| Max event size | **≤64 KB per event** — większe chunkuj na osobne eventy (Chrome soft-limit, nginx `proxy_buffer_size` default 4-8 KB) |
| Per-connection overhead | ~4-8 KB RAM/conn — przy >10k concurrent wybierz WebSocket |

### 14.3 WebSocket

```python
# ✅ WebSocket z auth, heartbeat i proper close
from fastapi import WebSocket, WebSocketDisconnect, status as ws_status


@router.websocket("/ws/jobs/{job_id}")
async def ws_job(
    websocket: WebSocket,
    job_id: UUID,
    settings: Settings,
    service: Annotated[JobService, Depends(get_job_service)],
) -> None:
    # 1. Auth PRZED accept() — możemy odrzucić z 403/401 bez open handshake
    token = websocket.query_params.get("token") or websocket.cookies.get("access_token")
    if not token:
        await websocket.close(code=ws_status.WS_1008_POLICY_VIOLATION)
        return
    try:
        user = await get_current_user(token, settings)
    except HTTPException:
        await websocket.close(code=ws_status.WS_1008_POLICY_VIOLATION)
        return
    if not await service.can_read(job_id, user.id):
        await websocket.close(code=ws_status.WS_1008_POLICY_VIOLATION)
        return

    await websocket.accept()
    try:
        async for event in service.watch(job_id):
            await websocket.send_json(event.model_dump(mode="json"))
    except WebSocketDisconnect:
        logger.info("WS disconnected: job={id}", id=job_id)
    except Exception:
        logger.opt(exception=True).error("WS error")
        await websocket.close(code=ws_status.WS_1011_INTERNAL_ERROR)
    else:
        await websocket.close(code=ws_status.WS_1000_NORMAL_CLOSURE)
```

| Aspekt | Reguła |
|--------|--------|
| Auth | Token w `query_params` (SPA) lub cookie; weryfikuj PRZED `accept()` |
| Close code | `1000` normal, `1008` policy (auth fail), `1011` internal, `1013` try again (overload) |
| Heartbeat | Starlette/uvicorn wysyła ping frames co 20s domyślnie — aplikacyjny ping gdy potrzebny custom protocol |
| Message validation | Pydantic model `.model_validate_json(raw)` — odrzuć invalid |
| Reconnect | Klient: exponential backoff; serwer: idempotent replay od `last_seq_id` |
| Auth expiry | Token TTL 15min → zamknij WS gdy wygasł; klient reconnectuje |

### 14.4 UploadFile — duże pliki

```python
# ✅ Chunked read + MIME validation + magic bytes + size limit
import magic   # python-magic — libmagic binding
from fastapi import UploadFile, File

_CHUNK = 1024 * 1024   # 1 MB
_MAX_SIZE = 100 * 1024 * 1024   # 100 MB
_ALLOWED_MIME = {"image/jpeg", "image/png", "image/webp", "application/pdf"}
_ALLOWED_EXT = {".jpg", ".jpeg", ".png", ".webp", ".pdf"}


@router.post("/upload", response_model=UploadResponse)
async def upload(file: UploadFile = File(..., max_length=_MAX_SIZE)) -> UploadResponse:
    # 1. Extension whitelist (cheap first check)
    ext = Path(file.filename or "").suffix.lower()
    if ext not in _ALLOWED_EXT:
        raise AppError(ErrorCode.VALIDATION, f"Extension {ext!r} not allowed")

    # 2. Declared MIME — tylko wskazówka, klient kłamie
    if file.content_type not in _ALLOWED_MIME:
        raise AppError(ErrorCode.VALIDATION, f"Content-Type {file.content_type!r} not allowed")

    # 3. Magic bytes — real MIME z zawartości (anti-spoofing)
    head = await file.read(2048)
    real_mime = magic.from_buffer(head, mime=True)
    if real_mime not in _ALLOWED_MIME:
        raise AppError(ErrorCode.VALIDATION, f"Detected MIME {real_mime!r} not allowed")
    await file.seek(0)

    # 4. Chunked zapis + twardy limit (max_length można obejść)
    size = 0
    async with aiofiles.open(f"/var/uploads/{uuid.uuid4()}{ext}", "wb") as out:
        while chunk := await file.read(_CHUNK):
            size += len(chunk)
            if size > _MAX_SIZE:
                raise AppError(ErrorCode.VALIDATION, "File too large")
            await out.write(chunk)

    # 5. W produkcji: async scan ClamAV / VirusTotal / cloud equivalent
    return UploadResponse(filename=file.filename, size=size, mime=real_mime)
```

```python
# ❌ Cały plik do pamięci + trust content_type
content = await file.read()   # OOM przy 2GB
if file.content_type == "image/png":   # Klient wyśle co chce
    ...
```

| Warstwa | Po co |
|---------|-------|
| Extension whitelist | Tani pierwszy filtr |
| `content_type` check | Klient-declared — pomocniczy |
| Magic bytes (`libmagic`) | Real MIME z zawartości — obrona przed spoof |
| Size limit twardy | `max_length` na `File()` + counter runtime |
| Antivirus scan | Produkcja z user uploadami — ClamAV/VirusTotal |
| Render-isolated storage | NIE serwuj z tego samego domenu (XSS via SVG/HTML) |

---

## 15. Async, background tasks, connection pools

> Powiązane: [13-async-concurrency.md](13-async-concurrency.md).

### 15.1 `async def` vs `def` endpoint — decision

| Logika endpointa | `async def` | `def` | Fix |
|------------------|-------------|-------|-----|
| Pure CPU ≤10ms | — | ✅ | Trafi do threadpool (FastAPI auto) |
| DB query (async driver) | ✅ | ❌ | Async wszystko |
| DB query (sync driver) | ❌ (blokuje event loop!) | ✅ | Używaj async drivera albo `def` |
| HTTP call | ✅ (httpx) | ❌ | httpx.AsyncClient |
| File I/O | ✅ (aiofiles) | ❌ | aiofiles |
| ML inference | `await asyncio.to_thread(...)` | ✅ | Thread pool |

### 15.2 BackgroundTasks — lightweight

```python
# ✅ Post-response side effect: email, log, cleanup
from fastapi import BackgroundTasks


@router.post("/jobs")
async def create_job(payload: JobCreateRequest, tasks: BackgroundTasks, ...) -> JobResponse:
    job = await service.enqueue(payload.to_domain())
    tasks.add_task(audit_log, event="job.created", job_id=job.id)
    return JobResponse.from_domain(job)
```

**Kiedy BackgroundTasks NIE wystarczy:**
- Task > 5s (trzyma worker)
- Retry / dead letter queue wymagany
- Crash middle-flight musi się odzyskać

→ wtedy: external queue (Celery / ARQ / RQ / Dramatiq) z status endpointem `/jobs/{id}`.

### 15.3 Connection pools — reuse

```python
# ✅ httpx.AsyncClient przez lifespan
@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    app.state.http = httpx.AsyncClient(
        timeout=httpx.Timeout(30.0, connect=5.0),
        limits=httpx.Limits(max_connections=100, max_keepalive_connections=20),
    )
    yield
    await app.state.http.aclose()


def get_http(request: Request) -> httpx.AsyncClient:
    return request.app.state.http


HttpClient = Annotated[httpx.AsyncClient, Depends(get_http)]
```

| Scenariusz | `max_connections` | `max_keepalive_connections` | `timeout` |
|-----------|-------------------|------------------------------|-----------|
| Dev / 1 worker | 20 | 10 | 30s |
| Prod API (I/O bound) | 100 | 20 | 10s + 5s connect |
| High-throughput gateway | 500 | 100 | 5s + 2s connect |
| Webhook fanout | 200 | 50 | 15s (remote services słabe) |

> Reguła: `max_connections` ≈ `workers × avg_concurrent_outbound`. Za mało = kolejkowanie; za dużo = FD exhaustion.

```python
# ❌ Per-request nowy klient = no keepalive, 5x wolniej
@router.get("/proxy")
async def proxy() -> Response:
    async with httpx.AsyncClient() as client:   # Tworzy + zamyka za każdym razem
        r = await client.get(...)
```

### 15.4 Job tracking pattern (async work + polling)

```
POST /jobs        -> 202 Accepted, {job_id}
GET /jobs/{id}    -> {status, progress, result_url?}
GET /jobs/{id}/events (SSE)   -> live updates
```

| Element | Rola |
|---------|------|
| 202 na POST | Przyjęte, nie zakończone |
| `Location` header | URL statusu |
| Status w DB | `queued|running|done|failed|cancelled` |
| `progress` 0-100 | Opcjonalnie |
| `result_url` | Gdy `done` — gdzie pobrać wynik |

---

## 16. Testing API

> Powiązane: [12-testing.md](12-testing.md).

### 16.1 TestClient vs httpx.AsyncClient

| Kryterium | `TestClient` (starlette) | `httpx.AsyncClient` + ASGI transport |
|-----------|-------------------------|--------------------------------------|
| Sync vs async | Sync | Async |
| Lifespan | Automatic via ctx manager | Manual `LifespanManager` |
| Speed | Szybki | Szybki |
| Realizm | Wywołuje ASGI bezpośrednio | Wywołuje ASGI bezpośrednio |

```python
# ✅ Async test
from httpx import ASGITransport, AsyncClient


@pytest.fixture
async def client(app: FastAPI) -> AsyncIterator[AsyncClient]:
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as c:
        yield c


@pytest.mark.asyncio
async def test_create_job(client: AsyncClient) -> None:
    r = await client.post("/api/v1/jobs", json={"title": "demo", "priority": 5})
    assert r.status_code == 202
    assert r.json()["status"] == "queued"
```

### 16.2 Dependency overrides

```python
@pytest.fixture
def app(test_settings: ApiSettings, fake_job_service: JobService) -> Iterator[FastAPI]:
    app = create_app(settings=test_settings)
    app.dependency_overrides[get_job_service] = lambda: fake_job_service
    yield app
    app.dependency_overrides.clear()
```

### 16.3 Contract / snapshot testing

```python
# ✅ OpenAPI schema nie zmienia się bez świadomości
import json
from pathlib import Path


SNAPSHOT = Path("tests/snapshots/openapi.json")


def test_openapi_schema_snapshot(app: FastAPI) -> None:
    schema = app.openapi()
    if not SNAPSHOT.exists():
        SNAPSHOT.write_text(json.dumps(schema, indent=2, sort_keys=True))
        pytest.skip("Snapshot created; re-run")
    assert schema == json.loads(SNAPSHOT.read_text())
```

### 16.4 Testowanie SSE / WebSocket

```python
# ✅ SSE — klient iteracyjnie czyta
async def test_job_events(client: AsyncClient) -> None:
    async with client.stream("GET", f"/api/v1/jobs/{job_id}/events") as r:
        assert r.status_code == 200
        events = []
        async for line in r.aiter_lines():
            if line.startswith("data:"):
                events.append(json.loads(line.removeprefix("data: ")))
                if len(events) >= 3:
                    break
        assert events[0]["kind"] == "started"
```

---

## 17. Antypatterny

| # | Antypattern ❌ | Fix ✅ | Dlaczego |
|---|---------------|-------|----------|
| 1 | Global `db = SessionLocal()` | `Depends(get_db_session)` | Nie per-request, brak izolacji testów |
| 2 | `return {"id": x}` (bare dict) | `response_model=Schema` | Brak typów, leak internal fields |
| 3 | Biznes logika w routerze | Deleguj do `service` | Nietestowalne |
| 4 | `except Exception:` w endpoincie | Specific + exception handler | Łapie `CancelledError`, `KeyboardInterrupt` |
| 5 | `time.sleep(...)` w `async def` | `await asyncio.sleep(...)` | Blokuje event loop |
| 6 | Ręczna walidacja `if "x" not in body` | Pydantic `BaseModel` | Trzy razy ta sama walidacja |
| 7 | `HTTPException(500, str(exc))` | `raise AppError(...)` + handler | Leak internals, brak struktury |
| 8 | Read cały `UploadFile` do RAM | Chunked `while chunk := await f.read(1MB)` | OOM na dużych plikach |
| 9 | `allow_origins=["*"]` + `credentials=True` | Explicit whitelist | Blocked przez browsery; security |
| 10 | JWT w localStorage | HttpOnly cookie + CSRF | XSS = kradzież tokenu |
| 11 | Brak correlation ID | Middleware z `X-Request-ID` | Nie da się skorelować logów |
| 12 | Singleton `httpx.Client()` tworzony ad-hoc | `app.state.http` w lifespan | Brak keepalive, slow |
| 13 | `response_model_exclude_unset` globalnie | Per-endpoint wybór | Ukrywa pola = bug |
| 14 | `async def` z `requests.get(...)` | `httpx.AsyncClient` | Blokuje event loop |
| 15 | Hardcoded `/api/v1` w testach | `reverse` helper / router name | Breakage przy versioningu |
| 16 | Tokeny HS256 między mikrousługami | RS256 + public key | Secret sharing = risk |
| 17 | 200 OK na błąd (payload.success=false) | Właściwy status + ErrorResponse | Niezgodne z HTTP semantics |
| 18 | Brak `/health/ready` | Split liveness vs readiness | K8s nie wyjmie z LB |
| 19 | Rate limit in-memory w multi-worker | Redis-backed | Limit nieefektywny |
| 20 | `@app.on_event(...)` | `lifespan` context manager | Deprecated od 0.93 |
| 21 | WebSocket bez auth przed `accept()` | Weryfikuj token → close 1008 jeśli fail | Open socket = koszt resources |
| 22 | SSE bez `id:` + brak obsługi `Last-Event-ID` | `id: N` per event + backfill | Utracone eventy przy reconnect |
| 23 | SSE bez heartbeat | `: keepalive\n\n` co 15s | Proxy zamknie idle connection |
| 24 | Upload: trust `content_type` | Magic bytes (`libmagic`) | Klient wysyła co chce — XSS via SVG |
| 25 | JWT `algorithms=None` / brak parametru | `algorithms=["RS256"]` whitelist | Atak `alg: none` |
| 26 | Brak `iss`/`aud` w JWT | Waliduj `issuer=`, `audience=` | Token reuse cross-service |
| 27 | Long-lived access token (godziny) | ≤15 min + refresh | Kompromitacja = długie okno |
| 28 | Cookie auth bez CSRF protection | `SameSite=Strict` + double-submit token | CSRF attack |
| 29 | Rate limit per-IP za NAT/proxy | Per-user gdy auth, IP tylko fallback | Bypass via shared IP |
| 30 | OFFSET pagination dla 100k+ rows | Keyset/cursor | O(N) scan per request |

---

## 18. Egzekucja ruff

### 18.1 Ruleset dla API

```toml
# pyproject.toml (fragment)
[tool.ruff.lint]
extend-select = [
    "ASYNC",  # misuse asyncio / sync w async
    "FAST",   # FastAPI-specific rules
    "S",      # bandit: eval(), hardcoded secrets, weak crypto
    "N818",   # Exception class suffix "Error"
    "B",      # bugbear: mutable defaults, etc.
    "TRY",    # tryceratops: raise from, log or raise
    "G",      # logging format
    "UP",     # pyupgrade
    "PT",     # pytest idioms
]

[tool.ruff.lint.per-file-ignores]
# FAST002 zalecamy w nowym kodzie (Annotated[X, Depends(...)]), ale w legacy routerach
# można zostawić stary składnik = Depends() — wtedy silencuj per-folder:
# "legacy/routers/*.py" = ["FAST002"]
"**/tests/**" = ["S101", "S105", "S106"]  # assert, hardcoded creds OK w testach
```

### 18.2 Kluczowe reguły

| Ruff | Co łapie | Fix |
|------|----------|-----|
| `ASYNC100` | `open()`, `time.sleep` w async | `aiofiles`, `asyncio.sleep` |
| `ASYNC210` | Blocking HTTP call (`requests.get`) | `httpx.AsyncClient` |
| `FAST001` | Redundant `response_model` = return type | Użyj jednego źródła prawdy |
| `FAST002` | Old `x: X = Depends(...)` | `x: Annotated[X, Depends(...)]` |
| `S101` | `assert` w produkcji | `raise AppError(...)` |
| `S105/106/107` | Hardcoded password / secret | `SecretStr` + env var |
| `B008` | Mutable default w arg | `= Field(default_factory=list)` |
| `B904` | `raise` bez `from` w except | `raise X(...) from exc` |
| `TRY003` | Long string w `raise ValueError(...)` | Custom exception class |
| `TRY400` | `logger.error` zamiast `logger.exception` | `logger.opt(exception=exc).error(...)` |
| `PT011` | `pytest.raises(X)` bez `match` | `match=r"..."` |
| `N818` | Exception class bez sufiksu `Error` | `class JobNotFoundError(AppError):` |

---

## Źródła

> - [FastAPI docs](https://fastapi.tiangolo.com/) — lifespan, Depends, routers, middleware
> - [Pydantic v2](https://docs.pydantic.dev/latest/) — ConfigDict, validators, discriminated unions
> - [Starlette](https://www.starlette.io/) — middleware, Request/Response, StreamingResponse, WebSocket
> - [RFC 7807 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc7807) — standardowy format błędów
> - [RFC 8594 — Sunset header](https://www.rfc-editor.org/rfc/rfc8594) — deprecation
> - [RFC 9745 — Deprecation header](https://www.rfc-editor.org/rfc/rfc9745)
> - [RFC 6749 — OAuth 2.0](https://www.rfc-editor.org/rfc/rfc6749); [RFC 7519 — JWT](https://www.rfc-editor.org/rfc/rfc7519)
> - [OWASP API Security Top 10](https://owasp.org/API-Security/) — reguły bezpieczeństwa
> - [OpenTelemetry Python](https://opentelemetry.io/docs/languages/python/) — tracing & metrics
> - [slowapi](https://github.com/laurentS/slowapi), [prometheus_client](https://github.com/prometheus/client_python)
> - Powiązane sekcje repo: [06](06-function-api-design.md) (signatures), [08](08-error-handling.md) (AppError), [10](10-config-data.md) (settings), [11](11-logging.md) (loguru), [12](12-testing.md) (pytest), [13](13-async-concurrency.md) (asyncio)
