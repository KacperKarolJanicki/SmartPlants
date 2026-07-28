from tools import *
from datetime import *

class ModuleSteereing(Tools):
    def __init__(self):
        self.lights_log = ""

    def __light_breaks(self):
        breaks_list =[
        {"start": 6,"finish": 8},
        {"start": 10,"finish": 12},
        {"start": 14,"finish": 16}]
        return breaks_list

    def light_steering(self):
        current_uv_index = self.uv_index()
        current_sunrise_sunset = self.sunrise_sunset(52.193346, 20.899060)["results"]
        current_clouds = self.weather_check("Warsaw","pl")["clouds"]["all"]
        
        utc_2_sunrise = datetime.fromisoformat(current_sunrise_sunset["sunrise"])
        utc_2_sunset = datetime.fromisoformat(current_sunrise_sunset["sunset"])
        time_now = datetime.now(timezone.utc)
        finish_for_today = time(22,00,0)
        
        # for i in self.__light_breaks():
        #     break_start = time(i["start"],00,0)
        #     break_finish = time(i["finish"],00,0)
        #     if break_start < time_now.time() < break_finish or current_uv_index["uvi"] > 5.5:
        #         self.lights_log = "[LIGHTS LOG]: 🍵 It's time for break 🍩. Turning off the lights"
        #         print(self.lights_log)
        #         return "light_off"

        if utc_2_sunset < time_now and time_now.time() < finish_for_today:
            self.lights_log = "[LIGHTS LOG]: Sunset! 🌙 See U tommorrow sun 🌙! Lamps turning on and do the job now."
            print(self.lights_log)
            return "light_on"
        elif (current_uv_index["uvi"] < 5.5 and utc_2_sunrise < time_now and current_clouds > 90):
            self.lights_log = "[LIGHTS LOG]: Lights on. ⛅ UV Index is less than 6 ⛅"
            print(self.lights_log)
            return "light_on"
        else:
            self.lights_log = f"[LIGHTS LOG]: Don't need lamps. ☀️ Weather is great ☀️ Sunset at {utc_2_sunset.time()}"
            print(self.lights_log)
            return "light_off"
        
manual_steering = ModuleSteereing()