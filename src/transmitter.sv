module transmitter
    (
        input wire clk,
        input wire clk_baud,
        input wire data,
        output rx
    );
    reg [7:0] uart_packet;

	reg next_bit_signal = 0, data_ready = 0;

    uart_deserialize uart_rx(data, clk_baud, uart_packet, data_ready);
    uart_data_buffer buffer2(data_ready, data_clear, uart_packet, packet, buffer_send);

    /*phase_clock counter(clk, current_bit, buffer_send, phase, next_bit_signal);
	sine_wave generator(phase, amp);
	data_send sender(packet, next_bit_signal, current_bit, data_clear);*/
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clk, ser_signal, buffer_send, signal_analog, ser_next);

endmodule