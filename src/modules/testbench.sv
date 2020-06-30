`include "../built-src/parameters.svh"

module testbench
	(
		input wire sysclk,
		input wire uart_txd_in,
		output wire uart_rxd_out
	);
    wire [DATA_WIDTH - 1:0] signal;

	(* keep_hierarchy = "yes" *)
    transmitter tx(
		.sysclk(sysclk),
		.clk_carrier(clk_carrier),
		.uart_txd_in(uart_txd_in),
		.pio(signal)
	);

	(* keep_hierarchy = "yes" *)
	reciever rx(
		.sysclk(sysclk),
		.clk_carrier(clk_carrier),
		.pio(signal),
		.uart_rxd_out(uart_rxd_out)
	);
	(* keep_hierarchy = "yes" *)
    MMCM clk_MMCM
       (
        // Clock out ports
        .clk_carrier(clk_carrier),     // output clk_carrier
       // Clock in ports
        .clk_in_sys(sysclk));

	/*
	test_data data(
		.clk(clk),
		.uart_rxd_out(uart_txd_in)
	);*/

endmodule