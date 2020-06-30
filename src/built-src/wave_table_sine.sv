`include "parameters.svh"

module wave_table_sine
    (
        input wire clk,
	    input wire [$clog2(SINE_RESOLUTION):0] phase,
        output reg [DATA_WIDTH-1:0] signal = AMPLITUDE
    );

    always @(posedge clk) begin
        case(phase)
        0 : begin
 signal <=2047;
 end
1 : begin
 signal <=3250;
 end
2 : begin
 signal <=3993;
 end
3 : begin
 signal <=3993;
 end
4 : begin
 signal <=3250;
 end
5 : begin
 signal <=2047;
 end
6 : begin
 signal <=843;
 end
7 : begin
 signal <=100;
 end
8 : begin
 signal <=100;
 end
9 : begin
 signal <=843;
 end

        endcase
    end
endmodule