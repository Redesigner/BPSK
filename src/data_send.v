module data_send
    (
        input packet [0:PACKET_SIZE-1],
        input wire next,
        output reg current_bit
    );
    //should be able to hold the range of packet values, log2 of PACKET_SIZE
    reg [7:0] index = 0;
    //the next bit is being requested!
    initial begin
    //we need the first bit. later, this won't be necessary
            current_bit <= packet[index];
    end
    
    always @ (next) begin
        if (index + 2 > PACKET_SIZE) begin
            //send end of packet signal
        end else begin
            index <= index + 1;
        end
        current_bit <= packet[index];
    end
endmodule