`include "../built-src/parameters.svh"
`include "../built-src/cross_comparison_sample.svh"

///This module uses a very simplistic cross-correlation algorithm to find the
///phase alignment based on the preamble.
///Simple peak detection will not work well with low Nyquist ratios, so be
///sure to use this instead of the peak detection in those cases
parameter SAMPLE_COUNT = WAVELENGTH * PREAMBLE_LENGTH;
parameter PROP_DELAY = 4;
module peak_detection_v2(
        input wire clk,
        input wire [DATA_WIDTH-1:0] signal,
        output wire done
    );
    wire signed [$clog2(PREAMBLE_THRESHOLD):0] samples_dif [0:SAMPLE_COUNT - 1];
    wire signed [$clog2(PREAMBLE_THRESHOLD * SAMPLE_COUNT):0] samples_sum [0:SAMPLE_COUNT - 1];
    reg signed [$clog2(PREAMBLE_THRESHOLD * SAMPLE_COUNT):0] sum = '0;

    reg signed [$clog2(PREAMBLE_THRESHOLD):0] samples [0:SAMPLE_COUNT - 1];
    reg signed [$clog2(PREAMBLE_THRESHOLD):0] ref_samples [0:SAMPLE_COUNT - 1];
    reg signed [$clog2(PREAMBLE_THRESHOLD):0] min = 0;

    reg[$clog2(SAMPLE_COUNT):0] shifted_spaces = 0;
    reg ref_done = 0;

    wire signed [DATA_WIDTH-1:0] sample_out;
    signal_modulator#(PREAMBLE_LENGTH/2) ref_signal(clk, PREAMBLE, ~ref_done, sample_out, done2);

    //It takes two cycles to generate the sine value at from each index

    //have we generated enough samples to compare our incoming signal to?
    always @(posedge clk) begin
        //Looping ring shift occurrs in constant time
        if(shifted_spaces < SAMPLE_COUNT - 1 + PROP_DELAY) begin
            shifted_spaces <= shifted_spaces + 1;
        end
        else begin
            ref_done <= 1;
            shifted_spaces <= 0;
        end
        if(~ref_done && shifted_spaces >= PROP_DELAY) begin
            ref_samples[0] <= (sample_out - AMPLITUDE);
        end
        samples[0] <= (signal - AMPLITUDE);
    end

    //We will be constantly calculating the sum of the data * the ref signal
    //when this value reaches its maximum, this is where the reference signal
    //and the incoming signal are in alignment

    reg [$clog2(SINE_RESOLUTION):0] shift_counter = 0;
    always @(posedge clk) begin
        if(~done) begin
            sum <= samples_sum[SAMPLE_COUNT - 1];
            if(sum < min) begin
                min <= sum;
            end
        end
    end
    genvar i;
    generate
        for (i = 0; i < SAMPLE_COUNT - 1 ; i++) begin
            always @(posedge clk) begin
                if(~done) begin
                    samples[i + 1] <= samples[i];
                    if(~ref_done) begin
                        ref_samples[i + 1] <= ref_samples[i];
                    end
                end
            end
            assign samples_sum[i + 1] = samples_sum[i] + samples_dif[i + 1];
        end
        assign samples_sum[0] = samples_dif[0];
        //integrate our samples
        for (i = 0; i < SAMPLE_COUNT ; i++) begin
            //absolute value
            assign samples_dif[i] =  (samples[i] - ref_samples[i])>>11 ? ~(samples[i] - ref_samples[i]) + 1 : (samples[i] - ref_samples[i]);
            initial begin
                //initialize values
                samples[i] <= 0;
                ref_samples[i] <= 0;
            end
        end
    endgenerate
    assign done = ((sum < DEMOD_THRESHOLD) && ref_done) ? 1'b1 : 1'b0;

endmodule