#PLEASE USE PYTHON 3.0 OR NEWER!!!!
from string import Template
import fileinput, os, sys, math, traceback

defaults = [12, 135, 13500, 1000]

dir_path = os.path.dirname(os.path.realpath(__file__))
src = os.path.join(dir_path,"src\\preprocessed")
build = os.path.join(dir_path,"src\\built-src")

if not os.path.exists(build):
    os.makedirs(build)

try:
    print("Press ENTER for default values.")
    input_bits = int(input("Wave size in bits (default is: " + str(defaults[0]) + ")") or defaults[0])
    clock_speed = int(input("Base clock frequency in MHz (default is: " + str(defaults[1]) + ")") or defaults[1])
    wavelength = int(math.ceil(1000 * clock_speed / (float(input("Wave frequency in KHz (default is: " + str(defaults[2]) + ")") or defaults[2]))))
    data_frame_initial = int(math.ceil(clock_speed / float(input("Data Rate in Kbps (default is: " + str(defaults[3]) + ")") or defaults[3]) * 1000))
    data_frame = data_frame_initial - data_frame_initial % wavelength
    table_size = int(math.ceil(wavelength))
except:
    print("Invalid arguments for command. Make sure your integers are formatted properly:")
    traceback.print_exc()
    exit()


print("\nThe data rate has been adjusted to " + str(math.ceil(clock_speed/data_frame * 1000)) + " Kbps")
print("Raw data rate is " + str(((clock_speed/data_frame * 1000)) / (96.0/64.0)) + " Kbps")
print("The maximum Baud rate for a continous data stream is " + str(math.floor((clock_speed/data_frame * 1000000) / (96.0/88.0))) + " Baud\n")
factor = math.pi / table_size * 2
amplitude = 2 ** (input_bits-1) - 1

sine_table = [0] * table_size
for i in range(0, table_size):
    sine_table[i] =  str(i) + " : begin\n signal <=" + str(int(((math.sin(factor * i)) + 1) * amplitude)) + ";\n end\n"

phase_table_on = [0] * data_frame
for i in range(0, data_frame):
    phase_table_on[i] =  str(i) + " : begin\n phase <=" + str(i % wavelength) + ";\n end\n"
phase_table_off = [0] * data_frame
for i in range(0, data_frame):
    phase_table_off[i] = str(i) + " : begin\n phase <=" + str((i + int(wavelength/2)) % wavelength) + ";\n end\n"

sine_table_string = ''.join(map(str,sine_table))
replacement_values = {"DATA_WIDTH":input_bits,
"SINE_TABLE_SIZE": table_size,
"WAVELENGTH": data_frame,
"SHIFT": int(wavelength/2),
"sine_table": sine_table_string,
"phase_table_on": ''.join(map(str,phase_table_on)),
"phase_table_off": ''.join(map(str,phase_table_off)),
"AMPLITUDE": amplitude,
"clog2": "clog2"
}

for root, dirs, files in os.walk(src):
    for filename in files:
        print('>parsing ' + filename)
        source = open(os.path.join(src, filename), "r")
        output = open(os.path.join(build, filename), "w+")
        lines = source.readlines()
        for line in lines:
            preprocessed = Template(line)
            processed = preprocessed.substitute(replacement_values)
            output.write(processed)
        source.close()
        output.close()

