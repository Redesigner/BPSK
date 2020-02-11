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

parameter PACKET_SIZE = 184;

module testbench
	(
		input clk
	);

	reg [PACKET_SIZE-1:0] packet = 184'h5468697320697320612074657374206d65737361676521;
	

	//use our premade packet to test our reciever
	packet_serializer serializer_1(packet, ser_next, ser_signal, ser_clear);

	wire mod_enable = 1; //force signal generation for testing
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clk, ser_signal, mod_enable, signal_analog, ser_next);

	reciever rx(clk, clk, signal_analog, uart_stream);
	transmitter tx(clk, clk, uart_stream, led0);

endmodule