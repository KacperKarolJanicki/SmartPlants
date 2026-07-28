from database import *
from flask import abort

def authorization(deviceID):
    auth_d = dict(plants_database["admin"].find_one())
    auth = list(auth_d.get("devices"))

    if deviceID not in auth:
        abort(401)