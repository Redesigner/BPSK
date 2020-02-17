`include "parameters.svh"

module wave_table_sine
    (
	    input reg [DATA_WIDTH-1:0] phase,
        output reg signed [DATA_WIDTH-1:0] signal
    );

    reg [DATA_WIDTH-1:0] sine_table [0:SINE_RESOLUTION-1] = {0,1023,1772,2047,1772,1023}; //loaded by python

    always @ (phase) begin
        //the phase is divided into two sections, where one set is an inversion of the other
        if (phase > SINE_RESOLUTION-1) begin
            signal <= -1 * sine_table[phase-SINE_RESOLUTION];
        end else begin
            signal <= sine_table[phase];
        end
    end
endmodule