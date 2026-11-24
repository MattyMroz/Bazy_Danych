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
