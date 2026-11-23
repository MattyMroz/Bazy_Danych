import json
import random
import sys
from time import sleep

from kafka import KafkaProducer

from letter_schema import FEATURES

server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"

rows = [line.strip().split(",") for line in open("./letter/letter-recognition.data")]

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=lambda x: json.dumps(x).encode("utf-8"),
    api_version=(2, 7, 0),
)

try:
    while True:
        row = random.choice(rows)
        message = {"lettr": row[0], **{name: int(value) for name, value in zip(FEATURES, row[1:])}}
        producer.send("topicBD", value=message)
        print(message["lettr"], flush=True)
        sleep(1)
except KeyboardInterrupt:
    producer.close()
