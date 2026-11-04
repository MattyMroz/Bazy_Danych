# Watermark: okna 10 s + withWatermark("event_time", "10 seconds").
# Producent opoznia czas zdarzenia o 0-15 s, wiec czesc wiadomosci przychodzi "spoznionych".
# Tryb append: okno jest wypisane dopiero, gdy watermark (max event_time - 10 s) przekroczy jego koniec,
# a zdarzenia starsze niz watermark sa odrzucane.
# Uruchomienie: python 5_watermark.py localhost:9092
import sys

from pyspark.sql import functions as f

from _common import get_stream

if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"
    spark, parsed = get_stream(server, "watermark")

    result = (
        parsed.withWatermark("event_time", "10 seconds")
        .groupBy(f.window("event_time", "10 seconds"))
        .agg(f.count("*").alias("liczba_ocen"), f.round(f.avg("value"), 2).alias("srednia"))
    )

    query = result.writeStream.outputMode("append").format("console").option("truncate", "false").start()
    query.awaitTermination(90)
    query.stop()
