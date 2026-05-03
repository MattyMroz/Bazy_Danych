---
name: git
description: "Kompletny, przenośny Git & GitHub standard. All-in-one reference + 12 deep-dive files (00-11). Źródło prawdy dla zarządzania repozytorium, branchy, commitów, PR-ów, release'ów i CI/CD."
---

## Kiedy używać

Używaj tego skilla, gdy zadanie dotyczy **zarządzania Git i repozytoriami GitHub** — strategii branchowania, konwencji commitów, PR review, release management, branch protection, CI/CD, community health files.

### Typowe triggery

- `git workflow` — wybierz model branchowania
- `git commit` / `conventional commits` — format commitów
- `git branch` — nazewnictwo i strategia branchy
- `git pr` / `pull request` — PR best practices, review
- `git release` — tagi, SemVer, changelog, GitHub Releases
- `git hooks` — pre-commit, commit-msg, lint-staged
- `git protection` — branch protection rules
- `git setup` — setup nowego repo, community health files
- `git ci` / `github actions` — CI/CD wzorce
- `git advanced` — rebase, stash, cherry-pick, bisect

### Nie używaj do

- pisania kodu aplikacji (→ `python/`, `frontend/`),
- debugowania runtime errors (→ default agent),
- konfiguracji MCP/extensions (→ docs),
- jednorazowego pytania o jedną komendę (→ szybka odpowiedź, nie skill).

---

## Stack & Assumptions

| Element | Wartość |
|---------|---------|
| **Git** | ≥2.30 |
| **Platforma** | GitHub (transferowalne do GitLab/Bitbucket z adaptacją) |
| **Commit convention** | Conventional Commits 1.0.0 |
| **Versioning** | Semantic Versioning 2.0.0 |
| **CI/CD** | GitHub Actions |
| **Hooks** | pre-commit / husky + lint-staged |
| **CLI** | `gh` (GitHub CLI) |
| **Changelog** | Keep a Changelog format |

---

# 📖 ALL-IN-ONE REFERENCE

> Poniżej skompresowana esencja z 12 sekcji referencyjnych.
> Deep dive → `references/00-11` (self-contained pliki z pełnymi przykładami).

---

## 1. Workflow Models

> Deep dive → `references/00-workflow-models.md`

### Porównanie

| Model | Branche stałe | Deploy | Złożoność | Dla kogo |
|-------|--------------|--------|-----------|----------|
| **GitHub Flow** | `main` | Z `main` po merge PR | 🟢 Niska | Solo, startup, team ≤20, CI/CD web app |
| **Git-flow** | `main` + `develop` | Z `main` po release merge | 🔴 Wysoka | Multi-version SDK, mobile, regularne release cykle |
| **Trunk-Based** | `main` (trunk) | Z `main`, ciągle | 🟡 Średnia | Duże zespoły 50+, daily deploys, monorepo |

### Tabela decyzyjna

```
Dostarczasz ciągle (CI/CD, web app)?
├── TAK → Zespół > 20 z feature toggles? → Trunk-Based
│         Zespół ≤ 20, PR-centric? → GitHub Flow ← DEFAULT
└── NIE → Utrzymujesz wiele wersji? → Git-flow
          Inaczej → GitHub Flow
```

### ⛔ HARD RULES workflow

- 🔴 **`main` zawsze deployowalny** — nigdy broken code na main.
- 🔴 **Każda zmiana przez PR** — zero direct push na `main`.
- 🔴 **CI musi być green** przed merge.
- 🟡 **Branch < 1 tydzień** (GitHub Flow) / **< 1 dzień** (TBD).

> 💡 **Default: GitHub Flow.** Nie stosuj Git-flow "bo brzmi profesjonalnie" — prostota > ceremonia.

---

## 2. Branching

> Deep dive → `references/01-branching.md`

### Konwencja nazewnictwa

**Format:** `<type>/<scope>-<description>`

