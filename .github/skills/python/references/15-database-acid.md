# 15 — Database & ACID (SQLite + SQLAlchemy 2.0)

> **Powiązane:** [08-error-handling.md](08-error-handling.md) (AppError, retry), [09-class-design.md](09-class-design.md) (Repository/UoW), [10-config-data.md](10-config-data.md) (SecretStr), [11-logging.md](11-logging.md) (loguru), [12-testing.md](12-testing.md) (pytest async), [13-async-concurrency.md](13-async-concurrency.md) (asyncio), [14-api-design.md](14-api-design.md) (DI endpoint).
>
> **Cel:** Kompletne reguły trwałego store'u — ACID w praktyce, SQLite tuning, SQLAlchemy 2.0, async, schema design, Alembic, Repository/UoW, transakcje, performance, testing, security.
> **Scope:** Python ≥3.10, SQLAlchemy ≥2.0, aiosqlite, Alembic ≥1.13, Pydantic ≥2.6. Skupienie na SQLite (embedded / desktop / małe serwisy) z uwagami Postgres-ready.
> **NIE duplikuje:** error hierarchy (→08), config/secrets (→10 `SecretStr`), async basics (→13), pattern Repository/UoW struktura (→09), testing infra (→12), loguru (→11).
> **Zasada nadrzędna:** Transakcja to kontrakt biznesowy. Commit = prawda. ORM to narzędzie, nie magia — znaj co emituje.

---

## Spis treści

