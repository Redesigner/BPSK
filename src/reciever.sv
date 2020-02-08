module reciever
    (
        input wire clk,
        input wire clk_baud,
        input signed [7:0] signal,
        output uart_stream
    );
    wire demod_data, demod_write;
    signal_demodulator demod(clk, signal, demod_data, demod_write);

    reg [PACKET_SIZE-1:0] sys_packet;
    wire buf_ready, buf_clear, buf_send;
    data_buffer_demodulator buffer(demod_write, buf_clear, demod_data, sys_packet, buf_send);

    reg [10:0] uart_packet;
    reg enc_write, enc_clear;
    uart_encode encode(sys_packet, buf_send, enc_clear, buf_clear, uart_packet);

    uart_serialize serial(uart_packet, clk_baud, uart_stream);
endmodule
