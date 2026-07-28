from google import genai
from google.genai import types
from openai import OpenAI
from response_schema import PompsWorkflow
from dotenv import load_dotenv
from database import *
from tools import Tools
import time
import os

load_dotenv()

def load_prompt(file: str):
    with open(f"prompts/{file}") as p:
        prompt = p.read()
        return prompt

class AI_Logic(Tools):
    def __init__(self, model):
        self.model = model
        self.clinet = genai.Client(api_key=os.getenv("GEMINI_KEY"))
        self.models = self.clinet.models
    
    def fertilizers_steering(self, sensors_data):
        response = self.models.generate_content(
            model=self.model,
            contents=[
                types.Part(text=sensors_data),
                types.Part(text=load_prompt("fertilizers_steering_prompt.txt"))
            ],
            config=types.GenerateContentConfig(
                response_json_schema=PompsWorkflow.model_json_schema(),
                tools=[self.weather_check,self.light_data,types.GoogleSearch()]
                )
            )
        return response.text
    
    def light_steering(self):
        response = self.models.generate_content(
            model=self.model,
            contents=[
                types.Part(text=f"Current timestamp: {time.time()-946771200}"),
                types.Part(text=load_prompt("light_steering_prompt.txt"))
            ],
            config=types.GenerateContentConfig(tools=[
                self.weather_check, 
                types.GoogleSearch()])
            )
        return response.text
    
class AI_Logic_Debug(AI_Logic):
    def __init__(self, model):
        self.model = model
        self.models = OpenAI(base_url='http://localhost:11434/v1', api_key='ollama')

    def fertilizers_steering(self, sensors_data):
        response = self.models.chat.completions.parse(
            model=self.model,
            temperature=0.4,
            messages=[
                {"role": "system", "content": load_prompt("fertilizers_steering_prompt.txt")},
                {"role": "user", "content": f"sensors_data: {sensors_data}"},
                {"role": "user", "content": f"weather_data: {self.weather_check("Warsaw","pl")}"},
                {"role": "user", "content": f"fertilizers_data: {self.fertilizers_data("W210428_Prototype_1")}"}
            ],
            response_format=PompsWorkflow
        )
        return response.choices[0].message.content
    
    def light_steering(self):
        print(f"Current time: {time.time()-946771200}")
        response = self.models.chat.completions.create(
            model=self.model,
            temperature=0.0,
            messages=[
                {"role": "system", "content": load_prompt("light_steering_prompt.txt")},
                {"role": "user", "content": f"Current timestamp: {time.time()}"},
                {"role": "user", "content": f"weather_data: {self.weather_check("Warsaw","pl")}"},
                {"role": "user", "content": f"sunrise_sunset: {self.sunrise_sunset(52.193346,20.899060)}"},
                {"role": "user", "content": f"lamps_working: {self.light_data(user="W210428_Prototype_1")}"},
            ],
        )
        return response.choices[0].message.content
        

if os.getenv("DEBUG"): 
    ai = AI_Logic_Debug("gemma2:latest")
else:
    ai = AI_Logic("gemini-3-flash-preview")