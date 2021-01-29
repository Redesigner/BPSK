`include "core_params.svh"

`timescale 1ns/10ps

module sorter
    (
        input wire clk,
        input wire reset,
        input wire [SORTING_SLICES - 1 : 0][SLICE_WIDTH - 1:0] sys_packet,
        output packet sorted_packet_out,
        output wire done
    );

    reg ready = 1'b0;

    reg [SORTING_SLICES - 1:0][INDEX_WIDTH - 1:0] index_in = '0;
    localparam INITIAL_DEPTH = $clog2(PAYLOAD_WIDTH);

    generate
    genvar i;
    //We need two bytes reserved for the start and end signal
    for (i = 0; i < SORTING_SLICES; i++) begin
        initial begin
            index_in[i] = i;
        end
    end
    endgenerate

    wire [PAYLOAD_WIDTH - 1 : 0] data;
    wire [REFERENCE_WIDTH - 1 : 0] indices;

    comparison_merge_r #(SORTING_SLICES, 1'b1) comparison
    (
        clk,
        reset,
        ready,
        sys_packet, index_in,
        data, indices, sorted
    );

    always @(posedge clk) begin
        if(reset) begin
            ready <= 1'b1;
        end
    end

    assign sorted_packet_out = {
        PREAMBLE,
        FRAME_HEADSTART,
        indices,
        FRAME_START,
        data,
        FRAME_END
    };

    edge_pulse sorter_edge(.clk(clk), .I(sorted), .O(done));
endmodule