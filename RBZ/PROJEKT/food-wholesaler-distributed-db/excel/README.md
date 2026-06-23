# Excel

Tutaj powinien byc plik z cennikiem dostawcy:

```text
cenniki_dostawcow.xlsx
```

Arkusz w pliku:

```text
Cennik$
```

Kolumny w arkuszu:

```text
id_produktu
cena_netto
data_od
```

Ten plik bedzie czytany z SQL Servera przez `OPENROWSET` albo linked server
`SRV_EXCEL`. Dane z arkusza maja trafic do tabeli `CENNIK_IMPORT`.

Przyklad danych:

```text
id_produktu | cena_netto | data_od
1           | 12.50      | 2026-01-01
2           | 7.99       | 2026-01-01
```
