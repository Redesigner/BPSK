module PISO_buffer #(WIDTH = 32)
/**
* Parallel In; Parallel Out buffer
* synchronized with clk
*
* if reset is brought high, will write 'parallel' to buffer
*
* while active, buffer will barrel shift, causing the 'serial_signal' to output data LSB first 
*
**/
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
            data <= (data << WIDTH - 1) | (data >> 1);
        end
    end

    assign serial_signal = data[0];

endmodule