`include "../../build/core_params.svh"
`include "../../build/network_params.svh"

module comparison_base_r #(parameter UP = 1'b1)
    (
        input wire clk,
        input wire reset,
        input wire ready,

        input wire [NETWORK_WIDTH-1:0] in_a,
        input wire [NETWORK_WIDTH-1:0] in_b,

        input wire [INDEX_WIDTH-1:0] in_a_index,
        input wire [INDEX_WIDTH-1:0] in_b_index,


        output reg [NETWORK_WIDTH-1:0] out_a = '0,
        output reg [NETWORK_WIDTH-1:0] out_b = '0,

        output reg [INDEX_WIDTH-1:0] out_a_index = '0,
        output reg [INDEX_WIDTH-1:0] out_b_index = '0,

        output reg done = 0

    );
    generate
        if(~UP) begin
            always @(posedge clk) begin
                if(reset) begin
                    done <= 0;
                end
                else if(ready) begin
                    case(in_a >= in_b)
                        1'b0 : begin
                            out_a <= in_a;
                            out_b <= in_b;
                            out_a_index <= in_a_index;
                            out_b_index <= in_b_index;
                        end
                        1'b1 : begin
                            out_a <= in_b;
                            out_b <= in_a;
                            out_a_index <= in_b_index;
                            out_b_index <= in_a_index;
                        end
                    endcase
                    done <= 1;
                end
            end
        end
        if(UP) begin
            always @(posedge clk) begin
                if(reset) begin
                    done <= 0;
                end
                else if(ready) begin
                    case(in_a >= in_b)
                        1'b1 : begin
                            out_a <= in_a;
                            out_b <= in_b;
                            out_a_index <= in_a_index;
                            out_b_index <= in_b_index;
                        end
                        1'b0 : begin
                            out_a <= in_b;
                            out_b <= in_a;
                            out_a_index <= in_b_index;
                            out_b_index <= in_a_index;
                        end
                    endcase
                    done <= 1;
                end
            end
        end
    endgenerate
endmodule