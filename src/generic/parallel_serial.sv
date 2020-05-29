`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module parallel_serial #(WIDTH = 16)
    (
        input wire clk,
        input wire [WIDTH-1:0] parallel_data,
        input wire next,

        output wire serial_signal,
        output reg done = 0
    );
    localparam N = $clog2(WIDTH);
    
    reg [N-1:0] counter = 0;

    always @(posedge clk) begin
        if(next == 1) begin
            if (counter < (WIDTH - 1)) begin
                counter <= counter + 1;
                //serial_signal <= parallel_data[counter];
                done <= 0;
            end
            if (counter == (WIDTH - 1)) begin
                counter <= 0;
                //serial_signal <= parallel_data[WIDTH - 1];
                done <= 1;
            end
        end
    end
    
    assign serial_signal = parallel_data[counter];

endmodule