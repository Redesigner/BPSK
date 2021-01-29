`include "../build/core_params.svh"

module testbench
	(
		input wire sysclk,
		input wire uart_txd_in,
		output wire debug,
		output wire uart_rxd_out,
		output wire led0,
		output wire led1
	);
    signal signal;

	(* keep_hierarchy = "yes" *)
	transmitter tx (
		.sysclk(sysclk),            // input wire sysclk
		.uart_txd_in(uart_txd_in),  // input wire uart_txd_in
		.wave(signal),              // output wire [9 : 0] wave
		.clk_out(clk_out),          // output wire clk_out
		.sleep(sleep),              // output wire sleep
		.debug(led0)
	);

	(* keep_hierarchy = "yes" *)
	reciever rx
	(
		.sysclk(sysclk),
		.wave(signal),
		.uart_rxd_out(uart_rxd_out),
		.debug(led1)
	);
	assign debug = uart_rxd_out;

	reg sysclk = 0; always #100 sysclk=~sysclk;
	test_data data(		.clk(sysclk),		.uart_rxd_out(uart_txd_in)	);

endmodule