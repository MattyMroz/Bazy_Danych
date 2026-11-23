use("airbnb");
// 1. Pobieramy narzędzie mongoimport i inne (MongoDB Command Line Database Tools) do katalogu c:\data
// Znajdziemy go tutaj: https://www.mongodb.com/try/download/database-tools


// 2. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_airbnb.
// Baza ma mieć nazwę airbnb
// (nazwa kolekcji = nazwa pliku bez rozszerzenia) - analizujemy strukturę.
use("airbnb");
db.listingsAndReviews.findOne();

// 3. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_weather.
// Baza ma mieć nazwę weather.
// (nazwa kolekcji = nazwa pliku bez rozszerzenia) - analizujemy strukturę.
use("weather");
db.data.findOne();

// 4. Importujemy za pomocą polecenia mongoimport przykładowy zestaw danych z katalogu .\sample_analytics.
// Baza ma mieć nazwę analytics.
// Tym razem wykorzystujemy polecenie mongoimport z kontenera w dockerze i trzeba przesłać *.json do katalogu /data w kontenerze
// (nazwy kolekcji = nazwy plików bez rozszerzenia) - analizujemy strukturę.
use("analytics");
db.accounts.findOne();
use("analytics");
db.customers.findOne();
use("analytics");
db.transactions.findOne();

// 5. Wylistuj istniejące bazy danych (mongosh) i sprawdź ile jest w nich dokumentów.
// -- use("airbnb")
// -- db.listingsAndReviews.find().count() -- jeśli liczymy liczbę dokumentów zwracanych w zapytaniu
// -- db.listingsAndReviews.count() -- deprecated
// -- db.listingsAndReviews.countDocuments()
// -- db.listingsAndReviews.estimatedDocumentCount()

db.getMongo().getDBNames();
// [
//   'admin',
//   'airbnb',
//   'analytics',
//   'config',
//   'local',
//   'weather'
// ]

use("airbnb");
db.listingsAndReviews.countDocuments();
// 5555

use("weather");
db.data.countDocuments();
// 10000

use("analytics");
db.accounts.countDocuments();
// 1746

use("analytics");
db.customers.countDocuments();
// 500

use("analytics");
db.transactions.estimatedDocumentCount();
// 1746

// 6. Utwórz kopię zapasową (bezpieczeństwa) swoich zaimportowanych kolekcji używając narzędzia mongodump.
// Po wykonaniu kopii zapasowej przywróć dane za pomocą narzędzia mongorestore (po uprzednim usunięciu trzech nowo utworzonych baz).

// docker exec mongodb mongodump --db airbnb --out /data/backup
// docker exec mongodb mongodump --db weather --out /data/backup
// docker exec mongodb mongodump --db analytics --out /data/backup

use("airbnb");
db.dropDatabase();
use("weather");
db.dropDatabase();
use("analytics");
db.dropDatabase();
// docker exec mongodb mongorestore /data/backup
use("airbnb");
db.listingsAndReviews.countDocuments();
// 5555


// 7. Odtwórz bazy z pliku sampledata.archive (wcześniej skasuj trzy nowo utworzone bazy)
// kopiuj archiwum (PowerShell):
// -- curl https://atlas-education.s3.amazonaws.com/sampledata.archive -o sampledata.archive
// lub pobierz z sieci lokalnej.
// -- Kopiuj do kontenera: docker cp C:\temp\sampledata.archive mongodb:/data/sampledata.archive
// -- Rozpakuj z pliku sampledata.archive: docker exec -i mongodb mongorestore --archive=/data/sampledata.archive

// docker exec mongodb mongorestore /data/backup

use("airbnb");
db.dropDatabase();
use("weather");
db.dropDatabase();
use("analytics");
db.dropDatabase();

// docker exec mongodb mongorestore --drop --archive=/data/sampledata.archive

db.getMongo().getDBNames();
use("sample_airbnb");
db.listingsAndReviews.countDocuments();
// 5555

// 8. Wyświetl plan wykonania wybranego zapytania.
// -- db.listingsAndReviews.find().explain("executionStats")
// Czy został użyty jakikolwiek indeks (COLLSCAN (pełne skanowanie kolekcji) czy IXSCAN (skanowanie indeksu))?
// Napisz takie zapytanie, aby MongoDB zdecydował się na indeksu name_1 (np. wybiera element "name" zaczynający się na słowo Resort - wyrażenie regularne).
use("sample_airbnb");
db.listingsAndReviews.find().explain("executionStats");

use("sample_airbnb");
db.listingsAndReviews.find({ name: /^Resort/ }).explain("executionStats");

