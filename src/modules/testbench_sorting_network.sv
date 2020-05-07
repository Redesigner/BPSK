`include "../built-src/parameters.svh"

module sorting_test
    (

    );

    reg [31:0][NETWORK_WIDTH-1:0] data_in = '{92,35,95,83,16,63,54,24,51,28,29,70,18,47,80,53,25,32,33,97,34,35,82,41,11,83,26,46,28,74,93,34};
    reg [31:0][INDEX_WIDTH-1:0] index_in = '{31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};

    /*comparison_size8 comparator
    (
        data_in, index_in,
        data_out, index_out
    );*/
    
    comparison_size_x #(32, 5, 1'b1) comparator2
    (
        data_in, index_in,
        data_out, index_out
    );

    wire [31:0][NETWORK_WIDTH-1:0] data_out;
    wire [31:0][INDEX_WIDTH-1:0] index_out;

    unsort #(32) unsorter
    (
        clk,
        data_out, index_out,
        data_final
    );


endmodule