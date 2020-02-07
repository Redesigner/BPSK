module data_send
    (
        input [0:PACKET_SIZE-1] packet,
        input wire next,
        output reg current_bit,
        output reg data_clear = 0
    );
    //should be able to hold the range of packet values, log2 of PACKET_SIZE
    reg [7:0] index = 0;
    reg current_bit = 0;

    
    always @ (next) begin
        if (index + 2 > PACKET_SIZE) begin
            //end of packet
            data_clear <= ~data_clear;
        end else begin
            index <= index + 1;
        end
        current_bit <= packet[index];
    end
endmodule