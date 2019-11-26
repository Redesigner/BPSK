/*parameter DATA_WIDTH = 12;
parameter SINE_RESOLUTION = 32;
parameter WAVELENGTH = 64;
parameter SHIFT = 32;*/
//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

parameter DATA_WIDTH = $DATA_WIDTH;
parameter SINE_RESOLUTION = $SINE_TABLE_SIZE;
parameter WAVELENGTH = $WAVELENGTH;
parameter SHIFT = $SHIFT;

parameter PACKET_SIZE = 128;

module Main (
	clock,
	amp
	);
	input wire clock;
	output reg signed [DATA_WIDTH-1:0] amp;
	
	reg [DATA_WIDTH-1:0] phase;
	reg next_bit_signal = 0;
	reg current_bit;
	reg packet [0:PACKET_SIZE-1] = {0,1,0,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,0,0,1,0,0,0,0,0,0,1,1,1,0,1,1,1,0,1,1,0,1,1,1,1,0,1,1,1,0,0,1,0,0,1,1,0,1,1,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	
	phase_clock counter(clock, current_bit, phase, next_bit_signal);
	sine_wave generator(phase, amp);
	data_send sender(packet, next_bit_signal, current_bit);
endmodule