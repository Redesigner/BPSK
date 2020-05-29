`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module sorter
    (   
        input wire clk,
        input reg [PACKET_WIDTH-1:0][7:0] sys_packet,
        input wire copy,

        output wire [(PACKET_WIDTH * (8 + INDEX_WIDTH)) + PREAMBLE_LENGTH - 1:0] sorted_packet_out,
        output reg data_sorted = 0
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
    //wire [(PACKET_WIDTH * (8 + INDEX_WIDTH)) + PREAMBLE_LENGTH - 1:0] sorted_packet;

    comparison_size_x #(PACKET_WIDTH, INITIAL_DEPTH, 1'b1) comparator
    (
        sys_packet, index_in,
        data, indices
    );

    assign sorted_packet_out = {>>{
        indices,
        data,
        PREAMBLE
    }};
    always @(posedge clk) begin
        data_sorted <= copy;
    end
endmodule