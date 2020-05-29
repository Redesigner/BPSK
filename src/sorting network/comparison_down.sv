`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module comparison_down
    (

        input wire [NETWORK_WIDTH-1:0] in_a,
        input wire [NETWORK_WIDTH-1:0] in_b,

        input wire [INDEX_WIDTH-1:0] in_a_index,
        input wire [INDEX_WIDTH-1:0] in_b_index,


        output wire [NETWORK_WIDTH-1:0] out_a,
        output wire [NETWORK_WIDTH-1:0] out_b,

        output wire [INDEX_WIDTH-1:0] out_a_index,
        output wire [INDEX_WIDTH-1:0] out_b_index

    );
    assign out_a = (in_a <= in_b) ? in_a : in_b;
    assign out_b = (in_a <= in_b) ? in_b : in_a;
    assign out_a_index = (in_a <= in_b) ? in_a_index : in_b_index;
    assign out_b_index = (in_a <= in_b) ? in_b_index : in_a_index;
endmodule