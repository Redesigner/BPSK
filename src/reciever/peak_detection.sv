`include "../built-src/parameters.svh"

module peak_detection(
        input clk,
        input reg [DATA_WIDTH-1:0] signal,
        input reg[$clog2(WAVELENGTH):0] phase,
        output reg[$clog2(WAVELENGTH):0] offset = 0,   //the offset between the demod and mod, in clock cycles, between 0 and WAVELENGTH
        output reg ready = 0
    );

    parameter PEAKS = (WAVELENGTH / SINE_RESOLUTION ) * (PREAMBLE_LENGTH + 1);
    reg [DATA_WIDTH-1:0] prev_max = AMPLITUDE;
    reg [DATA_WIDTH-1:0] prev_min = AMPLITUDE;
    reg maxima_ready = 1;
    reg[DATA_WIDTH - 1:0] maxima[PEAKS - 1:0]; //we store 8 maxima! Right now, these are unused, but may be useful for more complex analysis
    reg[$clog2(WAVELENGTH):0] index = 0;
    reg[$clog2(PEAKS):0] sum = 0; //up to 8 times our phase width, or 3 more bits - larger signal/clock frequency ratios may need larger numbers
    always @(posedge clk) begin
        if (ready == 0) begin
            if(index > PEAKS - 1) begin
                index <= 0;//wavelength is representative of 2pi
                ready <= 1;//maximas should occur at 1/2pi for sine, or 3/2pi for a 1pi phase shift.
                offset <= ((sum / PEAKS)) % WAVELENGTH;//which comes out to 3/4 of our original wavelength
            end
            else begin
                if (signal <= prev_min) begin
                    maxima_ready <= 1;
                end
                else if (maxima_ready == 1) begin
                    if (signal >= prev_max) begin
                        prev_max <= signal;
                    end
                    if(signal < prev_max) begin
                        maxima[index] <= (phase - 1); //the maxima actually occured last cycle
                        sum <= sum + (phase - 1); //prevent underflow, should we use a limiter instead? how slow is mod?
                        prev_max <= AMPLITUDE;
                        prev_min <= AMPLITUDE;
                        index <= index + 1;
                        maxima_ready <= 0;
                    end
                end
            end
        end
    end
endmodule