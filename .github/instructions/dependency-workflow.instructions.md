---
applyTo: "**/*"
---

# Dependency Workflow Instructions

## Cel

Nie wrzucaj nowych dependency automatycznie do base `project.dependencies`. Najpierw sklasyfikuj pakiet według modułu, bo MangaShift ma dwa światy: lokalny dev Mateusza z CUDA/Torch oraz instalator/production bez Torcha.

## Zasada główna

- **Nigdy nie edytuj dependency ręcznie** w `pyproject.toml`.
- Używaj tylko `uv add`, `uv remove`, `uv lock`, `uv sync`.
- `uv add <pakiet>` bez flag jest dozwolone tylko dla lekkiego core CLI/config/network.
- Jeśli nie wiesz gdzie dodać pakiet, dodaj go tymczasowo do `spike` i zapytaj usera przy HITL.

## Routing dependency

| Pakiet służy do | Profil | Dodawanie |
|---|---|---|
| Core CLI/config/network | base | `uv add <pakiet>` |
| API/server | `api-server` | `uv add --group api-server <pakiet>` |
| Baza danych | `db` | `uv add --group db <pakiet>` |
| Obrazki/CV bez Torcha | `image-core` | `uv add --group image-core <pakiet>` |
| Filmy/audio/ffmpeg/video export | `media` | `uv add --group media <pakiet>` |
| ONNX runtime/export | `runtime-onnx` | `uv add --group runtime-onnx <pakiet>` |
| Text/transformers runtime bez Torcha | `text-runtime` | `uv add --group text-runtime <pakiet>` |
| LLM clients (Gemini/OpenAI/Anthropic/DeepSeek/OpenRouter) | `llm` | `uv add --group llm <pakiet>` |
| TTS | `tts` | `uv add --group tts <pakiet>` |
| Torch/PT/local GPU/export/parity | `torch-models` | `uv add --group torch-models <pakiet>` |
| ComfyUI/lab | `lab-comfy` | `uv add --group lab-comfy <pakiet>` |
| Eksperyment chwilowy | `spike` | `uv add --group spike <pakiet>` |

## Installer / wheel extras

Jeśli dependency ma być częścią instalowalnej aplikacji, dodaj też matching optional extra:

```bash
uv add --optional <profil> <pakiet>
```

Przykład dla obróbki filmów:

```bash
uv add --group media moviepy
uv add --optional media moviepy
uv sync
```

## Usuwanie

Usuń z tych samych miejsc, do których pakiet był dodany:

```bash
uv remove --group media moviepy
uv remove --optional media moviepy
uv sync
```

## Walidacja po zmianie dependency

Minimum po każdej zmianie dependency:

```bash
uv lock --check
uv sync --dry-run
uv sync --no-default-groups --group production --dry-run
uv sync --no-default-groups --extra production --dry-run
```

## Krótka reguła dla modeli AI

Najpierw odpowiedz: **do czego służy pakiet?** Dopiero potem wybierz profil. Dla video/audio użyj `media`; dla eksperymentu użyj `spike`; dla Torcha użyj `torch-models`; dla lekkiego core dopiero wtedy użyj gołego `uv add`.