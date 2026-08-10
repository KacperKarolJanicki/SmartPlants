from flask import Flask, request
from dotenv import load_dotenv
from auth import authorization
from database import *
from ai_logic import ai
from manual_logic import *
from datetime import *
import threading

load_dotenv()
app = Flask(__name__)


@app.route("/ground_data", methods=["GET","POST"])
def ground_data():
    # authorization()

    device_ip = request.headers.get('deviceIp')

    if request.method == "GET":
        response = requests.get(device_ip)
        return response.json()
    if request.method == "POST":
        data = request.get_json()
        response = requests.post(device_ip, json=data)
        return response.json()


@app.route("/light", methods=["POST","GET"])
def light():

    device_ip = request.headers.get('deviceIp')

    if request.method == "GET":
        result = manual_steering.light_steering()
        return result
    if request.method == "POST":
        # authorization()
        data = request.get_json()
        response = requests.post(device_ip, json=data)
        return "Ok"

@app.route("/automatics", methods=["POST"])
def automatics():
    device_ip = request.headers.get('deviceIp')
    data = request.get_json()
    print(data)
    try:
        requests.post(f"{device_ip}/automatics", json=data)
        return "Ok"
    except Exception as e:
        return e 
    
@app.route("/plants_data", methods=["GET"])
def plants_data():
    # header = request.headers.get("deviceId")
    # authorization(header)
    return list(plants_database["data"].find({},{"_id":0}))[::-1]
        
        

@app.route("/", methods=["POST","GET"])
def home():
    return "Connected"

threading.Thread(target=run).start()
app.run(host="0.0.0.0", port=3350, debug=False)