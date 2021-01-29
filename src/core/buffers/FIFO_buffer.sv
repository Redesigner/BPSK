module FIFO_buffer #(parameter WIDTH = 4, parameter COUNT = 5)
/**
* A clock synchronized buffer, if rw is high on a clock posedge, stores data in the register
* WIDTH = size of each unit of data
* COUNT = Number of units of data stored at once
* Until the buffer is full, data_out will be 0
**/
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