module pulse_with_mod
    (
        input wire clock,
        input [DATA_WIDTH-1:0] amp,
        output wire pulse;
    );
    int max = 63
    int duty = 0
    always @ (posedge clock) begin
        if (phase > 15) begin
            phase <= 0
            duty <= amp * 16 / max
            pulse <= 1
        end
        if (phase > duty) begin
            pulse <= 0
        end
endmodule