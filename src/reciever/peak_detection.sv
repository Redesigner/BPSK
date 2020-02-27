`include "../built-src/parameters.svh"

module peak_detection(
        input clk,
        input reg [DATA_WIDTH-1:0] signal,
        input reg[15:0] phase,
        output reg[15:0] offset = 0,   //the offset between the demod and mod, in clock cycles, between 0 and WAVELENGTH
        output reg ready = 0
    );

    reg [DATA_WIDTH-1:0] prev_max = 0;
    reg[15:0] maxima[7:0]; //we store 8 maxima! Right now, these are unused, but may be useful for more complex analysis
    reg[4:0] index = 0;
    reg[15:0] sum = 0; //up to 8 times our phase width, or 3 more bits - larger signal/clock frequency ratios may need larger numbers

    always @(posedge clk) begin
        if (ready == 0) begin
            if (index >= 8) begin
                index <= 0;//wavelength is representative of 2pi
                ready <= 1;//maximas should occur at 1/2pi for sine, or 3/2pi for a 1pi phase shift.
                offset <= ((sum / 8) + (WAVELENGTH / 4)) % WAVELENGTH;//which comes out to 3/4 of our original wavelength
            end
            else if (signal >= prev_max) begin
                prev_max <= signal;
            end
            else if(signal > THRESHOLD) begin
                maxima[index] <= (phase + WAVELENGTH - 1) % WAVELENGTH; //the maxima actually occured last cycle
                sum <= sum + (phase + WAVELENGTH - 1) % WAVELENGTH; //prevent underflow, should we use a limiter instead? how slow is mod?
                prev_max <= AMPLITUDE/2;
                index <= index + 1;
            end
        end
    end
endmodule