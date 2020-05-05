`include "../built-src/parameters.svh"

module testbench
	(
		input wire clk,
		output wire uart_rxd_out,
        output wire pio1
	);
    clock_divider # (16, 40000) clock2(clk, clk_baud);

    reg [PACKET_WIDTH-1:0][7:0] sys_packet = "abcdefgh";
	uart_encode debug_out_encoder
    (
        ~clk_baud, sys_packet, 1,
        uart_stream2
    );

	assign uart_rxd_out = uart_stream2;
    assign pio1 = uart_stream2;

endmodule