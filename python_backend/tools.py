import requests
from database import *

class Tools:

    def weather_check(self, city:str, country_code:str):
        
        """ Funkcja odpowiedzialna za sprawdzanie pogody
         za pompcą api Open Weather Map. Zwrócony tekst przedstawia
         aktualne dane pogodowe. """
        
        print(f"🤖 [AGENT LOG]: Sprawdzam pogodę w {city},{country_code}")

        url = f"https://api.openweathermap.org/data/2.5/weather?q={city},{country_code}&APPID=d41e5d6be222264aa4b94c928f72f2cc"
        response = requests.get(url)
        return response.json()
    
    def uv_index(self):
        
        """ Funkcja odpowiedzialna za sprawdzanie indexu UV. """
        
        print(f"🤖 [AGENT LOG]: Sprawdzam index UV")

        url = f"http://api.agromonitoring.com/agro/1.0/uvi?polyid=6a3566154e13cb41cdfae646&appid=3540081c2bdb038ae3c39673102911ec"
        response = requests.get(url)
        return response.json()
    
    def sunrise_sunset(self, lat:float, lng:float):
        """
        Funkcja przedstawia dane na temat wschodu i zachodu
        słońca dla aktualnej lokalizacji.
        """

        print(f"🤖 [AGENT LOG]: Sprawdzam godzinę wschodu i zachodu słońca")
        
        url = f"https://api.sunrise-sunset.org/json?lat={lat}&lng={lng}&formatted=0"
        response = requests.get(url)
        return response.json()
    
    # def light_data(self, user):
    #     """
    #     Funkcja zwraca dane o porach uruchamiania i gaszenia lamp.
    #     """
    #     print(f"🤖 [AGENT LOG]: Sprawdzam harmonogram uruchamiania lamp")
        
    #     return list(db_light[user].find({},{"_id":0}))
    
    # def fertilizers_data(self, user):
    #     """
    #     Funkcja zwraca dane o nawożeniu roślin.
    #     """
    #     print(f"🤖 [AGENT LOG]: Sprawdzam harmonogram nawożenia roślin")
    #     return list(db_fertilizers[user].find({},{"_id":0}))