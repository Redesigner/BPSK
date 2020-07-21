onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib demod_mult_opt

do {wave.do}

view wave
view structure
view signals

do {demod_mult.udo}

run -all

quit -force
