`include "../built-src/parameters.svh"
`timescale 1ns/10ps

module pulse_width_mod
    (
        input wire clock,
        input signed [7:0] amp,
        output wire out,
        output reg clock2

    );
    reg pulse = 0;
    reg [7:0] max = 255;
    reg [10:0] duty = 0;
    reg [10:0] phase = 0;
    reg [3:0] phase_next;

    int phase2 = 0; //This is to make it human visible!

    assign out = pulse;
    
    initial begin
        clock2 = 0;
    end
    
    always @ (posedge clock) begin
        if (phase2 < 50000) begin
            if (phase > 14) begin
                phase = 0;
                duty = (amp + 128);
                duty = duty * 16 / max;
                phase2 = phase2 + 1;
            end else begin
                phase = phase+1;
                if (phase >= duty) begin
                    pulse = 0;
                end else begin
                    pulse = 1;
                end
            end
        end else begin
            phase2 = 0;
            clock2 = ~clock2;
        end
    end
endmodule