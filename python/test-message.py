import threading
import serial
import time
import binascii

def chunkstring(string, length):
    return (string[0+i:length+i] for i in range(0, len(string), length))

datarate = 750000

serial_port_tx = serial.Serial('COM4', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)
#serial_port_rx = serial.Serial('COM4', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)

data = 'hello!!!'
message = data.encode('ascii')
message_h = hex(int.from_bytes(message, "little"))
message_b = ''.join(format(ord(i), 'b').zfill(8) for i in data) 
message_length = len(message_b)
print("sending message with length " + str(message_length) + " :" + str(message))
serial_port_tx.write(message)

message2 = serial_port_tx.read_until('00',int(message_length))
message2_h = hex(int.from_bytes(message2, "little"))
message2_b = ''.join(format(byte, '08b') for byte in message2)
message2_length = len(message2_b)
print("recieved message with length " + str(message2_length) + " :" + str(message2))
print(' | '.join(chunkstring(str(message_b ), 8)) + " : sent")
print(' | '.join(chunkstring(str(message2_b), 8)) + " : recieved")

diff = 0
for i in range(min(len(message_b), len(message2_b))) :
    if message_b[i] != message2_b[i] :
        diff += 1
err_rate = round((diff/message_length) * 100, 2)

print("Encountered " + str(diff) + " errors, out of " + str(message_length) + " bits")
print("Error rate: " + str(err_rate) + "%")