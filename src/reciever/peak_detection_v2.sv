`include "../build/core_params.svh"
`include "../build/preamble_params.svh"

///This module uses a very simplistic cross-correlation algorithm to find the
///phase alignment based on the preamble.
///Simple peak detection will not work well with low Nyquist ratios, so be
///sure to use this instead of the peak detection in those cases
module peak_detection_v2(
        input wire clk,
        input wire [DATA_WIDTH-1:0] signal,
        output wire done
    );

    localparam PROP_DELAY = 4;
    localparam SAMPLE_COUNT = WAVELENGTH * PREAMBLE_LENGTH;
    localparam WIDTH = $clog2(PREAMBLE_THRESHOLD);

    wire signed [WIDTH:0] samples_dif [0:SAMPLE_COUNT - 1];
    wire signed [$clog2(PREAMBLE_THRESHOLD * SAMPLE_COUNT):0] samples_sum [0:SAMPLE_COUNT - 1];
    reg  signed [$clog2(PREAMBLE_THRESHOLD * SAMPLE_COUNT):0] sum = '0;
    wire signed [DATA_WIDTH-1:0] sample_out;

    reg signed [WIDTH:0] min = '0;
    reg unsigned [WIDTH:0] shifted_spaces = '0;
    reg ref_done = 0;

    //These will be initialized in the correct loop
    reg signed [WIDTH:0] samples [0:SAMPLE_COUNT - 1];
    reg signed [WIDTH:0] ref_samples [0:SAMPLE_COUNT - 1];

    signal_modulator#(PREAMBLE_LENGTH) ref_signal
    (
        .clk(clk),
        .data(PREAMBLE),
        .enable(~ref_done),
        .signal_out(sample_out),
        .done(done2)
    );

    always @(posedge clk) begin
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
        for (i = 0; i < SAMPLE_COUNT ; i++) begin
            assign samples_dif[i] =  (samples[i] - ref_samples[i])>> (DATA_WIDTH - 1) ?
             ~(samples[i] - ref_samples[i]) + 1 :
             (samples[i] - ref_samples[i]);
            initial begin
                //initialize values
                samples[i] <= 0;
                ref_samples[i] <= 0;
            end
        end
    endgenerate
    
    assign done = ((sum < DEMOD_THRESHOLD) && ref_done);

endmodule