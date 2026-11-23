# Sliding window: okno 20 s przesuwane co 5 s (okna zachodza na siebie, jedna ocena trafia do kilku okien).
# Uruchomienie: python 3_sliding_window.py localhost:9092
import sys

from pyspark.sql import functions as f

from _common import get_stream

if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"
    spark, parsed = get_stream(server, "slidingWindow")

    result = (
        parsed.groupBy(f.window("event_time", "20 seconds", "5 seconds"))
        .agg(f.count("*").alias("liczba_ocen"), f.round(f.avg("value"), 2).alias("srednia"))
        .orderBy("window")
    )

    query = result.writeStream.outputMode("complete").format("console").option("truncate", "false").start()
    query.awaitTermination(60)
    query.stop()
