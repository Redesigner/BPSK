module uart_serialize
    (
        input reg [10:0] uart_packet,
        input clk_baud, //should be synced to Baud rate
        //input reg serialize_write,
        output reg uart_stream
        //output reg data_ready = 0
    );
    reg [4:0] index = 0;

    always @ (clk_baud) begin
        uart_stream <= uart_packet[index];
        if (index >= 10) begin
            index <= 0;
            //data_ready <= ~data_ready;
        end else begin
            index <= index + 1;
        end
    end
    /*always @ (posedge serialize_write) begin
        data_ready = ~data_ready;
    end*/
endmodule