# 13 — Async & Concurrency

> **Cel:** Decyzja kiedy użyć asyncio / threads / processes, idiomatyczne wzorce, GIL, structured concurrency, mixing.
> **Scope:** Uniwersalny — Python ≥3.10, asyncio, concurrent.futures, multiprocessing, ruff ASYNC rules.
> **NIE duplikuje:** error handling (→08), testing async (→12 §7), logging (→11).

---

## Spis treści

1. [Kiedy co użyć — tabela decyzyjna](#1-kiedy-co-użyć--tabela-decyzyjna)
2. [GIL — co musisz wiedzieć](#2-gil--co-musisz-wiedzieć)
3. [asyncio — coroutines & event loop](#3-asyncio--coroutines--event-loop)
4. [Structured concurrency — TaskGroup](#4-structured-concurrency--taskgroup)
5. [asyncio — timeouts & cancellation](#5-asyncio--timeouts--cancellation)
6. [concurrent.futures — ThreadPool & ProcessPool](#6-concurrentfutures--threadpool--processpool)
7. [Mixing async + threads/processes](#7-mixing-async--threadsprocesses)
8. [multiprocessing — niskopoziomowe API](#8-multiprocessing--niskopoziomowe-api)
9. [Synchronizacja & thread safety](#9-synchronizacja--thread-safety)
10. [Antypatterny](#10-antypatterny)
11. [Egzekucja ruff](#11-egzekucja-ruff)


## 📋 Quick Reference

### Tabela decyzyjna — one-liner

| Problem | Rozwiązanie | Moduł |
|---------|------------|-------|
| I/O-bound + async lib | `asyncio` | `asyncio` |
| I/O-bound + blocking lib | `ThreadPoolExecutor` | `concurrent.futures` |
| CPU-bound | `ProcessPoolExecutor` | `concurrent.futures` |
| Mixed async + blocking | `asyncio.to_thread()` | `asyncio` |
| Mixed async + CPU | `loop.run_in_executor(ProcessPool)` | `asyncio` + `concurrent.futures` |
| ≥3.11 structured concurrency | `TaskGroup` | `asyncio` |
| ≥3.11 timeouts | `asyncio.timeout()` | `asyncio` |
| Low-level IPC | `Queue`, `Pipe`, `SharedMemory` | `multiprocessing` |

### Checklist przed użyciem async/concurrency

- [ ] **Czy na pewno potrzebujesz concurrency?** (premature optimization = root of evil)
- [ ] **I/O-bound vs CPU-bound** — zidentyfikuj bottleneck
- [ ] **Czy library jest async-native?** — jeśli tak → `asyncio`; jeśli nie → `ThreadPool`
- [ ] **`if __name__ == "__main__":`** — przy `ProcessPoolExecutor`
- [ ] **Nie połykaj `CancelledError`** — zawsze re-raise
- [ ] **Trzymaj referencje do tasks** — unikaj dangling tasks
- [ ] **Nie mieszaj `asyncio.run()` z istniejącym event loop**
- [ ] **Ruff ASYNC rules** — włączone w konfiguracji

---

## 1. Kiedy co użyć — tabela decyzyjna

### 1.1 Główna matryca

| Typ problemu | Rozwiązanie | Moduł | CPU cores | Kiedy |
|--------------|-------------|-------|-----------|-------|
| **I/O-bound** (sieć, dysk, DB) | `asyncio` | `asyncio` | 1 | Dostępne async-native libraries (aiohttp, asyncpg, httpx) |
| **I/O-bound** (blocking libs) | Thread pool | `concurrent.futures.ThreadPoolExecutor` | 1 | Library nie wspiera async (requests, psycopg2) |
| **CPU-bound** (obliczenia, przetwarzanie) | Process pool | `concurrent.futures.ProcessPoolExecutor` | N | Potrzebujesz prawdziwego paralelizmu |
| **CPU-bound** (lekkie, per-interpreter GIL) | Interpreter pool | `concurrent.futures.InterpreterPoolExecutor` | N | ⚠️ **Python ≥3.14 only** |
| **Mixed** (I/O + CPU) | async + executor | `asyncio` + `concurrent.futures` | N | Główna pętla async, CPU tasks offloadowane |

### 1.2 Reguła kciuka

```text
"Use asyncio when you can, threading when you must, multiprocessing when you need CPU parallelism."
```

### 1.3 Metryki decyzyjne

| Pytanie | asyncio | threads | processes |
|---------|---------|---------|-----------|
| Czy library jest async-native? | ✅ Wymagane | ❌ Nie wymagane | ❌ Nie wymagane |
| Czy potrzebujesz >1000 concurrent tasks? | ✅ Skaluje się dobrze | ⚠️ Overhead per thread | ❌ Za drogi |
| Czy task jest CPU-intensive? | ❌ Zablokuje event loop | ❌ GIL blokuje | ✅ Jedyna opcja |
| Czy dane muszą być współdzielone? | ✅ Łatwe (jeden wątek) | ⚠️ Wymaga locks | ❌ Wymaga IPC/pickle |
| Czy start-up cost ma znaczenie? | ✅ Lekkie coroutines | ✅ Lekkie wątki | ❌ Ciężkie procesy |

---

## 2. GIL — co musisz wiedzieć

### 2.1 Czym jest GIL

**Global Interpreter Lock** — mutex w CPython, który pozwala tylko **jednemu wątkowi** na wykonywanie bytecode'u jednocześnie.

| Fakt | Implikacja |
|------|-----------|
| GIL dotyczy **CPython** | PyPy, Jython, GraalPy mogą nie mieć GIL |
| GIL jest zwalniany podczas **I/O** | `time.sleep()`, `socket.recv()`, `file.read()` — inne wątki mogą działać |
| GIL **NIE jest zwalniany** podczas CPU | `for i in range(10**9)` — blokuje inne wątki |
| C extensions mogą **zwolnić GIL** | NumPy, PIL, OpenCV — wewnętrznie operują bez GIL |
| ⚠️ **Python 3.13+:** Experimental free-threading | `--disable-gil` flag, eksperymentalne, nie production-ready |

> 📌 **Python 3.13 free-threading:** `--disable-gil` włącza brak GIL. **Nie** jest obowiązkowe i niezgodne z wieloma C extensions (NumPy, etc.). Na dziś — do testów, NIE do produkcji.

| ⚠️ **Python 3.14+:** `InterpreterPoolExecutor` | Per-interpreter GIL — prawdziwa wielowątkowość bez osobnych procesów |

### 2.2 Konsekwencje praktyczne

```python
# ❌ ŹLE: threads dla CPU-bound — GIL serializes
from concurrent.futures import ThreadPoolExecutor

def compute_heavy(n: int) -> int:
    return sum(i * i for i in range(n))

# Nie szybsze niż sekwencyjne! GIL blokuje.
with ThreadPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(compute_heavy, [10**7] * 4))
```

```python
# ✅ DOBRZE: processes dla CPU-bound — omija GIL
from concurrent.futures import ProcessPoolExecutor

def compute_heavy(n: int) -> int:
    return sum(i * i for i in range(n))

# Każdy proces ma własny interpreter i GIL!
with ProcessPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(compute_heavy, [10**7] * 4))
```

---

## 3. asyncio — coroutines & event loop

### 3.1 Podstawy — async/await

```python
import asyncio


async def fetch_data(url: str) -> str:
    """Coroutine — nie blokuje event loop."""
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.text()


async def main() -> None:
    # asyncio.run() tworzy event loop i uruchamia coroutine.
    result = await fetch_data("https://api.example.com/data")
    print(result)


# Entry point — jedyny asyncio.run() na top-level.
asyncio.run(main())
```

### 3.2 Kluczowe koncepty

| Koncept | Definicja | Przykład |
|---------|----------|---------|
| **Coroutine function** | Funkcja z `async def` | `async def foo() -> None: ...` |
| **Coroutine object** | Obiekt zwrócony przez wywołanie coroutine function | `coro = foo()` |
| **Awaitable** | Obiekt, który można `await` — coroutine, Task, Future | `await coro` |
| **Task** | Wrapper wokół coroutine, zaplanowany do wykonania | `asyncio.create_task(coro)` |
| **Event loop** | Scheduler — uruchamia task po task, kooperatywnie | `asyncio.run(main())` |

### 3.3 Uruchamianie wielu coroutines — gather

```python
import asyncio

import httpx


async def fetch(client: httpx.AsyncClient, url: str) -> int:
    response = await client.get(url)
    return response.status_code


async def main() -> None:
    urls = [
        "https://api.example.com/users",
        "https://api.example.com/posts",
        "https://api.example.com/comments",
    ]
    async with httpx.AsyncClient() as client:
        # gather uruchamia WSZYSTKIE coroutines jednocześnie.
        results = await asyncio.gather(
            *(fetch(client, url) for url in urls),
            return_exceptions=True,
        )
    for url, result in zip(urls, results, strict=True):
        if isinstance(result, BaseException):
            print(f"{url} → error: {result}")
        else:
            print(f"{url} → status {result}")


asyncio.run(main())
```

### 3.4 create_task — fire-and-manage

```python
import asyncio


async def background_job(name: str) -> None:
    await asyncio.sleep(2)
    print(f"Job {name} done")


async def main() -> None:
    # create_task planuje coroutine do wykonania.
    task1 = asyncio.create_task(background_job("A"))
    task2 = asyncio.create_task(background_job("B"))

    # ⚠️ ZAWSZE trzymaj referencję do task!
    # Event loop trzyma weak references — task bez referencji
    # może zostać garbage collected.
    await task1
    await task2


asyncio.run(main())
```

> **⚠️ Reguła:** Nigdy nie twórz "fire-and-forget" tasks bez trzymania referencji. Event loop trzyma tylko weak references — task może zniknąć przed zakończeniem.

### 3.5 asyncio.Queue — async producer/consumer

```python
import asyncio


async def producer(queue: asyncio.Queue[str]) -> None:
    for i in range(10):
        await asyncio.sleep(0.1)
        await queue.put(f"item-{i}")
    await queue.put("STOP")  # Sentinel


async def consumer(queue: asyncio.Queue[str]) -> list[str]:
    results: list[str] = []
    while True:
        item = await queue.get()
        if item == "STOP":
            break
        results.append(item)
        queue.task_done()
    return results


async def main() -> None:
    queue: asyncio.Queue[str] = asyncio.Queue(maxsize=5)  # Bounded queue
    producer_task = asyncio.create_task(producer(queue))
    consumer_task = asyncio.create_task(consumer(queue))

    await producer_task
    results = await consumer_task
    print(f"Consumed {len(results)} items")


asyncio.run(main())
```

---

## 4. Structured concurrency — TaskGroup

> ⚠️ **Python ≥3.11 required.** Dla Python 3.10 użyj `asyncio.gather()` z `return_exceptions=True`.

### 4.1 Dlaczego TaskGroup > gather

| Cecha | `asyncio.gather()` | `asyncio.TaskGroup` (≥3.11) |
|-------|-------------------|----------------------------|
| Auto-cancel przy failure | ❌ Kontynuuje resztę | ✅ Cancelluje wszystkie taski |
| Exception handling | Jedna exception (lub lista z `return_exceptions`) | `ExceptionGroup` — przechwytuj z `except*` |
| Dodawanie w trakcie | ❌ Stała lista | ✅ `tg.create_task()` wewnątrz body |
| Safety | ⚠️ Tasks mogą "uciec" | ✅ Gwarantowane cleanup |

### 4.2 Podstawowy wzorzec

```python
import asyncio


async def fetch(url: str) -> str:
    await asyncio.sleep(1)  # Symulacja I/O
    return f"Data from {url}"


async def main() -> None:
    results: list[str] = []

    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(fetch("https://api.example.com/a"))
        task2 = tg.create_task(fetch("https://api.example.com/b"))
        task3 = tg.create_task(fetch("https://api.example.com/c"))

    # Po wyjściu z context managera WSZYSTKIE taski są done.
    results = [task1.result(), task2.result(), task3.result()]
    print(results)


asyncio.run(main())
```

### 4.3 Exception handling z except*

> 🔒 **HARD RULE:** W `TaskGroup` wymagany jest `except*` (Python ≥3.11). NIGDY `except Exception` — `TaskGroup` generuje `ExceptionGroup`, a zwykły `except` jej nie przechwytuje.

```python
import asyncio


async def failing_task() -> None:
    await asyncio.sleep(0.5)
    msg = "Something went wrong"
    raise ValueError(msg)


async def main() -> None:
    try:
        async with asyncio.TaskGroup() as tg:
            tg.create_task(failing_task())
            tg.create_task(asyncio.sleep(10))
            # ↑ Ten task zostanie auto-cancelled po failure!
    except* ValueError as eg:
        for exc in eg.exceptions:
            print(f"Caught: {exc}")
    except* OSError as eg:
        for exc in eg.exceptions:
            print(f"OS error: {exc}")


asyncio.run(main())
```

---

## 5. asyncio — timeouts & cancellation

### 5.1 Timeouts

> ⚠️ `asyncio.timeout()` wymaga Python ≥3.11. Dla 3.10 użyj `asyncio.wait_for()`.

```python
import asyncio


async def slow_operation() -> str:
    await asyncio.sleep(30)
    return "done"


# ✅ Python ≥3.11: asyncio.timeout (preferowane)
async def with_timeout_modern() -> str | None:
    try:
        async with asyncio.timeout(5.0):
            return await slow_operation()
    except TimeoutError:
        return None


# ✅ Python ≥3.10: asyncio.wait_for (legacy, ale działa)
async def with_timeout_legacy() -> str | None:
    try:
        return await asyncio.wait_for(slow_operation(), timeout=5.0)
    except TimeoutError:
        return None
```

### 5.2 Cancellation — graceful cleanup

```python
import asyncio

from loguru import logger


async def cancellable_work() -> None:
    try:
        while True:
            await asyncio.sleep(1)
            logger.debug("Working...")
    except asyncio.CancelledError:
        logger.info("Cancelled — cleaning up")
        # Cleanup logic here (flush buffers, close connections)
        raise  # ⚠️ ZAWSZE re-raise CancelledError!


async def main() -> None:
    task = asyncio.create_task(cancellable_work())
    await asyncio.sleep(3)
    task.cancel()

    try:
        await task
    except asyncio.CancelledError:
        logger.info("Task was cancelled")


asyncio.run(main())
```

> **⚠️ Reguła:** Nie połykaj `CancelledError` — zawsze `raise` po cleanup. Inaczej `TaskGroup` i `asyncio.timeout()` nie będą działać poprawnie (wewnętrznie polegają na propagacji cancellation).

---

## 6. concurrent.futures — ThreadPool & ProcessPool

### 6.1 ThreadPoolExecutor — I/O-bound z blocking libs

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests


def download(url: str) -> tuple[str, int]:
    """Blocking I/O — idealne dla ThreadPool."""
    response = requests.get(url, timeout=10)
    return url, response.status_code


def main() -> None:
    urls = [
        "https://api.example.com/users",
        "https://api.example.com/posts",
        "https://api.example.com/comments",
    ]
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(download, url): url for url in urls}

        for future in as_completed(futures):
            url = futures[future]
            try:
                _, status = future.result(timeout=30)
                print(f"{url} → {status}")
            except Exception as exc:
                print(f"{url} → error: {exc}")


if __name__ == "__main__":
    main()
```

### 6.2 ProcessPoolExecutor — CPU-bound

```python
from concurrent.futures import ProcessPoolExecutor


def compute_heavy(n: int) -> int:
    """CPU-intensive — idealne dla ProcessPool."""
    return sum(i * i for i in range(n))


def main() -> None:
    # max_workers domyślnie = os.cpu_count()
    with ProcessPoolExecutor() as executor:
        inputs = [10**7, 2 * 10**7, 3 * 10**7]
        results = list(executor.map(compute_heavy, inputs))
    print(results)


# ⚠️ KRYTYCZNE: if __name__ == "__main__" jest WYMAGANE
# na Windows (spawn start method) — bez tego dostaniesz
# RuntimeError / nieskończony loop forkowania procesów.
if __name__ == "__main__":
    main()
```

### 6.3 executor.map() vs executor.submit()

| Metoda | Kiedy | Return |
|--------|-------|--------|
| `executor.map(fn, iterable)` | Proste batch processing, jeden fn na wiele inputów | Iterator wyników (w kolejności inputów) |
| `executor.submit(fn, *args)` | Potrzebujesz `Future` — cancel, exception, callback | `Future` object |

### 6.4 Future API — submit pattern

```python
from concurrent.futures import Future, ProcessPoolExecutor, wait


def process_item(item: str) -> str:
    return item.upper()


def main() -> None:
    with ProcessPoolExecutor() as executor:
        futures: list[Future[str]] = [
            executor.submit(process_item, item) for item in ["a", "b", "c"]
        ]

        done, not_done = wait(futures, timeout=10)

        for future in done:
            if future.exception() is not None:
                print(f"Error: {future.exception()}")
            else:
                print(f"Result: {future.result()}")

        for future in not_done:
            future.cancel()


if __name__ == "__main__":
    main()
```

### 6.5 InterpreterPoolExecutor — ⚠️ Python ≥3.14 ONLY

> **UWAGA:** `InterpreterPoolExecutor` jest dostępny od **Python 3.14** (released 2025-10).
> Nie używaj w projektach targetujących Python ≥3.10.

```python
# ⚠️ Python ≥3.14 ONLY — per-interpreter GIL.
# Każdy interpreter ma osobny GIL, ale współdzieli pamięć procesu.
# Lżejsze niż ProcessPoolExecutor, ale ograniczone typy danych.
#
# Import ZAWIODZIE na Python <3.14 — użyj conditional import:
#   import sys
#   if sys.version_info >= (3, 14):
#       from concurrent.futures import InterpreterPoolExecutor
from __future__ import annotations

import sys

if sys.version_info >= (3, 14):
    from concurrent.futures import InterpreterPoolExecutor


def compute(n: int) -> int:
    return sum(i * i for i in range(n))


def main() -> None:
    if sys.version_info < (3, 14):
        msg = "InterpreterPoolExecutor requires Python ≥3.14"
        raise RuntimeError(msg)

    with InterpreterPoolExecutor() as executor:
        results = list(executor.map(compute, [10**7] * 4))
    print(results)


if __name__ == "__main__":
    main()
```

---

## 7. Mixing async + threads/processes

### 7.1 asyncio.to_thread() — blocking fn w async context

> ⚠️ `asyncio.to_thread()` wymaga Python ≥3.9.
> 💡 **Timeout:** Użyj `asyncio.timeout()` (≥3.11) lub `asyncio.wait_for()` wokół executor call:
> ```python
> async with asyncio.timeout(5.0):
>     result = await asyncio.to_thread(blocking_fn, arg)
> ```

```python
import asyncio

import requests


def blocking_download(url: str) -> str:
    """Blocking function — NIE jest async."""
    response = requests.get(url, timeout=10)
    return response.text


async def main() -> None:
    # to_thread offloaduje blocking call do thread pool.
    # Event loop NIE jest blokowany.
    result = await asyncio.to_thread(blocking_download, "https://api.example.com/data")
    print(f"Got {len(result)} chars")


asyncio.run(main())
```

### 7.2 loop.run_in_executor() — custom executor

```python
import asyncio
from concurrent.futures import ProcessPoolExecutor


def cpu_intensive(n: int) -> int:
    """CPU-bound — offload do ProcessPool."""
    return sum(i * i for i in range(n))


async def main() -> None:
    loop = asyncio.get_running_loop()

    # ThreadPoolExecutor (default gdy executor=None)
    io_result = await loop.run_in_executor(None, blocking_download, url)

    # ProcessPoolExecutor (jawnie przekazany)
    with ProcessPoolExecutor() as pool:
        cpu_result = await loop.run_in_executor(pool, cpu_intensive, 10**7)

    print(f"I/O: {io_result}, CPU: {cpu_result}")


asyncio.run(main())
```

### 7.3 Pattern: async orchestrator + sync workers

```python
import asyncio
from concurrent.futures import ProcessPoolExecutor

from loguru import logger


def process_image(image_path: str) -> str:
    """CPU-bound — przetwarzanie obrazu (sync)."""
    # Heavy computation...
    return f"processed:{image_path}"


async def process_batch(image_paths: list[str]) -> list[str]:
    """Async orchestrator — dispatches CPU work do pool."""
    loop = asyncio.get_running_loop()
    results: list[str] = []

    with ProcessPoolExecutor() as pool:
        futures = [
            loop.run_in_executor(pool, process_image, path)
            for path in image_paths
        ]
        for coro in asyncio.as_completed(futures):
            result = await coro
            results.append(result)
            logger.info("Processed: {}", result)

    return results


async def main() -> None:
    paths = [f"image_{i}.png" for i in range(20)]
    results = await process_batch(paths)
    logger.info("All done: {} images", len(results))


asyncio.run(main())
```

---

## 8. multiprocessing — niskopoziomowe API

> **Preferuj `concurrent.futures`** zamiast raw `multiprocessing` — prostsze API, lepsze error handling.
> Sięgaj po `multiprocessing` gdy potrzebujesz: Queue, Pipe, shared memory, custom start methods.

### 8.1 Start methods

| Metoda | OS | Default | Opis |
|--------|----|---------|------|
| `spawn` | Wszystkie | ✅ Windows, macOS (≥3.14: POSIX) | Nowy interpreter, bezpieczny, wolniejszy |
| `fork` | POSIX | ✅ POSIX (<3.14) | Kopiuje proces, szybki, **niebezpieczny z threads** |
| `forkserver` | POSIX | ❌ | Kompromis — forkuje z czystego serwera |

```python
import multiprocessing as mp

# ✅ Explicit start method — nie polegaj na domyślnym!
# Na Windows ZAWSZE jest spawn, na POSIX warto wymusić spawn
# dla bezpieczeństwa z bibliotekami wątkowymi.
mp.set_start_method("spawn", force=True)
```

> **⚠️ Uwaga:** Od Python 3.14, domyślna metoda na POSIX zmienia się z `fork` na `forkserver`. Jeśli targetujesz Python ≥3.10 — **jawnie ustaw** `spawn` lub `forkserver` dla portability.

### 8.2 Queue — komunikacja między procesami

```python
import multiprocessing as mp
from multiprocessing import Queue


def worker(task_queue: Queue[str], result_queue: Queue[str]) -> None:
    while True:
        item = task_queue.get()
        if item == "STOP":
            break
        result_queue.put(item.upper())


def main() -> None:
    task_queue: Queue[str] = mp.Queue()
    result_queue: Queue[str] = mp.Queue()

    process = mp.Process(target=worker, args=(task_queue, result_queue))
    process.start()

    for item in ["hello", "world", "mangashift"]:
        task_queue.put(item)
    task_queue.put("STOP")

    process.join()

    while not result_queue.empty():
        print(result_queue.get())


if __name__ == "__main__":
    main()
```

### 8.3 Shared memory (Python ≥3.8)

```python
from multiprocessing import Process
from multiprocessing.shared_memory import SharedMemory

import numpy as np


def worker(shm_name: str, shape: tuple[int, ...], dtype: str) -> None:
    existing_shm = SharedMemory(name=shm_name)
    array = np.ndarray(shape, dtype=dtype, buffer=existing_shm.buf)
    array[:] = array * 2  # Modyfikacja in-place
    existing_shm.close()


def main() -> None:
    data = np.array([1, 2, 3, 4, 5], dtype=np.float64)
    shm = SharedMemory(create=True, size=data.nbytes)

    shared_array = np.ndarray(data.shape, dtype=data.dtype, buffer=shm.buf)
    shared_array[:] = data  # Kopiuj dane

    p = Process(target=worker, args=(shm.name, data.shape, str(data.dtype)))
    p.start()
    p.join()

    print(shared_array)  # [2. 4. 6. 8. 10.]
    shm.close()
    shm.unlink()  # ⚠️ ZAWSZE unlink po zakończeniu!


if __name__ == "__main__":
    main()
```

---

## 9. Synchronizacja & thread safety

### 9.1 Kiedy potrzebujesz synchronizacji

| Koncept | asyncio | threading | multiprocessing |
|---------|---------|-----------|-----------------|
| Lock | `asyncio.Lock()` | `threading.Lock()` | `multiprocessing.Lock()` |
| Semaphore | `asyncio.Semaphore(n)` | `threading.Semaphore(n)` | `multiprocessing.Semaphore(n)` |
| Event | `asyncio.Event()` | `threading.Event()` | `multiprocessing.Event()` |
| Queue | `asyncio.Queue()` | `queue.Queue()` | `multiprocessing.Queue()` |
| Dane współdzielone | Nie potrzebne (jeden thread) | Wymaga Lock | Wymaga IPC lub shared memory |

### 9.2 asyncio.Semaphore — rate limiting

```python
import asyncio

import httpx

# Limit do 10 jednoczesnych requestów.
SEMAPHORE = asyncio.Semaphore(10)


async def fetch_with_limit(client: httpx.AsyncClient, url: str) -> int:
    async with SEMAPHORE:
        response = await client.get(url)
        return response.status_code


async def main() -> None:
    urls = [f"https://api.example.com/item/{i}" for i in range(100)]
    async with httpx.AsyncClient() as client:
        tasks = [fetch_with_limit(client, url) for url in urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)
    print(f"Fetched {len(results)} URLs")


asyncio.run(main())
```

### 9.3 threading.Lock — mutable shared state

```python
import threading
from concurrent.futures import ThreadPoolExecutor

counter_lock = threading.Lock()
counter = 0


def increment() -> None:
    global counter  # noqa: PLW0603
    with counter_lock:
        counter += 1


def main() -> None:
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(increment) for _ in range(1000)]
        for future in futures:
            future.result()
    print(f"Counter: {counter}")  # Zawsze 1000


if __name__ == "__main__":
    main()
```

---

## 10. Antypatterny

### 10.1 Blocking w async

```python
# ❌ ŹLE: blocking call w async — blokuje CAŁY event loop!
import time


async def bad_handler() -> str:
    time.sleep(5)  # ← Blokuje event loop na 5 sekund!
    return "done"
```

```python
# ✅ DOBRZE: użyj async sleep lub offloaduj do thread
import asyncio


async def good_handler() -> str:
    await asyncio.sleep(5)  # ← Kooperatywne — inne taski mogą działać
    return "done"


# Lub offload blocking I/O:
async def good_handler_blocking() -> str:
    result = await asyncio.to_thread(blocking_io_function)
    return result
```

### 10.2 Fire-and-forget bez referencji

```python
# ❌ ŹLE: task może zostać garbage collected!
async def bad_fire_and_forget() -> None:
    asyncio.create_task(some_background_work())  # ← Brak referencji!
```

```python
# ✅ DOBRZE: trzymaj referencje w zbiorze
_background_tasks: set[asyncio.Task[None]] = set()


async def good_fire_and_forget() -> None:
    task = asyncio.create_task(some_background_work())
    _background_tasks.add(task)
    task.add_done_callback(_background_tasks.discard)
```

### 10.3 Połykanie CancelledError

```python
# ❌ ŹLE: łamie TaskGroup i timeout!
async def bad_cancellation() -> None:
    try:
        await asyncio.sleep(10)
    except asyncio.CancelledError:
        pass  # ← Połknięte! TaskGroup nie wie, że task się zakończył.
```

```python
# ✅ DOBRZE: cleanup + re-raise
async def good_cancellation() -> None:
    try:
        await asyncio.sleep(10)
    except asyncio.CancelledError:
        # Cleanup logic (flush, close, etc.)
        raise
```

### 10.4 Brak if \_\_name\_\_ == "\_\_main\_\_" z processes

```python
# ❌ ŹLE: na Windows powoduje RuntimeError / infinite fork!
from concurrent.futures import ProcessPoolExecutor

with ProcessPoolExecutor() as executor:
    executor.map(compute, data)
```

```python
# ✅ DOBRZE: guard na top-level
from concurrent.futures import ProcessPoolExecutor


def main() -> None:
    with ProcessPoolExecutor() as executor:
        results = list(executor.map(compute, data))


if __name__ == "__main__":
    main()
```

### 10.5 asyncio.run() w runtime — nested event loop

```python
# ❌ ŹLE: RuntimeError — already running event loop!
async def handler() -> None:
    result = asyncio.run(some_coroutine())  # ← Crash!
```

```python
# ✅ DOBRZE: await bezpośrednio
async def handler() -> None:
    result = await some_coroutine()
```

### 10.6 Shared mutable state bez synchronizacji

```python
# ❌ ŹLE: race condition — results mogą stracić wpisy
results: list[str] = []


def worker(item: str) -> None:
    results.append(item.upper())  # ← Nie thread-safe!
```

```python
# ✅ DOBRZE: użyj queue lub zbieraj wyniki z Future
from concurrent.futures import ThreadPoolExecutor


def worker(item: str) -> str:
    return item.upper()


def main() -> None:
    with ThreadPoolExecutor() as executor:
        results = list(executor.map(worker, ["a", "b", "c"]))
    print(results)
```

### 10.7 Threads dla CPU-bound

```python
# ❌ ŹLE: GIL serializes — brak speedup!
with ThreadPoolExecutor(max_workers=8) as executor:
    executor.map(heavy_computation, data)

# ✅ DOBRZE: użyj ProcessPoolExecutor
with ProcessPoolExecutor() as executor:
    results = list(executor.map(heavy_computation, data))
```

### 10.8 asyncio.get_event_loop() — deprecated pattern

```python
# ❌ ŹLE: deprecated od Python 3.10 — tworzy nowy loop jeśli nie istnieje!
import asyncio

loop = asyncio.get_event_loop()  # DeprecationWarning!
loop.run_until_complete(some_coro())
```

```python
# ✅ DOBRZE: asyncio.run() dla entry point
import asyncio

asyncio.run(main())  # Tworzy loop, uruchamia, zamyka.

# ✅ DOBRZE: get_running_loop() wewnątrz async function
async def inside_async() -> None:
    loop = asyncio.get_running_loop()  # Bezpieczne wewnątrz async context
    await loop.run_in_executor(None, blocking_fn)
```

---

## 11. Egzekucja ruff

### 11.1 Reguły ASYNC (flake8-async)

| Reguła | Opis | Autofix |
|--------|------|---------|
| `ASYNC100` | Timeout context (`asyncio.timeout`, trio/anyio `cancel_scope`) bez `await` — timeout bezużyteczny | ❌ |
| `ASYNC105` | Sync call na trio/anyio — brak `await` | ✅ |
| `ASYNC109` | `async def` z parametrem `timeout` — użyj structured timeout | ❌ |
| `ASYNC110` | `while` + `await sleep()` zamiast `Event` | ❌ |
| `ASYNC115` | `sleep(0)` zamiast `checkpoint()` | ✅ |
| `ASYNC210` | Blocking HTTP call w async (requests, urllib) | ❌ |
| `ASYNC220` | `subprocess.Popen` w async — użyj `asyncio.create_subprocess_exec` | ❌ |
| `ASYNC230` | `open()` w async — użyj `aiofiles` lub `asyncio.to_thread` | ❌ |
| `ASYNC251` | `time.sleep()` w async — użyj `asyncio.sleep()` | ❌ |

### 11.2 Powiązane reguły z innych kategorii

| Reguła | Opis |
|--------|------|
| `B904` | `raise ... from err` wewnątrz `except` — ważne w async exception chains |
| `RUF006` | `asyncio.create_task()` bez trzymania referencji — dangling task |
| `RUF029` | Funkcja `async def` bez `await` — niepotrzebne async |
| `PLW2101` | `threading.Lock()` bezpośrednio w `with` — Lock nie ma efektu (tworzy i zwalnia od razu) |
| `PLE1700` | `yield from` w `async` — użyj `async for` |

### 11.3 Konfiguracja ruff

```toml
[tool.ruff.lint]
select = [
    # ... inne reguły ...
    "ASYNC",   # flake8-async — catching blocking calls in async
]
```

---
## Źródła

- [asyncio — docs.python.org](https://docs.python.org/3/library/asyncio.html) — oficjalna dokumentacja
- [asyncio — Coroutines and Tasks](https://docs.python.org/3/library/asyncio-task.html) — TaskGroup, gather, timeout
- [concurrent.futures — docs.python.org](https://docs.python.org/3/library/concurrent.futures.html) — Thread/Process/InterpreterPoolExecutor
- [multiprocessing — docs.python.org](https://docs.python.org/3/library/multiprocessing.html) — Process, Pool, Queue, shared memory
- [Speed Up Your Python Program With Concurrency — Real Python](https://realpython.com/python-concurrency/) — benchmarki I/O vs CPU
- [ruff — flake8-async (ASYNC)](https://docs.astral.sh/ruff/rules/#flake8-async-async) — reguły lint dla async
