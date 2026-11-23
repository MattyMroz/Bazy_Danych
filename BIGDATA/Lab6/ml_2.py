from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType
schema = StructType([
    StructField("lettr", StringType(),  True),
    StructField("x_box", IntegerType(), True),
    StructField("y_box", IntegerType(), True),
    StructField("width", IntegerType(), True),
    StructField("high",  IntegerType(), True),
    StructField("onpix", IntegerType(), True),
    StructField("x_bar", IntegerType(), True),
    StructField("y_bar", IntegerType(), True),
    StructField("x2bar", IntegerType(), True),
    StructField("y2bar", IntegerType(), True),
    StructField("xybar", IntegerType(), True),
    StructField("x2ybr", IntegerType(), True),
    StructField("xy2br", IntegerType(), True),
    StructField("x_ege", IntegerType(), True),
    StructField("xegvy", IntegerType(), True),
    StructField("y_ege", IntegerType(), True),
    StructField("yegvx", IntegerType(), True),])
spark = SparkSession.builder.appName("ml").getOrCreate()
df = spark.read.csv("./letter/letter-recognition.data",
                    header=False, schema=schema)
df.show(10)
df.schema
