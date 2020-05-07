`include "../built-src/parameters.svh"


module comparison_up
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

    wire comparison = (in_a <= in_b);

    assign out_a = comparison ? in_a : in_b;
    assign out_a_index = comparison ? in_a_index : in_b_index;

    assign out_b = comparison ? in_b : in_a;
    assign out_b_index = comparison ? in_b_index : in_a_index;

endmodule