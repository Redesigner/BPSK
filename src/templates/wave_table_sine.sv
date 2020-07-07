`include "parameters.svh"

module wave_table_sine
    (
        input wire clk,
	    input wire [$$clog2(SINE_RESOLUTION):0] phase,
        output reg [DATA_WIDTH-1:0] signal = AMPLITUDE
    );

    always @(posedge clk) begin
        case(phase)
        $sine_table
        endcase
    end
endmodule