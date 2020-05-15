import threading
import serial
import time
import binascii

serial_port = serial.Serial('COM4', 1000000, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)

message = b'hello there, this is a test message! please make sure that this message sends correctly, or there will be severe communications errors'
print("sending message: " + bin(int.from_bytes(message, "little")))
serial_port.write(message)
message2 = serial_port.read(3000)
print(bin(int.from_bytes(message2, "little")))
print(message2)