/*parameter DATA_WIDTH = 12;
parameter SINE_RESOLUTION = 32;
parameter WAVELENGTH = 64;
parameter SHIFT = 32;*/
//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

parameter DATA_WIDTH = 8;
parameter SINE_RESOLUTION = 7;
parameter WAVELENGTH = 14;
parameter SHIFT = 7;

parameter PACKET_SIZE = 128;

module Main (
	clk,
	led0
	);
	input wire clk;
	output wire led0;
	
	wire clock2;
	wire next_bit_signal;
	
	reg [DATA_WIDTH-1:0] amp;
	reg [DATA_WIDTH-1:0] phase;
	reg current_bit;
	reg packet [0:PACKET_SIZE-1] = {0,1,0,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,0,0,1,0,0,0,0,0,0,1,1,1,0,1,1,1,0,1,1,0,1,1,1,1,0,1,1,1,0,0,1,0,0,1,1,0,1,1,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	
	phase_clock counter(clock2, current_bit, phase);
	sine_wave generator(phase, amp);
	data_send sender(packet, clock2, current_bit);
	
	pulse_width_mod pulser(clk, amp, led0, clock2);
	
	initial begin
	   	automatic reg next_bit_signal = 0;
    end
	
endmodule