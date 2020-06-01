import threading
import serial
import time
import binascii

datarate = 12000000

serial_port_tx = serial.Serial('COM6', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)
#serial_port_rx = serial.Serial('COM4', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=10)

message = b'hello there, this is a test message! please make sure that this message sends correctly, or there will be severe communications errors'
print("sending message: " + bin(int.from_bytes(message, "little")))
serial_port_tx.write(message)
#message2 = serial_port_rx.read(3000)
#print(bin(int.from_bytes(message2, "little")))
#print(message2)