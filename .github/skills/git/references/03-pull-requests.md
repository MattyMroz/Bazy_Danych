# 03 — Pull Requests

> **Cel:** Best practices tworzenia, review i merge pull requestów.
> **Scope:** Przenośny — niezależny od projektu. Dopasuj szczegóły do workflow modelu.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Anatomia dobrego PR](#1-anatomia-dobrego-pr)
3. [Rozmiar PR](#2-rozmiar-pr)
4. [Code Review](#3-code-review)
5. [Merge Strategies](#4-merge-strategies)
6. [PR Template](#5-pr-template)
7. [Draft PRs](#6-draft-prs)

> **Branch protection** → patrz `04-branch-protection.md`
> **Conventional Commits (PR title)** → patrz `02-conventional-commits.md`

---

## 📋 Quick Reference

| Metryka | Rekomendacja |
|---------|-------------|
| **Rozmiar** | 200-400 LOC zmian (max 600-800) |
| **Reviewers** | 1-2 (min 1 wymagany) |
| **Review time** | < 4h od otwarcia (cel: < 24h) |
| **Lifetime** | < 3 dni (cel: same-day merge) |
| **Merge strategy** | Squash merge (default) |
| **Delete branch** | Zawsze po merge |

**Komendy:**

```bash
# Utwórz PR (GitHub CLI)
gh pr create --title "feat(auth): add login" --body "Closes #42"

# Lista PR
gh pr list

# Checkout PR lokalnie
gh pr checkout 42

# Merge PR
gh pr merge 42 --squash --delete-branch

# Review PR
gh pr review 42 --approve
gh pr review 42 --request-changes --body "Fix the validation"
```

---

## 1. Anatomia dobrego PR

### Tytuł

Format: **Conventional Commit** (identyczny jak commit message)

```bash
# ✅ Dobre
feat(auth): add two-factor authentication
fix(api): handle timeout on large payloads
docs: update contributing guidelines

# ❌ Złe
Update code
Fix stuff
WIP
PR #42
```

### Opis

```markdown
## Description
Krótkie streszczenie CO robisz i DLACZEGO.

## Related Issue
Closes #42

## Type of Change
- [ ] Bug fix (non-breaking)
- [x] New feature (non-breaking)
- [ ] Breaking change
- [ ] Documentation

## How Has This Been Tested?
- Unit tests: `test_auth.py`
- Manual: tested login flow in dev environment

## Screenshots (jeśli UI change)
| Before | After |
|--------|-------|
| screenshot | screenshot |

## Checklist
- [x] Code follows project conventions
- [x] Tests added for new functionality
- [x] All tests pass locally
- [x] Documentation updated (if needed)
- [x] No breaking changes (or documented in description)
```

---

## 2. Rozmiar PR

### Złota reguła

> **200-400 LOC** zmian (kod + testy) = optymalny PR.

| Rozmiar | LOC | Efekt na review |
|---------|-----|-----------------|
| 🟢 Ideal | 50-200 | Szybki, dokładny review |
| 🟡 OK | 200-400 | Standardowy review |
| 🟠 Duży | 400-800 | Wymaga więcej czasu, łatwo przeoczyć bugi |
| 🔴 Za duży | 800+ | Split na mniejsze PRy! |

### Dlaczego małe PRy?

- **Review quality** spada eksponencjalnie z rozmiarem
- **Time to merge** rośnie (reviewer odkłada duży PR na "później")
- **Merge conflicts** rosną z czasem
- **Revert** prostszy (1 mały PR vs 1 mega PR)

### Jak rozdzielić duży PR

```bash
# Strategia 1: Vertical slicing (feature po feature)
PR1: feat(auth): add user model and migration
PR2: feat(auth): add login endpoint
PR3: feat(auth): add password reset flow
PR4: test(auth): add integration tests

# Strategia 2: Horizontal slicing (warstwa po warstwie)
PR1: refactor(db): add database migration for users table
PR2: feat(api): add user CRUD endpoints
PR3: feat(ui): add user management UI

# Strategia 3: Prep + implement
PR1: refactor: extract validation into separate module (prep)
PR2: feat(auth): add input validation using extracted module
```

### ⛔ HARD RULES rozmiar

- 🔴 **PR > 1000 LOC = split obowiązkowy** — wyjątek: auto-generated code, migrations.
- 🟡 **1 PR = 1 logiczna zmiana** — nie pakuj bugfixa + feature + refactora.
- 🟡 **Testy w tym samym PR co kod** — nie osobne PRy na testy.

---

## 3. Code Review

### Rola reviewera

| Odpowiedzialność | Opis |
|------------------|------|
| **Correctness** | Czy kod robi to, co obiecuje PR title? |
| **Design** | Czy architektura jest sensowna? |
| **Tests** | Czy są testy? Czy pokrywają edge cases? |
| **Readability** | Czy za 6 miesięcy zrozumiem ten kod? |
| **Security** | Czy nie ma vulnerability? (injection, XSS, secrets) |
| **Convention** | Czy kod respektuje styl projektu? |

### Etykieta review

| ✅ Dobrze | ❌ Źle |
|----------|--------|
| "Consider using `Optional[str]` here for clarity" | "This is wrong, fix it" |
| "Nit: trailing whitespace" (prefix `nit:`) | "Terrible code" |
| "Could we add a test for empty input?" | "Where are the tests??" |
| "I'd prefer X because Y, but your call" | "Just use X" |
| Linkuj do docs/standards | "Everyone knows this" |

### Prefixes w review comments

| Prefix | Znaczenie | Wymaganie |
|--------|-----------|-----------|
| (brak) | Normalne suggestion | Must fix before merge |
| `nit:` | Nitpick (kosmetyka) | Nice to fix, non-blocking |
| `question:` | Pytanie o kontekst | Wyjaśnij, nie fixuj |
| `suggestion:` | Alternatywne podejście | Rozważ, nie obowiązkowe |
| `blocker:` | Blocker — nie mergujemy bez fix | Must fix |
| `praise:` | Chwalę! Dobry kod | 😊 |

### Workflow review

```
Author: Otwórz PR → Assign reviewers
  ↓
Reviewer: Review → Comments / Approve / Request Changes
  ↓
Author: Address comments → Push fixes → Re-request review
  ↓
Reviewer: Re-review → Approve
  ↓
Author: Merge (squash) → Delete branch
```

### ⛔ HARD RULES review

- 🔴 **Min 1 approval przed merge** — zero self-merge (wyjątek: solo project).
- 🔴 **CI musi przejść** — nie approve PR z czerwonym CI.
- 🟡 **Review < 24h** — nie blokuj autora na tydzień.
- 🟡 **Resolve conversations** — każdy komentarz resolved przed merge.
- 🟢 **Praise dobre rzeczy** — nie tylko krytykuj.

---

## 4. Merge Strategies

### Porównanie

| Strategy | Historia | Kiedy | Komenda |
|----------|---------|-------|---------|
| **Squash merge** | 1 commit per PR | Features, bugfixy, chores | `gh pr merge --squash` |
| **Rebase merge** | Oryginalne commity, liniowa historia | Małe zmiany, atomic commits | `gh pr merge --rebase` |
| **Merge commit** | Merge node w historii | Release branches, hotfixy | `gh pr merge --merge` |

### Squash merge (default recommendation)

```bash
# PR z 5 commitami → 1 commit na main
# Commit message = PR title
gh pr merge --squash --delete-branch

# Wynik na main:
# a1b2c3 feat(auth): add two-factor authentication (#42)
```

**Zalety:**
- ✅ Czysta historia (1 commit = 1 feature)
- ✅ Łatwy bisect, revert
- ✅ PR title = commit message (Conventional Commits)

**Wady:**
- ❌ Tracisz granularne commity z brancha (zwykle OK)

### Rebase merge

```bash
# PR z 3 commitami → 3 commity na main (rebased)
gh pr merge --rebase --delete-branch

# Wynik na main:
# a1b2c3 feat(auth): add login endpoint
# d4e5f6 feat(auth): add password validation
# g7h8i9 test(auth): add tests for login flow
```

**Zalety:**
- ✅ Zachowuje atomic commits
- ✅ Liniowa historia (brak merge nodes)

**Wady:**
- ❌ Wymaga dobrych granularnych commitów (rzadko w praktyce)
- ❌ Szum jeśli commity to WIP/fixup

### Merge commit

```bash
# PR → merge node na main
gh pr merge --merge --delete-branch

# Wynik na main:
# m1n2o3 Merge pull request #42 from feature/auth
```

**Zalety:**
- ✅ Pełna historia (kiedy branch powstał, kiedy zmergowany)
- ✅ Atomowa granica (cały PR = 1 merge commit revertable)

**Wady:**
- ❌ "Noisy" historia (dużo merge nodes)
- ❌ Trudniejszy bisect

### Rekomendacja

> 💡 **Default: Squash merge** dla feature branches.
> **Rebase** gdy commity są już atomic i chcesz je zachować.
> **Merge commit** dla release/hotfix branches w Git-flow.

---

## 5. PR Template

Stwórz plik `.github/pull_request_template.md`:

```markdown
## Description

Brief summary of changes and motivation.

## Related Issue

Closes #

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Refactoring (no functional changes)
- [ ] CI/CD changes

## Testing

Describe the tests you ran and how to reproduce.

## Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally
- [ ] I have updated documentation accordingly
- [ ] My changes generate no new warnings
```

---

## 6. Draft PRs

### Kiedy używać

- Chcesz early feedback zanim skończysz
- Praca w toku — sygnalizujesz "nie mergujcie jeszcze"
- Chcesz uruchomić CI na swoim branchu

### Workflow

```bash
# Utwórz draft PR
gh pr create --draft --title "feat(auth): add login [WIP]"

# Kiedy gotowy → mark as ready
gh pr ready
```

### ⛔ HARD RULES draft

- 🔴 **Draft PR = not reviewable** — nie proś o formal review.
- 🟡 **Zamień na ready gdy skończysz** — nie zostawiaj draft na wieki.
- 🟢 **Używaj do CI dry-run** — sprawdź czy CI przechodzi zanim poprosisz o review.
