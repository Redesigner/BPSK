module signal_demodulator
    (
        input clock,
        input reg [DATA_WIDTH-1:0] signal,
        output wire guess,
        output wire write
    );
    longint signed sum = 0;
    reg [15:0] phase = 0;
    reg signed [DATA_WIDTH-1:0] amp;


    wave_table_sine sine_table(phase, amp);
    reg [15:0] offset;
    peak_detection peak(clock, signal, phase, offset, peak_found);
    reg shifted = 0;


    always @ (posedge clock) begin
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