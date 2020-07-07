`include "../build/core_params.svh"
`include "../build/network_params.svh"
`include "../build/preamble_params.svh"

`timescale 1ns/10ps

module sorter
    (
        input wire clk,
        input wire reset,
        input wire ready,
        input wire [PACKET_WIDTH-1:0][7:0] sys_packet,
        output wire [SORTING_WIDTH + PREAMBLE_LENGTH + PACKET_WIDTH_BITS - 1:0] sorted_packet_out,
        output wire done
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

    wire [PACKET_WIDTH_BITS - 1:0] data;
    wire [SORTING_WIDTH - 1:0] indices;

    comparison_merge_r #(PACKET_WIDTH, 1'b1) comparison
    (
        clk,
        reset,
        ready,
        sys_packet, index_in,
        data, indices, sorted
    );

    assign sorted_packet_out = {>>{
        indices,
        data,
        PREAMBLE
    }};

    edge_pulse sorter_edge(.clk(clk), .I(sorted), .O(done));
endmodule