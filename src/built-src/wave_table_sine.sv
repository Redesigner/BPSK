`include "parameters.svh"

module wave_table_sine
    (
        input wire clk,
	    input wire [$clog2(SINE_RESOLUTION):0] phase,
        output reg [DATA_WIDTH-1:0] signal = 0
    );

    always @(posedge clk) begin
        case(phase)
        0 : begin
 signal <=2047;
 end
1 : begin
 signal <=2519;
 end
2 : begin
 signal <=2965;
 end
3 : begin
 signal <=3362;
 end
4 : begin
 signal <=3688;
 end
5 : begin
 signal <=3926;
 end
6 : begin
 signal <=4062;
 end
7 : begin
 signal <=4090;
 end
8 : begin
 signal <=4008;
 end
9 : begin
 signal <=3819;
 end
10 : begin
 signal <=3535;
 end
11 : begin
 signal <=3171;
 end
12 : begin
 signal <=2747;
 end
13 : begin
 signal <=2284;
 end
14 : begin
 signal <=1809;
 end
15 : begin
 signal <=1346;
 end
16 : begin
 signal <=922;
 end
17 : begin
 signal <=558;
 end
18 : begin
 signal <=274;
 end
19 : begin
 signal <=85;
 end
20 : begin
 signal <=3;
 end
21 : begin
 signal <=31;
 end
22 : begin
 signal <=167;
 end
23 : begin
 signal <=405;
 end
24 : begin
 signal <=731;
 end
25 : begin
 signal <=1128;
 end
26 : begin
 signal <=1574;
 end

        endcase
    end
endmodule