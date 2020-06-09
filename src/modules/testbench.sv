`include "../built-src/parameters.svh"

module testbench
	(
	    input wire uart_txd_in,
		input wire clk,
		output wire led0,
		output wire uart_rxd_out
	);
    reg led = 0;
    wire [7:0] uart_word;
    (* keep_hierarchy = "yes" *)
    uart_fast_read uart_read
    (
        .clk(clk),
        .uart_stream(uart_txd_in),
        .word(uart_word),
        .write(write)
    );
    
    (* keep_hierarchy = "yes" *)
    uart_fast_write uart_write
    (
        .clk(clk),
        .ready(write),
        .word(uart_word),
        .rxd(uart_rxd_out)
    );
    always @(posedge clk) begin
        if(write) begin
            led <= 1;
        end
    end
    /*
    clk_wiz_0 instance_name
    (
    // Clock out ports
    .clk_1(clk_1),     // output clk_1
   // Clock in ports
    .clk(clk));      // input clk
    */
    assign led0 = led;
    /*
    //~~~~~~~~~~~~~~SIMULATION ONLY~~~~~~~~~~~~~~
    localparam PERIOD = 4;
    reg clk = 0;
    always #(PERIOD/2) clk=~clk;
    reg [176:0] test_data = 177'b100010000101000100001010011011110100010000101001101100010011011000100110010101101101000010001000010100010000101000100001010011011110100110110001001101100010011001010110110100001;
    parallel_serial #(177) debug_serial
    (
        //IN
        clk, test_data, 1'b1 ^ done2,
        //OUT
        uart_txd_in, done2
    );
    */
endmodule