| Reguła | ✅ Dobrze | ❌ Źle |
|--------|----------|--------|
| 🔴 Lowercase + kebab-case | `feature/user-auth` | `Feature/UserAuth` |
| 🔴 Max 50 znaków total | `bugfix/login-redirect` | `bugfix/fix-the-issue-where-user-gets-redirected-to-wrong-page` |
| 🔴 Prefix z type | `feature/dark-mode` | `dark-mode` |
| 🟡 Referuj ticket | `feature/login-#42` | `feature/login` (gdy jest #42) |

### Typy branchy

| Type | Kiedy | Merge do |
|------|-------|---------|
| `feature/` | Nowa funkcjonalność | `main` / `develop` |
| `bugfix/` | Fix buga (non-urgent) | `main` / `develop` |
| `hotfix/` | Urgent production fix | `main` + `develop` |
| `release/` | Przygotowanie release | `main` + `develop` |
| `chore/` | Maintenance, deps, config | `main` / `develop` |
| `docs/` | Dokumentacja | `main` / `develop` |
| `test/` | Testy | `main` / `develop` |
| `ci/` | CI/CD pipeline changes | `main` / `develop` |

### ⛔ HARD RULES branching

- 🔴 **Max lifetime: 1 tydzień** — dłuższe = merge hell.
- 🔴 **Sync z main codziennie** — `git rebase origin/main` na feature branch.
- 🔴 **Usuń branch po merge** — zero zombie branches.
- 🔴 **Nigdy force-push na shared branch** — `--force-with-lease` tylko na personal.
- 🟡 **1 feature = 1 branch = 1 PR**.
- 🟡 **Auto-delete head branches** — włącz w Settings → General.

---

## 3. Conventional Commits

> Deep dive → `references/02-conventional-commits.md`

### Format

```
<type>[scope][!]: <description>

[body]

[footer(s)]
```

### Types + SemVer mapping

| Type | Kiedy | SemVer bump |
|------|-------|-------------|
| `feat` | Nowa feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Dokumentacja | — |
| `refactor` | Restructure (no behavior change) | — |
| `perf` | Performance | PATCH |
| `test` | Testy | — |
| `chore` | Deps, build, tooling | — |
| `ci` | CI/CD pipeline | — |
| `style` | Format (whitespace) | — |
| `build` | Build system | — |
| `revert` | Revert commita | Zależy |

### Breaking Change

`!` po type/scope LUB `BREAKING CHANGE:` w footer → **MAJOR bump**.

### ✅ Dobre vs ❌ Złe commit messages

```bash
# ✅
feat(auth): add two-factor authentication via TOTP
fix(api): return 404 instead of 500 for missing resources
chore(deps): upgrade fastapi from 0.104 to 0.109

# ❌
fix stuff                      # brak type i opisu
updated code                   # co? gdzie?
WIP                            # commituj skończone
feat: Add New Feature.         # uppercase, kropka, ogólne
```

### ⛔ HARD RULES commits

- 🔴 **Type jest obowiązkowy** — `feat:`, `fix:`, `docs:` itd.
- 🔴 **Tryb rozkazujący, lowercase, bez kropki** — `add`, nie `Added.`
- 🔴 **Max 72 znaki w header** — krótko i konkretnie.
- 🔴 **1 commit = 1 logiczna zmiana** (atomic commits).
- 🔴 **BREAKING CHANGE = uppercase** w footer.
- 🟡 **Scope konsystentny** — `auth` zawsze, nie raz `auth` raz `authentication`.

---

## 4. Pull Requests

> Deep dive → `references/03-pull-requests.md`

### Kluczowe metryki

| Metryka | Rekomendacja |
|---------|-------------|
| **Rozmiar** | 200-400 LOC (max 800, >1000 = split!) |
| **Reviewers** | 1-2 (min 1 required) |
| **Review time** | < 24h (cel: < 4h) |
| **Lifetime** | < 3 dni (cel: same-day merge) |
| **Merge strategy** | Squash merge (default) |

### Merge Strategies

| Strategy | Kiedy | Rezultat |
|----------|-------|---------|
| **Squash merge** ← DEFAULT | Features, bugfixy, chores | 1 commit per PR na main |
| **Rebase merge** | Małe zmiany, atomic commits | Oryginalne commity, liniowa historia |
| **Merge commit** | Release/hotfix branches (Git-flow) | Merge node w historii |

### Code Review etykieta

| Prefix | Znaczenie | Blocking? |
|--------|-----------|-----------|
| (brak) | Normalne suggestion | Must fix |
| `nit:` | Kosmetyka | Non-blocking |
| `question:` | Pytanie o kontekst | Non-blocking |
| `blocker:` | Blocker | Must fix |
| `praise:` | Chwalę! | 😊 |

### ⛔ HARD RULES PR

- 🔴 **Min 1 approval** przed merge.
- 🔴 **CI musi przejść** — nie approve z czerwonym CI.
- 🔴 **PR > 1000 LOC = split obowiązkowy** — wyjątek: auto-gen, migrations.
- 🟡 **Review < 24h** — nie blokuj autora.
- 🟡 **Resolve conversations** — każdy komentarz resolved przed merge.
- 🟡 **Testy w tym samym PR co kod**.
- 🟡 **Squash merge** jako default — PR title = commit message (Conventional Commits).

---

## 5. Branch Protection

> Deep dive → `references/04-branch-protection.md`

### Rekomendowane ustawienia dla `main`

| Ustawienie | Wartość | Priorytet |
|-----------|---------|-----------|
| Require PR before merging | ✅ | 🔴 MUST |
| Required approvals | 1 (solo/small) / 2 (team) | 🔴 MUST |
| Dismiss stale reviews on new push | ✅ | 🟡 |
| Require review from code owners | ✅ | 🟡 |
| Require status checks to pass | ✅ | 🔴 MUST |
| Require branches up to date | ✅ | 🟡 |
| Require conversation resolution | ✅ | 🟡 |
| Require linear history | ✅ | 🟢 |
| Allow force pushes | ❌ | 🔴 NIGDY |
| Allow deletions | ❌ | 🔴 NIGDY |

### CODEOWNERS

Plik `.github/CODEOWNERS` — automatyczny assignment reviewerów:

```
*                           @default-reviewer
/src/auth/                  @security-team
/src/api/                   @backend-team
*.py                        @python-team
/.github/workflows/         @devops-team
```

> Ostatni match wygrywa. Owners muszą mieć write access.

### ⛔ HARD RULES protection

- 🔴 **NIGDY `Allow force pushes` na `main`** — utrata historii = katastrofa.
- 🔴 **NIGDY `Allow deletions` na `main`**.
- 🔴 **Min 1 required approval** — nawet solo project.
- 🟡 **Status checks muszą istnieć** — dodaj CI ZANIM włączysz require checks.
- 💡 **Rulesets > Classic** — nowa generacja, stackowalne, audytowalne.

---

## 6. Versioning & Releases

> Deep dive → `references/05-versioning-releases.md`

### SemVer 2.0.0

**Format:** `MAJOR.MINOR.PATCH[-prerelease][+build]`

| Zmieniłem... | Bump | Przykład |
|-------------|------|---------|
| Breaking API change (usunięcie, zmiana sygnatury) | **MAJOR** | `1.0.0 → 2.0.0` |
| Nowa feature (backward-compatible) | **MINOR** | `1.0.0 → 1.1.0` |
| Bug fix, performance (backward-compatible) | **PATCH** | `1.0.0 → 1.0.1` |

### Git Tags

```bash
# ✅ Annotated (ZAWSZE)
git tag -a v1.2.0 -m "Release 1.2.0: description"
git push origin v1.2.0

# ❌ Lightweight (brak metadata)
git tag v1.2.0
```

### Keep a Changelog — sekcje

| Sekcja | Kiedy |
|--------|-------|
| `Added` | Nowe features |
| `Changed` | Zmiany w istniejącej funkcjonalności |
| `Deprecated` | Oznaczone do usunięcia |
| `Removed` | Usunięte features |
| `Fixed` | Bug fixes |
| `Security` | Vulnerability fixes (🔴 najważniejsze) |

### ⛔ HARD RULES versioning

- 🔴 **Breaking change = MAJOR** — zawsze, bez wyjątków.
- 🔴 **Opublikowana wersja jest immutable**.
- 🔴 **Annotated tags** — zawsze `-a` (metadata).
- 🔴 **Tag = immutable** — nigdy nie przesuwaj taga.
- 🟡 **`v` prefix** — `v1.2.0` (convention).
- 🟡 **`[Unreleased]` zawsze na top** changeloga.
- 🟡 **Changelog z perspektywy usera** — nie impl details.

---

## 7. Git Hooks

> Deep dive → `references/06-git-hooks.md`

### Hook types

| Hook | Kiedy | Use case | Blocking? |
|------|-------|----------|-----------|
| `pre-commit` | Przed commit | Lint, format, security scan | ✅ |
| `commit-msg` | Przed zapisaniem msg | Walidacja Conventional Commits | ✅ |
| `pre-push` | Przed push | Run tests | ✅ |
| `post-merge` | Po merge | Auto install deps jeśli lockfile zmieniony | ❌ |

### Pre-commit (Python) — kluczowe hooki

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit  # lint + format
  - repo: https://github.com/pre-commit/pre-commit-hooks
    hooks:
      - id: check-yaml
      - id: check-merge-conflict
      - id: detect-private-key      # ← security!
      - id: no-commit-to-branch     # ← blokuj direct commit na main
        args: ['--branch', 'main']
  - repo: https://github.com/commitizen-tools/commitizen # commit msg validation
    hooks:
      - id: commitizen
        stages: [commit-msg]
  - repo: https://github.com/Yelp/detect-secrets         # secret scanning
```

### ⛔ HARD RULES hooks

- 🔴 **`.pre-commit-config.yaml` commitowany** — shared z zespołem.
- 🔴 **`detect-private-key` always on** — catch secrets before push.
- 🔴 **`no-commit-to-branch` na `main`**.
- 🟡 **`--no-verify` to emergency exit** — nie nawyk.
- 🟡 **Pre-commit < 10s** — ciężkie testy przenieś do CI.

---

## 8. Advanced Git

> Deep dive → `references/07-advanced-git.md`

### Tabela decyzyjna

| Chcę... | Komenda | Bezpieczne? |
|---------|---------|-------------|
| Posprzątać commity przed PR | `rebase -i` | 🟡 Local only |
| Odłożyć WIP na chwilę | `stash push -m "opis"` | 🟢 |
| Przenieść konkretny fix | `cherry-pick <hash>` | 🟢 |
| Znaleźć buggy commit | `bisect start` → `bisect run pytest ...` | 🟢 |
| Odzyskać "stracone" commity | `reflog` → `reset --hard <hash>` | 🟢 |
| Cofnij commit (local) | `reset --soft HEAD~1` | 🟡 Local |
| Cofnij commit (shared branch) | `revert <hash>` | 🟢 |
| Wyczyść wszystko (nuclear) | `reset --hard HEAD~1` | 🔴 Destrukcyjne! |

### Reset modes

| Typ | Commit | Staged | Working dir |
|-----|--------|--------|-------------|
| `--soft` | ❌ Cofnięty | ✅ Zachowany | ✅ Zachowany |
| `--mixed` (default) | ❌ Cofnięty | ❌ Unstaged | ✅ Zachowany |
| `--hard` | ❌ Cofnięty | ❌ Usunięty | ❌ Usunięty |

### Interactive Rebase — komendy edytora

```
pick   — zostaw jak jest
reword — zmień commit message
fixup  — squash do poprzedniego (bez msg)
squash — squash do poprzedniego (merge msg)
drop   — usuń commit
edit   — zatrzymaj, pozwól edytować
```

### ⛔ HARD RULES advanced git

- 🔴 **NIGDY rebase/reset --hard/push --force na shared branch** (main, develop).
- 🔴 **Po rebase: `--force-with-lease`** — nie `--force`.
- 🟡 **Squash WIP commitów przed PR** — reviewer widzi clean history.
- 🟡 **Stash = tymczasowy** — nie long-term storage. Commituj!
- 💡 **Reflog = safety net** — istnieje ~30 dni, odzyskasz "stracone" commity.

---

## 9. .gitignore

> Deep dive → `references/08-gitignore.md`

### Co NIGDY nie commituj

| 🔴 ABSOLUTNE | 🟡 POWINNO BYĆ IGNOROWANE |
|-------------|--------------------------|
| `.env`, API keys, tokens, passwords | `node_modules/`, `.venv/`, `__pycache__/` |
| `*.pem`, `*.key`, `id_rsa` | `dist/`, `build/`, `*.pyc` |
| `*.db`, `*.sqlite3` (z danymi) | `.idea/`, `.vscode/settings.json` |
| Auth tokens, service accounts | `.DS_Store`, `Thumbs.db` |

### Co jest OK do commitowania

`.env.example` (template bez wartości), `.vscode/extensions.json`, lock files (`uv.lock`, `package-lock.json`), `docker-compose.yml`.

### Key syntax

```gitignore
build/           # ignoruj folder
*.log            # wildcard
!.gitkeep        # negacja (NIE ignoruj)
**/build/        # dowolna głębokość
.env             # ignoruj
!.env.example    # ale NIE ignoruj template
```

### ⛔ HARD RULES gitignore

- 🔴 **Secrets NIGDY w repo** — nawet na 1 sekundę. Raz w historii = compromised.
- 🔴 **Jeśli secret wyciekł → rotate keys NATYCHMIAST** (usunięcie z repo NIE wystarczy).
- 🔴 **`.gitignore` PRZED pierwszym commitem**.
- 🟡 **Plik tracked + dodany do .gitignore = dalej tracked** — potrzebny `git rm --cached`.
- 🟡 **Lock files COMMITUJ** — reproducible builds.

---

## 10. GitHub Repo Setup

> Deep dive → `references/09-github-repo-setup.md`

### Community health files — checklist

| Plik | Lokalizacja | Priorytet |
|------|-------------|-----------|
| `README.md` | root | 🔴 MUST |
| `LICENSE` | root | 🔴 MUST (MIT = safe default) |
| `.gitignore` | root | 🔴 MUST |
| `CONTRIBUTING.md` | root / `.github/` | 🟡 |
| `CODE_OF_CONDUCT.md` | root | 🟡 (Contributor Covenant) |
| `SECURITY.md` | root / `.github/` | 🟡 |
| `.github/CODEOWNERS` | `.github/` | 🟡 |
| `.github/ISSUE_TEMPLATE/` | `.github/` | 🟡 (bug_report.yml + feature_request.yml) |
| `.github/PULL_REQUEST_TEMPLATE.md` | `.github/` | 🟡 |
| `.github/dependabot.yml` | `.github/` | 🟡 |

### README structure

```markdown
# Project Name
> One-liner: co to robi i dla kogo.

[![CI](badge)](link) [![License](badge)](LICENSE)

## Features / Quick Start / Installation / Usage
## Documentation / Contributing / License
```

### Repository Settings

| Setting | Rekomendacja |
|---------|-------------|
| Default branch | `main` |
| Auto-delete branches | ✅ Enable |
| Merge strategies | Squash merge (default) |
| Topics | 3-5 relevantnych |
| Description | Jasny one-liner |
| Wiki | Disable (use `docs/`) |

### ⛔ HARD RULES repo setup

- 🔴 **Brak licencji = all rights reserved** — nikt nie ma prawa kopiować.
- 🔴 **Wybierz licencję PRZED pierwszym commitem**.
- 🟡 **MIT = safe default** — sprawdź licencje dependencji (GPL = viral).
- 🟡 **SECURITY.md musi zawierać** — jak zgłaszać vulnerabilities, timeline response.

---

## 11. CI/CD & GitHub Actions

> Deep dive → `references/10-ci-cd-actions.md`

### Workflow anatomy

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
permissions:
  contents: read    # principle of least privilege
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync --all-extras
      - run: uv run ruff check .
      - run: uv run ruff format --check .
  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync --all-extras
      - run: uv run pytest --cov
```

### Kluczowe patterns

| Pattern | Kiedy |
|---------|-------|
| `paths:` / `paths-ignore:` | Filtruj po zmienionych plikach |
| `matrix: python-version: ["3.11", "3.12"]` | Multi-version testing |
| `needs: lint` | Dependency między jobami |
| `cache: "pip"` / `enable-cache: true` (uv) | Przyspieszenie CI |
| `workflow_dispatch:` | Manual trigger |
| `schedule: cron` | Scheduled runs |
| `workflow_call:` | Reusable workflows |
| `environment: production` | Deploy z manual approval |

### Status badge

```markdown
[![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/USER/REPO/actions/workflows/ci.yml)
```

### ⛔ HARD RULES CI/CD

- 🔴 **NIGDY nie loguj secrets** — `echo $SECRET` w logach = wyciek.
- 🔴 **Secrets NIGDY w kodzie** — zawsze `${{ secrets.X }}`.
- 🔴 **`permissions:` explicit** — principle of least privilege.
- 🔴 **Environment protection na production** — manual approval.
- 🟡 **Cache ZAWSZE** — uv/pip/npm cache drastycznie przyspiesza CI.
- 🟡 **`fail-fast: false` w matrix** — nie przerywaj na pierwszym failure.
- 🟡 **Rotate secrets co 90 dni**.

---

## 12. Security & Signing

> Deep dive → `references/11-security-signing.md`

### Commit signing (GPG vs SSH)

| Aspekt | GPG | SSH |
|--------|-----|-----|
| Setup complexity | 🔴 Skomplikowane | 🟢 Proste |
| GitHub Verified badge | ✅ | ✅ |
| Rekomendacja | Enterprise | Zwykli devs ← DEFAULT |

**SSH signing setup:**

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
# → GitHub → Settings → SSH and GPG keys → New SSH key (Signing Key type)
```

### Dependabot

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule: { interval: "weekly" }
    labels: ["dependencies"]
    commit-message: { prefix: "chore" }
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule: { interval: "weekly" }
    commit-message: { prefix: "ci" }
```

### Jeśli secret wyciekł

1. 🔴 **NATYCHMIAST rotate credentials** — usunięcie z repo NIE wystarczy (historia!).
2. Użyj BFG Repo Cleaner do usunięcia z historii.
3. Force push (po coordination z zespołem).

### ⛔ HARD RULES security

- 🔴 **Secrets raz w historii = compromised** — rotate > delete.
- 🔴 **Dependabot ON** — przestarzałe deps = vulnerabilities.
- 🔴 **Push protection ON** (Settings → Code security) — blokuj secrety PRZED push.
- 🟡 **Signing = trust** — bez podpisu nie wiadomo kto commitował.
- 🟡 **Vigilant mode** — oznacza unsigned commity jako "Unverified".
- 🟡 **CodeQL on schedule** — weekly scan nawet bez zmian.

---

# 📦 DEEP DIVE REFERENCES

Poniżej lista pełnych plików referencyjnych. Każdy jest self-contained z Quick Reference, ✅/❌ parami i pełnymi przykładami.

```
references/
├── 00-workflow-models.md      — GitHub Flow, Git-flow, Trunk-Based Dev
├── 01-branching.md            — Nazewnictwo, lifecycle, cleanup
├── 02-conventional-commits.md — Format, types, scopes, body/footer
├── 03-pull-requests.md        — PR size, review, merge strategies, templates
├── 04-branch-protection.md    — Rules, CODEOWNERS, rulesets
├── 05-versioning-releases.md  — SemVer, tagi, changelog, GitHub Releases
├── 06-git-hooks.md            — pre-commit, husky, lint-staged, commitlint
├── 07-advanced-git.md         — rebase, stash, cherry-pick, bisect, reflog
├── 08-gitignore.md            — Patterns, templates Python/Node/universal
├── 09-github-repo-setup.md    — README, CONTRIBUTING, templates, license
├── 10-ci-cd-actions.md        — GitHub Actions, matrix, caching, reusable
└── 11-security-signing.md     — GPG/SSH signing, Dependabot, scanning
```

---

## Powiązane pliki

| Plik | Relacja |
|------|---------|
| `.github/copilot-instructions.md` | Baseline — polityka warstw |
| `.github/skills/python/` | Cross-ref: pyproject.toml, uv, CI config |
