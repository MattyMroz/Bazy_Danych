# Bazy_Danych

Materiały do studiów z baz danych: wykłady w PDF, skrypty SQL z zajęć, zadania, kolokwia i projekty z raportami w LaTeX. Repo nie ma kodu do budowania ani testów.

## Bramki jakości

```bash
prek run --all-files
```

## Mapa

- `BAZY_SQL/`: MS SQL Server (T-SQL): wykłady (`Wykład/`), pliki z zajęć, zadania (`DO_ODDANIA/`, `EGZAMIN/`), bazy Northwind jako pliki `.mdf`/`.ldf` (`bazy/`, `Pliki z Zajeć/`).
- `BIGDATA/`: Big Data: laboratoria z HDFS, Spark i MongoDB (notebooki w `Lab3/`) oraz wykłady.
- `Nowy folder/`: MongoDB: instalacja (`Lab1/`), lab 2 z kolekcjami Northwind w JSON (`Lab2/northwind/`) i skryptami `*.mongodb.js`, uruchamianie w Dockerze (`docker_mongodb.ps1`).
- `PIABD/`: Projektowanie i Administracja Baz Danych: projekt CompanyDB (`Projekt/`, skrypty `01_`-`05_`, raport LaTeX w `Projekt/raport/`), teoria, zadania.
- `RBZ/`: Rozproszone Bazy Danych: laboratoria, kolokwium (`KOLOS/`), projekt Hurtownia POL-FOOD na Oracle i MS SQL Server (`PROJEKT/food-wholesaler-distributed-db/`).
- `ROBD_ORACLE/`: obiektowa baza Oracle: laboratoria, kolokwium, kolejne wersje projektu Szkoła Muzyczna jako osobne katalogi `Projekt_v1`-`Projekt_v8` (numerowane skrypty SQL i raport LaTeX).
- `temp/brain_storm/`: notatki robocze do projektu HiDPPS.

## Pułapki

- Numerowane skrypty SQL projektu uruchamia się w kolejności numerów; wersje z własnym `README.md` (np. `ROBD_ORACLE/Projekt_v6/`) opisują tę kolejność.
- Śledzone binaria (bazy `.mdf`/`.ldf`, PNG, ZIP, artefakty LaTeX `.log` i `.synctex.gz`) są w gicie celowo i mają reguły zachowujące w sekcji `Re-includes` w `.gitignore`. Nowy plik typu, który `.gitignore` ignoruje, wymaga tam własnej wąskiej reguły.
- Hook `check-added-large-files` odrzuca dodawane pliki powyżej 1024 KB, w tym nowe bazy `.mdf`.
- `.github/copilot-instructions.md` i `.github/workflows/ci.yml` pochodzą z innego projektu (odwołują się do MangaShift i katalogu `mangashift/`) i nie opisują tego repo.

## Git

- Commit: nagłówek Conventional Commits po angielsku, `type(scope): opis`, ze scope'em z listy w `.pre-commit-config.yaml`; po pustej linii streszczenie „co i dlaczego”; potem sekcja `Validation:` z kontrolami uruchomionymi na finalnym indeksie. Format: https://github.com/MattyMroz/agents/blob/main/presets/hooks/references/commit-message.md
- Kontrole uruchamiaj przez `mm-validate run "<kontrola>" -- <komenda>`, blok `Validation:` bierz z `mm-validate list`. Hooki `conventional-pre-commit` i `commit-validation` odrzucą inny commit.
- Pliki dodawaj po nazwie, nigdy `git add .`; bez `--no-verify`. Worktree'y tylko w `.worktrees/<nazwa>`.
