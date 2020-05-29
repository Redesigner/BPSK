`include "../built-src/parameters.svh"

module reciever
    (
        input wire clk,
        input wire pio1,
        input wire pio2,
        input wire pio3,
        input wire pio4,
        input wire pio5,
        input wire pio6,
        input wire pio7,
        input wire pio8,
        input wire pio9,
        input wire pio10,
        input wire pio11,
        input wire pio12,

        output wire uart_rxd_out,
        output wire led0,
        output wire led1
    );

    wire [DATA_WIDTH - 1:0] signal_analog = {<<{pio1, pio2, pio3, pio4, pio5, pio6, pio7, pio8, pio9, pio10, pio11, pio12}};
    wire [PACKET_WIDTH * 8 - 1: 0] sys_packet;

    clock_divider #(5, 20) clock2(clk_1, clk_baud);
    
    signal_demodulator demod
    (
        clk_1,
        signal_analog,
        data_demod, write
    );

    data_buffer_demodulator buffer
    (
        clk_1,
        write, 0, data_demod,
        sys_packet, done
    );

    uart_encode uart_out
    (
        clk_baud,
        sys_packet, done && !message_sent,
        uart_rxd_out, message_sent
    );

    assign led1 = data_demod;
    assign led0 = message_sent;

  clk_wiz_0 clock_step
   (
    // Clock out ports
    .clk_out1(clk_1),     // output clk_out1
   // Clock in ports
    .clk_in1(clk));      // input clk_in1

endmodule
