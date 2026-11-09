// Mateusz Mróz 251190

// 0. Importujemy jeden duży plik z dokumentami JSON (wcześniej przygotowany z plików pobranych poniżej)
// Wykorzystujemy dane do MongoDB dużego zbioru danych o dość złożonej strukturze. Dane pobrano z serwisu filmowego IMDb, https://www.imdb.com/interfaces.
// Dostęp do pliku z sieci lokalnej - podany na zajęciach.
// -- docker cp .\movies.json mongodb:/data/movies.json
// -- docker exec mongodb mongoimport --db imdb --collection movies --file /data/movies.json
// 23539 filmow: title, year, countries (lista), genres (lista), directors, cast, imdb { rating, votes, id }, runtime...
use("imdb");
db.movies.countDocuments();
db.movies.findOne();


// Wykonujemy szereg zapytań:
// 1. zapytania punktowe, gdzie poszukujemy konkretnego dokumentu (Ew. dokumentów), np. gdy chcemy wyświetlić dane o filmie o podanym tytule,
use("imdb");
db.movies.find({ title: "The Godfather" });
db.movies.find({ title: "The Godfather" }).explain("executionStats").executionStats.executionTimeMillis;
// COLLSCAN, przeglada wszystkie 23539 dokumentow, ok 10 ms


// 2. zdefiniować odpowiedni indeks (indeksy) i powtórzyć powyższe zapytanie. Zaobserwować wzrost szybkości odpowiedzi,
//   wykorzystać składnię dodając do zapytania w celu zwrócenia czasu wykonania: .explain("executionStats").executionStats.executionTimeMillis;
use("imdb");
db.movies.createIndex({ title: 1 });
db.movies.find({ title: "The Godfather" }).explain("executionStats").executionStats.executionTimeMillis;
// IXSCAN title_1, przeglada 1 dokument, 0 ms


// 3. zapytania agregujące dane (funkcjonalny odpowiednik klauzuli GROUP BY w bazach relacyjnych),
//   np. policzenie ile filmów otrzymało wskazany rating, ile mamy filmów wyprodukowanych w kolejnych latach, itp.,
use("imdb");
db.movies.aggregate([
  { $match: { "imdb.rating": 8 } },
  { $count: "filmy_z_ratingiem_8" }
]);

db.movies.aggregate([
  { $group: { _id: "$imdb.rating", ile: { $sum: 1 } } },
  { $sort: { _id: -1 } }
]);

db.movies.aggregate([
  { $match: { year: { $type: "number" } } },
  { $group: { _id: "$year", ile: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]);
// year w kilku filmach jest stringiem (np. '2010è') wiec je pomijam


// 4. zapytania przedziałowe, np. ile filmów wyprodukowano w podanym zakresie lat. Rozważyć utworzenie stosownych indeksów,
use("imdb");
db.movies.countDocuments({ year: { $gte: 2000, $lte: 2010 } });
db.movies.find({ year: { $gte: 2000, $lte: 2010 } }).explain("executionStats").executionStats;

db.movies.createIndex({ year: 1 });
db.movies.find({ year: { $gte: 2000, $lte: 2010 } }).explain("executionStats").executionStats;
// 8719 filmow, bez indeksu COLLSCAN po 23539 dok ok 12 ms, z indeksem year_1 IXSCAN tylko 8719 dok ok 6 ms


// 5. zapytania z operatorami logicznymi, np. filmy powstałe w Polsce w roku 2010 z rankingiem większym niż 5,
use("imdb");
db.movies.find(
  { $and: [{ countries: "Poland" }, { year: 2010 }, { "imdb.rating": { $gt: 5 } }] },
  { _id: 0, title: 1, year: 1, countries: 1, "imdb.rating": 1 }
);

db.movies.find(
  { $or: [{ countries: "Poland" }, { countries: "Czech Republic" }], year: { $gte: 2010 }, "imdb.rating": { $not: { $lt: 7 } } },
  { _id: 0, title: 1, year: 1, countries: 1, "imdb.rating": 1 }
);


// 6. zapytania z sortowaniem danych, np. sortowanie wybranej kolekcji filmów po ich tytułach,
use("imdb");
db.movies.find({ countries: "Poland" }, { _id: 0, title: 1, year: 1 }).sort({ title: 1 });


// 7. zapytania wyświetlające dane statystyczne, np. średni ranking filmów z USA, Polski, Niemiec,
use("imdb");
db.movies.aggregate([
  { $match: { "imdb.rating": { $type: "number" } } },
  { $unwind: "$countries" },
  { $match: { countries: { $in: ["USA", "Poland", "Germany"] } } },
  { $group: { _id: "$countries", sredniRating: { $avg: "$imdb.rating" }, minRating: { $min: "$imdb.rating" }, maxRating: { $max: "$imdb.rating" }, ileFilmow: { $sum: 1 } } },
  { $sort: { sredniRating: -1 } }
]);
// Polska 6.94 (255 filmow), Niemcy 6.67 (1657), USA 6.54 (11831)
// bez pierwszego $match maxRating wychodzil '' bo czesc filmow ma pusty rating jako string


// 8. zapytania z sortowanie danych oraz ograniczaniem ilości wyświetlanych dokumentów (metody sort() oraz limit()).
use("imdb");
db.movies.find(
  { "imdb.rating": { $type: "number" }, "imdb.votes": { $gte: 10000 } },
  { _id: 0, title: 1, year: 1, "imdb.rating": 1 }
).sort({ "imdb.rating": -1 }).limit(10);
// bez $type na gorze wychodza filmy z pustym ratingiem '' bo stringi sa w sortowaniu wyzej niz liczby
