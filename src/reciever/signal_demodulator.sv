module signal_demodulator
    (
        input clk,
        input reg [DATA_WIDTH-1:0] signal,
        output wire guess,
        output wire write
    );
    reg [DATA_WIDTH * 2 + $clog2(WAVELENGTH) - 1:0] sum = 0;
    reg [$clog2(WAVELENGTH):0] phase = 0;
    wire signed [DATA_WIDTH-1:0] amp;
    wire [DATA_WIDTH-1:0] phase2;

    reg [$clog2(WAVELENGTH):0] offset;
    peak_detection peak(clk, signal, phase, offset, peak_found);
    reg shifted = 0;

    wave_table_sine sine_table(clk, phase2, amp);
    phase_table phase_shifter(clk, 1'b1, phase, phase2);

    always @ (posedge clk) begin
        if (~shifted && peak_found && phase == offset) begin
            shifted <= 1;
            phase <= ((3 * WAVELENGTH / 4) + 1);
            sum <= 0;
        end
        else begin
            if (phase >= WAVELENGTH - 1) begin
                phase <= phase - WAVELENGTH + 1;
                sum <= 0;
            end
            else if (shifted) begin
                phase <= phase + 1;
                sum <= sum + ((signal - AMPLITUDE) * (amp - AMPLITUDE)) ; //our signal is unsigned, so it has an offset of our max amplitude
            end
            else begin
                phase <= phase + 1;
            end
        end
    end

    assign guess = sum < 0;
    assign write = (phase >= WAVELENGTH - 1) && shifted;

endmodule