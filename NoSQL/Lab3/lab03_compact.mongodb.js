// Mateusz Mróz 251190

use("airbnb");
// 1. Pobieramy narzędzie mongoimport i inne (MongoDB Command Line Database Tools) do katalogu c:\data
// Znajdziemy go tutaj: https://www.mongodb.com/try/download/database-tools
// -- rozpakowane do c:\data, w srodku mongoimport, mongoexport, mongodump, mongorestore


// 2. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_airbnb.
// Baza ma mieć nazwę airbnb
// (nazwa kolekcji = nazwa pliku bez rozszerzenia) - analizujemy strukturę.
// -- c:\data\mongoimport --db airbnb --collection listingsAndReviews --file .\sample_airbnb\listingsAndReviews.json
// 5555 dokumentow, kazdy to oferta: name, property_type, price (Decimal128), beds, amenities (lista),
// address (zagniezdzony z country), host, reviews (lista dokumentow), review_scores
use("airbnb");
db.listingsAndReviews.findOne();


// 3. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_weather.
// Baza ma mieć nazwę weather.
// (nazwa kolekcji = nazwa pliku bez rozszerzenia) - analizujemy strukturę.
// -- c:\data\mongoimport --db weather --collection data --file .\sample_weatherdata\data.json
// 10000 dokumentow, pomiary pogody: st (stacja), ts (data), position (GeoJSON), airTemperature, wind, pressure... jako zagniezdzone dokumenty
use("weather");
db.data.findOne();


// 4. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_analytics.
// Baza ma mieć nazwę analytics.
// Tym razem wykorzystujemy polecenie mongoimport z kontenera w dockerze i trzeba przesłać *.json do katalogu /data w kontenerze
// (nazwy kolekcji = nazwy plików bez rozszerzenia) - analizujemy strukturę.
// -- docker cp .\sample_analytics mongodb:/data/sample_analytics
// -- docker exec mongodb mongoimport --db analytics --collection accounts --file /data/sample_analytics/accounts.json
// -- docker exec mongodb mongoimport --db analytics --collection customers --file /data/sample_analytics/customers.json
// -- docker exec mongodb mongoimport --db analytics --collection transactions --file /data/sample_analytics/transactions.json
// accounts - konto z limitem i lista produktow, customers - klient z lista kont (accounts) i tier_and_details,
// transactions - konto z lista transakcji (transactions to tablica dokumentow)
use("analytics");
db.accounts.findOne();
db.customers.findOne();
db.transactions.findOne();


// 5. Wylistuj istniejące bazy danych (mongosh) i sprawdź ile jest w nich dokumentów.
// -- use("airbnb")
// -- db.listingsAndReviews.find().count() -- jeśli liczymy liczbę dokumentów zwracanych w zapytaniu
// -- db.listingsAndReviews.count() -- deprecated
// -- db.listingsAndReviews.countDocuments()
// -- db.listingsAndReviews.estimatedDocumentCount()
// show dbs
db.getMongo().getDBNames();

use("airbnb");
db.listingsAndReviews.countDocuments(); // 5555

use("weather");
db.data.countDocuments(); // 10000

use("analytics");
db.accounts.countDocuments(); // 1746
db.customers.countDocuments(); // 500
db.transactions.estimatedDocumentCount(); // 1746

// 6. Utwórz kopię zapasową (bezpieczeństwa) swoich zaimportowanych kolekcji używając narzędzia mongodump.
// Po wykonaniu kopii zapasowej przywróć dane za pomocą narzędzia mongorestore (po uprzednim usunięciu trzech nowo utworzonych baz).
// -- c:\data\mongodump --db airbnb --out c:\data\backup
// -- c:\data\mongodump --db weather --out c:\data\backup
// -- c:\data\mongodump --db analytics --out c:\data\backup
use("airbnb");
db.dropDatabase();
use("weather");
db.dropDatabase();
use("analytics");
db.dropDatabase();
// -- c:\data\mongorestore c:\data\backup
// przywrocilo 19547 dokumentow (5555 + 10000 + 1746 + 500 + 1746), wszystko wrocilo
use("airbnb");
db.listingsAndReviews.countDocuments();

