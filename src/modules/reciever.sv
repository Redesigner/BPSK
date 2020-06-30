`include "../built-src/parameters.svh"

module reciever
    (
        input wire sysclk,
        input wire clk_carrier,
        input wire [DATA_WIDTH:1] pio,

        output wire uart_rxd_out
    );

    wire [PACKET_WIDTH * 8 - 1: 0] sys_packet;
    wire [PACKET_WIDTH * 8 - 1: 0] sys_packet_o;
    wire [7:0] uart_word;
    wire [DATA_WIDTH - 1:0] wave;
    assign wave = pio[DATA_WIDTH:1];
    clock_divider #(12) clock2(sysclk, clk_baud);
    
    signal_demodulator demod
    (
        //IN
        .clk(clk_carrier),
        .signal(wave),
        //OUT
        .guess(data_guess),
        .write(write)
    );

    reciever_buffer buffer
    (
        //IN
        .clk(clk_carrier),
        .read(write),
        .clear('b0),
        .data_stream(data_guess),
        //OUT
        .sys_packet(sys_packet),
        .send(done)
    );

    CDC_sync #(PACKET_WIDTH * 8) sync
    (
        //IN
        .slow_clk(clk_carrier),
        .fast_clk(clk_baud),
        .I(sys_packet),
        //OUT
        .O(sys_packet_o)
    );

    PIPO_buffer #(PACKET_WIDTH * 8, 8) buffer2
    (
        //IN
        .clk(clk_baud),
        .data_in(sys_packet),
        .write(done),
        .read(read),
        //OUT
        .data_out(uart_word)
    );

    uart_fast_write uart_out
    (
        //IN
        .clk(clk_baud),
        .ready(done),
        .word(uart_word),
        //OUT
        .next(read),
        .rxd(uart_rxd_out)
    );

  /*MMCM reciever_MMCM
   (
    // Clock out ports
    .clk_carrier(clk_carrier),     // output clk_carrier
   // Clock in ports
    .clk_in_sys(sysclk)); */
endmodule
