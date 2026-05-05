"""Task queue processor with priority scheduling and rich type annotations.

Provides a simple in-memory task queue with priority levels,
retry logic, and batch processing. Designed as a cumulative showcase
of conventions from the Python coding standard skill.

Sections demonstrated:
    - ``01-docstrings.md`` — all 3 docstring scales, comments, TODO/FIXME.
    - ``02-type-hints.md`` — TypeAlias, TypeVar, ParamSpec, Protocol,
      Literal, Final, TypeGuard, TypedDict, NamedTuple, @overload,
      Self, Never, cast, ``type: ignore``, TYPE_CHECKING block.

Typical usage:

    queue = (
        TaskQueue(QueueConfig(max_retries=3))
        .with_handler("resize", handle_resize)
    )
    queue.submit(Task(name="resize", payload={"width": 800}))
    results = queue.process_all()

Note:
    This is a showcase file — patterns are deliberately varied
    to demonstrate the full range of the coding standard.
    Requires Python >=3.11 for ``Never``, ``Self``, ``assert_never``.
"""

from __future__ import annotations

import time
from contextlib import contextmanager
from dataclasses import dataclass, field
from enum import IntEnum
from typing import (
    TYPE_CHECKING,
    Final,
    NamedTuple,
    ParamSpec,
    Protocol,
    TypedDict,
    TypeVar,
    cast,
    overload,
)

from loguru import logger

if TYPE_CHECKING:
    from collections.abc import Callable, Iterator
    from pathlib import Path
    from typing import Literal, Never, Self, TypeGuard

    # ── Type Aliases (annotation-only, zero runtime cost) ─────────────────────
    type TaskHandler = "Callable[[Task], dict[str, object]]"
    type TaskStatus = Literal["pending", "running", "done", "failed"]

# ── assert_never (3.11+) ──────────────────────────────────────────────────────

from typing import assert_never

# ── Generic Type Variables (ParamSpec + TypeVar) ──────────────────────────────

_P = ParamSpec("_P")
_R = TypeVar("_R")


# ── Constants (Final) ─────────────────────────────────────────────────────────


MAX_RETRIES: Final[int] = 5
"""Maximum retry attempts before marking task as failed."""

DEFAULT_TIMEOUT: Final[float] = 30.0
"""Default task execution timeout in seconds."""

BATCH_SIZE: Final[int] = 10
"""Number of tasks processed per batch cycle."""


# ── Enums ─────────────────────────────────────────────────────────────────────


class Priority(IntEnum):
    """Task priority levels.

    Lower numeric value = higher priority. Critical tasks
    are always processed before normal ones.

    Attributes:
        CRITICAL: System-critical tasks, processed first.
        HIGH: Important but not critical.
        NORMAL: Default priority for most tasks.
        LOW: Background tasks, processed when idle.
    """

    CRITICAL = 0
    HIGH = 1
    NORMAL = 2
    LOW = 3


# ── Protocol (structural typing) ──────────────────────────────────────────────


class Processable(Protocol):
    """Structural type for objects the queue can process.

    Protocol enables duck typing with type safety — any class
    with matching attributes satisfies this, no inheritance needed.
    ``Task`` satisfies ``Processable`` because it has ``name``
    and ``priority`` — without inheriting from it.
    """

    name: str
    priority: Priority


# ── Structured Data (TypedDict + NamedTuple) ──────────────────────────────────


class TaskSummaryDict(TypedDict):
    """Summary of queue processing results.

    TypedDict gives per-key types — unlike ``dict[str, object]``,
    the type checker knows ``total`` is ``int`` and ``duration``
    is ``str``.
    """

    total: int
    success_rate: str
    duration: str


class TimingInfo(NamedTuple):
    """Immutable timing measurement for a single task.

    NamedTuple: lightweight, immutable, unpackable, typed fields.
    Prefer over dataclass for simple 2-5 field DTOs.
    """

    task_name: str
    duration_ms: float


# ── Data Models ───────────────────────────────────────────────────────────────


