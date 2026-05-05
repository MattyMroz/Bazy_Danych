# Portable AI System — Always-On Baseline

## Kim jest user

Mateusz Mróz, 22 lata, student 3. roku Informatyki na Politechnice Łódzkiej.
Komunikacja: polski z angielskimi terminami technicznymi.

Kontekst osobowy i projektowy dla bieżącego repo:
- Persona: `knowledge/MattyMroz.md`

## Zasady współpracy

- Zero hallucination: nie zgaduj, sprawdzaj albo pytaj.
- Kod > dyskusja: jeśli da się działać, działaj.
- Komunikacja ma być konkretna, partnerska i praktyczna.
- Uwzględniaj dysleksję usera: literówki nie są problemem, liczy się intencja.
- Po złożonych zadaniach kończ HITL przez `vscode_askQuestions`, nigdy markdownową listą opcji.
- Tylko user może zakończyć sesję. Agent nie może zamknąć jej sam.
- Przy złożonych zadaniach i ważnych checkpointach każda odpowiedź agenta ma kończyć się ankietą HITL.

## Twarde preferencje techniczne

- Type hints everywhere, DRY, SOLID, no magic numbers.
- Python: PEP 8, ruff, mypy, Google-style docstrings. `uv` do wszystkiego (`uv add`, `uv run`, `uv sync`).
- Dependency changes w MangaShift: zanim użyjesz gołego `uv add`, sklasyfikuj pakiet według `.github/instructions/dependency-workflow.instructions.md`.
- TypeScript: strict mode, React + Tailwind v4 + cva + cn.
- Nie dubluj standardów, jeśli istnieją już w dedykowanych plikach instrukcji.

## Architektura systemu

Ten plik jest warstwą bazową. Nie wkładaj tu pełnych workflow taskowych.

Portable framework ma żyć głównie w `.github/`.
Wszystko poza `.github/` traktuj jako lokalny kontekst repo.

Podział odpowiedzialności:
- `.github/copilot-instructions.md` — baseline i always-on zasady.
- `AGENTS.md` — mapa agentów, skilli i relacji.
- `.github/instructions/` — reguły zależne od typu pliku lub obszaru repo.
- `.github/skills/` — reusable workflow do zadań specjalistycznych.
- `.github/prompts/` — repeatable komendy i template.
- `.github/agents/` — trwałe persony agentowe.
- `knowledge/` i `temp/brain_storm/` — lokalny kontekst repo.

## Polityka domyślna

- Domyślnym entrypointem systemu jest `@orchestrator`.
- Jeśli istnieje pasujący skill, użyj skilla zamiast improwizować workflow.
- Jeśli istnieją aktywne instructions, respektuj je przed własnym stylem działania.
- Jeśli istnieje prompt file lub template pasujące do tasku, użyj go zamiast pisać wszystko od zera.
- Zasady wywoływania subagentów trzymaj w orchestratorze, nie w baseline.

## Anti-patterny

- Nie zamieniaj globalnych instructions w śmietnik całego systemu.
- Nie kopiuj tych samych zasad do agentów, skilli i promptów bez powodu.
- Nie twórz nowego agenta, jeśli wystarczy skill albo prompt file.
- Nie twórz promptu ogólnego tam, gdzie potrzebna jest trwała architektura.
- Nie mieszaj przenośnego frameworka z repo-specific wiedzą, jeśli system ma być przenośny.