import threading
import serial
import time
import binascii

datarate = 1000000

serial_port_tx = serial.Serial('COM6', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)
#serial_port_rx = serial.Serial('COM6', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)

message = b'hello there! this is a test message, it can now be of any length! isn\'t that great? try saying something here if you want to see how well it sends a message'
serial_port_tx.write(message)
message2 = serial_port_tx.read(10000)

message_b = hex(int.from_bytes(message, "little"))
print("sending message: \n" + message_b)

message2_b = hex(int.from_bytes(message2, "little"))
print("recieved message: \n" + message2_b)

diff = int.from_bytes(message2, "little") ^ int.from_bytes(message, "little")
errors = str(diff).count('1')
message_length = len(format(int.from_bytes(message, "little"), 'b')) + 1
err_rate = round((errors/message_length) * 100, 2)

print("Encountered " + str(errors) + " errors, out of " + str(message_length) + " bits")
print("Error rate: " + str(err_rate) + "%")