use("sample_airbnb");
db.listingsAndReviews.getIndexes();
// COLLSCAN bez filtra nie ma po czym użyć indeksu, przegląda wszystkie 5555 dokumentow

// 9. Przeprowadź eksperyment podający szybkość realizacji zapytania
// db.listingsAndReviews.find().sort({"name":1}) (z indeksem)
// db.listingsAndReviews.find() (bez indeksu)
// (np. wykorzystując .explain("executionStats").executionStats.nReturned zwracana jest ilość dokumentów).
use("sample_airbnb");
db.listingsAndReviews.find().sort({ name: 1 }).explain("executionStats").executionStats.executionTimeMillis;

use("sample_airbnb");
db.listingsAndReviews.find().explain("executionStats").executionStats.executionTimeMillis;

use("sample_airbnb");
db.listingsAndReviews.find().sort({ name: 1 }).explain("executionStats").executionStats.nReturned;

use("sample_airbnb");
db.listingsAndReviews.find().explain("executionStats").executionStats.nReturned;


// 10. Wyeksportuj jedną z kolekcji do pliku CSV a następnie zaimportuj do bazy (korzystamy z mongoexport i monogoimport). Baza sample_airbnb
// docker exec mongodb mongoexport --db sample_airbnb --collection listingsAndReviews --type=csv --fields _id,name,property_type,bedrooms,beds --out /data/backup/listings.csv
// docker exec mongodb mongoimport --db sample_airbnb --collection listings_csv --type=csv --headerline --file /data/backup/listings.csv
use("sample_airbnb");
db.listings_csv.countDocuments();

use("sample_airbnb");
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
  {
    $project: {
      _id: 0,
      name: 1,
      property_type: 1,
      bedrooms: 1,
      beds: 1,
      "address.country": 1,
    },
  },
  { $limit: 3 },
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
  { $project: { _id: 0, name: 1, beds: 1 } },
  { $limit: 3 },
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
  { $project: { _id: 0, name: 1, price: 1 } },
  { $limit: 3 },
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
  { $project: { _id: 0, name: 1, price: 1, "address.country": 1 } },
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
  {
    $project: {
      _id: 0,
      name: 1,
      country: "$address.country",
      price: 1,
    },
  },
  { $limit: 5 },
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
  { $count: "totalPortugal" },
]);

// Wynik:
// [ { totalPortugal: 555 } ]

// 19. Ile lokalów jest do wynajęcia w każdym z państw.
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $group: { _id: "$address.country", totalLocal: { $sum: 1 } } },
]);

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
db.listingsAndReviews.aggregate([
  { $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } },
]);

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
  {
    $group: {
      _id: "$address.country",
      totalLocal: { $sum: 1 },
      totalPeople: { $sum: "$accommodates" },
    },
  },
  { $out: "country" },
]);

use("sample_airbnb");
db.country.find();

// Wynik:
// wykonaj polecenie - db.country.find()

// 22. (Baza northwind) Wyświetl 3 dokumenty z kolekcji orders gdzie zamiast customer wstawimy dokument z koleckji customers ($lookup)
use("northwind");
db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer",
      foreignField: "_id",
      as: "customer1",
    },
  },
  { $limit: 3 },
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
db.listingsAndReviews.aggregate([
  { $group: { _id: null, totalBeds: { $sum: "$beds" } } },
]);

// Wynik:
// [ { _id: null, totalBeds: 11480 } ]

// 24. Minimalny i maksymalny czas pobytu:
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  {
    $group: {
      _id: null,
      minNights: { $min: "$minimum_nights" },
      maxNights: { $max: "$maximum_nights" },
    },
  },
]);

// Wynik:
// [ { _id: null, minNights: '1', maxNights: '999' } ]

// 25. Ilość recenzji dla każdego obiektu (number_of_reviews):
use("sample_airbnb");
db.listingsAndReviews.aggregate([
  { $group: { _id: "$_id", totalReviews: { $sum: "$number_of_reviews" } } },
]);

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
  { $group: { _id: null, uniqueAmenities: { $addToSet: "$amenities" } } },
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
db.listingsAndReviews.aggregate([
  { $group: { _id: null, avgPricePerNight: { $avg: "$price" } } },
]);

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
  {
    $group: {
      _id: "$property_type",
      averagePrice: { $avg: "$price" },
      country: { $first: "$address.country" },
    },
  },
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
  {
    $project: {
      _id: 0,
      name: 1,
      number_of_reviews: 1,
      country: "$address.country",
    },
  },
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
