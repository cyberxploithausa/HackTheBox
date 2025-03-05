#!/bin/sh
#PORT 0
#USB2.0/3.0 LED Trigger
#If PORT1 exist , you need to add other trigger.
echo "1-1,2-1" > /sys/class/leds/led_usb/device_name

