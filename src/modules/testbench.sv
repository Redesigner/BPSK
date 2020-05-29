`include "../built-src/parameters.svh"

module testbench
	(
		input wire clk,
		input wire uart_txd_in,
		output wire uart_rxd_out
	);

	transmitter tx
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
	);
    
endmodule