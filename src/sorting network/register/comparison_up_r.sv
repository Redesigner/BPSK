`include "../../built-src/parameters.svh"


module comparison_up_r
    (
        input wire clk,
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

    always @(posedge clk) begin
        if(ready) begin
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

endmodule