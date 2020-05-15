`include "parameters.svh"

module wave_table_sine
    (
	    input reg [DATA_WIDTH-1:0] phase,
        output reg signed [DATA_WIDTH-1:0] signal
    );

    reg [DATA_WIDTH-1:0] sine_table [0:SINE_RESOLUTION-1] = {2047,2679,3250,3703,3993,4094,3993,3703,3250,2679,2047,1414,843,390,100,0,100,390,843,1414}; //loaded by python

    always @ (phase) begin
        signal <= sine_table[phase];
    end
endmodule