# Access

Tutaj powinien byc plik z kartoteka przedstawicieli:

```text
przedstawiciele.accdb
```

Tabela w pliku:

```text
PRZEDSTAWICIELE
```

Kolumny w tabeli:

```text
id_przedstawiciela
imie
nazwisko
region
telefon
email
```

Ten plik bedzie czytany z SQL Servera przez `OPENROWSET` albo linked server
`SRV_ACCESS`.

Przyklad danych:

```text
id_przedstawiciela | imie | nazwisko | region
1                  | Jan  | Kowalski | Lodzkie
2                  | Anna | Nowak    | Mazowieckie
```
