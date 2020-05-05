module clock_divider
    (    
        input wire clk,
        output reg clk_out = 0
    );
    parameter WIDTH = 4;
    parameter N = 10;
    reg [WIDTH-1:0] index = 0;

    always @(posedge clk) begin
        if (index >= ((N / 2) - 1)) begin
            clk_out <= ~clk_out;
            index <= 0;
        end
        else begin
            index <= index + 1;
        end
    end
endmodule