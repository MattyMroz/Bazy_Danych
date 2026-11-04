# Lab 4: Apache Spark w środowisku lokalnym

Notatka na zajęcia: jak postawić Sparka na komputerze w labie i odpalić rozwiązanie.

- Zadanie: [Lab.4_exercises_EN.pdf](Lab.4_exercises_EN.pdf)
- Instrukcja instalacji prowadzącego: [Lab_04_PySpark_installation.pdf](Lab_04_PySpark_installation.pdf)
- Rozwiązanie: [lab4_spark_lokalny.ipynb](lab4_spark_lokalny.ipynb)
- Do oddania (WIKAMP, termin 19.12.2026): [Lab4_Mroz_Mateusz_251190.zip](Lab4_Mroz_Mateusz_251190.zip) (raport docx, notebook, riskfactor.csv)

## 1. Pobranie repo

```powershell
git clone https://github.com/MattyMroz/Bazy_Danych.git
cd Bazy_Danych
git checkout bigdata-nauka
```

Jeśli repo już jest: `git pull`.

## 2. Instalacja (PowerShell, bez uprawnień administratora)

Wszystko trafia do `C:\BigData`. Nic nie zmienia ustawień Windowsa; żeby posprzątać, wystarczy usunąć ten katalog.

```powershell
# katalogi z instrukcji prowadzącego
New-Item -ItemType Directory -Force C:\BigData\hive | Out-Null

# Java 21 (Eclipse Temurin, zip bez instalatora)
Invoke-WebRequest "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.13_9.zip" -OutFile C:\BigData\jdk21.zip
Expand-Archive C:\BigData\jdk21.zip C:\BigData
Rename-Item "C:\BigData\jdk-21.0.13+9" jdk21
Remove-Item C:\BigData\jdk21.zip

# winutils z WIKAMP (jest w repo) -> C:\BigData\winutils\bin
Expand-Archive BIGDATA\Lab4\winutils.zip C:\BigData
C:\BigData\winutils\bin\winutils.exe chmod 777 C:\BigData\hive

# Python 3.12 + PySpark (PySpark 4.3 wymaga Pythona 3.11-3.13; listę Pythonów pokazuje: py -0)
py -3.12 -m venv C:\BigData\venv
C:\BigData\venv\Scripts\python -m pip install pyspark==4.3.0 "pandas<3" pyarrow matplotlib ipykernel nbconvert
```

Szybki test w konsoli `pyspark` (zmienne ustawione tylko dla tego okna PowerShella):

```powershell
$env:JAVA_HOME = "C:\BigData\jdk21"
$env:HADOOP_HOME = "C:\BigData\winutils"
$env:PATH = "C:\BigData\jdk21\bin;C:\BigData\winutils\bin;$env:PATH"
$env:PYSPARK_PYTHON = "C:\BigData\venv\Scripts\python.exe"
C:\BigData\venv\Scripts\pyspark
```

W konsoli: `spark.range(5).show()`, a potem `exit()`.

Prowadzący w PDF ustawia JAVA_HOME, HADOOP_HOME, SPARK_HOME i PATH na stałe jako zmienne użytkownika. Tutaj ustawia je tylko pierwsza komórka notebooka, więc nie są potrzebne.

## 3. Uruchomienie rozwiązania

W VS Code: otwórz `lab4_spark_lokalny.ipynb`, wybierz kernel `C:\BigData\venv\Scripts\python.exe` i kliknij Run All.

Albo z konsoli (ok. 3 minuty):

```powershell
cd BIGDATA\Lab4
C:\BigData\venv\Scripts\python -m jupyter nbconvert --to notebook --execute --inplace lab4_spark_lokalny.ipynb
```

Notebook sam pobiera dane NYC Taxi (49 MB) do `data/`. Wyniki zadań 19-20 zapisuje do `out/`, a `riskfactor.csv` i wykresy obok notebooka. `data/` i `out/` są w `.gitignore`.

Sprzątanie po zajęciach: `Remove-Item -Recurse -Force C:\BigData`.

