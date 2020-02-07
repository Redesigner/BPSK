module transmitter
    (
        input wire clock,
        input wire baud_clock,
        input wire data,
        output rx
    );
    reg signed [DATA_WIDTH-1:0] amp;	
	reg [DATA_WIDTH-1:0] phase;

    reg [7:0] uart_packet;

	reg next_bit_signal = 0, data_ready = 0, data_clear = 0, buffer_send = 0;
	reg current_bit;

    uart_recieve uart_rx(data, baud_clock, uart_packet, data_ready);
    data_buffer_uart buffer2(data_ready, data_clear, uart_packet, packet, buffer_send);
    phase_clock counter(clock, current_bit, buffer_send, phase, next_bit_signal);
	sine_wave generator(phase, amp);
	data_send sender(packet, next_bit_signal, current_bit, data_clear);

endmodule