from microdot import Microdot
from functionality import *
from machine import Pin
app = Microdot()

def sensor_state(sensor):
    if sensor > 2.6:
        return "wet"
    elif sensor > 2:
        return "semi-wet"
    else:
        return "dry"
    

@app.route('/', methods=['POST','GET'])
async def ground_data(request):
    data = request.json
    
    water_sensor_1 = Input(pin=32, pull_mode=Pin.PULL_DOWN)
    water_sensor_2 = Input(pin=33, pull_mode=Pin.PULL_DOWN)
    water_sensor_3 = Input(pin=34, pull_mode=Pin.PULL_DOWN)
    water_sensor_4 = Input(pin=35, pull_mode=Pin.PULL_DOWN)
    
    water_pomp_1 = Output(pin=18)
    water_pomp_2 = Output(pin=19)
    water_pomp_3 = Output(pin=21)
    water_pomp_4 = Output(pin=22)
    
    sensor_voltage_1 = water_sensor_1.voltage_data()
    sensor_voltage_2 = water_sensor_2.voltage_data()
    sensor_voltage_3 = water_sensor_3.voltage_data()
    sensor_voltage_4 = water_sensor_4.voltage_data()
    
    sensors_data = {
            "sensor_voltage_1":sensor_voltage_1,
            "sensor_voltage_2":sensor_voltage_2,
            "sensor_voltage_3":sensor_voltage_3,
            "sensor_voltage_4":sensor_voltage_4,
            "sensor_1_ground": sensor_state(sensor_voltage_1),
            "sensor_2_ground": sensor_state(sensor_voltage_2),
            "sensor_3_ground": sensor_state(sensor_voltage_3),
            "sensor_4_ground": sensor_state(sensor_voltage_4),
            }
    
    if request.method == 'GET':
        return sensors_data
    
    if request.method == 'POST':
        print(data)
        
        if "water_pomp_1" in data:
            pomp_1_state = data["water_pomp_1"]
            
            if water_sensor_1.voltage_data() <= pomp_1_state["dry_voltage"] and pomp_1_state['pomp_time'] < 180:
                water_pomp_1.set_timer(t=pomp_1_state['pomp_time'])
                time.sleep(1)
            
        if "water_pomp_2" in data:
            pomp_2_state = data["water_pomp_2"]
            
            if water_sensor_2.voltage_data() <= pomp_2_state["dry_voltage"] and pomp_2_state['pomp_time'] < 180:
                water_pomp_2.set_timer(t=pomp_2_state['pomp_time'])
                time.sleep(1)
        
        if "water_pomp_3" in data:
            pomp_3_state = data["water_pomp_3"]
            
            if water_sensor_3.voltage_data() <= pomp_3_state["dry_voltage"] and pomp_3_state['pomp_time'] < 180:
                water_pomp_3.set_timer(t=pomp_3_state['pomp_time'])
                time.sleep(1)
            
        if "water_pomp_4" in data:
            pomp_4_state = data["water_pomp_4"]
            
            if water_sensor_4.voltage_data() <= pomp_4_state["dry_voltage"] and pomp_4_state['pomp_time'] < 180:
                water_pomp_4.set_timer(t=pomp_4_state['pomp_time'])
                time.sleep(1)
        return sensors_data

    
app.run(host="0.0.0.0",port=80)