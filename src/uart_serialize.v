module uart_serialize
    (
        input reg [10:0] packet,
        input wire clock, //should be synced to Baud rate
        output wire tx_serialized,
        output wire data_ready
    );

    initial begin
        reg [4:0] index = 0;
        tx_serialized = 1'bx;
    end

    always @ (posedge clock) begin
        assign tx_serialized = packet[index];
        if (index >= 10) begin
            index = 0;
            data_ready = ~data_ready;
        end else begin
            index = index + 1;
        end
    end
endmodule