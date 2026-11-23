from pyspark.sql import SparkSession
from pyspark.ml.recommendation import ALS
from pyspark.ml.evaluation import RegressionEvaluator

spark = SparkSession.builder.appName("rec_2").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

ratings = spark.read.csv("./ml-latest-small/ratings.csv", header=True, inferSchema=True).select("userId", "movieId", "rating")
train, test = ratings.randomSplit([0.8, 0.2], seed=42)
print("train:", train.count(), "test:", test.count())

als = ALS(
    userCol="userId",
    itemCol="movieId",
    ratingCol="rating",
    rank=10,
    maxIter=10,
    regParam=0.1,
    coldStartStrategy="drop",
    seed=42,
)

model = als.fit(train)
model.write().overwrite().save("./als_model")

pred = model.transform(test)
pred.show(10)

rmse = RegressionEvaluator(metricName="rmse", labelCol="rating", predictionCol="prediction").evaluate(pred)
mae = RegressionEvaluator(metricName="mae", labelCol="rating", predictionCol="prediction").evaluate(pred)
print("RMSE:", round(rmse, 4))
print("MAE:", round(mae, 4))
