from machine import Pin, ADC
import time

class Input:
    def __init__(self, pin:int, pull_mode):
        self.pin = Pin(pin, Pin.IN, pull_mode)
        adc = ADC(self.pin)
        adc.atten(ADC.ATTN_11DB)
        self.voltage = adc.read_uv()
        
    def input_state(self):
        return self.pin.value()
    
    def voltage_data(self):
        return self.voltage / 1000000

class Output:
    def __init__(self, pin: int):
        self.pin = Pin(pin, Pin.OPEN_DRAIN, value=1)
        self.pin_number = pin

    def turn_on(self):
        
        #Some function which just turn on something

        self.pin.value(0)
        print(f"Pin {self.pin_number} is giving a signal")

    def turn_off(self):
        
        #Some function which just turn off something

        self.pin.value(1)
        print(f"Pin {self.pin_number} is not giving a signal yet")

    def set_timer(self, t):
        # try:
            self.pin.value(0)
            print(f"Gave a signal at pin {self.pin_number}")

            time.sleep(t)

            self.pin.value(1)
            print(f"Stop giving the signal {self.pin_number}")

        # except Exception as e:
        #     print(f"I have a trouble with giving signal at pin {self.pin_number}. My problem is {e}")