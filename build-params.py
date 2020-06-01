#PLEASE USE PYTHON 3.0 OR NEWER!!!!
from string import Template
import fileinput, os, sys, math, traceback

defaults = [12, 30, 1500]

dir_path = os.path.dirname(os.path.realpath(__file__))
src = os.path.join(dir_path,"src\\preprocessed")
build = os.path.join(dir_path,"src\\built-src")

if not os.path.exists(build):
    os.makedirs(build)

try:
    print("Press ENTER for default values.")
    input_bits = int(input("Wave size (in bits): ") or defaults[0])
    clock_speed = int(input("Base clock frequency (in MHz): ") or defaults[1])
    wavelength = int(math.ceil(1000 * clock_speed / (float(input("Wave frequency (in KHz): ") or defaults[2]))))
    table_size = int(math.ceil(wavelength))
except:
    print("Invalid arguments for command. Make sure your integers are formatted properly:")
    traceback.print_exc()
    exit()

factor = math.pi / table_size * 2
amplitude = 2 ** (input_bits-1) - 1

sine_table = [0] * table_size

for i in range(0, table_size):
    sine_table[i] =  str(i) + " : begin\n signal <=" + str(int(((math.sin(factor * i)) + 1) * amplitude)) + ";\n end\n"

sine_table_string = ''.join(map(str,sine_table))
replacement_values = {"DATA_WIDTH":input_bits,
"SINE_TABLE_SIZE": table_size,
"WAVELENGTH": wavelength,
"SHIFT": int(wavelength/2),
"sine_table": sine_table_string,
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

