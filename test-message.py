import threading
import serial
import time

serial_port = serial.Serial('COM4', 96000, serial.EIGHTBITS, serial.PARITY_EVEN)

print("sending message...")
serial_port.write(b'This message should send back\n')