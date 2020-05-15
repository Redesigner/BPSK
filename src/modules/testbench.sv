`include "../built-src/parameters.svh"

module testbench
	(
		input wire clk,
        output pio1,
        output pio2,
        output pio3,
        output pio4,
        output pio5,
        output pio6,
        output pio7,
        output pio8,
        output pio9,
        output pio10,
        output pio11,
        output pio12
	);

    wire[11:0] signal_analog;
	signal_modulator modulator
    (
        //IN
        clk_1, 0, 1,
        //OUT
        signal_analog, ser_next
    );
    
    assign  pio1 =  signal_analog[0];
    assign  pio2 =  signal_analog[1];
    assign  pio3 =  signal_analog[2];
    assign  pio4 =  signal_analog[3];
    assign  pio5 =  signal_analog[4];
    assign  pio6 =  signal_analog[5];
    assign  pio7 =  signal_analog[6];
    assign  pio8 =  signal_analog[7];
    assign  pio9 =  signal_analog[8];
    assign  pio10 = signal_analog[9];
    assign  pio11 = signal_analog[10];
    assign  pio12 = signal_analog[11];

  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_1(clk_1),     // output clk_1
   // Clock in ports
    .clk(clk));      // input clk
// INST_TAG_END ------ End INSTANTIATION Template ---------

endmodule