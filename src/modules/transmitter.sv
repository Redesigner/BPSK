`include "../built-src/parameters.svh"

module transmitter
    (
        input wire clk,
        input wire clk_baud,
        input wire data,
        output rx
    );
    reg [7:0] uart_packet;
    uart_deserialize uart_rx(data, clk_baud, uart_packet, data_ready);
    uart_data_buffer buffer(data_ready, data_clear, clk_baud, uart_packet, sys_packet, buffer_send);
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clk, ser_signal, buffer_send, signal_analog, ser_next);
    reg [PACKET_SIZE-1:0] sys_packet;
    packet_serializer serialize(sys_packet, clk, ser_next, ser_signal, data_clear);

endmodule