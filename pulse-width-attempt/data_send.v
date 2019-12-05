module data_send
    (
        input packet [0:PACKET_SIZE-1],
        input wire clock,
        output reg current_bit
    );
    //should be able to hold the range of packet values, log2 of PACKET_SIZE
    reg [7:0] index = 0;
    reg [7:0] count = 0;
    //the next bit is being requested!
    initial begin
    //we need the first bit. later, this won't be necessary
            current_bit = packet[index];
    end
    
    always @ (clock) begin
        if (count > WAVELENGTH - 1) begin
            count = 0;
            index = index + 1;
        end else begin
            count = count + 1;
            current_bit = packet[index];
        end
    end
endmodule