`include "parameters.svh"

module wave_table_sine
    (
	    input reg [DATA_WIDTH-1:0] phase,
        output reg signed [DATA_WIDTH-1:0] signal
    );

    reg [DATA_WIDTH-1:0] sine_table [0:SINE_RESOLUTION-1] = {2047,3070,3819,4094,3819,3070,2047,1023,274,0,274,1023}; //loaded by python

    always @ (phase) begin
        signal <= sine_table[phase];
    end
endmodule