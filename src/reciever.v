module reciever
    (
        input wire clock,
        input wire baud_clock,
        input signed [7:0] signal,
        output tx
    );
    reg demod_data, demod_write;
    demodulator demod(clock, signal, demod_data, demod_write);
    reg [PACKET_SIZE-1:0] packet_full;
    reg buffer1_send, buffer1_clear;
    data_buffer buffer1(demod_write, buffer1_clear, demod_data, packet_full, buffer1_send);
    reg [10:0] uart_word;
    reg uart_write, uart_clear;
    uart_send bridge(packet_full, buffer1_send, uart_clear, uart_word);
    uart_serialize serial1(uart_word, baud_clock, tx, uart_clear);
endmodule
