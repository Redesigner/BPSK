`include "../built-src/parameters.svh"
module sorter
    (   
        input wire clk,
        input reg [PACKET_WIDTH-1:0][7:0] sys_packet,
        input wire packet_ready,

        output reg [(PACKET_WIDTH * 8) - 1:0] sorted_packet = 0,
        output reg ready = 0
    );

    reg [31:0] index = 0;
    always @(posedge clk) begin
        if (packet_ready == 1) begin
            if (index >= PACKET_WIDTH) begin
                ready <= 1;
            end
            else begin
                sorted_packet[index * 8 +:8] <= sys_packet[index];
                index <= index + 1;
            end
        end
    end
endmodule