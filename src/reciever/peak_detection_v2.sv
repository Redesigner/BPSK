`include "../build/core_params.svh"
`include "../build/preamble_params.svh"

///This module uses a very simplistic cross-correlation algorithm to find the
///phase alignment based on the preamble.
///Simple peak detection will not work well with low Nyquist ratios, so be
///sure to use this instead of the peak detection in those cases
module peak_detection_v2(
        input wire clk,
        input wire [DATA_WIDTH-1:0] signal,
        output wire done,
        output reg [$clog2(WAVELENGTH):0] offset 
    );

    localparam SUB_RATE = 5;

    localparam PROP_DELAY = 4;
    localparam SAMPLE_COUNT = WAVELENGTH * PREAMBLE_LENGTH / SUB_RATE;
    localparam WIDTH = DATA_WIDTH - 1;
    localparam SUM_COUNT = 5; //number of additons we do per loop
    localparam SUM_TIME = SAMPLE_COUNT / SUM_COUNT;

    localparam THRESHOLD = (PREAMBLE_LENGTH * AMPLITUDE) / 10;

    //These will be initialized in the correct loop
    reg signed [DATA_WIDTH - 1:0] demod_samples [0:SAMPLE_COUNT - 1];
    reg signed [DATA_WIDTH - 1:0] ref_samples [0:SAMPLE_COUNT - 1];

    reg [WIDTH:0] samples_dif [0:SAMPLE_COUNT - 1];
    wire [WIDTH:0] samples_dif_debug [0:SAMPLE_COUNT - 1];
    wire unsigned [WIDTH + $clog2(SUM_COUNT):0] ripple_sum [0:SUM_COUNT - 1];
    reg unsigned [WIDTH + $clog2(SAMPLE_COUNT):0] sum = '0;
    reg unsigned [WIDTH + $clog2(SAMPLE_COUNT):0] sum_debug = '0;
    wire signed [DATA_WIDTH-1:0] ref_signal_out;

    reg ref_done = 0;
    
    //reg unsigned [$clog2(WAVELENGTH):0] offset = 0;

    reg [$clog2(SUM_TIME):0] sum_counter = 0;
    reg [$clog2(SAMPLE_COUNT + PROP_DELAY):0] ref_counter = 0;
    reg [$clog2(SUB_RATE):0] sub_counter = 0;

    signal_modulator#(PREAMBLE_LENGTH) ref_signal
    (
        .clk(clk),
        .data(PREAMBLE),
        .enable(~ref_done),
        .signal_out(ref_signal_out),
        .done(refs)
    );

    wire [DATA_WIDTH - 1:0] signal_buf;

    always @(posedge clk) begin
        if(~done) begin
            if(ref_counter < SAMPLE_COUNT - 1 + PROP_DELAY) begin
                ref_counter <= ref_counter + 1;
            end
            else begin
                ref_done <= 1;
                ref_counter <= 0;
            end
            if(~ref_done && ref_counter >= PROP_DELAY) begin
                ref_samples[0] <= (ref_signal_out - AMPLITUDE);
            end
            else if (sum_counter >= (SUM_TIME - 1)) begin
                ref_samples[0] <= ref_samples[SAMPLE_COUNT - 1];
                if(offset < WAVELENGTH - 1) begin
                    offset <= offset + 1;
                end
                else begin
                    offset <= 0;
                end
            end
            demod_samples[0] <= (signal - AMPLITUDE);
        end
    end
    always @(posedge clk) begin
        if(sum_counter < SUM_TIME - 1) begin
            //add the first SUM_COUNT difference values to our register
            sum <= sum + ripple_sum[SUM_COUNT - 1];

            sum_counter <= sum_counter + 1;
        end
        else begin
            sum_debug <= sum;
            sum <= 0;

            sum_counter <= 0;
        end
    end

    genvar i;
    generate
        for (i = 0; i < SAMPLE_COUNT - 1 ; i++) begin
            always @(posedge clk) begin
                if(~refs) begin
                    demod_samples[i + 1] <= demod_samples[i];
                end
                if((~ref_done) || sum_counter >= (SUM_TIME - 1)) begin
                    ref_samples[i + 1] <= ref_samples[i];                   
                end
            end
        end
        for (i = 0; i < SAMPLE_COUNT ; i++) begin
            always @(posedge clk) begin
                if(sum_counter < SUM_TIME - 1) begin
                    //shift all of our differences by SUM_COUNT - we will add the first n differences together, and add that to the sum register.
                    samples_dif[i] <= samples_dif[(i + SUM_COUNT) % (SAMPLE_COUNT - 1)];
                end
                else begin
                    //store all the differences into the dif register
                    samples_dif[i] <=  ((demod_samples[i] - ref_samples[i])>> (DATA_WIDTH - 1) >= 1) ?
                    ~(demod_samples[i] - ref_samples[i]) + 1 :
                    (demod_samples[i] - ref_samples[i]);
                end
            end
    assign samples_dif_debug[i] = ((demod_samples[i] - ref_samples[i])>> (DATA_WIDTH - 1) >= 1) ?
                    ~(demod_samples[i] - ref_samples[i]) + 1 :
                    (demod_samples[i] - ref_samples[i]);
            
            //initialize reg
            initial begin
                demod_samples[i] <= 0;
                ref_samples[i] <= 0;
            end
        end
    endgenerate
    
    //SUM LOGIC
    genvar j;
    generate
        assign ripple_sum[0] = samples_dif[0];

        //ripple_sum[n] is the nth step in the sum logic - if n is too large this won't work!
        for (j = 1; j < SUM_COUNT; j++) begin
            assign ripple_sum[j] = ripple_sum[j-1] + samples_dif[j];
        end
    endgenerate

    assign done = ((sum < THRESHOLD) && ref_done && (sum_counter >= SUM_TIME - 1));

endmodule