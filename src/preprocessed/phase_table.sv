`include "parameters.svh"

module phase_table
    (
        input wire clk,
        input wire data,
	    input wire [$$clog2(WAVELENGTH):0] index,
        output reg [$$clog2(SINE_RESOLUTION):0] phase = 0
    );

    always @(posedge clk) begin
        if(data) begin
            case(index)
                $phase_table_on
            endcase
        end
        else begin
            case(index)
                $phase_table_off
            endcase
        end 
    end
endmodule