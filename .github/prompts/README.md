# 📁 Prompts Folder

Krótka mapa folderu `.github/prompts/`.

| Plik | Typ | Cel |
|---|---|---|
| `agent-template.prompt.md` | template promptu | punkt startowy do projektowania nowych agentów |
| `MattyMroz.md` | reference | lokalny kontekst i notatki pomocnicze dla pracy z promptami |
| `ZIP.md` | reference | wiedza i notatki pomocnicze dla warstwy promptów |

## Po co jest ten folder

| Typ zawartości | Znaczenie |
|---|---|
| `.prompt.md` | szybka komenda lub template do powtarzalnego tasku |
| `.md` reference docs | wiedza pomocnicza trzymana bezpośrednio w folderze promptów |

## Reguła praktyczna

Prompt file przyspiesza powtarzalny task. Nie zastępuje agenta, jeśli potrzebna jest trwała persona z własnym scope.

`agent-template.prompt.md` służy do budowy nowych agentów. Briefowanie subagenta jest opisane bezpośrednio w `orchestrator.agent.md`.

Materiały reference związane z promptami, takie jak `ZIP.md` i `MattyMroz.md`, są trzymane bezpośrednio w `.github/prompts/`.
