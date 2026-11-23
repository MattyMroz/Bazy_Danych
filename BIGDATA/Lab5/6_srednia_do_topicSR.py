# Srednia ocena kazdego studenta z topicBD, zapisana do topicu topicSR w Kafce (klucz = id, wartosc = JSON).
# Uruchomienie: python 6_srednia_do_topicSR.py localhost:9092
# Podglad wyniku:
# .\bin\windows\kafka-console-consumer.bat --topic topicSR --from-beginning --bootstrap-server localhost:9092
import sys

from pyspark.sql import functions as f

from _common import get_stream

if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"
    spark, parsed = get_stream(server, "srednia")

    avg = parsed.groupBy("id").agg(f.round(f.avg("value"), 2).alias("srednia"), f.count("*").alias("liczba_ocen"))

    out = avg.select(
        f.col("id").alias("key"),
        f.to_json(f.struct("id", "srednia", "liczba_ocen")).alias("value"),
    )

    query = (
        out.writeStream.outputMode("update")
        .format("kafka")
        .option("kafka.bootstrap.servers", server)
        .option("topic", "topicSR")
        .option("checkpointLocation", "C:/BigData/chk/topicSR")
        .start()
    )
    query.awaitTermination(60)
    query.stop()
