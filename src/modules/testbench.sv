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
    */
    reg test1 = 1;
    reg [DATA_WIDTH-1:0] signal_analog;
    signal_modulator test_modulator(clk, test1, test1, signal_analog, ser_next);
    
    assign pio1 = signal_analog[0];
    assign pio2 = signal_analog[1];
    assign pio3 = signal_analog[2];
    assign pio4 = signal_analog[3];
    assign pio5 = signal_analog[4];
    assign pio6 = signal_analog[5];
    assign pio7 = signal_analog[6];
    assign pio8 = signal_analog[7];
    assign pio9 = signal_analog[8];
    assign pio10 = signal_analog[9];
    assign pio11 = signal_analog[10];
    assign pio12 = signal_analog[11];
    assign pio20 = clk;
    assign pio48 = 1;
endmodule