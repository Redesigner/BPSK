module packet_serializer
    (
        input reg [PACKET_SIZE-1:0] sys_packet,
        input wire next,
        output reg signal_stream,
        output reg data_clear = 0
    );
    //should be able to hold the range of packet values, log2 of PACKET_SIZE
    integer index = 0;
    
    reg [PACKET_SIZE-1:0] sys_packet_old;
    
    always @ (posedge next, sys_packet) begin
        if (sys_packet != sys_packet_old) begin
            sys_packet_old <= sys_packet;
            index <= 0;
        end else begin
            signal_stream = sys_packet[PACKET_SIZE-index-1];
            if (index + 2 > PACKET_SIZE) begin
                //end of packet
                data_clear = ~data_clear;
            end
            else if (index < PACKET_SIZE) begin
                index = index + 1;
            end
        end
    end
endmodule