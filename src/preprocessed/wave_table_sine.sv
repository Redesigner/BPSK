`include "parameters.svh"

module wave_table_sine
    (
	    input reg [DATA_WIDTH-1:0] phase,
        output reg signed [DATA_WIDTH-1:0] signal
    );

    reg [DATA_WIDTH-1:0] sine_table [0:SINE_RESOLUTION-1] = $sine_table; //loaded by python

    always @ (phase) begin
        signal <= sine_table[phase];
    end
endmodule