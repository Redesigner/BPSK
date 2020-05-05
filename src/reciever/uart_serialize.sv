module uart_serialize
    (
        input reg [UART_WIDTH-1:0] uart_packet,
        input clk_baud,
        output reg uart_stream
    );
    reg [4:0] index = 0;

    always @ (posedge clk_baud) begin
        uart_stream <= uart_packet[index];
        if (index >= UART_WIDTH-1) begin
            index <= 0;
        end else begin
            index <= index + 1;
        end
    end
endmodule