// 7. Odtwórz bazy z pliku sampledata.archive (wcześniej skasuj trzy nowo utworzone bazy)
// kopiuj archiwum (PowerShell):
// -- curl https://atlas-education.s3.amazonaws.com/sampledata.archive -o sampledata.archive
// lub pobierz z sieci lokalnej.
// -- Kopiuj do kontenera: docker cp C:\temp\sampledata.archive mongodb:/data/sampledata.archive
// -- Rozpakuj z pliku sampledata.archive: docker exec -i mongodb mongorestore --archive=/data/sampledata.archive
use("airbnb");
db.dropDatabase();
use("weather");
db.dropDatabase();
use("analytics");
db.dropDatabase();
// po restore jest 425367 dokumentow i bazy sample_airbnb, sample_analytics, sample_geospatial, sample_guides,
// sample_mflix, sample_restaurants, sample_supplies, sample_training, sample_weatherdata
db.getMongo().getDBNames();


// 8. Wyświetl plan wykonania wybranego zapytania.
// -- db.listingsAndReviews.find().explain("executionStats")
// Czy został użyty jakikolwiek indeks (COLLSCAN (pełne skanowanie kolekcji) czy IXSCAN (skanowanie indeksu))?
// Napisz takie zapytanie, aby MongoDB zdecydował się na indeksu name_1 (np. wybiera element "name" zaczynający się na słowo Resort - wyrażenie regularne).
use("sample_airbnb");
db.listingsAndReviews.getIndexes();
db.listingsAndReviews.find().explain("executionStats");
// COLLSCAN - bez filtra nie ma po czym uzyc indeksu, przeglada wszystkie 5555 dokumentow

db.listingsAndReviews.find({ name: /^Resort/ }).explain("executionStats");
// IXSCAN na name_1 - zwraca 5 dokumentow, przejrzal tylko 6 kluczy i 5 dokumentow


// 9. Przeprowadź eksperyment podający szybkość realizacji zapytania
// db.listingsAndReviews.find().sort({"name":1}) (z indeksem)
// db.listingsAndReviews.find() (bez indeksu)
// (np. wykorzystując .explain("executionStats").executionStats.nReturned zwracana jest ilość dokumentów).
use("sample_airbnb");
db.listingsAndReviews.find().sort({ "name": 1 }).explain("executionStats").executionStats;
db.listingsAndReviews.find().explain("executionStats").executionStats;
db.listingsAndReviews.find().sort({ "name": 1 }).hint({ $natural: 1 }).explain("executionStats").executionStats;
// oba zwracaja nReturned 5555
// sort z indeksem: IXSCAN name_1, ok 5 ms - dokumenty od razu wychodza posortowane z indeksu
// find() bez indeksu: COLLSCAN ok 2 ms - szybciej bo nic nie sortuje, tylko czyta po kolei
// ten sam sort ale wymuszony bez indeksu (hint $natural): COLLSCAN + SORT w pamieci ok 69 ms - wiec indeks przy sortowaniu daje duzo


// 10. Wyeksportuj jedną z kolekcji do pliku CSV a następnie zaimportuj do bazy (korzystamy z mongoexport i monogoimport). Baza sample_airbnb
// -- c:\data\mongoexport --db sample_airbnb --collection listingsAndReviews --type=csv --fields _id,name,property_type,bedrooms,beds,price,address.country --out c:\data\listings.csv
// -- c:\data\mongoimport --db sample_airbnb --collection listings_csv --type=csv --headerline --file c:\data\listings.csv
// przy csv trzeba podac --fields (csv nie zna zagniezdzen ani list), wraca 5555 dokumentow,
// price wraca jako zwykla liczba a nie Decimal128, address.country znowu robi sie zagniezdzonym dokumentem
use("sample_airbnb");
db.listings_csv.countDocuments();
db.listings_csv.findOne();




// Zapytania z bazy sample_airbnb
// (korzystamy z funkcji aggregate() - bardziej zaawansowane operacje, np. grupowanie, sumowanie, filtrowanie, sortowanie i projekcja w jednym pipeline)
use("sample_airbnb");
// 11. Podaj uniklane wartości z pola property_type (operator $group):
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: "$property_type" } }]);

// Wynik:
// [
//   { _id: 'Cabin' },
//   { _id: 'Aparthotel' },
//   { _id: 'Apartment' },
// ....

// 12. Podaj 1 dokument z kolekcji listingsAndReviews (operator $limit):
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $limit: 1 }]);

// Wynik:
// [
//   {
//     _id: '10009999',
//     listing_url: 'https://www.airbnb.com/rooms/10009999',
//     name: 'Horto flat with small garden',
// ....

// 13. Podaj 3 dokumenty, ale będzie on zawierać tylko określone pola (name, property_type, bedrooms, beds, address.country) (operator $project)
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $limit: 3 },
  { $project: { _id: 0, name: 1, property_type: 1, bedrooms: 1, beds: 1, "address.country": 1 } }
]);

