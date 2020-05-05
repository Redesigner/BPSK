module uart_data_buffer
    (
        input wire clk,
        input reg [7:0] uart_byte,                  //the data frame from the uart_signal
        input write,                                //copies uart_packet when set high
        input clear,

        output reg [PACKET_SIZE-1:0] sys_packet,    //PACKET_SIZE-1
        output reg send = 0                         //the sys_packet is ready to be sent
    );
    reg [32:0] index = 0;
    reg [PACKET_SIZE-1:0] buffer;

    always @ (posedge clk) begin
        if (clear == 1) begin
            index <= 0;
        end
        else if (write == 1) begin
            if ((index * 8) < PACKET_SIZE) begin
                buffer[PACKET_SIZE - 1 - (index * 8) -:8] <= uart_byte;//(PACKET_SIZE-1) - (index-8)
                index <= index + 1; //we must count up by 8, or packets would be restricted to being multiples of 9 only
            end
            else begin
                //the buffer is full, so copy the buffer to a new packet
                //add our last set of bits, dropping any extras
                sys_packet <= buffer;
                send <= 1;
                index <= index + 1;
                //begin transmitting
            end
        end
    end
endmodule: uart_data_buffer