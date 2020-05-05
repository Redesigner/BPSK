`include "../built-src/parameters.svh"

module sorting_test
    (

    );

    reg [7:0][NETWORK_WIDTH-1:0] data_in = '{72, 45, 66, 21, 5, 19, 81, 32};
    reg [7:0][INDEX_WIDTH-1:0] index_in = '{7, 6, 5, 4, 3, 2, 1, 0};

    comparison_size8 comparator
    (
        data_in, index_in,
        data_out, index_out
    );


endmodule