// Wynik:
// [
//   {
//     name: 'Horto flat with small garden',
//     property_type: 'Apartment',
//     bedrooms: 1,
//     beds: 2,
//     address: { country: 'Brazil' }
//   },
//   {
//     name: 'Apt Linda Vista Lagoa - Rio',
//     property_type: 'Apartment',
//     bedrooms: 1,
//     beds: 1,
//     address: { country: 'Brazil' }
//   },

// 14. Podaj 3 dokumenty posortowane w kolejności malejącej według pola beds i wyświetlić pola name i beds (operator $sort)
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $sort: { beds: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, name: 1, beds: 1 } }
]);

// Wynik:
// [
//   { name: 'Venue Hotel Old City', beds: 25 },
//   { name: 'LUXURY HOUSE IN BARRA DA TIJUCA', beds: 18 },
//   { name: 'Excellent Location and price !', beds: 16 }
// ]

// 15. Podaj 3 dokumenty, które mają property_type = "House" (operator $match)
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $match: { property_type: "House" } },
  { $limit: 3 },
  { $project: { _id: 0, name: 1, price: 1 } }
]);

// Wynik:
// [
//   { name: 'Ribeira Charming Duplex', price: '80.00' },
//   { name: 'Charming Flat in Downtown Moda', price: '527.00' }
// ]

// 16. Znaleźć najtańsze 3 apartamenty ("price") i wyświetlić w jakim państwie znajdują się.
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $match: { property_type: "Apartment" } },
  { $sort: { price: 1 } },
  { $limit: 3 },
  { $project: { _id: 0, name: 1, price: 1, "address.country": 1 } }
]);

// Wynik:
// [
//   {
//     name: 'Room on spacious appartment',
//     price: Decimal128("9.00"),
//     address: { country: 'Portugal' }
//   },
//   {
//     name: 'Private room with sunny terrace of 200m2. 6',
//     price: Decimal128("10.00"),
//     address: { country: 'Spain' }
//   },
//  ...

// 17. Znaleźć 5 dokumentów wraz z nowym polem country, które będzie zawierać wartość z klucza address.country
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $limit: 5 },
  { $project: { _id: 0, name: 1, country: "$address.country", price: 1 } }
]);

// Wynik:
// [
//   {
//     name: 'Horto flat with small garden',
//     country: 'Brazil',
//     price: '317.00'
//   },
//   {
//     name: 'Apt Linda Vista Lagoa - Rio',
//     country: 'Brazil',
//     price: '701.00'
//   },
// ....

// 18. Podaj liczbę dokumentów dla państwa Portugal.
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $match: { "address.country": "Portugal" } },
  { $count: "totalPortugal" }
]);

// Wynik:
// [ { totalPortugal: 555 } ]

// 19. Ile lokalów jest do wynajęcia w każdym z państw.
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: "$address.country", totalLocal: { $sum: 1 } } }]);

// Wynik:
// [
//   { _id: 'Brazil', totalLocal: 606 },
//   { _id: 'Turkey', totalLocal: 661 },
//   { _id: 'China', totalLocal: 19 },
//   { _id: 'Canada', totalLocal: 649 },
//   { _id: 'Australia', totalLocal: 610 },
//   { _id: 'Spain', totalLocal: 633 },
//   { _id: 'United States', totalLocal: 1222 },
//   { _id: 'Hong Kong', totalLocal: 600 },
//   { _id: 'Portugal', totalLocal: 555 }
// ]

// 20. Ile osób można pomieścić we wszystkich wynajmowanych ofertach w każdym z państw.
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }]);

// Wynik:
// [
//   { _id: 'Portugal', totalPeople: 2243 },
//   { _id: 'Brazil', totalPeople: 2499 },
//   { _id: 'Canada', totalPeople: 2262 },
//   { _id: 'Turkey', totalPeople: 1976 },
//   { _id: 'Australia', totalPeople: 2099 },
//   { _id: 'China', totalPeople: 47 },
//   { _id: 'United States', totalPeople: 4407 },
//   { _id: 'Spain', totalPeople: 2193 },
//   { _id: 'Hong Kong', totalPeople: 1749 }
// ]

// 21. Na podstawie powyższej instrukcji zdefiniuj nową kolekcję country, w której nazwa kraju będzie będzie identyfikatorem _id.
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } },
  { $out: "country" }
]);

// Wynik:
// wykonaj polecenie - db.country.find()
db.country.find();

// 22. (Baza northwind) Wyświetl 3 dokumenty z kolekcji orders gdzie zamiast customer wstawimy dokument z koleckji customers ($lookup)
use("northwind");
db.orders.aggregate([
  { $limit: 3 },
  { $lookup: { from: "customers", localField: "customer", foreignField: "_id", as: "customer1" } }
]);

