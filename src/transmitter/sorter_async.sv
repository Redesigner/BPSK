`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module sorter_async
    (
        input wire [PACKET_WIDTH-1:0][7:0] sys_packet,
        output wire [(PACKET_WIDTH * (8 + INDEX_WIDTH)) + PREAMBLE_LENGTH - 1:0] sorted_packet_out
    );

    reg [PACKET_WIDTH - 1:0][INDEX_WIDTH - 1:0] index_in = '0;
    parameter INITIAL_DEPTH = $clog2(PACKET_WIDTH);

    generate
    genvar i;
    for (i = 0; i < PACKET_WIDTH; i++) begin
        initial begin
            index_in[i] = i;
        end
    end
    endgenerate

    wire [PACKET_WIDTH * 8 - 1:0] data;
    wire [PACKET_WIDTH * INDEX_WIDTH - 1:0] indices;

    comparison_size_x #(PACKET_WIDTH, 1'b1) comparison
    (
        sys_packet, index_in,
        data, indices
    );

    assign sorted_packet_out = {>>{
        indices,
        data,
        PREAMBLE
    }};
endmodule