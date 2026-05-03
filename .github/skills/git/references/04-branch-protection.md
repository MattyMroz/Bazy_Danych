# 04 — Branch Protection

> **Cel:** Konfiguracja branch protection rules na GitHub — required reviews, CI checks, CODEOWNERS.
> **Scope:** GitHub-specific. Koncepcyjnie transferowalne do GitLab/Bitbucket.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Protection Rules dla main](#1-protection-rules-dla-main)
3. [CODEOWNERS](#2-codeowners)
4. [Rulesets (nowa generacja)](#3-rulesets-nowa-generacja)
5. [Konfiguracja per branch pattern](#4-konfiguracja-per-branch-pattern)

> **Workflow models** → patrz `00-workflow-models.md`
> **CI checks** → patrz `10-ci-cd-actions.md`

---

## 📋 Quick Reference

**Gdzie:** Settings → Branches → Add branch protection rule (classic) LUB Settings → Rules → Rulesets (nowe)

**Rekomendowane ustawienia dla `main`:**

| Ustawienie | Wartość | Priorytet |
|-----------|---------|-----------|
| Require pull request before merging | ✅ | 🔴 MUST |
| Required approvals | 1 (solo/small) / 2 (team) | 🔴 MUST |
| Dismiss stale reviews on new push | ✅ | 🟡 SHOULD |
| Require review from code owners | ✅ | 🟡 SHOULD |
| Require status checks to pass | ✅ | 🔴 MUST |
| Require branches to be up to date | ✅ | 🟡 SHOULD |
| Require conversation resolution | ✅ | 🟡 SHOULD |
| Require linear history | ✅ | 🟢 NICE |
| Allow force pushes | ❌ | 🔴 MUST |
| Allow deletions | ❌ | 🔴 MUST |

**CLI:**

```bash
# Włącz auto-delete branchy po merge
gh repo edit --delete-branch-on-merge

# Włącz auto-merge
gh repo edit --enable-auto-merge
```

---

## 1. Protection Rules dla main

### Wymaganie PR (Require pull request before merging)

```
✅ Require a pull request before merging
  ├── Required number of approvals before merging: 1
  ├── ✅ Dismiss stale pull request approvals when new commits are pushed
  ├── ✅ Require review from Code Owners
  └── ✅ Require approval of the most recent push
```

**Co daje:**
- Zero direct push na `main` — każda zmiana musi przejść przez PR.
- Stary approval jest unieważniany gdy autor pushnie nowe commity (security).
- CODEOWNERS mogą blokować merge jeśli ich pliki się zmienią.

### Status Checks (Require status checks to pass)

```
✅ Require status checks to pass before merging
  ├── ✅ Require branches to be up to date before merging
  └── Status checks:
      ├── lint (workflow: lint.yml)
      ├── test (workflow: test.yml)
      └── typecheck (workflow: typecheck.yml)
```

**Co daje:**
- CI musi przejść zanim PR może być zmergowany.
- Branch musi być up-to-date z `main` (rebase/merge required).

### Conversation Resolution

```
✅ Require conversation resolution before merging
```

**Co daje:**
- Wszystkie review comments muszą być resolved (nie "approved with comments" → merge).

### Historia i force push

```
✅ Require linear history
❌ Allow force pushes (NIGDY!)
❌ Allow deletions (NIGDY!)
```

**Co daje:**
- Linear history = brak merge commits, czysta linia (squash/rebase only).
- Brak force push = historia jest immutable.
- Brak deletions = `main` nie może być usunięty.

### ⛔ HARD RULES protection

- 🔴 **Nigdy `Allow force pushes` na `main`** — utrata historii = katastrofa.
- 🔴 **Nigdy `Allow deletions` na `main`** — usunięcie main = projekt zniknął.
- 🔴 **Min 1 required approval** — nawet w solo project warto (delay = quality).
- 🟡 **Status checks muszą istnieć** — dodaj CI ZANIM włączysz require checks.

---

## 2. CODEOWNERS

### Czym jest?

Plik definiujący kto jest odpowiedzialny za review zmian w danym katalogu/pliku. GitHub automatycznie assignuje reviewerów.

### Lokalizacja

```
.github/CODEOWNERS       ← preferowane
CODEOWNERS               ← alternatywne (root)
docs/CODEOWNERS           ← alternatywne
```

### Składnia

```
# CODEOWNERS

# Default — catch-all (wszyscy zmiany wymagają review od tych osób)
*                           @username

# Specyficzne katalogi
/src/auth/                  @security-team
/src/api/                   @backend-team
/frontend/                  @frontend-team
/docs/                      @docs-team

# Specyficzne pliki
/pyproject.toml             @lead-dev
/.github/workflows/         @devops-team
/SECURITY.md                @security-team

# Wiele osób (min 1 musi approve)
/src/database/              @dba-team @backend-team

# Pattern matching
*.py                        @python-team
*.ts                        @frontend-team
*.yml                       @devops-team
```

### Reguły CODEOWNERS

| Reguła | Opis |
|--------|------|
| Ostatni match wygrywa | Bardziej specyficzny pattern na dole |
| `@username` | Osoba z write access |
| `@org/team` | GitHub team |
| email | `user@example.com` |
| Pattern `*` | Wildcard (dowolny plik) |
| Pattern `*.py` | Wszystkie pliki .py |
| Pattern `/src/` | Katalog src od root |

### ⛔ HARD RULES CODEOWNERS

- 🔴 **CODEOWNERS muszą mieć write access** — inaczej GitHub ignoruje wpis.
- 🟡 **Nie za dużo owners** — 2-3 per area, nie 10.
- 🟡 **Aktualizuj regularnie** — stale CODEOWNERS = martwi reviewerzy.

---

## 3. Rulesets (nowa generacja)

### Czym są?

Rulesets (od 2023) = ulepszony branch protection:
- Obowiązuje dla branchy ORAZ tagów
- Stackowalne (wiele rulesets na raz)
- Wersjonowane i audytowalne
- Dostępne na organization scope

### Konfiguracja

Settings → Rules → New ruleset:

```yaml
Name: Protect main
Enforcement: Active
Target: default branch (main)

Rules:
  - Restrict creations: ✅
  - Restrict deletions: ✅
  - Require pull request:
      required_approving_review_count: 1
      dismiss_stale_reviews_on_push: true
      require_code_owner_review: true
  - Require status checks:
      required_checks:
        - context: lint
        - context: test
      strict_required_status_checks_policy: true
  - Require linear history: ✅
  - Block force pushes: ✅
```

### Classic vs Rulesets

| Feature | Classic | Rulesets |
|---------|---------|---------|
| Branch only | ✅ | ✅ + tagi |
| Stackable | ❌ | ✅ |
| Org-level | ❌ | ✅ |
| Audit log | ❌ | ✅ |
| API/IaC | Ograniczone | Pełne |
| Bypass actors | Admin only | Configurable |

> 💡 **Rekomendacja:** Używaj Rulesets dla nowych projektów. Classic jest legacy ale wciąż działa.

---

## 4. Konfiguracja per branch pattern

### Typowe patterns

| Pattern | Opis | Protection level |
|---------|------|-----------------|
| `main` | Produkcja | 🔴 Maximum |
| `develop` | Integration (Git-flow) | 🟡 Medium |
| `release/*` | Release prep | 🔴 High |
| `hotfix/*` | Urgent fix | 🟡 Medium |
| `feature/*` | Development | 🟢 Minimum |

### Rekomendowane ustawienia per pattern

**`main` (max protection):**
- Required approvals: 1-2
- Dismiss stale reviews: ✅
- Require code owner review: ✅
- Require status checks: ✅ (lint + test + typecheck)
- Require up-to-date: ✅
- Linear history: ✅
- No force push: ✅
- No deletions: ✅

**`develop` (medium protection):**
- Required approvals: 1
- Require status checks: ✅ (test only)
- No force push: ✅

**`release/*` (high protection):**
- Required approvals: 2
- Require code owner review: ✅
- Require status checks: ✅ (full pipeline)
- No force push: ✅

**`feature/*` (minimal):**
- Bez protection (developer ma pełną kontrolę)
- CI uruchamia się ale nie blokuje
