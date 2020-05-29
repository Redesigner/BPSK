`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module parallel_serial
    (
        input wire clk,
        input wire [WIDTH-1:0] parallel_data,
        input wire next,

        output reg serial_signal = 0,
        output reg done = 0
    );
    parameter WIDTH = 16;
    parameter N = $clog2(WIDTH);
    
    reg [N-1:0] counter = 0;
    reg [WIDTH-1:0] buffer = '0;
    reg valid = '0;

    always @(posedge clk) begin
        if(~valid) begin
            buffer <= parallel_data;
            valid <= 1;
        end
        if(next == 1 && valid) begin
            if (counter < (WIDTH - 1)) begin
                counter <= counter + 1;
                serial_signal <= buffer[counter];
                done <= 0;
            end
            if (counter == (WIDTH - 1)) begin
                counter <= 0;
                serial_signal <= buffer[WIDTH - 1];
                done <= 1;
                valid <= 0;
            end
        end
    end

endmodule