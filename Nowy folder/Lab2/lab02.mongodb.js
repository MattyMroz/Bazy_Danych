// ! Do pobierania danych wykorzystujemy metodę find()
// 1.  Utwórz bazę danych o nazwie northwind
use('northwind');
db.dropDatabase();

// 2.  Utwórz kolekcje: customers, orders, departments (bez danych)
// https://www.mongodb.com/docs/manual/reference/method/db.createCollection/
db.createCollection('customers');
db.createCollection('orders');
db.createCollection('departments');


// 3.  Dodaj dokumenty z materiałów do kolekcji za pomocą polecenia insertOne lub insertMany (podaj wszystkie polecenia)
db.customers.insertMany([
    {
        "_id" : 1,
        "firstName" : "Adam",
        "lastName" : "Kowalski",
        "phone" : "235 786 123",
        "email" : "adam_kowalski@inlook.pl",
        "created_date" : "2021-01-16",
        "purchase" : ["o2", "o4", "o6"]
    },
    {
        "_id" : 2,
        "firstName" : "Jan",
        "lastName" : "Kowalski",
        "phone" : "111 760 760",
        "email" : "jan_kowalski@rmail.pl",
        "created_date" : "2021-02-16",
        "purchase" : ["o8", "o9", "o10", "o11", "o12"]
    },
    {
        "_id" : 3,
        "firstName" : "Ewa",
        "lastName" : "Nowak",
        "phone" : "768 211 546",
        "email" : "ewanowak@poczta.eu",
        "created_date" : "2021-02-18",
        "isBusiness" : false,
        "purchase" : ["o1"]
    },
    {
        "_id" : 4,
        "firstName" : "Dominika",
        "lastName" : "Prosta",
        "email" : "prosta@pigeon.net",
        "created_date" : "2021-03-21",
        "purchase" : ["o5", "o7"]
    },
    {
        "_id" : 5,
        "firstName" : "Antoni",
        "lastName" : "Pit",
        "phone" : "122 506 506",
        "email" : "antoni.pit@firma.eu",
        "created_date" : "2021-04-30",
        "isBusiness" : true,
        "NIP" : "1256917711",
        "purchase" : ["o13"]
    },
    {
        "_id" : 6,
        "firstName" : "Agnieszka",
        "lastName" : "Zaradna",
        "phone" : "100 700 600",
        "email" : "a.zaradnapit@biznes.eu",
        "created_date" : "2021-05-06",
        "isBusiness" : true,
        "NIP" : "5348001235",
        "purchase" : ["o14", "o15", "o16", "o17", "o18"]
    }
]);

// Customer07 nie ma _id - MongoDB nada mu ObjectId automatycznie
db.customers.insertOne(
    {
        "firstName" : "Patryk",
        "lastName" : "Bez",
        "created_date" : "2021-07-07"
    }
);

db.departments.insertMany([
    {
        "_id" : "alpha",
        "city" : "Warszawa",
        "address" : { "street" : "Ostatnia", "block" : 12, "postalCode" : "00-120" },
        "sections" : ["Sales", "Finance", "Logistics"]
    },
    {
        "_id" : "beta",
        "city" : "Warszawa",
        "address" : { "street" : "Pierwsza", "block" : 21, "postalCode" : "00-145" },
        "sections" : ["Logistics", "Warehouse"]
    },
    {
        "_id" : "gamma",
        "city" : "Gdynia",
        "address" : { "street" : "Pierwsza", "block" : "13/31", "postalCode" : "80-209" },
        "sections" : ["Logistics", "Warehouse", "Helpdesk"]
    },
    {
        "_id" : "delta",
        "city" : "Poznań",
        "address" : { "street" : "Wojska Polskiego", "block" : 11, "postalCode" : "60-111" },
        "sections" : ["Logistics"]
    },
    {
        "_id" : "lambda",
        "city" : "Gdańsk",
        "address" : { "block" : 11, "postalCode" : "80-209" },
        "sections" : ["Logistics", "Sales"]
    }
]);

