`include "../built-src/parameters.svh"
//THIS MODULE PROVIDES A DEFAULT SET OF DATA FOR THE UART MODULE TO KICK EVERYTHING ELSE OFF
//IT SHOULD ONLY BE USED WHEN AN APPROPRIATE UART CONNECTION IS NOT AVAILABLE
module test_data
    (
        input wire clk,
        output wire uart_rxd_out
    );
    //SIMULATION INPUT DATA
    localparam TEST_MESSAGE_LENGTH = 177;
    clock_divider #(12) divider1
	(
		.I(clk),
		.O(clk_baud)
	);
	reg [TEST_MESSAGE_LENGTH - 1:0] test_data = 'b100010000101000100001010011011110100010000101001101100010011011000100110010101101101000010001000010100010000101000100001010011011110100110110001001101100010011001010110110100001;
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