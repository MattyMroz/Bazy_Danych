# spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.13:4.3.0 ml_6.py localhost:9092
import sys

from pyspark.sql import SparkSession
from pyspark.sql import functions as f

from letter_schema import schema, load_model

server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"

spark = SparkSession.builder.appName("ml_6").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

model = load_model("./model")
labels = model.stages[0].labels

raw = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", server)
    .option("subscribe", "topicBD")
    .load()
)

letters = (
    raw.select(f.from_json(raw.value.cast("string"), schema).alias("j"))
    .select("j.*")
    .where(f.col("lettr").isNotNull() & f.col("x_box").isNotNull())
)


def show_batch(batch, batch_id):
    if batch.isEmpty():
        return
    out = model.transform(batch).withColumn(
        "predicted", f.element_at(f.array(*[f.lit(x) for x in labels]), (f.col("prediction") + 1).cast("int"))
    )
    out = out.select("lettr", "predicted", (f.col("lettr") == f.col("predicted")).alias("ok"))
    total = out.count()
    good = out.where("ok").count()
    print("batch", batch_id, "poprawnie", good, "z", total)
    out.show(truncate=False)


query = letters.writeStream.foreachBatch(show_batch).start()
query.awaitTermination(90)
query.stop()