## 4. Co jest w zadaniu i co wyszło

**A. Teoria.** ORC i Parquet to formaty kolumnowe ze schematem i statystykami min/max w pliku. Spark czyta tylko potrzebne kolumny (column pruning), pomija fragmenty pliku po statystykach (predicate pushdown) i katalogi partycji (partition pruning). 200 tys. kursów taxi: CSV 21 MB, Parquet 4,1 MB, ORC 3,7 MB.

**Ćwiczenia 1-2: `trucks.csv` + `geolocation.csv`**

- `trucks.csv`: 100 ciężarówek, każdy miesiąc 01.2009-06.2013 w parze kolumn `<miesiąc>_miles` i `<miesiąc>_gas` (111 kolumn). `geolocation.csv`: 8000 zdarzeń z jazdy. Łączą się po `driverid` (wszystkie 100 kierowców w obu plikach).
- Transformacja: funkcja `stack` zamienia miesiące z kolumn na wiersze, czyli 100 × 54 = 5400 wierszy `driverid, truckid, model, rdate, miles, gas, mpg`.
- A. Przebieg kierowców: `SUM(miles) GROUP BY driverid`. Najwięcej przejechał A52 (684 131 mil).
- B. Średnie spalanie: nie da się go policzyć łatwo. Trzeba liczyć `SUM(miles) / SUM(gas)`, a nie średnią z miesięcy. Do tego w latach 2009-2010 `gas` jest stałe przez cały rok (wypełniacz, nie pomiar), więc rzetelny wynik dają tylko lata 2011-2013: od 4,90 do 5,20 MPG zależnie od modelu.
- Współczynnik ryzyka = liczba zdarzeń innych niż `normal` / przebieg, zapisany do `riskfactor.csv`. Odstaje A97: 20 zdarzeń, 3,17 na 100 000 mil.
- Błąd w danych: wszystkie 156 wierszy z San Fernando mają długość geograficzną -6,19 zamiast ok. -118,4.

**Ćwiczenie 3: NYC Yellow Taxi, styczeń 2024 (2 964 624 kursy, Parquet)**

| Zadania | Co | Wynik |
|---|---|---|
| 1-5 | wczytanie, schemat, liczba rekordów, braki, statystyki | 140 162 kursy bez `passenger_count`; kwoty od -900 do 5000 USD; dystans do 312 722 mil |
| 6-10 | filtr pasażerów, 0 mil z opłatą, czas kursu, prędkość, czyszczenie | 56 569 kursów 0 mil z opłatą; 35 504 ujemne kwoty; po czyszczeniu 2 757 476 (93%) |
| 11 | udział płatności kartą | 78,22% |
| 12 | top 5 stref odbioru | JFK Airport, Midtown Center, Upper East Side South/North, Midtown East |
| 13 | średni napiwek wg liczby pasażerów | 3,37 / 3,72 / 3,54 / 3,42 USD |
| 14 | godzina szczytu | 18:00 (197 998 kursów) |
| 15 | przychód operatorów | VendorID 2: 60,6 mln USD; VendorID 1: 18,8 mln USD |
| 16 | korelacja dystans - napiwek | 0,01 surowe dane; 0,73 dla płatności kartą po odrzuceniu błędnych dystansów |
| 17 | napiwek jako % opłaty | średnio 14,78%, mediana 16,67% |
| 18 | najdłuższy kurs dnia tygodnia (funkcja okna `row_number`) | bez filtra wygrywają błędy licznika; przy prędkości do 80 mph: od 97,5 do 233,25 mili |
| 19 | zapis Parquet z partycjami po dniu | 31 katalogów `pickup_date=2024-01-XX` |
| 20 | dzienny przychód w ORC | najlepszy dzień 25.01 (2,87 mln USD) |

Pułapka Sparka 4: tryb ANSI jest domyślnie włączony, więc dzielenie przez zero rzuca wyjątek. Prędkość liczy `try_divide`, które zwraca wtedy NULL.
