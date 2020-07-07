`include "../build/core_params.svh"

module phase_table
    (
        input wire clk,
        input wire data,
	    input wire [$clog2(WAVELENGTH):0] index,
        output reg [$clog2(SINE_RESOLUTION):0] phase = 0
    );

    always @(posedge clk) begin
        if(data) begin
            case(index)
                0 : begin
 phase <=0;
 end
1 : begin
 phase <=1;
 end
2 : begin
 phase <=2;
 end
3 : begin
 phase <=3;
 end
4 : begin
 phase <=4;
 end
5 : begin
 phase <=5;
 end
6 : begin
 phase <=6;
 end
7 : begin
 phase <=7;
 end
8 : begin
 phase <=8;
 end
9 : begin
 phase <=9;
 end

            endcase
        end
        else begin
            case(index)
                0 : begin
 phase <=5;
 end
1 : begin
 phase <=6;
 end
2 : begin
 phase <=7;
 end
3 : begin
 phase <=8;
 end
4 : begin
 phase <=9;
 end
5 : begin
 phase <=0;
 end
6 : begin
 phase <=1;
 end
7 : begin
 phase <=2;
 end
8 : begin
 phase <=3;
 end
9 : begin
 phase <=4;
 end

            endcase
        end 
    end
endmodule