@dataclass(slots=True)
class Task:
    """Unit of work to be processed by the queue.

    Attributes:
        name: Human-readable task identifier.
        payload: Arbitrary task data passed to the handler.
        priority: Scheduling priority. Defaults to NORMAL.
        retries_left: Remaining retry attempts.
        status: Current lifecycle status. Uses ``Literal`` for fixed values.
    """

    name: str
    payload: dict[str, object] = field(default_factory=dict)
    priority: Priority = Priority.NORMAL
    retries_left: int = MAX_RETRIES
    status: TaskStatus = "pending"


@dataclass(frozen=True, slots=True)
class TaskResult:
    """Outcome of processing a single task.

    Attributes:
        task: The original task that was processed.
        success: Whether the task completed without errors.
        duration_ms: Execution time in milliseconds.
        error: Error message if failed, None otherwise.
        output: Arbitrary output data from the handler.
    """

    task: Task
    success: bool
    duration_ms: float
    error: str | None = None
    output: dict[str, object] = field(default_factory=dict)


@dataclass(frozen=True, slots=True)
class QueueConfig:
    """Configuration for the task queue.

    Attributes:
        max_retries: Global retry limit per task.
        timeout: Default timeout in seconds.
        batch_size: Tasks per processing cycle.
        log_dir: Directory for task logs. None disables logging.
    """

    max_retries: int = MAX_RETRIES
    timeout: float = DEFAULT_TIMEOUT
    batch_size: int = BATCH_SIZE
    log_dir: Path | None = None


@dataclass(slots=True)
class QueueStats:
    """Aggregated statistics from a processing run.

    Attributes:
        total: Total tasks processed.
        succeeded: Tasks completed successfully.
        failed: Tasks that exhausted all retries.
        total_duration_ms: Wall-clock time for entire run.
    """

    total: int = 0
    succeeded: int = 0
    failed: int = 0
    total_duration_ms: float = 0.0

    @property
    def success_rate(self) -> float:
        """Ratio of succeeded to total tasks, 0.0-1.0."""
        return self.succeeded / self.total if self.total > 0 else 0.0

    @property
    def is_clean(self) -> bool:
        """Whether all tasks succeeded."""
        return self.failed == 0


# ── Utils (MINI scale) ────────────────────────────────────────────────────────


def clamp(value: float, low: float, high: float) -> float:
    """Clamp value to [low, high] range."""
    return max(low, min(high, value))


def ms_since(start: float) -> float:
    """Return milliseconds elapsed since start timestamp."""
    return (time.monotonic() - start) * 1000


def format_duration(ms: float) -> str:
    """Format milliseconds as human-readable string."""
    if ms < 1000:
        return f"{ms:.1f}ms"
    return f"{ms / 1000:.2f}s"


# ── Type Guards (TypeGuard) ───────────────────────────────────────────────────


def is_valid_task(obj: object) -> TypeGuard[Task]:
    """Narrow ``object`` to ``Task`` if it has required attributes.

    TypeGuard tells the type checker: if this returns True,
    treat ``obj`` as ``Task`` in the calling scope.

    Args:
        obj: Any object to validate.

    Returns:
        True if obj is a well-formed Task instance.
    """
    return isinstance(obj, Task) and bool(obj.name)


# ── Never + assert_never (exhaustive matching) ────────────────────────────────


def fatal_error(message: str) -> Never:
    """Abort execution — this function never returns.

    ``Never`` as return type tells the type checker that code
    after calling this function is unreachable.

    Args:
        message: Error description.
    """
    raise SystemExit(message)


def priority_label(priority: Priority) -> str:
    """Map priority enum to display label.

    Uses ``match`` + ``assert_never`` to guarantee exhaustive
    handling. Adding a new ``Priority`` variant without updating
    this function causes a type error at check time.

    Args:
        priority: Priority value to label.

    Returns:
        Emoji label for the priority.
    """
    match priority:
        case Priority.CRITICAL:
            return "🔴 critical"
        case Priority.HIGH:
            return "🟡 high"
        case Priority.NORMAL:
            return "🟢 normal"
        case Priority.LOW:
            return "⚪ low"
        case _ as unreachable:
            assert_never(unreachable)