db.orders.insertMany([
    {
        "_id" : "o1",
        "customer" : 1,
        "quantity" : 10,
        "cost" : 1200.00,
        "discount" : 20,
        "totalCost" : 960.00
    },
    {
        "_id" : "o2",
        "customer" : 1,
        "product" : "Papier do drukarki x5000",
        "cost" : 220.00,
        "totalCost" : 220.00
    },
    {
        "_id" : "o3",
        "customer" : 1,
        "quantity" : 2,
        "cost" : 58.00,
        "totalCost" : 58.00
    },
    {
        "_id" : "o4",
        "customer" : 2,
        "quantity" : 5,
        "product" : "Tusz czarny do drukarki",
        "cost" : 500.00,
        "discount" : 10,
        "totalCost" : 450.00
    },
    {
        "_id" : "o5",
        "customer" : 2,
        "quantity" : 5,
        "product" : "Tusz kolorowy do drukarki",
        "cost" : 750.00,
        "discount" : 10,
        "totalCost" : 675.00
    },
    {
        "_id" : "o6",
        "customer" : 3,
        "product" : "Drukarka kolorowa",
        "cost" : 1800.00
    },
    {
        "_id" : "o7",
        "customer" : 3,
        "product" : "Drukarka laserowa",
        "cost" : 1950.00,
        "discount" : 25,
        "totalCost" : 1462.50
    },
    {
        "_id" : "o8",
        "customer" : 3,
        "product" : "Laminator",
        "cost" : 700.00,
        "totalCost" : 700.00
    },
    {
        "_id" : "o9",
        "customer" : 3,
        "cost" : 799.00,
        "totalCost" : 799.00
    },
    {
        "_id" : "o10",
        "customer" : 4,
        "quantity" : 2,
        "cost" : 58.00,
        "totalCost" : 58.00
    },
    {
        "_id" : "o11",
        "customer" : 4,
        "product" : "Marker czarny",
        "quantity" : 50,
        "cost" : 100.00,
        "totalCost" : 100.00
    },
    {
        "_id" : "o12",
        "customer" : 4,
        "product" : "Długopis kulkowy",
        "quantity" : 70,
        "cost" : 70.00,
        "discount" : 50,
        "totalCost" : 35.00
    },
    {
        "_id" : "o13",
        "customer" : 4,
        "product" : "Długopis żelowy",
        "quantity" : 100,
        "cost" : 250.00,
        "discount" : 10,
        "totalCost" : 225.00
    },
    {
        "_id" : "o14",
        "customer" : 4,
        "product" : "Skoroszyt kratka",
        "quantity" : 100,
        "cost" : 350.00,
        "discount" : 35,
        "totalCost" : 227.50
    },
    {
        "_id" : "o15",
        "customer" : 5,
        "product" : "Oprogramowanie biurowe 12 msc",
        "quantity" : 100,
        "cost" : 44500.00,
        "discount" : 10,
        "totalCost" : 40050.50
    },
    {
        "_id" : "o16",
        "customer" : 5,
        "product" : "Papier biurowy 500 arkuszy",
        "quantity" : 750,
        "cost" : 17250.00,
        "discount" : 15,
        "totalCost" : 14662.50,
        "withDelivery" : true
    },
    {
        "_id" : "o17",
        "customer" : 5,
        "product" : "Długopis niebieski kulkowy",
        "quantity" : 5000,
        "cost" : 8250.00,
        "discount" : 60,
        "totalCost" : 3300.00,
        "withDelivery" : true
    },
    {
        "_id" : "o18",
        "customer" : 5,
        "product" : "Płyn do czyszczenia tablic 300 ml",
        "quantity" : 1200,
        "cost" : 4800.00,
        "withDelivery" : true
    }
]);

use('northwind');
db.getCollectionNames();

// 4. Utwórz kolekcję o nazwie lab_test.
// Dodaj do tej kolekcji wszystkie dokumenty z istniejących trzech kolekcji.
// Sprawdź czy dokumenty dodały się do kolekcji lab_test, a następnie usuń kolekcję lab_test
// (wykorzystać polecenie insertMany i metodę toArray() - mogą być trzy osobne polecenia)
// https://www.mongodb.com/docs/manual/reference/method/cursor.toArray/
use('northwind');
db.createCollection('lab_test');

db.lab_test.insertMany(db.customers.find().toArray());
db.lab_test.insertMany(db.orders.find().toArray());
db.lab_test.insertMany(db.departments.find().toArray());

db.lab_test.find();

