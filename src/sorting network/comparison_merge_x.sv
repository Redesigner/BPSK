`include "../built-src/parameters.svh"

module comparators_merge_x #(parameter SIZE = 4, parameter DEPTH = 2, UP = 1)
    (
        //input wire clk,
        //input wire ready,
        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,

        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out,
        output wire [SIZE-1:0][INDEX_WIDTH-1:0] index_out
        //output wire done
    );
    //TAKES A BUTTERFLY SEQUENCE AND FINALIZES THE SORT


    //VIRTUAL WIRE DECLARATIONS
    wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_internal;
    wire [SIZE-1:0][INDEX_WIDTH-1:0] index_internal;
    //These wires are to maintain data bewteen steps, a is the first intermediate step, etc.
    genvar i;
    generate
        if(SIZE != 2) begin
            wire [(SIZE / 2) - 1:0] done_multi_internal;
            wire [1:0] done_multi;
            wire done_internal;
            assign done_internal = &done_multi_internal;
            assign done = &done_multi;
            if(UP == 1) begin
                for(i = 0; i < SIZE / 2; i++) begin
                    comparison_up comparators_merge
                    (
                        //clk,
                        //ready,
                        data_in[i], data_in[i + (SIZE / 2)],
                        index_in[i], index_in[i + (SIZE / 2)],
                        data_internal[i], data_internal[i + (SIZE / 2)],
                        index_internal[i], index_internal[i + (SIZE / 2)]
                        //done_multi_internal[i]
                    );
                end
            end
            else begin
                for(i = 0; i < SIZE / 2; i++) begin
                    comparison_down comparators_merge
                    (
                        //clk,
                        //ready,
                        data_in[i], data_in[i + (SIZE / 2)],
                        index_in[i], index_in[i + (SIZE / 2)],
                        data_internal[i], data_internal[i + (SIZE / 2)],
                        index_internal[i], index_internal[i + (SIZE / 2)]
                        //done_multi_internal[i]
                    );
                end
            end
            comparators_merge_x #(SIZE / 2, DEPTH - 1, UP) merge_top
            (
                //clk,
                //done_internal,
                data_internal[SIZE-1:SIZE/2],
                index_internal[SIZE-1:SIZE/2],
                data_out[SIZE-1:SIZE/2],
                index_out[SIZE-1:SIZE/2]
                //done_multi[0]
            );
            comparators_merge_x #(SIZE / 2, DEPTH - 1, UP) merge_bottom
            (
                //clk,
                //done_internal,
                data_internal[SIZE/2-1:0],
                index_internal[SIZE/2-1:0],
                data_out[SIZE/2-1:0],
                index_out[SIZE/2-1:0]
                //done_multi[1]
            );

        end
        else begin
            if(UP == 1) begin
                comparison_up comparators_base
                (
                    //clk,
                    //ready,
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1]
                    //done
                );
            end
            else begin
                comparison_down comparators_base
                (
                    //clk,
                    //ready,
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1]
                    //done
                );
            end
        end
    endgenerate
endmodule