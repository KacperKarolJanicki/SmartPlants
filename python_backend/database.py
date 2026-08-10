from pymongo import *
import requests
import time
from datetime import datetime, timezone

client = MongoClient("mongodb://localhost:27017/")
plants_database = client["plants_data"]

def ask_sensors():
    data = {"datetime": datetime.now(timezone.utc).isoformat()}
    try:
        response = requests.get("http://192.168.0.26/")
        data.update(response.json())
        return data
    except Exception as e:
        return {"error": e}

def run():
    while True:
        plants_database["data"].insert_one(ask_sensors())
        time.sleep(3600)