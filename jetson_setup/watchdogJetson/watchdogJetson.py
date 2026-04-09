#!/usr/bin/env python3

import Jetson.GPIO as GPIO
import time

wd_pin = 13

GPIO.setmode(GPIO.BOARD)
GPIO.setup(wd_pin, GPIO.OUT, initial=GPIO.LOW)

# 3.3v Square Wave, 1Hz, 50% Duty Cycle

try:
        while True:
                GPIO.output(wd_pin, GPIO.HIGH)
                time.sleep(0.5)
                GPIO.output(wd_pin, GPIO.LOW)
                time.sleep(0.5)
except KeyboardInterrupt:
        print("Exiting")
        GPIO.cleanup()
