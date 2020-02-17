`include "../built-src/parameters.svh"

module testbench
	(
		input clock
	);

	reg [PACKET_SIZE-1:0] packet = 184'h5468697320697320612074657374206d65737361676521;
	

	//use our premade packet to test our reciever
	packet_serializer serializer_1(packet, ser_next, ser_signal, ser_clear);

	reg mod_enable = 0; //force signal generation for testing
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clock, ser_signal, mod_enable, signal_analog, ser_next);

	reciever rx(clock, clock, signal_analog, uart_stream);
	transmitter tx(clock, clock, uart_stream, led0);

endmodule