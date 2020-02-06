module data_buffer
    (
        input reg read,
        input reg clear,
        input reg data,
        output reg  [PACKET_SIZE-1:0] packet,
        output reg send = 0
    );
    reg [32:0] index = 0;
    reg [PACKET_SIZE-1:0] buffer;

    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (read) begin
        if (index <= PACKET_SIZE) begin
            buffer[PACKET_SIZE-index] = data;
            index = index + 1;
        end else begin
            //the buffer is full, so copy the buffer to a new packet
            packet <= buffer;
            send <= 1;
            //tell the uart modules to begin sending the full packet
        end
    end

    always @ (clear) begin
        //stop sending, our packet is expired, begin recieving new packet
        index <= 0;
        send <= 0;
    end
endmodule