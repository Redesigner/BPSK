module uart_encode
    (
        input clk_baud,
        input [PACKET_WIDTH-1:0][7:0] sys_packet,
        input ready,
        output wire uart_stream      //UART stream, in serial
    );
    //outputs the data in parallel
    reg [32:0] index = 0;

    reg open = 0;
    reg close = 1;
    reg [10:0] uart_packet = 11'b11111111111;

    reg transmit = 0;
    reg clear = 0;

    always @ (posedge clk_baud) begin
       // clear <= next;
        if (ready == 1) begin
            if (index == 0 && transmit == 0) begin
                //uart_packet <= {>>{close, ^sys_packet[index], sys_packet[index], open}};
                transmit <= 1;
            end
            else if (next == 1) begin
                if (index < (PACKET_WIDTH - 1)) begin
                    index <= index + 1;
                    //uart_packet <= {>>{close, ^sys_packet[index + 1], sys_packet[index + 1], open}};
                    transmit <= 1;
                end
                else if (index == PACKET_WIDTH - 1) begin
                    transmit <= 0;
                end
            end
        end
        else begin
            transmit <= 0;
        end
    end

    parallel_serial # (11, 4) uart_serialize
    (
        clk_baud, {>>{close, ^sys_packet[index], sys_packet[index], open}}, transmit, next,
        uart_stream_internal, active, next  
    );

    assign uart_stream = (uart_stream_internal || ~transmit);

endmodule
    