db.lab_test.drop();

// 5.  Wyświetl wszystkie dokumenty kolekcji orders
// https://www.mongodb.com/docs/manual/reference/method/db.collection.find/
use('northwind');
db.orders.find();

// 6.  Wyświetl tylko jeden dokument z kolekcji customers (findOne())
use('northwind');
db.customers.findOne();

// 7.  Wyświetl dokładnie trzy dokumenty z kolekcji departments (limit())
use('northwind');
db.departments.find().limit(3);

// 8.  Wyświetl klucze: _id, cost, totalCost z dokumentów kolekcji orders
use('northwind');
db.orders.find(
    {},
    {
        _id: 1,
        cost: 1,
        totalCost: 1
    }
);

// 9.  Wyświetl wszystkie klucze poza kluczem product z dokumentów znajdujących się w kolekcji customers.
use('northwind');
db.customers.find(
    {},
    {
        product: 0
    }
);

// 10. Wyświetl dokumenty z kolekcji orders, posortowane po kluczu customer w sposób malejący, a po totalCost w sposób rosnący.
use('northwind');
db.orders.find().sort({
    customer: -1,
    totalCost: 1
});

// 11. Wyświetl dokumenty z orders, gdzie totalCost przekracza 10000.
// https://www.mongodb.com/docs/manual/reference/operator/aggregation/gt/
use('northwind');
db.orders.find({
    totalCost: { $gt: 10000 }
});

// 12. Wyświetl dokumenty z orders, gdzie totalCost jest między between 5000 i 10000.
use('northwind');
db.orders.find({
    totalCost: {
        $gte: 5000,
        $lte: 10000
    }
});

// 13. Wyświetl klientów z tabeli customer, gdzie lastName zaczyna się na literę K
// https://www.mongodb.com/docs/manual/reference/operator/query/regex/
use('northwind');
db.customers.find({
    lastName: { $regex: /^K/ }
});

// 14. Wyświetl dokumenty z departments, gdzie city to: Poznań, Warszawa albo Łódź.
// https://www.mongodb.com/docs/manual/reference/operator/aggregation/in/
use('northwind');
db.departments.find({
    city: {
        $in: ["Poznań", "Warszawa", "Łódź"]
    }
});

// 15. Wyświetl dokumenty z customers, gdzie firstName to Jan, a lastName to Nowak.
use('northwind');
db.customers.find({
    firstName: "Jan",
    lastName: "Nowak"
});

// 16. Wyświetl tylko zamówienia z kolekcji orders, gdzie discount jest mniejsze niż 10 lub cost większy niż 5000. Posortuj po kluczu cost w sposób malejący.
use('northwind');
db.orders.find({
    $or: [
        { discount: { $lt: 10 } },
        { cost: { $gt: 5000 } }
    ]
}).sort({ cost: -1 });

// 17. Wyświetl tylko zamówienia z kolekcji orders, gdzie discount jest mniejsze niż 10 i cost większy niż 5000. Posortuj po kluczu cost w sposób malejący (stosujemy operator $and i bez operatora $and)
use('northwind');
db.orders.find({
    $and: [
        { discount: { $lt: 10 } },
        { cost: { $gt: 5000 } }
    ]
}).sort({ cost: -1 });

db.orders.find({
    discount: { $lt: 10 },
    cost: { $gt: 5000 }
}).sort({ cost: -1 });

// 18. Zaktualizuj dokument jeden dokument (dowolny) w kolekcji clients, dodając nowy klucz o nazwie isValid z wartością true.
use('northwind');
db.customers.updateOne(
    { _id: 1 },
    { $set: { isValid: true } }
);

db.customers.find({ _id: 1 });

// 19. Zaktualizuj wszystkie dokumenty w kolekcji departments o klucz status z wartością A, które są w Warszawie. Jeśli nie ma takich dokumentów to utwórz nowy dokument - jaka jest jego zawartość (upsert).
use('northwind');
db.departments.updateMany(
    { city: "Warszawa" },
    { $set: { status: "A" } },
    { upsert: true }
);

db.departments.find({ city: "Warszawa" });

// 20. Usuń jeden dokument z kolekcji orders, które należą do klienta o "customer" = 5.
// Usuń pozostałe wszystkie dokumenty z kolekcji orders, które należą do klienta o "customer" = 5.
use('northwind');
db.orders.deleteOne({ customer: 5 });
db.orders.deleteMany({ customer: 5 });

