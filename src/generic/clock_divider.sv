`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module clock_divider
    (    
        input wire I,
        output reg O = 0
    );
    parameter N = 10;
    parameter WIDTH = $clog2(N);
    reg [WIDTH-1:0] index = 0;

    always @(posedge I) begin
        if (index >= ((N / 2) - 1)) begin
            O <= ~O;
            index <= 0;
        end
        else begin
            index <= index + 1;
        end
    end
endmodule