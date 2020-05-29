`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module PISO_buffer #(WIDTH = 32)
    (
        input wire clk,
        input wire active,
        input wire reset,

        input wire [WIDTH-1:0] parallel,

        output wire serial_signal
    );
    reg [WIDTH - 1:0] data = '0;
    reg reset_old = 0;

    always @(posedge clk) begin
        reset_old <= reset;
        if(reset && ~reset_old) begin
            data <= {<<{parallel}};
        end
        else if(active) begin
            data <= data[WIDTH - 1] | (data << 1);
        end
    end

    assign serial_signal = data[0];

endmodule