`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module FIFO_buffer
    (
        input wire clk,
        input wire data_in,
        input wire write,
        input wire read,

        output wire data_out
    );
    parameter SIZE = 16;
    parameter SELECTOR_WIDTH = $clog2(SIZE);
    reg [SIZE - 1:0] buffer = '0;
    reg [SELECTOR_WIDTH - 1:0] write_selector, read_selector;

    always @(posedge clk) begin
        if(write) begin
            buffer[write_selector] <= data_in;
            if(write_selector < SIZE - 1) begin
                write_selector <= write_selector + 1;
            end
            else begin
                write_selector <= 0;
            end
        end

        if(read) begin
            if(read_selector < SIZE - 1) begin
                read_selector <= read_selector + 1;
            end
            else begin
                read_selector <= 0;
            end
        end
    end

    assign data_out = buffer[read_selector];
    
endmodule