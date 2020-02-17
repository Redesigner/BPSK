parameter DATA_WIDTH = 8;
parameter SINE_RESOLUTION = 8;
parameter WAVELENGTH = 16;
parameter SHIFT = 8;

parameter PACKET_SIZE = 184;

module transmitter
    (
        input wire clk,
        //input wire clk_baud,
        input wire data,
        output rx,
        output led0
    );
    reg [7:0] uart_packet;

    uart_deserialize uart_rx(data, clk, uart_packet, data_ready);
    uart_data_buffer buffer(data_ready, data_clear, uart_packet, sys_packet, buffer_send);
	reg [DATA_WIDTH-1:0] signal_analog;
	signal_modulator modulator(clk, ser_signal, buffer_send, signal_analog, ser_next);
    packet_serializer serialize(sys_packet, ser_next, ser_signal, data_clear);
    
    assign led0 = buffer_send;

endmodule