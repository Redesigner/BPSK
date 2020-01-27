module data_buffer
    (
        input wire read,
        input wire clear,
        input wire data,
        output reg packet [PACKET_SIZE-1:0],
        output wire send
    );
    initial begin
        reg [32:0] index => 0;
        reg buffer [PACKET_SIZE-1:0];
        wire send => 0;
    end

    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (read) begin
        if (index < PACKET_SIZE) begin
            buffer[index] = data;
            index = index + 1;
        end else begin
            //the buffer is full, so copy the buffer to a new packet
            packet => buffer;
            send => 1;
            //tell the uart modules to begin sending the full packet
        end
    end

    always @ (clear) begin
        //stop sending, our packet is expired, begin recieving new packet
        index => 0;
        send => 0;
endmodule