`include "core_params.svh"

`timescale 1ns/10ps
module transmitter
    (
        input wire sysclk,
        input wire uart_txd_in,

        output signal wave,
        output wire clk_out,
        output wire sleep,
        output reg debug = 0
    );

    always @(posedge clk_carrier) begin
        if(sleep) begin
            debug <= ~debug;
        end
    end

    assign clk_out = clk_carrier;

    //WIRE DECLARATIONS
    byte uart_word;
    byte uart_word_slow;
    wire [PAYLOAD_WIDTH - 1 : 0] payload;
    packet sorted_packet;
    signal signal;
    assign wave = signal;

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

    /*UART_buffer #(PAYLOAD_WIDTH, 8) buffer
    (
        .clk(clk_carrier),
        .data_in(uart_word),
        .write(uart_write),
        .data_out(payload),
        .output_ready(data_send)
    );*/
    PP_reg #(8, PAYLOAD_WIDTH) buffer
    (
        .clk(clk_baud),
        .cs(uart_write),
        .rw(~flow),
        .p_i(uart_word_slow),

        .flow(flow),
        .p_o(payload)
    );

    (* keep_hierarchy = "yes" *)
    sorter packet_sorter
    (
        //IN
        .clk(clk_carrier),
        .reset(flow),
        .sys_packet(payload),
        //OUT
        .sorted_packet_out(sorted_packet),
        .done(sorting_done)
    );

    (* keep_hierarchy = "yes" *)
	modulator_v2 #(PACKET_WIDTH) signal_modulator
    (
        //IN
        .clk(clk_carrier),
        .data(sorted_packet),
        .reset(sorting_done),
        //OUT
        .signal(signal),
        .sleep(sleep)
    );

    //~~~~~~~~~~~~~~~~~CLOCKS~~~~~~~~~~~~~~~~~~~~~~
    MMCM transmitter_MMCM
    (
    // Clock out ports
    .clk_carrier(clk_carrier),
    // Clock in ports
    .clk_in_sys(sysclk));
    
    //THE UART CLOCK IS 16 times the bitrate, or 750kbaud right now
    assign clk_baud = sysclk;
    
endmodule