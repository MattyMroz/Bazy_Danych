import json
import random
import sys
from datetime import datetime, timedelta
from time import sleep

from kafka import KafkaProducer


if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"

    producer = KafkaProducer(
        bootstrap_servers=[server],
        value_serializer=lambda x: json.dumps(x).encode("utf-8"),
        api_version=(2, 7, 0),
    )

    try:
        while True:
            message = {
                "time": str(
                    datetime.now() + timedelta(seconds=random.randint(-15, 0))
                ),
                "id": random.choice(["Jan1", "Ania2", "Adam3", "Alan4", "Zofia5"]),
                "value": random.randint(2, 5),
            }
            producer.send("topicBD", value=message)
            sleep(1)
    except KeyboardInterrupt:
        producer.close()