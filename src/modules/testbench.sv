`include "../built-src/parameters.svh"

module testbench
	(
		input wire clk,
		output wire pio1,pio2,pio3,pio4,pio5,pio6,pio7,pio8,pio9,pio10,pio11,pio12
	);

    /*transmitter tx
	(
		clk,
		uart_txd_in,
		p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12
	);
    reciever rx
	(
		clk,
		p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12,
		uart_rxd_out
	);*/
	wire [11:0] ANALOGWAVE;
	assign {>>{pio1,pio2,pio3,pio4,pio5,pio6,pio7,pio8,pio9,pio10,pio11,pio12}} = ANALOGWAVE;
    signal_modulator modulator
    (
        //IN
       .clk(clk_1),
       .data_stream(1'b1), .enable(1'b1),
        //OUT
        .signal_out(ANALOGWAVE), .next(blank)
    );
    clk_wiz_0 instance_name
    (
    // Clock out ports
    .clk_1(clk_1),     // output clk_1
   // Clock in ports
    .clk(clk));      // input clk
endmodule