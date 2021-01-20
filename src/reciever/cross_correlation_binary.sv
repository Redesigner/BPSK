`include "../build/core_params.svh"


module cross_correlation_binary
(
        input wire clk,
        input bit signal,
        input bit clr,
        output wire done,
        output reg [$clog2(WAVELENGTH) : 0] offset = 0
    );
    localparam SAMPLE_COUNT = PREAMBLE_WIDTH * WAVELENGTH;
    localparam THRESHOLD = 0;

    reg [SAMPLE_COUNT - 1:0] ref_samples = '0;
    reg [SAMPLE_COUNT - 1:0] real_samples = '0;
    wire [$clog2(SAMPLE_COUNT) - 1:0] sum;


    wire [SAMPLE_COUNT - 1:0] diff;

    reg [$clog2(SAMPLE_COUNT) - 1 : 0] ref_count = 0;
    reg ref_done = 1'b0;
    wire [SIGNAL_WIDTH - 1 : 0] ref_signal_out;
    modulator_v2 #(PREAMBLE_WIDTH) reference
    (
        .clk(clk),
        .data(PREAMBLE),
        .reset(1'b1),
        .signal(ref_signal_out)
    );

    tree_adder #(SAMPLE_COUNT, 1) adder
    (
        .clk(clk),
        .data_in(diff),
        .sum(sum)
    );

    always @(posedge clk) begin
        if(clr) begin
            real_samples <= '0;
        end
        
        else begin
            if(ref_count < SAMPLE_COUNT) begin
                ref_count <= ref_count + 1;    
            end
            else begin
                ref_done <= 1'b1;
            end

            if(~ref_done) begin
                ref_samples <= (ref_samples << 1) | (ref_signal_out[SIGNAL_WIDTH - 1]);
            end
            real_samples <= (real_samples << 1) | signal;

            if(offset < WAVELENGTH - 1) begin
                offset <= offset + 1;
            end
            else begin
                offset <= 0;
            end
        end
    end

    assign diff = (ref_samples ^ real_samples);
    assign done = (sum <= THRESHOLD) && (ref_done);

    genvar i;
    

endmodule