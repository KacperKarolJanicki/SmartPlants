from functionality import *
from machine import Pin
import asyncio

turn_on = False
    
def sensor_state(sensor):
    if sensor > 2.6:
        return "wet"
    elif sensor > 2:
        return "semi-wet"
    else:
        return "dry"


async def automatics_start(data):
        water_pomp_1 = Output(pin=18)
        water_pomp_2 = Output(pin=19)
        water_pomp_3 = Output(pin=21)
        water_pomp_4 = Output(pin=22)
        
        while turn_on:
            water_sensor_1 = Input(pin=32, pull_mode=Pin.PULL_DOWN)
            water_sensor_2 = Input(pin=33, pull_mode=Pin.PULL_DOWN)
            water_sensor_3 = Input(pin=34, pull_mode=Pin.PULL_DOWN)
            water_sensor_4 = Input(pin=35, pull_mode=Pin.PULL_DOWN)
            
            if "water_pomp_1" in data:
                pomp_1_state = data["water_pomp_1"]
                
                if water_sensor_1.voltage_data() <= pomp_1_state["dry_voltage"] and pomp_1_state['pomp_time'] < 180:
                    water_pomp_1.set_timer(t=pomp_1_state['pomp_time'])
                    await asyncio.sleep(1)
                else:
                    print("1 is wet")
                
            if "water_pomp_2" in data:
                pomp_2_state = data["water_pomp_2"]
                
                if water_sensor_2.voltage_data() <= pomp_2_state["dry_voltage"] and pomp_2_state['pomp_time'] < 180:
                    water_pomp_2.set_timer(t=pomp_2_state['pomp_time'])
                    await asyncio.sleep(1)
                else:
                    print("2 is wet")
            
            if "water_pomp_3" in data:
                pomp_3_state = data["water_pomp_3"]
                
                if water_sensor_3.voltage_data() <= pomp_3_state["dry_voltage"] and pomp_3_state['pomp_time'] < 180:
                    water_pomp_3.set_timer(t=pomp_3_state['pomp_time'])
                    await asyncio.sleep(1)
                else:
                    print("3 is wet")
                
            if "water_pomp_4" in data:
                pomp_4_state = data["water_pomp_4"]
                
                if water_sensor_4.voltage_data() <= pomp_4_state["dry_voltage"] and pomp_4_state['pomp_time'] < 180:
                    water_pomp_4.set_timer(t=pomp_4_state['pomp_time'])
                else:
                    print("4 is wet")
            await asyncio.sleep(3600)
        return "Finished"
