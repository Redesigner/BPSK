module data_buffer_demodulator
    (
        input read,                             //flips when data should be added to the buffer
        input clear,                            //flips when buffer should be emptied
        input data_stream,                      //data coming from the demodulator
        output reg [PACKET_SIZE-1:0] sys_packet,//completed packet
        output reg send = 0                     //high when packet is ready to send
    );
    reg [32:0] index = 0;
    reg [PACKET_SIZE-1:0] buffer;


    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (posedge read, posedge clear) begin
        if (clear == 1) begin
            index <= 0;
            send <= 0;
        end
        else if (index < PACKET_SIZE) begin
            buffer[PACKET_SIZE-1-index] = data_stream;
            index = index + 1;
        end else begin
            //the buffer is full, so copy the buffer to a new packet
            //add our last bit though
            buffer[PACKET_SIZE-1-index] = data_stream;
            sys_packet = buffer;
            send = 1;
            //tell the uart modules to begin sending the full packet
        end
    end
endmodule