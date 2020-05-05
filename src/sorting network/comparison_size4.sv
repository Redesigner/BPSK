module comparison_size4
    (
        input wire [3:0][NETWORK_WIDTH-1:0] data_in,
        input wire [3:0][INDEX_WIDTH-1:0] index_in,
        output wire [3:0][NETWORK_WIDTH-1:0] data_out,
        output wire [3:0][INDEX_WIDTH-1:0] index_out
    );

    //VIRTUAL WIRE DECLARATIONS
    wire [NETWORK_WIDTH-1:0] data_a0, data_a1, data_a2, data_a3,
    data_b0, data_b1, data_b2, data_b3;

    wire [INDEX_WIDTH-1:0] index_a0, index_a1, index_a2, index_a3,
    index_b0, index_b1, index_b2, index_b3;


    comparison_base comparator_a0
    (
        data_in[0], data_in[1],
        index_in[0], index_in[1],
        data_a0, data_a1,
        index_a0, index_a1 
    );

    comparison_base comparator_a2
    (
        data_in[2], data_in[3],
        index_in[2], index_in[3],
        data_a2, data_a3,
        index_a2, index_a3      
    );


    comparison_base comparator_b0
    (
        data_a0, data_a2,
        index_a0, index_a2,
        data_b0, data_b2,
        index_b0, index_b2
    );

    comparison_base comparator_b2
    (
        data_a1, data_a3,
        index_a1, index_a3,
        data_b1, data_b3,
        index_b1, index_b3
    );


    comparison_base comparator_c0
    (
        data_b0, data_b1,
        index_b0, index_b1,
        data_out[0], data_out[1],
        index_out[0], index_out[1] 
    );

    comparison_base comparator_c2
    (
        data_b2, data_b3,
        index_b2, index_b3,
        data_out[2], data_out[3],
        index_out[2], index_out[3]      
    );
endmodule