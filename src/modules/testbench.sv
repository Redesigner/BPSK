`include "../build/core_params.svh"

module testbench
	(
		input wire sysclk,
		input wire uart_txd_in,
		output wire led0,
		output wire uart_rxd_out
	);
	reg sysclk = 0;
	always #100 sysclk=~sysclk;

    wire [DATA_WIDTH - 1:0] signal;

	(* keep_hierarchy = "yes" *)
    transmitter tx(
		.sysclk(sysclk),
		.clk_carrier(clk_carrier),
		.uart_txd_in(uart_txd_in),
		.pio(signal)
	);

	(* keep_hierarchy = "yes" *)
	reciever rx
	(
		.sysclk(sysclk),
		.clk_carrier(clk_carrier),
		.pio(signal),
		.uart_rxd_out(uart_rxd_out)
	);
	(* keep_hierarchy = "yes" *)
    clk_wiz_0 clk_MMCM
       (
        // Clock out ports
        .clk_carrier(clk_carrier),     // output clk_carrier
       // Clock in ports
        .clk_in_sys(sysclk));

	assign led0 = signal[1];
	test_data data(
		.clk(sysclk),
		.uart_rxd_out(uart_txd_in)
	);

endmodule