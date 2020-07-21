`include "../build/core_params.svh"
`include "../build/network_params.svh"
`include "../build/preamble_params.svh"

`timescale 1ns/10ps
module transmitter
    (
        input wire sysclk,
        input wire uart_txd_in,

        output wire [DATA_WIDTH:1] pio
    );
    localparam WIDTH = SORTING_WIDTH + PREAMBLE_LENGTH + PACKET_WIDTH_BITS;
    //WIRE DECLARATIONS
    wire [7:0] uart_word;
    wire [7:0] uart_word_slow;
    //we already know what the first and last byte are going to be
    wire [(PACKET_WIDTH - 2) * 8 - 1:0] sys_packet;
    wire [WIDTH - 1:0] sorted_packet;
    wire [DATA_WIDTH - 1:0] ANALOGWAVE;
    reg led0_reg = 1'b0;
    reg led1_reg = 1'b0;
    
    assign pio[DATA_WIDTH:1] = ANALOGWAVE;

//~~~~~~~~~~~~~~~~MODULES~~~~~~~~~~~~~~~~~~~
    uart_fast_read uart_rx
    (
        .clk(clk_baud),
        .uart_stream(uart_txd_in),
        .word(uart_word_slow), .write(uart_write_slow)
    );

    CDC_sync#(8) buffer_sync
    (
        .slow_clk(clk_baud),
        .fast_clk(clk_carrier),
        .I(uart_word_slow),
        .O(uart_word)
    );

    CDC_sync#(1) write_sync
    (
        .slow_clk(clk_baud),
        .fast_clk(clk_carrier),
        .I(uart_write_slow),
        .O(uart_write)
    );

    (* keep_hierarchy = "yes" *)
    byte_packet_buffer buffer
    (   
        //IN
        .clk(clk_carrier),
        .reset(reset),
        .word(uart_word),
        .write(uart_write),
        //OUT
        .sys_packet(sys_packet),
        .send(data_send)
    );

    (* keep_hierarchy = "yes" *)
    sorter packet_sorter
    (
        //IN
        .clk(clk_carrier),
        .reset(reset),
        .ready(data_send),
        .sys_packet(sys_packet),
        //OUT
        .sorted_packet_out(sorted_packet),
        .done(sorting_done)
    );
    (* keep_hierarchy = "yes" *)
	modulator_v2 #(WIDTH) signal_modulator
    (
        //IN
        .clk(clk_carrier),
        .data(sorted_packet),
        .reset(sorting_done),
        //OUT
        .signal(ANALOGWAVE)
    );

//~~~~~~~~~~~~~~~~~CLOCKS~~~~~~~~~~~~~~~~~~~~~~

    MMCM transmitter_MMCM
    (
    // Clock out ports
    .clk_carrier(clk_carrier),     // output clk_carrier
   // Clock in ports
    .clk_in_sys(sysclk));
    
    //OUR UART CHIP ONLY SUPPORTS 12MBPS in standard mode, so the system clock works here
    clock_divider#(12) clk_divider(sysclk, clk_baud);
    
endmodule