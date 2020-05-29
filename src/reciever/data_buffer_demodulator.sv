`include "../built-src/parameters.svh"

module data_buffer_demodulator
    (
        input clk,
        input read,                                 //flips when data should be added to the buffer
        input clear,                                //flips when buffer should be emptied
        input data_stream,                          //data coming from the demodulator
        output reg [PACKET_WIDTH * 8 - 1:0] sys_packet,  //completed packet
        output reg send = 0                         //high when packet is ready to send
    );
    reg [32:0] index = 0;
    reg [PACKET_WIDTH * 8 -1:0] buffer;


    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (posedge clk) begin
        if (clear == 1) begin
            index <= 0;
            send <= 0;
        end
        else if (read == 1) begin
            if (index < PACKET_WIDTH * 8) begin
                buffer[index] <= data_stream;
                index <= index + 1;
                send <= 0;
            end else begin
                //the buffer is full, so copy the buffer to a new packet
                //add our last bit though
                buffer[index] <= data_stream;
                sys_packet <= buffer;
                send <= 1;
                //tell the uart modules to begin sending the full packet
            end
        end
    end
endmodule