// Wynik:
// [
//   {
//     _id: 'o1',
//     customer: 1,
//     quantity: 10,
//     cost: 1200,
//     discount: 20,
//     totalCost: 960,
//     customer1: [
//       {
//         _id: 1,
//         firstName: 'Adam',
//         lastName: 'Kowalski',
//         phone: '235 786 123',
//         email: 'adam_kowalski@inlook.pl',
//         created_date: '2021-01-16',
//         purchase: [ 'o2', 'o4', 'o6' ]
//       }
//     ]
//   },
// ....

// 23. Łączna liczba łóżek w całej kolekcji:
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: null, totalBeds: { $sum: "$beds" } } }]);

// Wynik:
// [ { _id: null, totalBeds: 11480 } ]

// 24. Minimalny i maksymalny czas pobytu:
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $group: { _id: null, minNights: { $min: "$minimum_nights" }, maxNights: { $max: "$maximum_nights" } } }
]);
// minimum_nights i maximum_nights sa stringami wiec min/max porownuje tekstowo ('999' > '1125')

// Wynik:
// [ { _id: null, minNights: '1', maxNights: '999' } ]

// 25. Ilość recenzji dla każdego obiektu (number_of_reviews):
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: "$_id", totalReviews: { $sum: "$number_of_reviews" } } }]);
// Wynik (tylko część wyniku):
// [
//   { _id: '27643974', totalReviews: 0 },
//   { _id: '11157167', totalReviews: 26 },
//   { _id: '20767798', totalReviews: 161 },
//   { _id: '29799437', totalReviews: 7 },
//   ...

// 26. Lista unikalnych udogodnień (amenities - uwaga lista, wykorzystać operator $unwind i $addToSet):
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $unwind: "$amenities" },
  { $group: { _id: null, uniqueAmenities: { $addToSet: "$amenities" } } }
]);

// Wynik:
// [
//   {
//     _id: null,
//     uniqueAmenities: [
//       'Garden or backyard',
//       'Indoor fireplace',
//       'Roll-in shower',
// ...

// 27. Średnia cena za noc:
use("sample_airbnb");
db.listingsAndReviews.aggregate([{ $group: { _id: null, avgPricePerNight: { $avg: "$price" } } }]);

// Wynik:
// [
//   {
//     _id: null,
//     avgPricePerNight: Decimal128("278.7661566156615661566156615661566")
//   }
// ]

// 28. Jakie są średnie ceny noclegów dla różnych rodzajów obiektów zaczynających się na literę C (nieważna wielkość litery C)?
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $match: { property_type: /^c/i } },
  { $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } },
  { $project: { averagePrice: { $round: ["$averagePrice", 2] } } }
]);

// Wynik:
// [
//  { _id: 'Campsite', averagePrice: Decimal128("25.00") },
//  { _id: 'Cottage', averagePrice: Decimal128("200.35") },
//  { _id: 'Camper/RV', averagePrice: Decimal128("64.50") },
// ....

// 29. Jakie są średnie ceny noclegów dla różnych rodzajów obiektów zaczynających się na literę C oraz w jakim państwie jest dany obiekt?
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $match: { property_type: /^c/i } },
  { $group: { _id: "$property_type", averagePrice: { $avg: "$price" }, country: { $first: "$address.country" } } },
  { $project: { averagePrice: { $round: ["$averagePrice", 2] }, country: 1 } }
]);

// Wynik:
// [
//   {
//     _id: 'Cottage',
//     averagePrice: Decimal128("200.35"),
//     country: 'Portugal'
//   },
//   {
//     _id: 'Camper/RV',
//     averagePrice: Decimal128("64.50"),
//     country: 'Canada'
//   },
//   {
//     _id: 'Campsite',
//     averagePrice: Decimal128("25.00"),
//     country: 'United States'
//   },
// ....

// 30. Które 3 obiekty mają najwięcej opinii i z jakiego państwa (number_of_reviews)?
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $sort: { number_of_reviews: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, name: 1, number_of_reviews: 1, country: "$address.country" } }
]);

// Wynik:
// [
//   {
//     name: '#Private Studio - Waikiki Dream',
//     number_of_reviews: 533,
//     country: 'United States'
//   },
//   {
//     name: 'Near Airport private room, 2 bedroom granny flat**',
//     number_of_reviews: 469,
//     country: 'Australia'
//   },
//   {
//     name: 'La Sagrada Familia (and metro) 4 blocks!',
//     number_of_reviews: 463,
//     country: 'Spain'
//   }
// ]
