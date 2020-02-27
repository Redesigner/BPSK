`include "../built-src/parameters.svh"

module transmitter
    (
        input wire clk,
        //input wire clk_baud,
        input wire uart_txd_in,
        output pio1,
        output pio2,
        output pio3,
        output pio4,
        output pio5,
        output pio6,
        output pio7,
        output pio8,
        output pio9,
        output pio10,
        output pio11,
        output pio12,
        output led0,
        output led1
    );
    clock_divider # (2, 2) clock2(clk, clk_baud);
    uart_deserialize uart_rx(uart_txd_in, clk_baud, uart_packet, data_ready);
    uart_data_buffer buffer(data_ready, data_clear, clk_baud, uart_packet, sys_packet, buffer_send);
	reg [DATA_WIDTH-1:0] signal_analog = 0;
	signal_modulator modulator(clk, ser_signal, buffer_send, signal_analog, ser_next);
    packet_serializer serialize(sys_packet, clk, ser_next, ser_signal, data_clear);
    
    assign pio1 = signal_analog[0];
    assign pio2 = signal_analog[1];
    assign pio3 = signal_analog[2];
    assign pio4 = signal_analog[3];
    assign pio5 = signal_analog[4];
    assign pio6 = signal_analog[5];
    assign pio7 = signal_analog[6];
    assign pio8 = signal_analog[7];
    assign pio9 = signal_analog[8];
    assign pio10 = signal_analog[9];
    assign pio11 = signal_analog[10];
    assign pio12 = signal_analog[11];
    assign led1 = clk_baud;


endmodule