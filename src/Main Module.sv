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

parameter PACKET_SIZE = 184; //2 bytes

module Main (
	clock,
	led0
	);
	input wire clock;
	//wire clock2;
	output wire led0;

	reg signed [DATA_WIDTH-1:0] amp;	
	reg [DATA_WIDTH-1:0] phase;
	reg next_bit_signal = 0;
	reg current_bit;
	reg [PACKET_SIZE-1:0] packet = 184'h5468697320697320612074657374206d65737361676521;
	
	phase_clock counter(clock, current_bit, phase, next_bit_signal);
	sine_wave generator(phase, amp);
	data_send sender(packet, next_bit_signal, current_bit);

	//demodulator test(clock, amp, led0);

	reciever test2(clock, clock, amp, led0);

	//pulse_width_mod light(clock, amp, led0, clock2);
endmodule