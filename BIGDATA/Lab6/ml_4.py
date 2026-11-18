from pyspark.sql import SparkSession
from pyspark.sql import functions as f
from pyspark.ml.evaluation import MulticlassClassificationEvaluator

from letter_schema import schema, load_model

spark = SparkSession.builder.appName("ml_4").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

df = spark.read.csv("./letter/letter-recognition.data", header=False, schema=schema)
train, test = df.randomSplit([0.8, 0.2], seed=42)

model = load_model("./model")
labels = model.stages[0].labels
pred = model.transform(test).withColumn("predicted", f.element_at(f.array(*[f.lit(x) for x in labels]), (f.col("prediction") + 1).cast("int")))

for metric in ["accuracy", "weightedPrecision", "weightedRecall", "f1"]:
    value = MulticlassClassificationEvaluator(labelCol="label", predictionCol="prediction", metricName=metric).evaluate(pred)
    print(metric, round(value, 4))

pred.select("lettr", "predicted").show(10)
pred.groupBy("lettr").agg(f.round(f.avg((f.col("lettr") == f.col("predicted")).cast("int")), 3).alias("skutecznosc")).orderBy("skutecznosc").show(26)
