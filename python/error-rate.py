import fileinput, os, sys, traceback
import random
from os import urandom
import datetime
import serial
import matplotlib.pyplot as plt

datarate = 1000000

def logmessage(log, string):
    dir_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    data = os.path.join(dir_path,"ref\\data\\logs")
    outfile = open(os.path.join(data, filename + ".txt"), "a")
    outfile.write( str(datetime.datetime.now()) + " >> " + string + "\n")
    outfile.close()

try:
    tx = serial.Serial('COM4', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)
    #rx = serial.Serial('COM6', datarate, serial.EIGHTBITS, serial.PARITY_EVEN, serial.STOPBITS_ONE, timeout=1)
except:
    print("Unable to connect to the USB devices")
    traceback.print_exc()

def sendmessage(dataset, bytes):
    try:
        msg_o = os.urandom(bytes)
        tx.write(msg_o)
        msg_i = tx.read()


    except:
        logmessage(log, "Error occurred when trying to send a message.")
        traceback.print_exc()
        dataset.append(0)
        return 0

    msg_o_b = ''.join(format(byte, '08b').zfill(8) for byte in msg_o)
    msg_i_b = ''.join(format(byte, '08b').zfill(8) for byte in msg_i)
    diff = 0
    for i in range(min(len(msg_o_b), len(msg_i_b))) :
        if msg_o_b[i] != msg_i_b[i] :
            diff += 1
    err_rate = round(((len(msg_o_b) - diff)/len(msg_o_b)) * 100, 5)
    dataset.append(err_rate)
    return err_rate

def createlog(filename):
    print("Creating " + filename)
    dir_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    data = os.path.join(dir_path,"ref\\data\\logs")
    if not os.path.exists(data):
        os.makedirs(data)
    outfile = open(os.path.join(data, filename + ".txt"), "w+")
    outfile.close()
    return outfile

def savechart(data, filename):
    dir_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    file = os.path.join(dir_path,"ref\\data\\logs\\" +  filename + ".png")
    plt.plot(data)
    plt.savefig(file)

filename = str(datetime.datetime.now()).split(".")[0].replace(":", "-")
log = createlog(filename)
errors = []
for i in range(0, 256):
    logmessage(log, "data sent, error rate " + str(sendmessage(errors, 16)) + "%")

savechart(errors, filename)