1. [ACID w praktyce](#1-acid-w-praktyce)
2. [SQLite vs inne bazy — kiedy co](#2-sqlite-vs-inne-bazy--kiedy-co)
3. [SQLite tuning (PRAGMAs)](#3-sqlite-tuning-pragmas)
4. [SQLAlchemy 2.0 — podstawy](#4-sqlalchemy-20--podstawy)
5. [Async SQLAlchemy](#5-async-sqlalchemy)
6. [Schema design](#6-schema-design)
7. [Relationships i loading strategies](#7-relationships-i-loading-strategies)
8. [Transakcje](#8-transakcje)
9. [Alembic migrations](#9-alembic-migrations)
10. [Repository + Unit of Work](#10-repository--unit-of-work)
11. [Performance](#11-performance)
12. [Security](#12-security)
13. [Testing bazodanowy](#13-testing-bazodanowy)
14. [Observability](#14-observability)
15. [Backup, restore, migracja do Postgres](#15-backup-restore-migracja-do-postgres)
16. [Antypatterny](#16-antypatterny)
17. [Egzekucja ruff](#17-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła | Wartość |
|---|--------|---------|
| 1 | **SQLite PRAGMAs obowiązkowe** | `journal_mode=WAL`, `foreign_keys=ON`, `synchronous=NORMAL`, `busy_timeout=5000` |
| 2 | **`foreign_keys` OFF by default** | MUSISZ jawnie włączyć per-connection |
| 3 | **SQLAlchemy 2.0 = `Mapped[T]`** | Nigdy `Column(...)` bez `Mapped[T]` |
| 4 | **Async = `async_sessionmaker`** | `expire_on_commit=False` |
| 5 | **Transakcja = `async with session.begin()`** | Automatyczny commit/rollback |
| 6 | **Alembic + SQLite** | `render_as_batch=True` (ALTER TABLE nieobsługiwany) |
| 7 | **N+1 = nieakceptowalne** | `selectinload` / `joinedload` z MIARĄ |
| 8 | **Repository = Protocol** | Testowalne, swap-able |
| 9 | **Testy = in-memory SQLite lub temp file** | `sqlite:///:memory:` per-test |
| 10 | **Secrets NIGDY w URL** | `SecretStr` + `URL.create(...)` |
| 11 | **Soft delete = `deleted_at TIMESTAMP NULL`** | Nigdy `DELETE` dla audytowalnych |
| 12 | **Timestamps = UTC** | `DateTime(timezone=True)` + `func.now()` |
| 13 | **PK = UUID7 albo BIGINT** | Nie leakuj liczników |
| 14 | **`EXPLAIN QUERY PLAN`** | Na każdym nowym query przed merge |
| 15 | **Ruff:** `SQL*`, `S608`, `B` — zawsze |
| 16 | **Locking** | Optimistic (`version_id_col`) default; pessimistic (`FOR UPDATE`) dla hot-rows (transfery, countery) |
| 17 | **Retry na `OperationalError`** | `SQLITE_BUSY` / serialization failure = expected; backoff exponential 0.05–1s |
| 18 | **SAVEPOINT** | `async with session.begin_nested()` — rollback inner bez outer |
| 19 | **Bulk = `insert(stmt), [rows]`** | Nigdy `for row: session.add()` + commit w pętli (100× wolniej) |
| 20 | **Backup SQLite** | `sqlite3.backup()` API (online, nie blokuje writes) + Litestream do S3 |

---

## 1. ACID w praktyce

### 1.1 Co znaczą litery

| Litera | Co gwarantuje | Naruszenie wygląda tak |
|--------|---------------|------------------------|
| **A**tomicity | Transakcja = all-or-nothing | Połowa updatów zapisana po crashu |
| **C**onsistency | Po commicie wszystkie constraints spełnione | FK wskazuje na nieistniejący wiersz |
| **I**solation | Concurrent transakcje nie widzą swoich brudów | Read uncommitted → duplicates |
| **D**urability | Po commicie dane przeżyją restart | Commit ok, ale po power off utrata |

### 1.2 Atomicity — dwie operacje, jedna prawda

```python
# ✅ Atomowo: kasa + rezerwacja albo nic
async with session.begin():
    await session.execute(update(Account).where(Account.id == buyer_id).values(balance=Account.balance - price))
    session.add(Order(buyer_id=buyer_id, item_id=item_id, price=price))
    # commit albo rollback całości
```

```python
# ❌ Dwa commity = split state po crashu
await session.execute(update(Account)...)
await session.commit()   # ← crash tutaj = zapłacił, zamówienia brak
session.add(Order(...))
await session.commit()
```

### 1.3 Isolation levels — decision table

| Level | Anomalie dozwolone | SQLite | Postgres | Kiedy |
|-------|--------------------|--------|----------|-------|
| Read Uncommitted | Dirty reads | ❌ (niedostępny) | ❌ (traktowany jak RC) | Nigdy — żaden mainstream DB tego nie oferuje |
| Read Committed | Non-repeatable reads, phantoms | ❌ (WAL daje Snapshot) | ✅ **default** | Większość workloadów w PG |
| Repeatable Read | Phantoms (PG: no, blokuje) | ❌ | opcjonalnie | Analityka w trakcie edytów |
| **Serializable (snapshot)** | — | ✅ **default** (WAL mode) | opcjonalnie (`SERIALIZABLE`) | Finanse, critical invariants |

> SQLite w WAL = **Serializable snapshot isolation**: writer ↔ readers nie blokują się, pisarz jest 1 per moment. Nie można switchować isolation per-connection jak w PG — SQLite ma jeden globalny poziom.

### 1.4 Durability — fsync, WAL, checkpoint

| Mode | `synchronous` | Durability | Speed |
|------|---------------|------------|-------|
| `OFF` | 0 | Brak — crash = loss | Najszybciej |
| `NORMAL` | 1 | Po checkpoint | **Rekomendowane w WAL** |
| `FULL` | 2 | Każdy commit fsynced | Bezpieczne ale wolne |
| `EXTRA` | 3 | + fsync directory | Paranoja |

---

## 2. SQLite vs inne bazy — kiedy co

| Kryterium | **SQLite** | **Postgres** | **MySQL** |
|-----------|-----------|--------------|-----------|
| Deploy | Jeden plik | Serwer + pool | Serwer + pool |
| Concurrent writers | 1 (WAL: wiele readers) | Wiele | Wiele |
| Rozmiar max | ~281 TB teoretycznie, realnie <1 TB | Petabytes | Petabytes |
| Typy | Dynamic typing | Strict, rich (JSONB, arrays, GIS) | Strict |
| Replikacja | Litestream / LiteFS | Native streaming/logical | Native |
| Skalowanie | Pionowe | Pionowe + horizontal sharding | Pionowe |
| **Kiedy używać** | Desktop, CLI, embedded, <100 concurrent writes/s, tests | Backend serwer, wielu writers, złożone zapytania | Ekosystem LAMP |

### 2.1 Triggery migracji z SQLite → Postgres

| Sygnał | Kroki |
|--------|-------|
| >100 writes/s trwale | Plan migracji |
| Wiele procesów piszących | Migracja (nawet WAL lockuje pisarzy) |
| Potrzeba `JSONB` z indexem | Postgres |
| Full-text search >GB | Postgres `tsvector` |
| Horizontal scaling | Postgres + Citus / CockroachDB |

---

## 3. SQLite tuning (PRAGMAs)

### 3.1 Obowiązkowe PRAGMAs

```python
# ✅ Ustaw na każdym connection — foreign_keys nie persist!
from sqlalchemy import event
from sqlalchemy.engine import Engine


@event.listens_for(Engine, "connect")
def _sqlite_pragmas(dbapi_connection, connection_record) -> None:
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA journal_mode=WAL")
    cursor.execute("PRAGMA synchronous=NORMAL")
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.execute("PRAGMA busy_timeout=5000")        # Czekaj 5s zamiast od razu "database is locked"
    cursor.execute("PRAGMA temp_store=MEMORY")
    cursor.execute("PRAGMA cache_size=-64000")         # 64 MB cache (ujemne = KB)
    cursor.execute("PRAGMA mmap_size=268435456")       # 256 MB mmap
    cursor.close()
```

### 3.2 PRAGMA — tabela decyzyjna

| PRAGMA | Default | Rekomendacja | Po co |
|--------|---------|--------------|-------|
| `journal_mode` | DELETE | **WAL** | Readers ≠ writers nie blokują się |
| `synchronous` | FULL | **NORMAL** (przy WAL) | Szybciej, ciągle bezpieczne |
| `foreign_keys` | **OFF** ⚠️ | **ON** (zawsze) | FK ignorowane po cichu jak OFF |
| `busy_timeout` | 0 | **5000** (5s) | Retry na lock zamiast crash |
| `temp_store` | DEFAULT | **MEMORY** | Sort/temp tables w RAM |
| `cache_size` | -2000 (2MB) | **-64000** (64MB) | Mniej I/O |
| `mmap_size` | 0 | **268435456** (256MB) | Read-heavy workloads |
| `auto_vacuum` | NONE | **INCREMENTAL** (setup-time) | Reclaim space bez full vacuum |
| `wal_autocheckpoint` | 1000 | Default OK | Co 1000 stron flush do main db |

### 3.3 Per-connection vs one-time

| PRAGMA | Persist? | Ustawiaj |
|--------|----------|----------|
| `journal_mode=WAL` | ✅ Tak (w pliku) | Raz (setup) |
| `foreign_keys=ON` | ❌ Nie | Na każdym connection (event listener) |
| `busy_timeout` | ❌ Nie | Na każdym connection |
| `synchronous=NORMAL` | ❌ Nie | Na każdym connection |
| `auto_vacuum=INCREMENTAL` | ✅ Tak | Raz (setup) — musi być przed `CREATE TABLE` |

---

## 4. SQLAlchemy 2.0 — podstawy

### 4.1 Engine + Session

```python
# ✅ Jeden engine per proces
from sqlalchemy import create_engine, URL
from sqlalchemy.orm import sessionmaker


url = URL.create(
    "sqlite",
    database="app.db",
    query={"check_same_thread": "false"},
)
engine = create_engine(
    url,
    echo=False,
    future=True,   # default w 2.0, ale jawnie
    pool_pre_ping=True,
    pool_recycle=3600,   # Odśwież połączenie co godzinę
    connect_args={"timeout": 30},
)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,   # KRYTYCZNE — inaczej po commicie atrybuty są "stale"
)
```

### 4.2 Declarative z `Mapped[T]` (2.0 style)

```python
# ✅ Type-safe ORM (mypy-friendly)
from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4

from sqlalchemy import String, DateTime, ForeignKey, Index, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship


class Base(DeclarativeBase):
    """Wspólna baza — tu idą `type_annotation_map`, metadata, etc."""


class User(Base):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    display_name: Mapped[str] = mapped_column(String(100))
    is_active: Mapped[bool] = mapped_column(default=True, server_default="1")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now(),
    )

    jobs: Mapped[list["Job"]] = relationship(back_populates="owner", cascade="all, delete-orphan")


class Job(Base):
    __tablename__ = "jobs"
    __table_args__ = (
        Index("ix_jobs_owner_status", "owner_id", "status"),
    )

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    owner_id: Mapped[UUID] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"))
    title: Mapped[str] = mapped_column(String(200))
    status: Mapped[str] = mapped_column(String(20), default="queued")
    result: Mapped[Optional[dict]] = mapped_column(JSON, nullable=True)

    owner: Mapped[User] = relationship(back_populates="jobs")
```

### 4.3 Query style — `select()` > legacy

```python
# ✅ 2.0 — select(...), scalars(), unique(), all()
from sqlalchemy import select


async def list_active_users(session: AsyncSession, limit: int = 100) -> list[User]:
    stmt = (
        select(User)
        .where(User.is_active.is_(True))
        .order_by(User.created_at.desc())
        .limit(limit)
    )
    result = await session.execute(stmt)
    return list(result.scalars().all())
```

```python
# ❌ Legacy 1.x — `session.query(...)` deprecated
users = session.query(User).filter(User.is_active == True).all()
```

### 4.4 Typowa mapa typów

```python
# ✅ type_annotation_map — raz skonfiguruj, globalnie
class Base(DeclarativeBase):
    type_annotation_map = {
        dict: JSON,
        list: JSON,
        datetime: DateTime(timezone=True),
        UUID: Uuid(native_uuid=False),     # Dla SQLite: CHAR(32) z hex
    }
```

---

## 5. Async SQLAlchemy

### 5.1 Async engine + session

```python
# ✅ aiosqlite driver
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine


async_engine = create_async_engine(
    "sqlite+aiosqlite:///app.db",
    echo=False,
    pool_pre_ping=True,
    connect_args={"timeout": 30},
)

AsyncSessionLocal = async_sessionmaker(
    bind=async_engine,
    class_=AsyncSession,
    expire_on_commit=False,   # MUSI być False w async (inaczej lazy load po commit crashuje)
)


async def get_session() -> AsyncIterator[AsyncSession]:
    async with AsyncSessionLocal() as session:
        yield session
```

### 5.2 Reguły async

| Reguła | Dlaczego |
|--------|----------|
| `expire_on_commit=False` | Async nie ma "implicit IO" — lazy load po commit = crash |
| Żadnych lazy relationships (domyślnie) | Używaj `selectinload` / `joinedload` explicit |
| Jedna sesja = jeden task | Nie współdziel sesji między `asyncio.gather` |
| `async with session.begin()` | Automatyczny commit/rollback |
| Session jako dependency | Per-request, nie global |

### 5.3 Concurrent queries — `asyncio.gather`

```python
# ❌ Shared session — RACE CONDITION
async def bad(session: AsyncSession, user_id: UUID) -> tuple[int, int]:
    return await asyncio.gather(
        session.scalar(select(func.count()).select_from(Job).where(Job.owner_id == user_id)),
        session.scalar(select(func.count()).select_from(Payment).where(Payment.user_id == user_id)),
    )
# → "InvalidRequestError: This session is already running a transaction"
```

```python
# ✅ Sesja per-task
async def good(user_id: UUID) -> tuple[int, int]:
    async def _jobs() -> int:
        async with AsyncSessionLocal() as s:
            return await s.scalar(select(func.count()).select_from(Job).where(Job.owner_id == user_id))

    async def _payments() -> int:
        async with AsyncSessionLocal() as s:
            return await s.scalar(select(func.count()).select_from(Payment).where(Payment.user_id == user_id))

    return await asyncio.gather(_jobs(), _payments())
```

---

## 6. Schema design

### 6.1 Primary key — wybór

| Typ PK | Plusy | Minusy | Kiedy |
|--------|-------|--------|-------|
| `BIGINT AUTOINCREMENT` | Mały, szybki, sequential | Leak counter info | Internal tables |
| `UUID4` (random) | Unguessable, distributed | 16B, index bloat, non-sequential I/O | Public APIs |
| **`UUID7`** (RFC 9562) | Unguessable + time-ordered | Wymaga generatora | **Rekomendowane** |
| `ULID` | String-sortowalny | 26 znaków | Gdy czytelne ID ważne |
| `CHAR(N)` slug | Czytelne | Kolizje możliwe | Jawne `/posts/{slug}` |

```python
# ✅ UUID7 — time-ordered, insert-friendly (brak index bloat jak UUID4)
from uuid6 import uuid7   # `uv add uuid6`


class Job(Base):
    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid7)
```

| Biblioteka | API | Uwagi |
|------------|-----|-------|
| `uuid6` | `uuid7()` | Prosty dropin, RFC 9562 compatible |
| `python-ulid` | `ULID()` / `.to_uuid()` | String-sortowalny, 26 znaków |
| `uuid` (stdlib) | `uuid4()` | Random, index bloat przy milionach insertów |

### 6.2 Timestamps (audit columns)

```python
# ✅ Mixin dla audit columns — DRY
from sqlalchemy.orm import declared_attr


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False,
    )


class SoftDeleteMixin:
    deleted_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True), nullable=True, index=True,
    )


class AuditedBase(Base, TimestampMixin, SoftDeleteMixin):
    __abstract__ = True
```

### 6.3 Foreign keys — cascades

```python
# ✅ Jawne cascade
class Job(AuditedBase):
    __tablename__ = "jobs"

    owner_id: Mapped[UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE", onupdate="RESTRICT"),
    )
```

| `ondelete` | Co robi |
|-----------|---------|
| `NO ACTION` (default) | Reject jeśli child istnieje |
| `CASCADE` | Usuń child (delete audytu!) |
| `SET NULL` | Wyzeruj FK |
| `SET DEFAULT` | Ustaw na default |
| `RESTRICT` | Reject natychmiast (immediate) |

### 6.4 Indeksy — kiedy co

| Wzorzec zapytania | Index |
|-------------------|-------|
| `WHERE email = ?` | `Index("ix_users_email", "email", unique=True)` |
| `WHERE owner_id = ? AND status = ?` | Composite `("owner_id", "status")` |
| `WHERE deleted_at IS NULL` | Partial (Postgres) / composite z flagą |
| `ORDER BY created_at DESC LIMIT 10` | Na `created_at DESC` |
| `WHERE lower(email) = ?` | Expression index `func.lower(User.email)` |

```python
# ✅ Expression index — index na funkcji, nie na kolumnie
from sqlalchemy import Index, func


class User(Base):
    __tablename__ = "users"
    __table_args__ = (
        Index("ix_users_email_lower", func.lower("email"), unique=True),
    )

    email: Mapped[str] = mapped_column(String(255))
```

> SQLite obsługuje expression indexes od 3.9 (2015). Postgres od zawsze. Query `WHERE lower(email) = ?` użyje tego indeksu.

### 6.5 Constraints jako contract

```python
# ✅ Check constraints + unique + FK wymuszają invariants
from sqlalchemy import CheckConstraint, UniqueConstraint


class Account(Base):
    __tablename__ = "accounts"
    __table_args__ = (
        CheckConstraint("balance >= 0", name="ck_account_non_negative"),
        UniqueConstraint("user_id", "currency", name="uq_account_user_currency"),
    )

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    user_id: Mapped[UUID] = mapped_column(ForeignKey("users.id"))
    currency: Mapped[str] = mapped_column(String(3))
    balance: Mapped[Decimal] = mapped_column(Numeric(precision=18, scale=2), default=0)
```

### 6.6 Optimistic locking (wersjonowanie)

```python
# ✅ `version_id` kolumna + mapper config
class Job(Base):
    __mapper_args__ = {"version_id_col": "version"}

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    version: Mapped[int] = mapped_column(default=1, nullable=False)
    status: Mapped[str] = mapped_column(String(20))
```

→ concurrent update podniesie `StaleDataError` zamiast cichego nadpisania.

### 6.7 JSON — kiedy (nie)używać

| ✅ Używaj JSON dla | ❌ NIE używaj JSON dla |
|--------------------|-------------------------|
| Opcjonalnych metadata z rzadkim odczytem | Pól do filtrowania / sortowania |
| Heterogenicznych struktur (np. audit logs) | Liczb do agregacji |
| Payloadów 3rd party API | Relacji do innych tabel |
| Config per-resource | Krytycznych dla indeksów |

---

## 7. Relationships i loading strategies

### 7.1 Loading strategies — decision

| Strategia | SQL | Kiedy |
|-----------|-----|-------|
| **`selectinload`** | 2 queries: parent + `WHERE id IN (...)` | Kolekcje, default dla 1→N |
| **`joinedload`** | 1 query z JOIN | Pojedyncze FK (N→1) |
| `subqueryload` | 2 queries, parent jako subquery | Legacy, prefer selectinload |
| `lazy` (default) | N+1 ⚠️ | Never w async |
| `raise` | Raise jeśli lazy-load | Development — łapie N+1 |
| `noload` | Zwraca `[]` bez query | Optymalizacja gdy child niepotrzebny |

### 7.2 Przykład — uniknąć N+1

```python
# ❌ N+1 — 1 query dla users, potem 1 query per user dla jobs
stmt = select(User).limit(100)
users = (await session.scalars(stmt)).all()
for user in users:
    print(len(user.jobs))   # ← każdy dostęp = SELECT
```

```python
# ✅ 2 queries total
from sqlalchemy.orm import selectinload


stmt = select(User).options(selectinload(User.jobs)).limit(100)
users = (await session.scalars(stmt)).all()
```

### 7.3 `raise`-on-lazy w dev

```python
# ✅ Łap N+1 w testach
class User(Base):
    jobs: Mapped[list[Job]] = relationship(lazy="raise_on_sql", back_populates="owner")
# → dostęp bez `options(selectinload(...))` podniesie InvalidRequestError
```

---

## 8. Transakcje

### 8.1 Scoping — `async with`

```python
# ✅ Automatyczny commit/rollback + pessimistic lock via select().with_for_update()
async def transfer(session: AsyncSession, src_id: UUID, dst_id: UUID, amount: Decimal) -> None:
    async with session.begin():
        # SELECT ... FOR UPDATE — lock row do końca transakcji
        # SQLite: ignoruje FOR UPDATE (brak wsparcia), ale WAL serializuje writes per-transaction
        # Postgres: hard lock na wierszu
        src = await session.scalar(select(Account).where(Account.id == src_id).with_for_update())
        dst = await session.scalar(select(Account).where(Account.id == dst_id).with_for_update())
        if src is None or dst is None:
            raise NotFoundError("account not found")
        if src.balance < amount:
            raise InsufficientFundsError(src_id=src_id, requested=amount)
        src.balance -= amount
        dst.balance += amount
        # commit auto na wyjściu; rollback auto przy exception
```

| Pessimistic vs Optimistic | Kiedy |
|---------------------------|-------|
| **Pessimistic (`FOR UPDATE`)** | Hot rows (transfery, countery), krotki lock, unikasz stale-data errors |
| **Optimistic (`version_id_col`)** | Cold updates, rzadkie kolizje, mniejsze koszty (brak locka) |
| **`FOR UPDATE SKIP LOCKED`** | Worker queues (Postgres) — kazdy worker bierze wolny job |

### 8.2 Zagnieżdżone transakcje — SAVEPOINT

```python
# ✅ Pseudo-nested przez SAVEPOINT
async with session.begin():          # Outer
    session.add(user)
    try:
        async with session.begin_nested():   # SAVEPOINT sp_1
            session.add(Job(owner=user, title="demo"))
            await session.flush()
            raise ValueError("rollback just inner")
    except ValueError:
        pass   # Outer OK, inner rollback
    # user zostaje zapisany
```

### 8.3 Isolation override

```python
# ✅ Per-connection isolation level
from sqlalchemy.ext.asyncio import AsyncConnection


async with async_engine.connect() as conn:
    await conn.execution_options(isolation_level="SERIALIZABLE")
    async with AsyncSession(bind=conn, expire_on_commit=False) as session:
        async with session.begin():
            ...
```

### 8.4 Deadlock handling (retry)

> Powiązane: [08-error-handling.md](08-error-handling.md) §6 — retry policy.

```python
# ✅ Retry na SQLITE_BUSY / serialization failures
from sqlalchemy.exc import OperationalError

from myapp.retry import retry_async


@retry_async(max_attempts=3, backoff=Backoff.exponential(0.05, 1.0), retry_on=(OperationalError,))
async def checkout(session: AsyncSession, user_id: UUID, cart: Cart) -> Order:
    async with session.begin():
        ...
```

---

## 9. Alembic migrations

### 9.1 Setup

```bash
uv add --group dev alembic
alembic init --template async alembic_db
```

### 9.2 `env.py` — SQLite-aware

```python
# alembic_db/env.py (fragment)
from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool

from myapp.db.models import Base
from myapp.settings import get_settings


config = context.config
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def _is_sqlite(url: str) -> bool:
    return url.startswith("sqlite")


def run_migrations_online() -> None:
    settings = get_settings()
    config.set_main_option("sqlalchemy.url", settings.database_url.get_secret_value())
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
            render_as_batch=_is_sqlite(str(connection.engine.url)),   # KRYTYCZNE dla SQLite
        )
        with context.begin_transaction():
            context.run_migrations()
```

> ⚠️ **SQLite nie obsługuje `ALTER TABLE DROP COLUMN` ani `ALTER COLUMN`.** `render_as_batch=True` każe Alembicowi emulować batch mode: `CREATE tmp + COPY + DROP + RENAME`. Bez tego każda zmiana kolumny = FAIL.

### 9.3 Workflow

```bash
# 1. Zmień model w myapp/db/models.py
# 2. Wygeneruj migrację
alembic revision --autogenerate -m "add soft delete to jobs"
# 3. PRZECZYTAJ migrację (autogenerate jest głupie — patrz 9.4)
# 4. Apply
alembic upgrade head
# 5. Rollback w razie czego
alembic downgrade -1
```

### 9.4 Limity autogenerate — co przegapia

| Problem | Fix |
|---------|-----|
| **Rename column** (zgaduje: DROP + ADD = utrata danych) | Ręczny `op.alter_column(..., new_column_name="...")` |
| **Rename table** | `op.rename_table(...)` |
| Check constraints zmiana | Manualnie |
| Default value zmiana (server_default) | `compare_server_default=True` + review |
| Custom types (np. Pydantic JSON) | Manualnie |
| Indeksy funkcyjne | Manualnie |
| Data migrations | ZAWSZE manualnie (op.execute) |

### 9.5 Data migration — wzorzec

```python
# ✅ alembic_db/versions/20260418_xxxx_migrate_status_values.py
from alembic import op
import sqlalchemy as sa


revision = "20260418_xxxx"
down_revision = "20260401_aaaa"


def upgrade() -> None:
    # 1. Schema change
    op.add_column("jobs", sa.Column("status_v2", sa.String(20), nullable=True))

    # 2. Data migration (jawnie)
    jobs = sa.table("jobs", sa.column("status", sa.String), sa.column("status_v2", sa.String))
    op.execute(
        jobs.update().where(jobs.c.status == "done").values(status_v2="completed")
    )
    op.execute(
        jobs.update().where(jobs.c.status == "error").values(status_v2="failed")
    )

    # 3. Make NOT NULL after backfill
    with op.batch_alter_table("jobs") as batch:
        batch.alter_column("status_v2", nullable=False)
        batch.drop_column("status")
        batch.alter_column("status_v2", new_column_name="status")


def downgrade() -> None:
    # Reverse logic
    ...
```

### 9.6 Reguły deploymentu

| Reguła | Dlaczego |
|--------|----------|
| Migracje commitowane razem z kodem który ich wymaga | Sync historia |
| Review każdej autogenerate migracji | Ręcznie fix rename/data |
| Backward-compatible migrations (dodaj → backfill → usuń) | Zero-downtime deploy |
| Nigdy nie edytuj committed migracji | Stracisz spójność |
| `alembic upgrade head` w CI (smoke) | Wychwyć błędy przed prod |

### 9.7 Zero-downtime deployment — 3-release pattern

Zmiana schema BEZ downtime wymaga rozbicia na 3 deploymenty.

| Release | Baza | Kod | Efekt |
|---------|------|-----|-------|
| **R1 (expand)** | Dodaj nową kolumnę/tabelę jako `nullable=True` | Pisze do starej **i** nowej (dual-write) | Stara wersja nadal działa, nowa też |
| **R2 (backfill)** | Data migration wypełnia nową kolumnę | Czyta z nowej; pisze do obu | Backfill batchami (offline job) — nie blokuj tabeli |
| **R3 (contract)** | `ALTER COLUMN ... NOT NULL` + `DROP COLUMN` (stara) | Czyta/pisze tylko nową | Cleanup; po potwierdzeniu że żaden proces nie używa starej |

```python
# R1 — dual-write
def upgrade_r1() -> None:
    op.add_column("jobs", sa.Column("status_v2", sa.String(20), nullable=True))
    # Application code: pisze `status` AND `status_v2`


# R2 — backfill (osobna migracja / job offline)
def upgrade_r2() -> None:
    op.execute("UPDATE jobs SET status_v2 = status WHERE status_v2 IS NULL")
    # Application code: czyta `status_v2`, pisze obie


# R3 — contract
def upgrade_r3() -> None:
    with op.batch_alter_table("jobs") as batch:
        batch.alter_column("status_v2", nullable=False)
        batch.drop_column("status")
        batch.alter_column("status_v2", new_column_name="status")
```

| Anti-pattern | Dlaczego boli |
|--------------|---------------|
| `ALTER TABLE ... DROP COLUMN` w R1 | Stara wersja aplikacji crashuje — downtime |
| Backfill w transakcji dla >100k rowów | Długi lock, timeout, replication lag |
| Brak feature flag dla nowej ścieżki | Nie można szybko rollback logiki |

---

## 10. Repository + Unit of Work

> Powiązane: [09-class-design.md](09-class-design.md) §6 — wzorce (adaptowane do DB).

### 10.1 Repository jako Protocol

```python
# ✅ Protocol = swap-able, testowalne
from typing import Protocol, runtime_checkable


@runtime_checkable
class JobRepository(Protocol):
    async def get(self, job_id: UUID) -> Job | None: ...
    async def get_or_raise(self, job_id: UUID) -> Job: ...
    async def list_by_owner(self, owner_id: UUID, *, limit: int, offset: int) -> list[Job]: ...
    async def add(self, job: Job) -> None: ...
    async def delete(self, job_id: UUID) -> None: ...
```

### 10.2 SQLAlchemy implementacja

```python
class SqlJobRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get(self, job_id: UUID) -> Job | None:
        return await self._session.get(Job, job_id)

    async def get_or_raise(self, job_id: UUID) -> Job:
        job = await self.get(job_id)
        if job is None:
            raise JobNotFoundError(job_id=job_id)
        return job

    async def list_by_owner(self, owner_id: UUID, *, limit: int, offset: int) -> list[Job]:
        stmt = (
            select(Job)
            .where(Job.owner_id == owner_id, Job.deleted_at.is_(None))
            .order_by(Job.created_at.desc())
            .limit(limit).offset(offset)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def add(self, job: Job) -> None:
        self._session.add(job)

    async def delete(self, job_id: UUID) -> None:
        await self._session.execute(update(Job).where(Job.id == job_id).values(deleted_at=func.now()))
```

### 10.3 Unit of Work

```python
# ✅ UoW = "boundary" transakcji + access do repozytoriów
class UnitOfWork:
    jobs: JobRepository
    users: UserRepository

    def __init__(self, session_factory: async_sessionmaker[AsyncSession]) -> None:
        self._session_factory = session_factory
        self._session: AsyncSession | None = None

    async def __aenter__(self) -> UnitOfWork:
        self._session = self._session_factory()
        self.jobs = SqlJobRepository(self._session)
        self.users = SqlUserRepository(self._session)
        return self

    async def __aexit__(self, exc_type, exc, tb) -> None:
        assert self._session is not None
        try:
            if exc_type is None:
                await self._session.commit()
            else:
                await self._session.rollback()
        finally:
            await self._session.close()
            self._session = None


# Użycie
async def enqueue_job(payload: NewJob, uow: UnitOfWork) -> Job:
    async with uow:
        user = await uow.users.get_or_raise(payload.owner_id)
        job = Job(owner_id=user.id, title=payload.title)
        await uow.jobs.add(job)
        return job
```

### 10.4 Kiedy NIE abstrahować

| Sytuacja | Robić repo? |
|----------|-------------|
| Mała aplikacja, <5 modeli | ❌ Session bezpośrednio OK |
| Kilka backendów (SQL + cache + external API) | ✅ Tak |
| Chcesz testować bez DB | ✅ Tak |
| Ciężkie query z JOINami per-view | ❌ SELECT w service'ie, nie pchaj w repo |

---

## 11. Performance

### 11.1 Bulk operations

```python
# ❌ N INSERTów — wolne
for payload in payloads:
    session.add(Job(**payload))
await session.commit()
```

```python
# ✅ Bulk insert — jeden statement
from sqlalchemy import insert


await session.execute(insert(Job), [p for p in payloads])
await session.commit()
```

```python
# ✅ Bulk update
from sqlalchemy import update, bindparam


stmt = (
    update(Job)
    .where(Job.id == bindparam("target_id"))
    .values(status=bindparam("new_status"))
)
await session.execute(stmt, [{"target_id": ..., "new_status": ...}, ...])
```

### 11.2 `EXPLAIN QUERY PLAN`

```sql
EXPLAIN QUERY PLAN
SELECT * FROM jobs
WHERE owner_id = ? AND status = 'running'
ORDER BY created_at DESC LIMIT 20;
```

| Output | Znaczenie |
|--------|-----------|
| `SEARCH ... USING INDEX ix_jobs_owner_status` | ✅ Indeks używany |
| `SCAN TABLE jobs` | ⚠️ Full table scan |
| `USE TEMP B-TREE FOR ORDER BY` | ⚠️ Sort nie używa indeksu |

### 11.3 Connection pool

| Workload | `pool_size` | `max_overflow` | Uwagi |
|----------|-------------|----------------|-------|
| CLI / skrypt jednorazowy | — | — | `poolclass=NullPool` (brak reuse) |
| Web API (SQLite) | 5–10 (wszystkie readers) | 0–5 | WAL pozwala wielu readers; writer serializowany przez SQLite |
| Web API (Postgres) | 10–20 | 10–20 | `pool_pre_ping=True` — wykrywaj zerwane połączenia |
| Serverless / Lambda | — | — | `poolclass=NullPool` — nowe connections per-invocation |
| Batch worker | 1 per worker | 0 | Jedna długa transakcja per worker |

> Dla SQLite: `NullPool` dla skryptów, default `QueuePool` dla serwera. `pool_recycle=3600` — odświez co godzinę, chroni przed firewall-drop stale connections.

### 11.4 Paginacja — keyset > offset

```python
# ❌ OFFSET — robi się wolne przy dużych offsetach
stmt = select(Job).order_by(Job.id).offset(10000).limit(20)
```

```python
# ✅ Keyset (cursor-based) — stały koszt
stmt = (
    select(Job)
    .where(Job.id > last_seen_id)   # cursor = ostatnie id z poprzedniej strony
    .order_by(Job.id)
    .limit(20)
)
```

### 11.5 Batch flush w długich pętlach

```python
# ✅ Flush co N insertów + reset identity map
for i, row in enumerate(rows):
    session.add(Job(**row))
    if i % 1000 == 0:
        await session.flush()
        session.expunge_all()   # Zwolnij pamięć
await session.commit()
```

---

## 12. Security

### 12.1 Parameterized queries (zawsze)

```python
# ✅ Parametry — SQLAlchemy robi bind automatycznie
stmt = select(User).where(User.email == email_input)
```

```python
# ❌ String concat = SQL injection
await session.execute(text(f"SELECT * FROM users WHERE email = '{email_input}'"))
```

### 12.2 `text()` — tylko z `bindparam`

```python
# ✅ Raw SQL ale bezpieczny
from sqlalchemy import text


stmt = text("SELECT * FROM users WHERE email = :email").bindparams(email=email_input)
await session.execute(stmt)
```

### 12.3 SecretStr w config

```python
# ✅ Nie wycieknie do logów (BaseSettings → repr ukryty)
from pydantic import SecretStr


class DbSettings(BaseSettings):
    database_url: SecretStr


# Użycie
engine = create_async_engine(settings.database_url.get_secret_value())
```

### 12.4 Encryption at rest

| Poziom | Jak | Kiedy |
|--------|-----|-------|
| FS (LUKS, APFS, BitLocker) | Zewnętrzne | Zawsze na produkcji |
| SQLCipher | Extension do SQLite | Mobile, desktop z sekretami |
| Field-level (pgcrypto, app-level) | Szyfruj kolumny wrażliwe | PII (PESEL, karty) |

### 12.5 Row-level access control

```python
# ✅ Predicate wstrzykiwany w każdym zapytaniu
class UserScopedJobRepository(SqlJobRepository):
    def __init__(self, session: AsyncSession, current_user_id: UUID) -> None:
        super().__init__(session)
        self._uid = current_user_id

    async def list(self, *, limit: int = 20) -> list[Job]:
        stmt = (
            select(Job)
            .where(Job.owner_id == self._uid, Job.deleted_at.is_(None))
            .limit(limit)
        )
        return list((await self._session.scalars(stmt)).all())
```

---

## 13. Testing bazodanowy

> Powiązane: [12-testing.md](12-testing.md).

### 13.1 Strategia — matryca

| Test | Baza | Cleanup | Prędkość |
|------|------|---------|----------|
| Unit (repo nie w grze) | — (fake repo) | — | Najszybszy |
| Integration (repo + SQL) | `sqlite+aiosqlite:///:memory:` per-test | `Base.metadata.drop_all` | Szybki |
| Transactional rollback | Shared engine, rollback per-test | Auto rollback | Szybki |
| E2E (prawdziwa baza) | Temp file | Drop + create | Wolniejszy |

### 13.2 In-memory SQLite fixture

```python
# ✅ conftest.py
import pytest
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from myapp.db.models import Base


@pytest.fixture
async def engine():
    eng = create_async_engine("sqlite+aiosqlite:///:memory:", future=True)
    async with eng.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    try:
        yield eng
    finally:
        await eng.dispose()


@pytest.fixture
async def session(engine) -> AsyncIterator[AsyncSession]:
    factory = async_sessionmaker(engine, expire_on_commit=False)
    async with factory() as s:
        yield s
```

> Ten wzorzec robi `Base.metadata.create_all` per-test — proste, ale wolniejsze przy wielu testach. Dla suite ≥100 testów użyj **13.3 Rollback-per-test** (shared engine + rollback). Nie commitów per-test — stan płynął między testami.

### 13.3 Rollback-per-test pattern

```python
# ✅ Szybki: jeden engine, transakcja per test
@pytest.fixture(scope="session")
async def engine():
    eng = create_async_engine("sqlite+aiosqlite:///:memory:")
    async with eng.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield eng
    await eng.dispose()


@pytest.fixture
async def session(engine) -> AsyncIterator[AsyncSession]:
    async with engine.connect() as conn:
        trans = await conn.begin()
        async with AsyncSession(bind=conn, expire_on_commit=False) as s:
            yield s
        await trans.rollback()   # Sprząta wszystkie zmiany testu
```

### 13.4 Factories (test data)

```python
# ✅ factory-boy lub wlasny helper
def make_user(**overrides) -> User:
    defaults = dict(email=f"user-{uuid4().hex[:6]}@test.dev", display_name="Test")
    return User(**{**defaults, **overrides})


async def test_list_jobs(session: AsyncSession) -> None:
    user = make_user()
    session.add(user)
    await session.flush()
    session.add_all([Job(owner_id=user.id, title=f"j-{i}") for i in range(3)])
    await session.flush()

    repo = SqlJobRepository(session)
    result = await repo.list_by_owner(user.id, limit=10, offset=0)
    assert len(result) == 3
```

### 13.5 Migrations w testach

```python
# ✅ Testuj że migracje chodzą — smoke test
from alembic import command
from alembic.config import Config


def test_migrations_upgrade_head(tmp_path: Path) -> None:
    db_path = tmp_path / "test.db"
    alembic_cfg = Config("alembic.ini")
    alembic_cfg.set_main_option("sqlalchemy.url", f"sqlite:///{db_path}")
    command.upgrade(alembic_cfg, "head")
    command.downgrade(alembic_cfg, "base")   # Round-trip
```

---

## 14. Observability

### 14.1 Slow query detection

```python
# ✅ Loguj query > threshold
import time

from loguru import logger
from sqlalchemy import event
from sqlalchemy.engine import Engine


_SLOW_MS = 100


@event.listens_for(Engine, "before_cursor_execute")
def _start(conn, cursor, statement, params, context, executemany) -> None:
    context._start = time.perf_counter()


@event.listens_for(Engine, "after_cursor_execute")
def _end(conn, cursor, statement, params, context, executemany) -> None:
    elapsed_ms = (time.perf_counter() - context._start) * 1000
    if elapsed_ms > _SLOW_MS:
        logger.warning("slow query {elapsed:.1f}ms: {stmt}", elapsed=elapsed_ms, stmt=statement[:200])
```

### 14.2 OpenTelemetry SQLAlchemy

```python
# ✅ Auto-span per query
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor


SQLAlchemyInstrumentor().instrument(engine=engine, enable_commenter=True)
# `enable_commenter=True` → SQL comment z trace_id (DB side)
```

### 14.3 Metryki

| Metryka | Typ | Po co |
|---------|-----|-------|
| `db_query_duration_seconds{op}` | Histogram | P99 latency |
| `db_connections_active` | Gauge | Connection pool health |
| `db_transactions_committed_total` | Counter | Throughput |
| `db_transactions_rolled_back_total` | Counter | Error rate |

---

## 15. Backup, restore, migracja do Postgres

### 15.1 SQLite backup

```python
# ✅ Online backup API (nie blokuje writes)
import sqlite3
from pathlib import Path


def backup_sqlite(src: Path, dst: Path) -> None:
    src_conn = sqlite3.connect(src)
    dst_conn = sqlite3.connect(dst)
    with dst_conn:
        src_conn.backup(dst_conn)
    src_conn.close()
    dst_conn.close()
```

### 15.2 Litestream (streaming replication)

```yaml
# /etc/litestream.yml
dbs:
  - path: /app/data/app.db
    replicas:
      - type: s3
        bucket: myapp-backups
        path: sqlite/app.db
        region: eu-central-1
```

> Litestream streamuje WAL do S3 ciągle. RPO <1s.

### 15.3 Migracja SQLite → Postgres

| Krok | Narzędzie |
|------|-----------|
| 1. Dump schema | Alembic → re-run na Postgres |
| 2. Dump data | `pgloader sqlite:///app.db postgres://...` |
| 3. Verify | Count per table, checksums |
| 4. Cutover | Maintenance window, ew. dual-write |

### 15.4 Checklist przed migracją

- [ ] Postgres-specific typy używane w kodzie? (JSON → JSONB)
- [ ] `AUTOINCREMENT` (SQLite) → `SERIAL`/`IDENTITY` (Postgres)
- [ ] `BOOLEAN` (SQLite = integer) → `BOOLEAN` (Postgres)
- [ ] Timestamps TZ-aware wszędzie
- [ ] Alembic `render_as_batch` usunięte (nie potrzebne w PG)
- [ ] Connection pool przerobiony pod liczbę writerów

---

## 16. Antypatterny

| # | Antypattern ❌ | Fix ✅ | Dlaczego |
|---|---------------|-------|----------|
| 1 | `foreign_keys` nie włączone | Event listener PRAGMA | FK ignorowane cicho |
| 2 | Shared session między `asyncio.gather` | Session per-task | Race condition, "transaction in progress" |
| 3 | `expire_on_commit=True` w async | `False` | Lazy load po commit = crash |
| 4 | `lazy=True` (default) w async models | `selectinload` / `joinedload` explicit | N+1 + lazy-load async = crash |
| 5 | `session.query(...)` (1.x) | `select(...)` (2.0) | Legacy API deprecated |
| 6 | String concat w `text(...)` | `bindparams(...)` | SQL injection |
| 7 | Plain DELETE zamiast soft delete (gdzie potrzebny audyt) | `deleted_at TIMESTAMP` | Audit loss |
| 8 | TIMESTAMP bez `timezone=True` | `DateTime(timezone=True)` | TZ bugs |
| 9 | `float` dla pieniędzy | `Decimal` (`Numeric(18,2)`) | Floating point drift |
| 10 | Brak `render_as_batch` w Alembic/SQLite | `render_as_batch=True` | ALTER TABLE crash |
| 11 | Migracja kolumny bez backfill | Dodaj → backfill → usuń (3 releases) | Downtime |
| 12 | Globalny `engine = create_engine(...)` z hardcoded URL | Factory z settings | Testy niemożliwe |
| 13 | Commit w pętli (1 commit per row) | Flush batchami + jeden commit | 100x wolniej |
| 14 | `SELECT *` (full row) gdy potrzebne 2 pola | `select(User.id, User.email)` | Narzut I/O |
| 15 | Brak index na FK / `WHERE` | Dodaj index | Full table scan |
| 16 | Autoincrement PK w publicznym URL | UUID7 / ULID | Counter leak, IDOR |
| 17 | Brak retry na `SQLITE_BUSY` | `retry_async` + backoff | Sporadic failures w concurrent |
| 18 | JSON dla pól do filtrowania | Oddzielne kolumny + index | Slow queries |
| 19 | Transakcja obejmująca I/O zewnętrzny (HTTP w środku) | Outbox pattern | Lock DB na czas network |
| 20 | Downgrade migracji niesprawdzony | CI: `upgrade head` + `downgrade base` | Broken rollback |
| 21 | Mixing `psycopg2` (sync) w `create_async_engine` | `asyncpg` lub `aiosqlite` only | Event loop blocks, crash |
| 22 | Session współdzielony między `asyncio.gather` | Nowy `AsyncSessionLocal()` per task | `InvalidRequestError: transaction in progress` |
| 23 | Brak `expire_on_commit=False` w async | Ustaw w `async_sessionmaker(..., expire_on_commit=False)` | Lazy load po commit = MissingGreenlet crash |
| 24 | Cascade `delete` bez audytu | Soft delete (`deleted_at`) + batch cleanup job | Nieodwracalna utrata danych |
| 25 | `json_col["field"]` mutacja bez `MutableDict` | `from sqlalchemy.ext.mutable import MutableDict`; `mapped_column(MutableDict.as_mutable(JSON))` | Dirty-tracking ślepe na in-place mutation |
| 26 | `lazy="raise_on_sql"` nie używany w dev | Dodaj do wszystkich relationships domyślnie w dev/test | Ciche N+1 w prod |
| 27 | Brak CI smoke testu `alembic upgrade head` | Dodaj krok w pipeline przed deploy | Broken migracje odkryte na prod |
| 28 | Logging SQL na prod (`echo=True`) | `echo=False` + slow-query event listener ≥100ms | Log explosion, PII leak |
| 29 | Hardcoded `database_url` w `create_engine(...)` | `Settings` + `SecretStr.get_secret_value()` | Secret leak do git / logs |
| 30 | Transakcja obejmująca zewnętrzne I/O (HTTP call) | Outbox pattern (DB write + async publish) | Lock DB na czas network latency |

---

## 17. Egzekucja ruff

### 17.1 Relevant rulesets

```toml
[tool.ruff.lint]
extend-select = [
    "S608",   # Hardcoded SQL (potential injection)
    "S311",   # random — nie używaj dla secretów
    "B",      # bugbear
    "TRY",    # exception handling
    "UP",     # pyupgrade
    "PERF",   # perflint — loops, comprehensions
    "N818",   # Exception suffix
    "ASYNC",  # async correctness
]
```

### 17.2 Typowe lapki

| Ruff | Co łapie | Fix |
|------|----------|-----|
| `S608` | `f"SELECT * FROM t WHERE x={val}"` | `text(...).bindparams(x=val)` |
| `B008` | `Depends(get_session)` jako default w routerze | `Annotated[Session, Depends(get_session)]` |
| `B018` | `session.query(...)` bez przypisania | `result = await session.execute(...)` |
| `PERF401` | `[x for x in query if cond]` zamiast `filter w WHERE` | Push do SQL |
| `ASYNC110` | `time.sleep()` w async scope DB | `await asyncio.sleep()` |
| `TRY400` | `logger.error(f"{e}")` bez traceback | `logger.opt(exception=e).error(...)` |

---

## Źródła

> - [SQLAlchemy 2.0 docs](https://docs.sqlalchemy.org/en/20/) — ORM, async, Mapped[T]
> - [SQLAlchemy ORM Quickstart](https://docs.sqlalchemy.org/en/20/orm/quickstart.html)
> - [SQLAlchemy Async](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html)
> - [SQLite docs](https://www.sqlite.org/docs.html): [WAL](https://www.sqlite.org/wal.html), [PRAGMA](https://www.sqlite.org/pragma.html), [Isolation](https://www.sqlite.org/isolation.html)
> - [Alembic docs](https://alembic.sqlalchemy.org/): autogenerate, [batch](https://alembic.sqlalchemy.org/en/latest/batch.html) for SQLite
> - [aiosqlite](https://github.com/omnilib/aiosqlite)
> - [RFC 9562 — UUID7](https://www.rfc-editor.org/rfc/rfc9562) (time-ordered UUIDs)
> - [Litestream](https://litestream.io/) — SQLite replication
> - [pgloader](https://pgloader.io/) — SQLite→Postgres
> - [Martin Fowler — Patterns of Enterprise Application Architecture](https://martinfowler.com/books/eaa.html) — Repository, Unit of Work
> - Powiązane sekcje repo: [08](08-error-handling.md) (AppError, retry), [09](09-class-design.md) (Repository pattern), [10](10-config-data.md) (SecretStr, Settings), [11](11-logging.md) (loguru), [12](12-testing.md), [13](13-async-concurrency.md), [14](14-api-design.md) (DI w endpoint)
