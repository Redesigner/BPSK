`include "../built-src/parameters.svh"

module testbench;

timeunit 10ns;
timeprecision 100ps;
reg clock;
initial begin
  $display($time, " << Starting the Simulation >>");
    clock = 0;
end

	always #5 clock=~clock;
	reg [PACKET_SIZE-1:0] packet = 192'hff5468697320697320612074657374206d65737361676521;
	

	//use our premade packet to test our reciever
	packet_serializer serializer_1(packet, clock, ser_next, ser_signal, ser_clear);

	reg mod_enable = 1; //force signal generation for testing
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clock, ser_signal, mod_enable, signal_analog, ser_next);

	reciever rx(clock, clock, signal_analog, uart_stream);
	transmitter tx(clock, clock, uart_stream, led0);

endmodule