# ── Protocol helper ───────────────────────────────────────────────────────────


def format_processable(item: Processable) -> str:
    """Format any processable item for logging.

    Accepts anything structurally matching ``Processable`` —
    no inheritance required.

    Args:
        item: Object with ``name: str`` and ``priority: Priority``.

    Returns:
        Formatted label string.
    """
    return f"{item.name} [{priority_label(item.priority)}]"


# ── Decorators (ParamSpec preserves signatures) ───────────────────────────────


def retry(max_attempts: int = 3, delay: float = 0.1) -> Callable[[Callable[_P, _R]], Callable[_P, _R]]:
    """Retry a function on exception with linear backoff.

    Uses ``ParamSpec`` to preserve the decorated function's
    exact parameter types and return type for the type checker.

    Args:
        max_attempts: Total attempts (1 = no retry).
        delay: Delay between attempts in seconds. Multiplied by attempt number.

    Returns:
        Decorated function with retry behavior.

    Example:
        >>> @retry(max_attempts=3, delay=0.5)
        ... def fetch(url: str) -> bytes: ...
    """

    def decorator(func: Callable[_P, _R]) -> Callable[_P, _R]:
        def wrapper(*args: _P.args, **kwargs: _P.kwargs) -> _R:
            last_error: Exception | None = None
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:  # noqa: BLE001
                    last_error = e
                    if attempt < max_attempts:
                        time.sleep(delay * attempt)
            assert last_error is not None  # guaranteed: loop ran ≥1 iteration
            raise last_error

        return wrapper

    return decorator


# ── Context Managers ──────────────────────────────────────────────────────────


@contextmanager
def task_timer(task_name: str) -> Iterator[dict[str, float]]:
    """Time a task and store duration in the yielded dict.

    Yields:
        Dict that will contain ``"duration_ms"`` after the block exits.

    Example:
        >>> with task_timer("resize") as timing:
        ...     do_work()
        >>> print(timing["duration_ms"])
    """
    result: dict[str, float] = {}
    start = time.monotonic()
    try:
        yield result
    finally:
        result["duration_ms"] = ms_since(start)
        logger.debug("Task '{}' took {}", task_name, format_duration(result["duration_ms"]))


# ── Complex Returns ───────────────────────────────────────────────────────────


def partition_by_priority(tasks: list[Task]) -> tuple[list[Task], list[Task]]:
    """Split tasks into urgent (CRITICAL/HIGH) and normal (NORMAL/LOW).

    Args:
        tasks: Tasks to partition.

    Returns:
        Tuple of:
            - Urgent tasks (CRITICAL and HIGH priority).
            - Normal tasks (NORMAL and LOW priority).
    """
    urgent = [t for t in tasks if t.priority <= Priority.HIGH]
    normal = [t for t in tasks if t.priority > Priority.HIGH]
    return urgent, normal


def get_queue_stats_summary(stats: QueueStats) -> TaskSummaryDict:
    """Build a summary dict suitable for JSON serialization.

    Returns ``TaskSummaryDict`` — a TypedDict with per-key types
    instead of ``dict[str, object]``.

    Args:
        stats: Queue statistics to summarize.

    Returns:
        TypedDict with keys ``total``, ``success_rate``, ``duration``.
    """
    return {
        "total": stats.total,
        "success_rate": f"{stats.success_rate:.1%}",
        "duration": format_duration(stats.total_duration_ms),
    }


# ── Queue ─────────────────────────────────────────────────────────────────────


