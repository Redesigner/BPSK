module signal_demodulator
    (
        input clock,
        input reg [DATA_WIDTH-1:0] signal,
        output reg guess,
        output reg write
    );
    reg write = 0;
    longint signed sum = 0;
    reg [15:0] phase = 0;
    reg signed [DATA_WIDTH-1:0] amp;


    wave_table_sine sine_table(phase, amp);
    reg [15:0] offset;
    peak_detection peak(clock, signal, phase, offset, peak_found);
    reg shifted = 0;


    always @ (posedge clock) begin
        if (~shifted && peak_found && phase + 2 >= offset) begin
            shifted <= 1;
            phase <= offset - phase;
            sum <= 0; //the offset is calculated during the 8th bit
        end           //we will have a few cycles to reset the integrator
        else if (phase + 2 > WAVELENGTH) begin
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
            if (peak_found) begin
                write = 1;
            end
        end
        else begin
            sum <= sum + ((signal - AMPLITUDE) * amp); //our signal is unsigned, so it has an offset of our max amplitude
            phase <= phase + 1;
            write <= 0;
        end
    end
endmodule