`include "../built-src/parameters.svh"

module comparison_size_x #(parameter SIZE = 4, parameter DEPTH = 2, parameter UP = 1)
    (
        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,
        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out,
        output wire [SIZE-1:0][INDEX_WIDTH-1:0] index_out
    );

    //VIRTUAL WIRE DECLARATIONS
    wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_internal;
    wire [SIZE-1:0][INDEX_WIDTH-1:0] index_internal;
    //These wires are to maintain data bewteen steps, a is the first intermediate step, etc.


    //genvar i, j;
    generate
        if(SIZE != 2) begin
            /*for(i = 0; i < SIZE / 4; i++) begin
                //compare every pair of wires
                comparison_size_x #(SIZE / 2, DEPTH - 1, ~UP) comparators_up
                (
                    data_in[2 * i +: SIZE / 2],
                    index_in[2 * i +: SIZE / 2],
                    data_internal[2 * i +: SIZE / 2],
                    index_internal[2 * i +: SIZE / 2]
                );

                //every other pair is flipped
                comparison_size_x #(SIZE / 2, DEPTH - 1, UP) comparators_down
                (
                    data_in[SIZE - 1 - (2 * i) -: SIZE / 2],
                    index_in[SIZE - 1 - (2 * i) -: SIZE / 2],
                    data_internal[SIZE - 1 - (2 * i) -: SIZE / 2],
                    index_internal[SIZE - 1 - (2 * i) -: SIZE / 2]
                );
            end*/
            comparison_size_x #(SIZE / 2, DEPTH - 1, UP) sort_top
            (
                data_in[SIZE-1:SIZE/2],
                index_in[SIZE-1:SIZE/2],
                data_internal[SIZE-1:SIZE/2],
                index_internal[SIZE-1:SIZE/2]
            );
            comparison_size_x #(SIZE / 2, DEPTH - 1, ~UP) sort_bottom
            (
                data_in[SIZE/2-1:0],
                index_in[SIZE/2-1:0],
                data_internal[SIZE/2-1:0],
                index_internal[SIZE/2-1:0]
            );
            //merge
            comparators_merge_x #(SIZE, DEPTH, UP) merge
            (
                data_internal[SIZE-1:0],
                index_internal[SIZE-1:0],
                data_out[SIZE-1:0],
                index_out[SIZE-1:0]
            );
        end
        else begin
            if(UP == 1) begin
                comparison_up comparators_base
                (
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1]
                );
            end
            else begin
                comparison_down comparators_base
                (
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1]
                );
            end
        end
    endgenerate

endmodule