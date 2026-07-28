from pymongo import *


client = MongoClient("mongodb://localhost:27017/")
plants_database = client["plants_data"]