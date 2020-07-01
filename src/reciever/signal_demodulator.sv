module signal_demodulator
    (
        input wire clk,
        input wire reset,
        input wire [DATA_WIDTH-1:0] signal,
        output wire guess,
        output wire write
    );
    reg signed [DATA_WIDTH * 2 + $clog2(WAVELENGTH) - 1:0] sum = 0;
    reg [$clog2(WAVELENGTH):0] phase = 0;
    wire signed [DATA_WIDTH-1:0] amp;
    wire [DATA_WIDTH-1:0] phase2;

    reg started = 0;

    wave_table_sine sine_table(clk, phase2, amp);
    phase_table phase_shifter(clk, 1'b1, phase, phase2);

    always @ (posedge clk) begin
        if(reset) begin
            started <= 1'b1;
        end
        if(started) begin
            if (phase >= WAVELENGTH - 1) begin
                phase <= phase - WAVELENGTH + 1;
                sum <= 0;
            end
            else begin
                phase <= phase + 1;
                sum <= sum + ((signal - AMPLITUDE) * (amp - AMPLITUDE)) ; //our signal is unsigned, so it has an offset of our max amplitude
            end
        end
    end

    assign guess = sum > 0;
    assign write = (phase >= WAVELENGTH - 1) && (sum > DEMOD_THRESHOLD || sum < -DEMOD_THRESHOLD);

endmodule