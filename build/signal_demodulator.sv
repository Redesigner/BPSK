module signal_demodulator
    (
        input clock,
        input reg signed [DATA_WIDTH-1:0] signal,
        output reg guess,
        output reg write
    );
    reg write = 0;
    longint signed sum = 0;
    reg [15:0] phase = 0;
    reg signed [DATA_WIDTH-1:0] amp;
    wave_table_sine sine_table(phase, amp);

    always @ (posedge clock) begin
        if (phase + 2 > WAVELENGTH) begin
            phase <= 0;
            //make our guess!
            if (sum >= 0) begin
                guess = 0;
                sum = 0;
            end else begin
                guess = 1;
                sum = 0;
            end
            //tell our recipient the data is ready!
            write = 1;
        end else begin
            sum <= sum + (signal * amp);
            phase <= phase + 1;
            write <= 0;
        end
    end
endmodule