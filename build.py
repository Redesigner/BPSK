from string import Template
import fileinput, os, sys, math

dir_path = os.path.dirname(os.path.realpath(__file__))
src = os.path.join(dir_path,"src")
build = os.path.join(dir_path,"build")

if not os.path.exists(build):
    os.makedirs(build)

input_bits = int(raw_input("Wave size (in bits): "))
clock_speed = int(raw_input("Base clock frequency (in MHz): "))
wavelength = int(math.ceil(1000 * clock_speed / float(raw_input("Wave frequency (in KHz): "))))
table_size = int(math.ceil(wavelength / 2))

factor = math.pi / table_size
amplitude = 2 ** (input_bits-1) - 1

sine_table = [0] * table_size

for i in range(0, table_size):
    sine_table[i] = int(math.sin(factor * i) * amplitude)

sine_table_string = "{" +  ','.join(map(str,sine_table)) + "}"
replacement_values = {"DATA_WIDTH":input_bits,
"SINE_TABLE_SIZE": table_size,
"WAVELENGTH": wavelength,
"SHIFT": wavelength/2,
"sine_table": sine_table_string}


for root, dirs, files in os.walk('src'):
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

