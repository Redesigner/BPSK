`include "../../built-src/parameters.svh"

module comparison_size_r #(parameter SIZE = 4, parameter UP = 1)
    (
        input wire clk,
        input wire ready,

        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,

        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out,
        output wire [SIZE-1:0][INDEX_WIDTH-1:0] index_out,

        output reg done = 0
    );

    //VIRTUAL WIRE DECLARATIONS
    wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_internal;
    reg [SIZE-1:0][NETWORK_WIDTH-1:0] data_internal_reg = '0;
    wire [SIZE-1:0][INDEX_WIDTH-1:0] index_internal;
    reg [SIZE-1:0][INDEX_WIDTH-1:0] index_internal_reg = '0;
    //These wires are to maintain data bewteen steps, a is the first intermediate step, etc.


    generate
        if(SIZE != 2) begin
            reg done_internal = 0;
            always @(posedge clk) begin
                if(&done_multi_internal) begin
                    done_internal <= 1;
                    data_internal_reg <= data_internal;
                    index_internal_reg <= index_internal;
                end
                if(done_merge_internal) begin
                    done <= 1;
                end
            end

            wire [1:0] done_multi_internal;
            wire done_merge_internal;

            (* keep_hierarchy = "yes" *)
            comparison_size_r #(SIZE / 2, UP) sort_top
            (
                clk,
                ready,

                data_in[SIZE-1:SIZE/2],
                index_in[SIZE-1:SIZE/2],
                data_internal_reg[SIZE-1:SIZE/2],
                index_internal_reg[SIZE-1:SIZE/2],

                done_multi_internal[0]
            );
            
            (* keep_hierarchy = "yes" *)
            comparison_size_r #(SIZE / 2, ~UP) sort_bottom
            (
                clk,
                ready,

                data_in[SIZE/2-1:0],
                index_in[SIZE/2-1:0],
                data_internal_reg[SIZE/2-1:0],
                index_internal_reg[SIZE/2-1:0],

                done_multi_internal[1]
            );
            //merge
            (* keep_hierarchy = "yes" *)
            comparators_merge_r #(SIZE, UP) merge
            (
                clk,
                done_internal,
                data_internal[SIZE-1:0],
                index_internal[SIZE-1:0],
                data_out[SIZE-1:0],
                index_out[SIZE-1:0],
                done_merge_internal
            );
        end
        else begin
            if(UP == 1) begin
                comparison_up_r comparators_base
                (
                    clk,
                    ready,
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1],
                    done
                );
            end
            else begin
                comparison_down_r comparators_base
                (
                    clk,
                    ready,
                    data_in[0], data_in[1],
                    index_in[0], index_in[1],
                    data_out[0], data_out[1],
                    index_out[0], index_out[1],
                    done
                );
            end
        end
    endgenerate

endmodule