module FIFO_buffer #(parameter WIDTH = 4, parameter COUNT = 5)
(
        input wire clk,
        input wire [WIDTH - 1:0] data_in,
        input wire rw,
        output wire [WIDTH - 1:0 ]data_out
    );
    reg [(WIDTH * COUNT) - 1:0] buffer = '0;

    always @(posedge clk) begin
        if(rw) begin
            buffer <= (buffer << WIDTH) | data_in;
        end
    end

    assign data_out = buffer[(WIDTH * COUNT) - 1 -:WIDTH];

endmodule