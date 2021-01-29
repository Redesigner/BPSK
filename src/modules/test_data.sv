`include "../build/core_params.svh"
//THIS MODULE PROVIDES A DEFAULT SET OF DATA FOR THE UART MODULE TO KICK EVERYTHING ELSE OFF
//IT SHOULD ONLY BE USED WHEN AN APPROPRIATE UART CONNECTION IS NOT AVAILABLE
module test_data
    (
        input wire clk,
        output wire uart_rxd_out
    );
    //SIMULATION INPUT DATA
    localparam TEST_MESSAGE_LENGTH = 354;
    clock_divider #(16) divider1
	(
		.I(clk),
		.O(clk_baud)
	);
    // Test data that should decode to 'hello!!!', when passed through the UART_read module
    // contains several predefined errors and repeats multiple times
	reg [TEST_MESSAGE_LENGTH - 1:0] test_data = 'b100001011011010100110010001101100100011011001011110110010100001000101000010001010000100010000101101101010100001011011010100110010001101100100011011001011110110010100001000101000010001010000100010000101101101010;
    edge_pulse pulser(
        .clk(clk_baud),
        .I(1'b1),
        .O(start)
    );
    PISO_buffer #(TEST_MESSAGE_LENGTH) debug_serial
    (
        //IN
        .clk(clk_baud),
		.active(1'b1),
		.reset(start),
		.parallel(test_data),
        //OUT
        .serial_signal(uart_rxd_out)
    );
endmodule