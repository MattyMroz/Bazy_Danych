# Zadania 1-4 oraz 10-11: MongoDB w Dockerze
# Uruchamiac krok po kroku (wymaga dzialajacego Docker Desktop).

# 1. Pobranie obrazu
docker pull mongodb/mongodb-community-server

# 2. Kontener "mongodb" na standardowym porcie 27017
#    (przed tym zatrzymaj lokalny mongod.exe, bo zajmuje port 27017 - zadanie 10)
docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest

# 3. Mongosh w kontenerze; w konsoli wpisz:  show dbs   oraz   use test1
docker exec -it mongodb mongosh

# 11. Drugi kontener "mongodb1" na porcie 27018 (do pracy rownolegle z lokalnym serwerem)
docker run --name mongodb1 -d -p 27018:27017 mongodb/mongodb-community-server:latest
docker ps

# 4. Zatrzymanie kontenerow (a potem zamkniecie Docker Desktop)
docker stop mongodb mongodb1