class TaskQueue:
    """Priority-based in-memory task queue with retry logic.

    Tasks are processed in priority order (CRITICAL first). Failed
    tasks are retried up to ``config.max_retries`` times before
    being marked as permanently failed.

    Supports fluent API via ``with_handler()`` returning ``Self``.

    Attributes:
        config: Queue configuration.

    Example:
        >>> queue = (
        ...     TaskQueue(QueueConfig(max_retries=2))
        ...     .with_handler("ping", lambda t: {})
        ... )
        >>> queue.submit(Task(name="ping", priority=Priority.HIGH))
        >>> results = queue.process_all()
        >>> results.is_clean
        True
    """

    def __init__(self, config: QueueConfig | None = None) -> None:
        self.config = config or QueueConfig()
        self._tasks: list[Task] = []
        self._handlers: dict[str, TaskHandler] = {}
        logger.info("TaskQueue initialized (retries={}, timeout={:.1f}s)", self.config.max_retries, self.config.timeout)

    @property
    def pending_count(self) -> int:
        """Number of tasks waiting to be processed."""
        return len(self._tasks)

    @property
    def is_empty(self) -> bool:
        """Whether the queue has no pending tasks."""
        return len(self._tasks) == 0

    # ── Self return type (fluent API) ─────────────────────────────────────────

    def with_handler(self, task_name: str, handler: TaskHandler) -> Self:
        """Register handler and return self for chaining.

        Uses ``Self`` return type — correct in subclasses too,
        unlike hardcoding ``TaskQueue``.

        Args:
            task_name: Task name this handler processes.
            handler: Callable that accepts a Task and returns a dict.

        Returns:
            Self for fluent chaining.

        Raises:
            ValueError: If handler for this task_name already registered.
        """
        if task_name in self._handlers:
            msg = f"Handler already registered for '{task_name}'"
            raise ValueError(msg)
        self._handlers[task_name] = handler
        return self

    def register_handler(self, task_name: str, handler: TaskHandler) -> None:
        """Register a handler function for a task type.

        Args:
            task_name: Task name this handler processes.
            handler: Callable that accepts a Task and returns a dict.

        Raises:
            ValueError: If handler for this task_name already registered.
        """
        if task_name in self._handlers:
            msg = f"Handler already registered for '{task_name}'"
            raise ValueError(msg)
        self._handlers[task_name] = handler

    def submit(self, task: Task) -> None:
        """Add a task to the queue.

        Args:
            task: Task to enqueue. Will be scheduled by priority.
        """
        task.retries_left = self.config.max_retries
        task.status = "pending"
        self._tasks.append(task)
        self._tasks.sort(key=lambda t: t.priority)

    # ── @overload (different return types per call signature) ─────────────────

    @overload
    def get_task(self, *, index: int) -> Task: ...

    @overload
    def get_task(self, *, name: str) -> Task | None: ...

    def get_task(self, *, index: int = -1, name: str = "") -> Task | None:
        """Retrieve a pending task by index or name.

        Overloaded: by ``index`` returns ``Task`` (may raise),
        by ``name`` returns ``Task | None``.

        Args:
            index: Position in the queue (raises IndexError if OOB).
            name: Task name to search for (returns None if not found).

        Returns:
            The matching Task, or None when searching by name.

        Raises:
            IndexError: If index is out of bounds.
        """
        if name:
            return next((t for t in self._tasks if t.name == name), None)
        return self._tasks[index]

    def process_all(self) -> QueueStats:
        """Process all pending tasks in priority order.

        Tasks are processed one at a time. Failed tasks are retried
        up to the configured limit. Returns aggregate statistics.

        Returns:
            QueueStats with totals, successes, failures, and duration.
        """
        stats = QueueStats()
        start = time.monotonic()

        while not self.is_empty:
            task = self._tasks.pop(0)
            task.status = "running"
            result = self._execute_task(task)
            stats.total += 1

            if result.success:
                stats.succeeded += 1
                task.status = "done"
            elif task.retries_left > 0:
                # Re-enqueue for retry — keep original priority
                task.retries_left -= 1
                task.status = "pending"
                self._tasks.append(task)
                self._tasks.sort(key=lambda t: t.priority)
            else:
                stats.failed += 1
                task.status = "failed"
                logger.warning("Task '{}' permanently failed: {}", task.name, result.error)

        stats.total_duration_ms = ms_since(start)
        return stats

    def process_batch(self) -> Iterator[TaskResult]:
        """Process up to batch_size tasks, yielding results as they complete.

        Yields:
            TaskResult for each processed task.
        """
        processed = 0
        while not self.is_empty and processed < self.config.batch_size:
            task = self._tasks.pop(0)
            yield self._execute_task(task)
            processed += 1

    def _execute_task(self, task: Task) -> TaskResult:
        """Run a single task through its registered handler."""
        handler = self._handlers.get(task.name)
        if handler is None:
            return TaskResult(task=task, success=False, duration_ms=0, error=f"No handler for '{task.name}'")

        with task_timer(task.name) as timing:
            try:
                output = handler(task)
                return TaskResult(
                    task=task,
                    success=True,
                    duration_ms=timing.get("duration_ms", 0),
                    output=output or {},
                )
            except Exception as e:  # noqa: BLE001
                return TaskResult(
                    task=task,
                    success=False,
                    duration_ms=timing.get("duration_ms", 0),
                    error=str(e),
                )


