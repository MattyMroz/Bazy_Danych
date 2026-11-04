# Ściąga: moje błędy i pułapki

## Ekosystem Hadoopa (pomyłka: HBase)

Skojarz nazwę z obrazkiem, a obrazek z funkcją.

| Narzędzie | Skojarzenie | Do czego służy |
|---|---|---|
| **HBase** | „base” = baza | **baza NoSQL** (kolumnowa) |
| **Hive** | ul, w którym gromadzi się miód | **SQL na Hadoopie** (HiveQL), hurtownia danych |
| **Pig** | świnia je wszystko | **skrypty przepływu danych** (Pig Latin), każdy format |
| **Spark** | iskra, szybko | przetwarzanie **w pamięci** |
| **MapReduce** | map, a potem reduce | przetwarzanie **wsadowe** (batch), zapis na dysk |
| **Storm** | burza, ciągły strumień | przetwarzanie **strumieni** |
| **Solr** | search | **wyszukiwanie pełnotekstowe** |
| **Flume** | rynna, którą coś spływa | **zbieranie logów** i wlewanie ich do HDFS |
| **Oozie** | dyrygent | **harmonogram i workflow** zadań |
| **Ambari** | panel admina | **zarządzanie i monitoring** klastra |
| **HCatalog** | katalog | **metadane i tabele** |
| **Sqoop** | SQL + Hadoop | przenoszenie danych **między bazą relacyjną a Hadoopem** |
| **YARN** | przędza łącząca wszystko | **zarządca zasobów** klastra |
| **HDFS** | dysk | **system plików**, gdzie leżą dane |

Pułapki:
- **HBase ≠ Hive.** HBase to baza NoSQL, Hive to SQL.
- **Storm ≠ Solr.** Storm to strumienie, Solr to wyszukiwanie.
- **Flume ≠ Sqoop.** Flume to logi, Sqoop to dane z bazy SQL.
- **Oozie ≠ Ambari.** Oozie to harmonogram, Ambari to panel admina.

## setrep (Wykład 1, HDFS, polecenia szczegółowe)

`hdfs dfs -setrep [-R] [-w] <liczba_kopii> <ścieżka>` zmienia, w ilu kopiach HDFS trzyma plik (domyślnie 3).

- **`-R`** = **R**ekurencyjnie, dla całego katalogu z podkatalogami.
- **`-w`** = **w**ait, czyli czekaj, aż kopie naprawdę powstaną. Bez `-w` polecenie wraca od razu, a kopiowanie dzieje się w tle.
- Kolejność: najpierw **liczba**, potem **ścieżka**: `-setrep 2 plik`, nie `-setrep plik 2`.
