from pyspark.sql import SparkSession
from pyspark.sql import functions as f
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, TimestampType

JSON_SCHEMA = StructType(
    [
        StructField("time", TimestampType()),
        StructField("id", StringType()),
        StructField("value", IntegerType()),
    ]
)


def get_stream(server, app_name):
    """Strumien ocen z topicu topicBD jako kolumny: event_time, id, value."""
    spark = SparkSession.builder.appName(app_name).getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")
    raw = (
        spark.readStream.format("kafka")
        .option("kafka.bootstrap.servers", server)
        .option("subscribe", "topicBD")
        .option("startingOffsets", "latest")
        .load()
    )
    parsed = raw.select(f.from_json(raw.value.cast("string"), JSON_SCHEMA).alias("j")).select(
        f.col("j.time").alias("event_time"),
        f.col("j.id").alias("id"),
        f.col("j.value").alias("value"),
    )
    return spark, parsed
