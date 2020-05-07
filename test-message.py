import threading
import serial
import time
import binascii

serial_port = serial.Serial('COM4', 2500000, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)

message = b'hello!!!'
print("sending message: " + bin(int.from_bytes(message, "little")))
serial_port.write(message)
message2 = serial_port.read(3000)
print(bin(int.from_bytes(message2, "little")))
print(message2)