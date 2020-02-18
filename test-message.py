import serial
ser = serial.Serial('COM4', 96000, serial.EIGHTBITS, serial.PARITY_EVEN)
ser.write(b'This is a test message!')