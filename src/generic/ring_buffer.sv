`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module ring_buffer
    (
        input wire clk,
        input wire data_in,
        input wire write,

        output wire [WIDTH - 1:0] data_out
    );
    parameter SIZE = 16;
    parameter WIDTH = 4;

    reg[SIZE - 1:0] buffer = '0;

    always @(posedge clk) begin
        if(write) begin
            buffer <= (buffer << 1) | data_in;
        end
    end

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign data_out[i] = buffer[WIDTH - i - 1];
        end
    endgenerate
endmodule