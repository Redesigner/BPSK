module byte_packet_buffer
    (
        input wire clk,
        input wire [7:0] word,                       //the data frame from the uart_signal
        input write,                                //copies word when set high

        output wire [PACKET_WIDTH-1:0][7:0] sys_packet,//PACKET_WIDTH in bits
        output wire send                             //the sys_packet is ready to be sent
    );
    reg [32:0] index = 0;
    reg [PACKET_WIDTH-1:0][7:0] buffer = 0;

    always @ (posedge clk) begin
        if (index >= PACKET_WIDTH) begin
            index <= 0;
        end
        else if (index <= PACKET_WIDTH - 1) begin
            if (write == 1) begin
                buffer[index] <= word;
                index <= index + 1;
            end
        end
    end

    assign sys_packet = buffer;
    assign send = index == (PACKET_WIDTH - 1);

endmodule