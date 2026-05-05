# 07 — Advanced Git

> **Cel:** Zaawansowane komendy Git: rebase, stash, cherry-pick, bisect, reflog, reset, revert.
> **Scope:** Przenośny — komendy Git niezależne od platformy.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Interactive Rebase](#1-interactive-rebase)
3. [Stash](#2-stash)
4. [Cherry-pick](#3-cherry-pick)
5. [Bisect](#4-bisect)
6. [Reflog](#5-reflog)
7. [Reset vs Revert](#6-reset-vs-revert)
8. [Tabela decyzyjna](#7-tabela-decyzyjna)

> **Workflow i merge** → patrz `00-workflow-models.md`
> **PR merge strategies** → patrz `03-pull-requests.md`

---

## 📋 Quick Reference

| Komenda | Kiedy | Ryzyko |
|---------|-------|--------|
| `git rebase -i HEAD~N` | Przebuduj ostatnie N commitów | 🟡 Rewrites history |
| `git stash` | Schowaj WIP zmiany tymczasowo | 🟢 Bezpieczne |
| `git cherry-pick <hash>` | Skopiuj konkretny commit | 🟢 Bezpieczne |
| `git bisect start` | Znajdź buggy commit (binary search) | 🟢 Bezpieczne |
| `git reflog` | Odzyskaj "stracone" commity | 🟢 Ratunek |
| `git reset --soft HEAD~1` | Cofnij commit (zachowaj zmiany) | 🟡 Local only |
| `git reset --hard HEAD~1` | Cofnij commit (USUŃ zmiany) | 🔴 Destrukcyjne! |
| `git revert <hash>` | Odwróć commit (nowy commit) | 🟢 Bezpieczne |

**Zasada złota:**

> ⛔ Nigdy nie `rebase` / `reset --hard` / `push --force` na shared branches (main, develop).
> Tylko na SWOIM osobistym branchu.

---

## 1. Interactive Rebase

### Czym jest?

Przebudowa historii commitów — squash, reword, reorder, drop, split.

### Użycie

```bash
# Edytuj ostatnie 3 commity
git rebase -i HEAD~3

# Edytuj od konkretnego commita
git rebase -i a1b2c3^  # ^ = inclusive

# Rebase na top of main (synchronizacja)
git checkout feature/my-branch
git rebase origin/main
```

### Komendy w edytorze

```
pick   a1b2c3 feat: add login form       ← zostaw jak jest
reword d4e5f6 fix: typo in validation     ← zmień commit message
fixup  g7h8i9 fix: another typo           ← squash do poprzedniego (bez msg)
squash j0k1l2 refactor: extract helper    ← squash do poprzedniego (merge msg)
drop   m3n4o5 WIP: temp debugging code    ← usuń commit
edit   p6q7r8 feat: add auth middleware   ← zatrzymaj, pozwól edytować
```

### Scenariusze

#### Squash WIP commitów przed PR

```bash
# Masz 5 commitów, chcesz 1
git rebase -i HEAD~5

# W edytorze:
pick   a1b2c3 feat: add login
fixup  d4e5f6 WIP: half done
fixup  g7h8i9 WIP: more progress
fixup  j0k1l2 fix: typo
fixup  m3n4o5 test: add tests

# Rezultat: 1 commit "feat: add login" z kodem ze wszystkich 5
```

#### Zmiana commit message

```bash
git rebase -i HEAD~2

# W edytorze: zmień 'pick' na 'reword'
reword a1b2c3 fix: wrong message

# Git otworzy edytor — wpisz nowy message
```

#### Reorder commitów

```bash
git rebase -i HEAD~3

# Zmień kolejność linii
pick  g7h8i9 test: add tests      ← był trzeci, teraz pierwszy
pick  a1b2c3 feat: add login      ← był pierwszy, teraz drugi
pick  d4e5f6 docs: update readme   ← bez zmian
```

### Conflict handling

```bash
# Jeśli conflict w trakcie rebase
# 1. Rozwiąż conflict w plikach
# 2. Stage
git add .
# 3. Kontynuuj
git rebase --continue

# LUB abort (cofnij do stanu sprzed rebase)
git rebase --abort
```

### ⛔ HARD RULES rebase

- 🔴 **NIGDY rebase na shared branch** — łamie historię innym developerom.
- 🔴 **Po rebase: `--force-with-lease`** — nie `--force` (safety check).
- 🟡 **Rebase PRZED utworzeniem PR** — nie po code review.
- 🟡 **Squash WIP commitów** — reviewer widzi clean history.

---

## 2. Stash

### Czym jest?

Tymczasowe schowanie zmian (staged + unstaged) bez commitowania.

### Basic usage

```bash
# Schowaj wszystko
git stash

# Schowaj z opisem
git stash push -m "WIP: half-done feature"

# Schowaj tylko staged
git stash push --staged

# Schowaj konkretne pliki
git stash push -m "only auth files" -- src/auth/

# Lista stashów
git stash list
# stash@{0}: On feature/auth: WIP: half-done feature
# stash@{1}: WIP on main: abc1234 Previous work

# Przywróć ostatni (i usuń z listy)
git stash pop

# Przywróć konkretny (bez usuwania)
git stash apply stash@{1}

# Usuń stash
git stash drop stash@{0}

# Usuń wszystkie
git stash clear

# Pokaż diff stasha
git stash show -p stash@{0}

# Utwórz branch z stasha
git stash branch feature/recovered stash@{0}
```

### Use case: Context switching

```bash
# Pracujesz nad feature A, szef mówi "fix production NOW"
git stash push -m "WIP: feature A"                   # schowaj

git checkout main && git pull                         # przejdź
git checkout -b hotfix/critical-bug                   # fix
git commit -m "fix: resolve critical production bug"
git push && gh pr create                              # push + PR

git checkout feature/my-branch                        # wróć
git stash pop                                         # przywróć WIP
```

### ⛔ HARD RULES stash

- 🟡 **Stash = tymczasowy** — nie używaj jako long-term storage (commituj!).
- 🟡 **Opisuj stashe** — `git stash push -m "opis"` zamiast raw `git stash`.
- 🟢 **Preferuj commit + amend nad stash** — commit jest bezpieczniejszy.

---

## 3. Cherry-pick

### Czym jest?

Kopiowanie konkretnego commita z jednego brancha do drugiego.

### Basic usage

```bash
# Skopiuj 1 commit
git checkout main
git cherry-pick a1b2c3

# Skopiuj zakres commitów
git cherry-pick a1b2c3..f8g9h0    # exclusive start
git cherry-pick a1b2c3^..f8g9h0   # inclusive start

# Cherry-pick bez auto-commit (stage only)
git cherry-pick --no-commit a1b2c3

# Abort jeśli conflict
git cherry-pick --abort

# Continue po resolve conflict
git cherry-pick --continue
```

### Use case: Backport bugfix do starszej wersji

```bash
# Fix jest na main, ale potrzebujesz go na release/1.2
git checkout release/1.2
git cherry-pick <hash-of-fix-commit>
git push origin release/1.2
```

### ⛔ HARD RULES cherry-pick

- 🟡 **Cherry-pick tworzy NOWY commit** — inny hash niż oryginał.
- 🟡 **Preferuj merge/rebase nad cherry-pick** — cherry-pick na exceptions.
- 🟡 **Dokumentuj cherry-pick** — w commit body: `Cherry-picked from <hash>`.

---

## 4. Bisect

### Czym jest?

Binary search po commitach — znajdź dokładnie który commit wprowadził buga.

### Workflow

```bash
# Start
git bisect start

# Oznacz aktualny jako bad (bug istnieje)
git bisect bad

# Oznacz known-good commit (bug nie istniał)
git bisect good v1.0.0

# Git checkoutuje commit w połowie — testuj!
# Jeśli bug jest:
git bisect bad

# Jeśli bug NIE jest:
git bisect good

# Powtarzaj — Git binary-searches do winowajcy
# Output: "First bad commit is a1b2c3..."

# Koniec — wróć do normalnego stanu
git bisect reset
```

### Automatyczny bisect

```bash
# Automatycznie testuj z skryptem
git bisect start HEAD v1.0.0
git bisect run pytest tests/test_auth.py -x

# Git uruchomi pytest na każdym kroku
# Exit code 0 = good, inny = bad
# Wynik: "First bad commit is..."
```

### Matematyka

| Commitów | Kroków max |
|----------|-----------|
| 10 | 4 |
| 100 | 7 |
| 1000 | 10 |
| 10 000 | 14 |

> 💡 200 commitów = max ~8 kroków zamiast ręcznego review 200 commitów.

---

## 5. Reflog

### Czym jest?

Lokalny log WSZYSTKICH zmian HEAD — nawet tych "utraconych" przez reset/rebase.

```bash
# Pokaż reflog
git reflog
# a1b2c3 HEAD@{0}: commit: feat: add login
# d4e5f6 HEAD@{1}: rebase: moving to origin/main
# g7h8i9 HEAD@{2}: reset: moving to HEAD~1    ← tu zrobiłeś reset!
# j0k1l2 HEAD@{3}: commit: feat: old work     ← "utracony" commit!

# Odzyskaj "utracony" commit
git checkout j0k1l2              # detached HEAD
git checkout -b recovered-work   # utwórz branch

# LUB przywróć branch do tego stanu
git reset --hard j0k1l2          # ⚠️ destrukcyjne! (ale przywraca)
```

### Use case: "Zgubiłem commity po rebase/reset"

```bash
# Coś poszło nie tak po rebase
git reflog
# Znajdź stan PRZED rebasem
# HEAD@{5}: checkout: moving from main to feature/auth  ← TU!

# Przywróć
git reset --hard HEAD@{5}
```

### ⛔ HARD RULES reflog

- 🟢 **Reflog to lokalna siatka bezpieczeństwa** — istnieje ~30 dni default.
- 🟢 **Reflog nie istnieje na remote** — tylko lokalnie.
- 💡 **Zanim zrobisz coś ryzykownego** — zanotuj `git log --oneline -5` (hash backup).

---

## 6. Reset vs Revert

### Reset (zmienia historię)

```bash
# Soft — cofnij commit, zachowaj zmiany staged
git reset --soft HEAD~1

# Mixed (default) — cofnij commit, zachowaj zmiany unstaged
git reset HEAD~1

# Hard — cofnij commit, USUŃ zmiany ⚠️
git reset --hard HEAD~1
```

| Typ | Commit | Index (staged) | Working dir |
|-----|--------|---------------|-------------|
| `--soft` | ❌ Cofnięty | ✅ Zachowany | ✅ Zachowany |
| `--mixed` | ❌ Cofnięty | ❌ Unstaged | ✅ Zachowany |
| `--hard` | ❌ Cofnięty | ❌ Usunięty | ❌ Usunięty |

### Revert (nie zmienia historii)

```bash
# Stwórz nowy commit odwracający zmiany
git revert a1b2c3

# Revert merge commit
git revert -m 1 <merge-commit-hash>

# Revert bez auto-commit
git revert --no-commit a1b2c3
```

### Kiedy co?

| Sytuacja | Użyj | Dlaczego |
|----------|------|----------|
| Cofnij ostatni commit (local only) | `reset --soft` | Zachowaj zmiany, zmień commit |
| Cofnij commit na shared branch | `revert` | Nie zmienia historii |
| Cofnij merge na main | `revert -m 1` | Bezpieczne, historia intact |
| Wyczyść working dir kompletnie | `reset --hard` | ⚠️ Destrukcyjne! |
| Odzyskaj po złym reset | `reflog` + `reset --hard <hash>` | Reflog = safety net |

---

## 7. Tabela decyzyjna

| Chcę... | Komenda | Bezpieczne? |
|---------|---------|-------------|
| Posprzątać commity przed PR | `rebase -i` | 🟡 Local only |
| Odłożyć pracę na chwilę | `stash` | 🟢 TAK |
| Przenieść konkretny fix | `cherry-pick` | 🟢 TAK |
| Znaleźć buggy commit | `bisect` | 🟢 TAK |
| Odzyskać "stracone" commity | `reflog` | 🟢 TAK |
| Cofnij commit (local) | `reset --soft` | 🟡 Local only |
| Cofnij commit (shared) | `revert` | 🟢 TAK |
| Wyczyść wszystko (nuclear) | `reset --hard` | 🔴 Destrukcyjne! |
| Synchronizuj branch z main | `rebase origin/main` | 🟡 Local branch only |
