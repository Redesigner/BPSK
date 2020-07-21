`include "../build/core_params.svh"

module testbench
	(
		input wire sysclk,
		input wire uart_txd_in,
		output wire led0,
		output wire uart_rxd_out
	);
	//reg sysclk = 0;
	//always #100 sysclk=~sysclk;

    wire [DATA_WIDTH - 1:0] signal;

	(* keep_hierarchy = "yes" *)
    transmitter tx(
		.sysclk(sysclk),
		.uart_txd_in(uart_txd_in),
		.pio(signal)
	);

	(* keep_hierarchy = "yes" *)
	reciever rx
	(
		.sysclk(sysclk),
		.pio(signal),
		.uart_rxd_out(uart_rxd_out)
	);

	assign led0 = signal[0];
	/*test_data data(
		.clk(sysclk),
		.uart_rxd_out(uart_txd_in)
	);*/

endmodule