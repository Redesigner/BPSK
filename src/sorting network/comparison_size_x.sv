`include "../built-src/parameters.svh"

module comparison_size_x #(parameter SIZE = 4, parameter DEPTH = 2, parameter UP = 1)
    (
        //input wire clk,
        //input wire ready,

        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,

        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out,
        output wire [SIZE-1:0][INDEX_WIDTH-1:0] index_out

        //output wire done
    );

    //VIRTUAL WIRE DECLARATIONS
    wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_internal;
    wire [SIZE-1:0][INDEX_WIDTH-1:0] index_internal;
    //These wires are to maintain data bewteen steps, a is the first intermediate step, etc.


    generate
        if(SIZE != 2) begin
            //wire [1:0] done_multi_internal;
            //wire done_internal;
            //assign done_internal = &done_multi_internal;
            
            (* keep_hierarchy = "yes" *)
            comparison_size_x #(SIZE / 2, DEPTH - 1, UP) sort_top
            (
                //clk,
                //ready,

                data_in[SIZE-1:SIZE/2],
                index_in[SIZE-1:SIZE/2],
                data_internal[SIZE-1:SIZE/2],
                index_internal[SIZE-1:SIZE/2]

                //done_multi_internal[0]
            );
            
            (* keep_hierarchy = "yes" *)
            comparison_size_x #(SIZE / 2, DEPTH - 1, ~UP) sort_bottom
            (
                //clk,
                //ready,

                data_in[SIZE/2-1:0],
                index_in[SIZE/2-1:0],
                data_internal[SIZE/2-1:0],
                index_internal[SIZE/2-1:0]

                //done_multi_internal[1]
            );
            //merge
            (* keep_hierarchy = "yes" *)
            comparators_merge_x #(SIZE, DEPTH, UP) merge
            (
                //clk,
                //done_internal,
                data_internal[SIZE-1:0],
                index_internal[SIZE-1:0],
                data_out[SIZE-1:0],
                index_out[SIZE-1:0]
                //done
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