`include "../built-src/parameters.svh"
`include "../built-src/cross_comparison_sample.svh"

///This module uses a very simplistic cross-correlation algorithm to find the
///phase alignment based on the preamble.
///Simple peak detection will not work well with low Nyquist ratios, so be
///sure to use this instead of the peak detection in those cases
parameter SAMPLE_COUNT = WAVELENGTH * PREAMBLE_LENGTH;
parameter TRUNCATED_WIDTH = 4;
module peak_detection_v2(
        input clk,
        input reg [DATA_WIDTH-1:0] signal,
        output reg[$clog2(SAMPLE_COUNT):0] offset = 0,   //the offset between the demod and mod, in clock cycles, between 0 and WAVELENGTH
        output reg ready = 0
    );
    wire signed [(TRUNCATED_WIDTH*2)-1:0] samples_int [0:SAMPLE_COUNT - 1];

    reg signed [TRUNCATED_WIDTH-1:0] samples [0:SAMPLE_COUNT - 1];
    reg signed [TRUNCATED_WIDTH-1:0] ref_samples [0:SAMPLE_COUNT - 1];
    reg signed [$clog2(PREAMBLE_THRESHOLD) + 1:0] samples_sum = 0;
    reg signed [$clog2(PREAMBLE_THRESHOLD) + 1:0] max = 0;
    reg unsigned [$clog2(PREAMBLE_THRESHOLD) - 1:0] p_threshold = PREAMBLE_THRESHOLD;

    reg[$clog2(SAMPLE_COUNT):0] shifted_spaces = 0;
    reg ref_done = 0;

    wire signed [DATA_WIDTH-1:0] sample_out;
    signal_modulator#(PREAMBLE_LENGTH) ref_signal(clk, PREAMBLE, ~ref_done, sample_out, done);

    //have we generated enough samples to compare our incoming signal to?
    always @(posedge clk) begin
        //Looping ring shift occurrs in constant time
        if(shifted_spaces < SAMPLE_COUNT - 1) begin
            shifted_spaces <= shifted_spaces + 1;
        end
        else begin
            ref_done <= 1;
            shifted_spaces <= 0;
        end
        if(~ref_done) begin
            ref_samples[0] <= (sample_out - AMPLITUDE) >> (DATA_WIDTH-TRUNCATED_WIDTH);
        end
        samples[0] <= (signal - AMPLITUDE) >> (DATA_WIDTH-TRUNCATED_WIDTH);
        samples_sum <= samples_sum +
        ((sample_out - AMPLITUDE) >> (DATA_WIDTH-TRUNCATED_WIDTH) * (signal - AMPLITUDE) >> (DATA_WIDTH-TRUNCATED_WIDTH)) -
        samples_int[SAMPLE_COUNT - 1];
    end

    //We will be constantly calculating the sum of the data * the ref signal
    //when this value reaches its maximum, this is where the reference signal
    //and the incoming signal are in alignment

    always @(posedge clk) begin
        if(samples_sum > max) begin
            max <= samples_sum;
        end
        //Cross correlation coeffecient is a LARGE int rather than 1
        if(max > p_threshold && ~ready) begin
            ready <= 1;
            offset <= shifted_spaces;
        end
    end
    genvar i;
    generate
        for (i = 0; i < SAMPLE_COUNT - 1 ; i++) begin
            always @(posedge clk) begin
                samples[i + 1] <= samples[i];
                if(~ref_done) begin
                    ref_samples[i + 1] <= ref_samples[i];
                end
            end
        end
        //integrate our samples
        for (i = 0; i < SAMPLE_COUNT ; i++) begin
            assign samples_int[i] = samples[i]*ref_samples[i];
            initial begin
                //initialize values
                samples[i] <= 0;
                ref_samples[i] <= 0;
            end
        end

    endgenerate

endmodule