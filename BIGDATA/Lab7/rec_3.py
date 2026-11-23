from pyspark.sql import SparkSession
from pyspark.sql import functions as f
from pyspark.ml.recommendation import ALSModel

spark = SparkSession.builder.appName("rec_3").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

movies = spark.read.csv("./ml-latest-small/movies.csv", header=True, inferSchema=True)
model = ALSModel.load("./als_model")

users = spark.createDataFrame([(1,), (2,), (3,)], ["userId"])
rec = model.recommendForUserSubset(users, 5)
rec.select("userId", f.explode("recommendations").alias("r")).select(
    "userId", "r.movieId", f.round("r.rating", 2).alias("przewidywana_ocena")
).join(movies, "movieId").orderBy("userId", f.desc("przewidywana_ocena")).select(
    "userId", "title", "przewidywana_ocena"
).show(truncate=False)

films = spark.createDataFrame([(1,), (296,), (2571,)], ["movieId"])
rec = model.recommendForItemSubset(films, 5)
rec.select("movieId", f.explode("recommendations").alias("r")).select(
    "movieId", "r.userId", f.round("r.rating", 2).alias("przewidywana_ocena")
).join(movies, "movieId").orderBy("movieId", f.desc("przewidywana_ocena")).select(
    "title", "userId", "przewidywana_ocena"
).show(truncate=False)
