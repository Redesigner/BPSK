`include "../built-src/parameters.svh"

module comparison_size8
    (
        input wire [7:0][NETWORK_WIDTH-1:0] data_in,
        input wire [7:0][INDEX_WIDTH-1:0] index_in,
        output wire [7:0][NETWORK_WIDTH-1:0] data_out,
        output wire [7:0][INDEX_WIDTH-1:0] index_out
    );

    //VIRTUAL WIRE DECLARATIONS
    wire [7:0][NETWORK_WIDTH-1:0] data_a;
    wire [7:0][INDEX_WIDTH-1:0] index_a;

    comparison_size4 comparator_a0
    (
        {>>{data_in[0], data_in[1], data_in[2], data_in[3]}},
        {>>{index_in[0], index_in[1], index_in[2], index_in[3]}},
        data_a[3:0],
        index_a[3:0]
    );

    comparison_size4 comparator_a4
    (
        {>>{data_in[4], data_in[5], data_in[6], data_in[7]}},
        {>>{index_in[4], index_in[5], index_in[6], index_in[7]}},
        data_a[7:4],
        index_a[7:4]
    );


endmodule