db.orders.find({ customer: 5 });

// 21. Wyświetl wszystkie indeksy w każdej z kolekcji.
use('northwind');
db.customers.getIndexes();
db.orders.getIndexes();
db.departments.getIndexes();

// 22. Utwórz indeksy w kolekcji customers: jeden o nazwie klienci na kluczach firstName i lastName w sposób rosnący, drugi na kluczu phone w sposób malejący.
use('northwind');
db.customers.createIndex(
    {
        firstName: 1,
        lastName: 1
    },
    {
        name: "klienci"
    }
);

db.customers.createIndex(
    {
        phone: -1
    }
);

db.customers.getIndexes();

// 23. Usuń drugi indeks z poprzedniego zadania.
use('northwind');
db.customers.dropIndex({ phone: -1 });
db.customers.getIndexes();


// 24. Wykorzystujemy metodę find(), sort(), limit(), skip() i sprawdzamy dla dowolnej kolekcji czy kolejność ostatnich 3 metod ma znaczenie na wynik zapytania. Podaj przykłady.
// -> Kolejność nie ma znaczenia.
// Mongo i tak najpierw sortuje, potem robi skip, a na końcu limit, więc wszystkie trzy zapytania poniżej zwracają to samo.

// Przykład 1: sort -> skip -> limit
use('northwind');
db.orders.find()
    .sort({ cost: -1 })
    .skip(2)
    .limit(3);

// Przykład 2: limit -> skip -> sort
use('northwind');
db.orders.find()
    .limit(3)
    .skip(2)
    .sort({ cost: -1 });

// Przykład 3: skip -> limit -> sort
use('northwind');
db.orders.find()
    .skip(2)
    .limit(3)
    .sort({ cost: -1 });


// 25. Utwórz nową bazę danych Politechnika i ponownie wylistuj istniejące bazy danych (mongosh).
// W mongosh:
//   use Politechnika
//   show dbs
// Politechnika nie pojawi się jeszcze na liście - Mongo tworzy bazę dopiero wtedy,
// gdy trafi do niej pierwsza kolekcja albo dokument (to robimy w 25.1).
use('Politechnika');
db.getMongo().getDBNames();

//   25.1 - w danej bazie utwórz kolekcję Students i wstaw dowolne dane związane z danymi studentów
// np. imię nazwisko, wydział, specjalność, rok urodzenia, zainteresowania w postaci listy,
// adresy poczty elektronicznej firmowej, prywatnej w postaci zagnieżdżonego JSON, data i godzina wstawienia dokumentu (createdAt: new Date()) za pomocą poleceń insertMany() (2 dokumenty) oraz insertOne() (1 dokument)
// (format struktury danych JSON w tym znaczniki ustalić wspólnie na zajęciach)
// Dana kolekcja ma mieć ograniczoną wielkość kolekcji na 1MB lub 100 dokumentów.
// Sprawdzić co się dzieje po przekroczeniu 1MB lub 100 dokumentów w kolekcji

//   25.2 - następnie wykonaj przykładowe polecenia updateMany(), updateOne(), replaceOne()
// i sprawdź zmodyfikowane odpowiednie dane.

//   25.3 - zmodyfikuj istniejące dane: dodaj nowe pole np. z aktualną datą ($set),
// wyrzuć pole np. z datą ($unset).
// https://www.mongodb.com/docs/manual/reference/operator/update/set/
// https://www.mongodb.com/docs/manual/reference/operator/update/unset/

//   25.4 - zmień nazwę dowolnego pola $rename

//   25.5 - opcja polecenia updateOne i innych z opcją {upsert:true}

//   25.6 - następnie wykonaj polecenia deleteMany(), deleteOne() i sprawdź czy skasowano odpowiednie dane.

//   25.7 - wstaw przykładowe dane z polem _id wstawianym w poleceniu insertOne().

//   25.8 - za pommocą funkcji bulkWrite() wstaw jednym poleceniem dwa nowe dokumenty, jeden z istniejących zmodyfikuj i jeden skasuj.
// https://www.mongodb.com/docs/manual/reference/method/db.collection.bulkWrite/
