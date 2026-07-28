from flask import Flask, request
from dotenv import load_dotenv
from auth import authorization
from database import *
from ai_logic import ai
from manual_logic import *
from datetime import *

load_dotenv()
app = Flask(__name__)

@app.route("/ground_data", methods=["GET","POST"])
def ground_data():
    if request.method == "GET":
        response = requests.get("http://192.168.0.26")
        return response.json()
    if request.method == "POST":
        data = request.get_json()
        response = requests.post("http://192.168.0.26", json=data)
        return response.json()


@app.route("/light", methods=["POST","GET"])
def light():
    if request.method == "GET":
        result = manual_steering.light_steering()
        return result
    if request.method == "POST":
        data = request.get_json()
        response = requests.post("http://192.168.0.27", json=data)
        return "Ok"
    
@app.route("/plants_data", methods=["POST","GET"])
def plants_data():
    header = request.headers.get("deviceId")

    if request.method == "GET":
        authorization(header)
        return list(plants_database[header].find({},{"_id":0}))[::-1]
    if request.method == "POST":
        authorization(header)
        data = request.get_json()
        if header not in plants_database.list_collection_names():
            plants_database.create_collection(header)
            plants_database[header].insert_one(data)
        else:
            plants_database[header].insert_one(data)
        return "Data updated"
        
        

@app.route("/", methods=["POST","GET"])
def home():
    return "Connected"

app.run(host="0.0.0.0", port=3350, debug=False)