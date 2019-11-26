module pulse_width_mod
    (
        input wire clock,
        input [7:0] amp,
        output wire out,
        output reg clock2

    );
    reg pulse = 0;
    reg [7:0] max = 255;
    reg [3:0] duty = 0;
    reg [3:0] phase = 0;
    reg [3:0] phase_next;
    assign out = pulse;
    
    initial begin
        clock2 = 0;
    end
    
    always @ (posedge clock) begin
        if (phase > 14) begin
            phase = 0;
            duty = (amp + 127) * 16 / max;
            clock2 = ~clock2;
            pulse = 1;
        end else begin
            phase = phase+1;
            if (phase == duty) begin
                pulse = 0;
            end
        end
        
    end
endmodule