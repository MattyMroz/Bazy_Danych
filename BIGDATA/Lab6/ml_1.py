from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("ml").getOrCreate()
df = spark.read.csv("./letter/letter-recognition.data",
                    header=False, inferSchema=True)
df.show(10)
df.schema
