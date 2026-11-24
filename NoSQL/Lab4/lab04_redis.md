# Lab 4 - Redis

## 1. Przygotowanie środowiska

```powershell
#Zadanie: Uruchomić REDIS na docker.
docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
```

```powershell
#Zadanie: Wejdź do CLI bezpośrednio w linii komend.
docker exec -it redis-stack redis-cli
```

```
#Zadanie: Sprawdź wersję Redis poleceniem INFO server.
INFO server
```

```
#Zadanie: Sprawdź ile baz danych jest dostępnych.
CONFIG GET databases
```

## 2. VS Code

```
#Zadanie: Wykonaj prostą operację zapisania i czytania danych.
SET test:1 "Hello"
GET test:1
```

## 3. Redis Insight (http://localhost:8001/)

```
#Zadanie: Sprawdź wersję Redis w konsoli Redis Insight.
INFO server
```

```
#Zadanie: Sprawdź ile baz danych jest dostępnych.
CONFIG GET databases
```

## 4. Strings (db0)

```
SELECT 0
```

```
#Zadanie: Utwórz licznik odwiedzin strony (INCR visits).
SET visits 0
INCR visits
INCR visits
GET visits
```

```
#Zadanie: Ustaw klucz z czasem wygaśnięcia (SETEX).
SETEX session:1 30 "aktywna"
GET session:1
TTL session:1
```

## 5. Hashes (db1)

```
SELECT 1
```

```
#Zadanie: Dodaj użytkownika z polami name, email.
HSET user:1 name "Jan" email "jan@example.com"
HGETALL user:1
```

```
#Zadanie: Zaktualizuj email i usuń jedno pole.
HSET user:1 email "jan.kowalski@example.com"
HDEL user:1 name
HGETALL user:1
```

## 6. Lists (db2)

```
SELECT 2
```

```
#Zadanie: Utwórz listę zadań (tasks) i dodaj 3 elementy.
RPUSH tasks "zadanie 1" "zadanie 2" "zadanie 3"
LRANGE tasks 0 -1
```

```
#Zadanie: Pobierz ostatnie 2 elementy.
LRANGE tasks -2 -1
```

```
#Zadanie: Skasuj listę zadań.
DEL tasks
EXISTS tasks
```

## 7. JSON (db3)

```
SELECT 3
```

```
#Zadanie: Utwórz obiekt {"name":"Bike","price":100}.
JSON.SET bike:1 $ '{"name":"Bike","price":100}'
JSON.GET bike:1
```

```
#Zadanie: Zmień cenę na 120.
JSON.SET bike:1 $.price 120
JSON.GET bike:1
```

## 8. Bike Shop JSON (db4)

```
#Zadanie: Wykonać operacje na nowych danych typu JSON (Bike Shop).
SELECT 4
JSON.SET bikes:1 $ '{"model":"Jigger","brand":"Velorim","price":270,"type":"Kids bikes","condition":"new"}'
JSON.SET bikes:2 $ '{"model":"Hillcraft","brand":"Bicyk","price":1200,"type":"Mountain bikes","condition":"used"}'
JSON.SET bikes:3 $ '{"model":"Chook","brand":"Nord","price":815,"type":"Commuter bikes","condition":"new"}'
JSON.MGET bikes:1 bikes:2 bikes:3 $.model
JSON.NUMINCRBY bikes:1 $.price 30
JSON.SET bikes:1 $.condition '"used"'
JSON.GET bikes:1
```

## 9. Pozostałe typy (db5)

```
SELECT 5
```

```
#Zadanie: Podaj 2-3 operacje i opisz w komentarzu co realizują dane polecenia (Sets).
SADD tags redis nosql db
SMEMBERS tags
SISMEMBER tags redis
SCARD tags
```

```
#Zadanie: Podaj 2-3 operacje i opisz w komentarzu co realizują dane polecenia (Sorted sets).
ZADD ranking 100 anna 250 jan 175 ola
ZRANGE ranking 0 -1 WITHSCORES
ZREVRANGE ranking 0 0 WITHSCORES
ZRANK ranking ola
```

```
#Zadanie: Podaj 2-3 operacje i opisz w komentarzu co realizują dane polecenia (Time Series).
TS.CREATE temp:1 RETENTION 600000
TS.ADD temp:1 1000 21.5
TS.ADD temp:1 2000 22.1
TS.RANGE temp:1 - + AGGREGATION avg 600000
```

```
#Zadanie: Opis poleceń.
SADD tags redis nosql db
//dodaje 3 unikalne elementy do zbioru
ZADD ranking 100 anna
//dodaje element z wynikiem do posortowanego zbioru
ZREVRANGE ranking 0 0 WITHSCORES
//zwraca element z najwyższym wynikiem
TS.ADD temp:1 1000 21.5
//dodaje pomiar z czasem 1000 do szeregu czasowego
TS.RANGE temp:1 - + AGGREGATION avg 600000
//średnia z pomiarów w oknach 10-minutowych
```

## 10. Python (db10)

```powershell
pip install redis
```

```python
#Zadanie: Aplikacja konsolowa w Pythonie z dostępem do bazy REDIS (Hashes, db10).
import redis

r = redis.Redis(host="localhost", port=6379, db=10, decode_responses=True)

while True:
    print("Wybierz operację:")
    print("1. Dodaj użytkownika")
    print("2. Znajdź użytkownika")
    print("3. Aktualizuj użytkownika")
    print("4. Usuń użytkownika")
    print("5. Zakończ")
    op = input("> ").strip()
    if op == "5":
        break
    if op not in ("1", "2", "3", "4"):
        continue
    name = input("Nazwisko: ").strip()
    key = f"user:{name}"
    if op == "1":
        email = input("Email: ").strip()
        r.hset(key, mapping={"name": name, "email": email})
        print("Dodano.")
    elif not r.exists(key):
        print("Nie znaleziono użytkownika.")
    elif op == "2":
        print(r.hgetall(key))
    elif op == "3":
        r.hset(key, "email", input("Nowy email: ").strip())
        print("Zaktualizowano.")
    else:
        r.delete(key)
        print("Usunięto.")
```

## 11. C# (db11)

```powershell
dotnet new console -n RedisApp
cd RedisApp
dotnet add package StackExchange.Redis
```

```csharp
//Zadanie: Aplikacja konsolowa w .NET z dostępem do bazy REDIS (StringSetAsync, StringGetAsync, Hashes).
using StackExchange.Redis;

var connection = await ConnectionMultiplexer.ConnectAsync("localhost:6379,defaultDatabase=11");
var db = connection.GetDatabase();

await db.StringSetAsync("bike:1", "Redis", TimeSpan.FromSeconds(50));
var value = await db.StringGetAsync("bike:1");
Console.WriteLine($"bike:1     {value}");

await db.HashSetAsync("user:Nowak", new HashEntry[]
{
    new("name", "Nowak"),
    new("email", "nowak@gmail.com")
});
var email = await db.HashGetAsync("user:Nowak", "email");
Console.WriteLine($"user:Nowak {email}");
```