# ── Deprecated ────────────────────────────────────────────────────────────────


def process_tasks_sync(tasks: list[Task]) -> list[TaskResult]:
    """Process tasks sequentially without queue management.

    .. deprecated: 2.0
        Use :class:`TaskQueue` with :meth:`TaskQueue.process_all` instead.

    Args:
        tasks: Tasks to process.

    Returns:
        Results in same order as input.
    """
    # HACK(mateusz): Legacy compatibility. Remove after v3.0 migration. #87
    queue = TaskQueue()
    for task in tasks:
        queue.submit(task)
    stats = queue.process_all()
    logger.info("Legacy sync processing: {} tasks", stats.total)
    return []  # simplified for showcase


# ── Main ──────────────────────────────────────────────────────────────────────


def main() -> None:
    """Run showcase demo of the task queue."""

    # Fluent API using Self return type
    def handle_resize(task: Task) -> dict[str, object]:
        """Resize an image to target dimensions."""
        # cast() — we know payload["width"] is int, checker sees object
        width = cast("int", task.payload.get("width", 800))
        time.sleep(0.01)
        return {"resized_to": width}

    def handle_compress(task: Task) -> dict[str, object]:
        """Compress file with specified quality."""
        quality = cast("int", task.payload.get("quality", 85))
        time.sleep(0.01)
        return {"quality": quality, "saved_bytes": 1024}

    queue = (
        TaskQueue(QueueConfig(max_retries=2, batch_size=5))
        .with_handler("resize", handle_resize)
        .with_handler("compress", handle_compress)
    )

    # Submit tasks with different priorities
    queue.submit(Task(name="resize", payload={"width": 1920}, priority=Priority.HIGH))
    queue.submit(Task(name="compress", payload={"quality": 90}, priority=Priority.NORMAL))
    queue.submit(Task(name="resize", payload={"width": 640}, priority=Priority.LOW))
    queue.submit(Task(name="compress", priority=Priority.CRITICAL))

    logger.info("Queued {} tasks", queue.pending_count)

    # TypeGuard — narrow unknown object to Task
    unknown: object = queue.get_task(index=0)
    if is_valid_task(unknown):
        # Type checker knows: unknown is Task here
        logger.info("First task: {} ({})", unknown.name, priority_label(unknown.priority))

    # Protocol — Task satisfies Processable structurally (no inheritance)
    first_task = queue.get_task(index=0)
    logger.info("Protocol demo: {}", format_processable(first_task))

    # @overload — different return types per call signature
    by_name: Task | None = queue.get_task(name="resize")
    if by_name:
        logger.info("Found by name: {}", by_name.name)

    # Process and report with TypedDict return
    stats = queue.process_all()
    summary: TaskSummaryDict = get_queue_stats_summary(stats)

    logger.info(
        "Done: {} tasks, {} success rate, {} total", summary["total"], summary["success_rate"], summary["duration"]
    )

    # NamedTuple — immutable, unpackable
    timing = TimingInfo(task_name="demo", duration_ms=stats.total_duration_ms)
    task_name, duration_ms = timing  # unpacking like a tuple
    logger.info("Timing: {} = {}", task_name, format_duration(duration_ms))

    # TODO(mateusz): Add JSON export of results. #123
    # FIXME(mateusz): process_batch doesn't handle retries correctly.


if __name__ == "__main__":
    main()
