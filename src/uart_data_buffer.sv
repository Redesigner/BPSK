module uart_data_buffer
    (
        input ready,                        //copies uart_packet when set high
        input clear,                        //clear the buffer and begin recording data again
        input reg [7:0] uart_word,          //the data frame from the uart_signal
        output reg [PACKET_SIZE-1:0] sys_packet,      //PACKET_SIZE-1
        output reg send = 0                 //the sys_packet is ready to be sent
    );
    reg [32:0] index = 0;
    reg [PACKET_SIZE-1:0] buffer;

    always @ (posedge ready) begin //ready has just been switched to on!
        if ((index * 8) < PACKET_SIZE) begin
            buffer[PACKET_SIZE - 1 - (index * 8) -:8] <= uart_word;//(PACKET_SIZE-1) - (index-8)
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

    always @ (clear) begin
        //stop sending, our packet is expired, begin recieving new packet
        index <= 0;
        //send <= 0;
    end

endmodule: uart_data_buffer