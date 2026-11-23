from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("rec_1").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

ratings = spark.read.csv("./ml-latest-small/ratings.csv", header=True, inferSchema=True)
movies = spark.read.csv("./ml-latest-small/movies.csv", header=True, inferSchema=True)

ratings.printSchema()
ratings.show(5)
movies.show(5, truncate=False)

print("oceny:", ratings.count())
print("uzytkownicy:", ratings.select("userId").distinct().count())
print("filmy z ocenami:", ratings.select("movieId").distinct().count())
ratings.groupBy("rating").count().orderBy("rating").show()
