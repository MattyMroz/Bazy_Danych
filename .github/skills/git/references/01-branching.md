# 01 — Branching

> **Cel:** Konwencje nazewnictwa branchy, strategia tworzenia i lifecycle management.
> **Scope:** Przenośny — niezależny od repozytorium. Dopasuj konwencję do wybranego workflow modelu.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Konwencja nazewnictwa](#1-konwencja-nazewnictwa)
3. [Typy branchy](#2-typy-branchy)
4. [Lifecycle branchy](#3-lifecycle-branchy)
5. [Cleanup i maintenance](#4-cleanup-i-maintenance)

> **Workflow models** → patrz `00-workflow-models.md`
> **Branch protection** → patrz `04-branch-protection.md`

---

## 📋 Quick Reference

**Format:** `<type>/<ticket-or-scope>-<description>`

```bash
# ✅ Dobre nazwy
feature/user-authentication
feature/api/payment-endpoints
bugfix/login-redirect-loop
hotfix/xss-sanitization
release/v1.4.0
chore/upgrade-dependencies
docs/api-reference
ci/add-matrix-testing

# ❌ Złe nazwy
new-stuff                    # brak type prefix
feature/UserAuth             # PascalCase
Feature/login                # uppercase type
fix                          # za ogólne
my-branch                    # brak kontekstu
wip/something                # brak merge timeline
john/test                    # personal branch w shared repo
```

**Szybkie komendy:**

```bash
# Lista branchy z datą ostatniego commita
git branch -v --sort=-committerdate

# Filtruj po type
git branch -l 'feature/*'
git branch -l 'bugfix/*'

# Usuń zmergowane lokalne branche
git branch --merged main | grep -v 'main' | xargs git branch -d

# Usuń remote-tracking branchy, które już nie istnieją
git fetch --prune
```

---

## 1. Konwencja nazewnictwa

### Format

```
<type>/<scope>-<description>
```

| Element | Zasada | Przykład |
|---------|--------|----------|
| `type` | Prefix kategorii (lowercase) | `feature`, `bugfix`, `hotfix` |
| `scope` | Opcjonalny sub-moduł (po `/`) | `api`, `ui`, `db` |
| `description` | Krótki opis (kebab-case) | `add-login-form`, `fix-memory-leak` |

### Reguły twardej nazwy

| Reguła | Przykład ✅ | Antyprzykład ❌ |
|--------|-----------|----------------|
| 🔴 Lowercase + kebab-case | `feature/user-auth` | `Feature/UserAuth` |
| 🔴 Max 50 znaków (łącznie) | `bugfix/login-redirect` | `bugfix/fix-the-issue-where-user-gets-redirected-to-wrong-page` |
| 🔴 Prefix z type | `feature/dark-mode` | `dark-mode` |
| 🟡 Bez spacji i polskich znaków | `feature/user-settings` | `feature/ustawienia użytkownika` |
| 🟡 Referuj ticket jeśli jest | `feature/login-#42` | `feature/login` (gdy jest issue #42) |
| 🟡 Bez znaków specjalnych | `bugfix/null-pointer` | `bugfix/fix~this<thing>` |
| 🟢 Grupowanie scope | `feature/api/users` | `feature/api-users` (mniej czytelne) |

### Ticket reference w nazwie

```bash
# GitHub issue
feature/login-#42
bugfix/PROJ-123-null-check

# JIRA ticket
feature/JIRA-456-payment-flow
```

---

## 2. Typy branchy

| Type | Kiedy | Merge do | Prefix |
|------|-------|---------|--------|
| `feature/` | Nowa funkcjonalność | `main` (GH Flow) lub `develop` (Git-flow) | `feature/` |
| `bugfix/` | Fix istniejącego buga (non-urgent) | `main` / `develop` | `bugfix/` |
| `hotfix/` | Urgent production fix | `main` + `develop` | `hotfix/` |
| `release/` | Przygotowanie release'u | `main` + `develop` | `release/v*` |
| `chore/` | Maintenance (deps, config, refactor) | `main` / `develop` | `chore/` |
| `docs/` | Dokumentacja | `main` / `develop` | `docs/` |
| `test/` | Testy (dodawanie, refactor) | `main` / `develop` | `test/` |
| `perf/` | Performance optimization | `main` / `develop` | `perf/` |
| `ci/` | CI/CD pipeline changes | `main` / `develop` | `ci/` |
| `revert/` | Revert poprzedniego commita | `main` / `develop` | `revert/` |

### Przykłady per typ

```bash
feature/api/user-endpoints     # nowy endpoint API
feature/ui/dashboard-redesign  # nowy UI
bugfix/database/connection-leak # fix buga w DB
hotfix/auth-bypass             # urgent security fix
release/v1.4.0                 # przygotowanie release
chore/deps/upgrade-numpy       # aktualizacja dependencies
docs/api-reference             # dokumentacja API
test/e2e/login-flow            # testy E2E
perf/query-optimization        # optymalizacja zapytań
ci/add-docker-build            # nowy step w CI
```

---

## 3. Lifecycle branchy

### Tworzenie

```bash
# Zawsze z najnowszego main (lub develop w Git-flow)
git checkout main
git pull origin main
git checkout -b feature/new-widget

# Alternatywnie: z konkretnego commita/taga
git checkout -b hotfix/critical-fix v1.2.0
```

### Praca na branchu

```bash
# Regularne synchronizacje z main (unikaj merge conflicts)
git fetch origin
git rebase origin/main  # ← preferowane (liniowa historia)
# LUB
git merge origin/main   # ← jeśli branch jest shared

# Push (pierwszy raz z upstream)
git push -u origin feature/new-widget

# Kolejne pushe
git push
```

### ⛔ HARD RULES lifecycle

- 🔴 **Max lifetime: 1 tydzień** (GitHub Flow), **< 1 dzień** (TBD). Dłuższe = merge hell.
- 🔴 **Sync z main codziennie** — `git rebase origin/main` na swoim feature branch.
- 🔴 **Usuń branch po merge** — zero zombie branches.
- 🔴 **Nigdy force-push na shared branch** — `--force-with-lease` tylko na personal branch.
- 🟡 **1 feature = 1 branch = 1 PR** — nie pakuj wielu tasków w jeden branch.

---

## 4. Cleanup i maintenance

### Lokalne branche

```bash
# Pokaż zmergowane branche (safe do usunięcia)
git branch --merged main

# Usuń zmergowane (oprócz main i develop)
git branch --merged main | grep -vE '(main|develop)' | xargs git branch -d

# Pokaż NIE-zmergowane (ostrożnie!)
git branch --no-merged main

# Usuń konkretny branch
git branch -d feature/done       # safe (sprawdza merge status)
git branch -D feature/abandoned  # force (bez sprawdzania)
```

### Remote branche

```bash
# Prune — usuń lokalne referencje do branchy usuniętych na remote
git fetch --prune

# Pokaż stale remote branches
git branch -r --merged origin/main

# Usuń remote branch
git push origin --delete feature/old-branch
```

### Automatyzacja cleanup (GitHub)

Włącz w Settings → General:
- ✅ **Automatically delete head branches** — po merge PR branch jest usuwany.

### Audyt branchy

```bash
# Branche starsze niż 30 dni
git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short)' refs/heads/ | head -20

# Branche bez aktywności (remote)
gh api repos/{owner}/{repo}/branches --jq '.[].name'
```

### 💡 TIP: Zombie branch policy

Ustaw w zespole regułę:
> Branch > 2 tygodnie bez aktywności = autor robi cleanup (merge, rebase, lub delete).

Automatyzuj z GitHub Actions:

```yaml
# .github/workflows/stale-branches.yml
name: Stale Branch Cleanup
on:
  schedule:
    - cron: '0 0 * * 1'  # co poniedziałek
jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          stale-branch-message: "Branch inactive > 30 days. Delete or update."
          days-before-stale: 30
          days-before-delete: 60
```
