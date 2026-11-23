from pyspark.sql import SparkSession
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.evaluation import MulticlassClassificationEvaluator

from letter_schema import schema, FEATURES

spark = SparkSession.builder.appName("ml_3").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

df = spark.read.csv("./letter/letter-recognition.data", header=False, schema=schema)
train, test = df.randomSplit([0.8, 0.2], seed=42)
print("train:", train.count(), "test:", test.count())

rf = RandomForestClassifier(labelCol="label", featuresCol="features", numTrees=50, maxDepth=15, seed=42)
for param in list(rf._defaultParamMap):
    if param.name == "pruneTree":
        del rf._defaultParamMap[param]

pipeline = Pipeline(stages=[
    StringIndexer(inputCol="lettr", outputCol="label"),
    VectorAssembler(inputCols=FEATURES, outputCol="features"),
    rf,
])

model = pipeline.fit(train)
for stage in model.stages:
    for param in list(stage._defaultParamMap):
        if param.name == "pruneTree":
            del stage._defaultParamMap[param]
model.write().overwrite().save("./model")

pred = model.transform(test)
acc = MulticlassClassificationEvaluator(labelCol="label", predictionCol="prediction", metricName="accuracy").evaluate(pred)
print("accuracy (test):", round(acc, 4))
