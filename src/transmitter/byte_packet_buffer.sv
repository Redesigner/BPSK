module byte_packet_buffer
    (
        input wire clk,
        input wire [7:0] word,                       //the data frame from the uart_signal
        input wire write,                                //copies word when set high

        output wire [PACKET_WIDTH - 1:0][7:0] sys_packet,//PACKET_WIDTH in bits
        output reg send = 0                             //the sys_packet is ready to be sent
    );
    reg [$clog2(PACKET_WIDTH):0] index = 0;
    reg [PACKET_WIDTH-1:0][7:0] buffer = 0;
    reg write_old = 1'b0;

    always @ (posedge clk) begin
        write_old <= write;
        if (index >= PACKET_WIDTH) begin
            index <= 0;
            send <= 1;
        end
        else if (index <= PACKET_WIDTH - 1) begin
            if (write && ~write_old) begin
                buffer[index] <= word;
                index <= index + 1;
                send <= 0;
            end
        end
    end

    assign sys_packet = buffer;
endmodule