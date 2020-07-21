`include "../build/core_params.svh"
`include "../build/sine_table.svh"

module signal_demodulator
    (
        input wire clk,
        input wire reset,
        input wire [DATA_WIDTH-1:0] signal,
        output wire guess,
        output wire write
    );
    localparam DELAY = WAVELENGTH * 1;

    wire signed [31:0] sum_out;
    reg signed [31:0] sum_in = 0;

    reg [$clog2(WAVELENGTH):0] phase = 0;
    reg [$clog2(WAVELENGTH):0] buffer_delay = '0;
    wire unsigned [DATA_WIDTH-1:0] ref_signal;
    wire unsigned [DATA_WIDTH-1:0] signal_buf;
    reg unsigned [DATA_WIDTH-1:0] signal_buf_2;
    wire [$clog2(WAVELENGTH):0] phase_o;

    reg started = 1'b0;
    reg buffer_ready = 1'b0;

    demod_mult demod_slice (
      .CLK(clk),  // input wire CLK
      .A(signal_buf_2 - AMPLITUDE),      // input wire [11 : 0] A
      .B(ref_signal - AMPLITUDE),      // input wire [11 : 0] B
      .C(sum_in),      // input wire [31 : 0] C
      .P(sum_out)      // output wire [31 : 0] P
    );
    
    PIPO_buffer #(SINE_RESOLUTION * DATA_WIDTH, DATA_WIDTH) sine_table
    (
        .clk(clk),
        .read(1'b1),
        .write(reset),
        .data_in({>>{SHIFTED_SINE_TABLE}}),
        .data_out(ref_signal)
    );

    FIFO_buffer#(DATA_WIDTH, DELAY) signal_FIFO
    (
        .clk(clk),
        .data_in(signal),
        .rw(1'b1),
        .data_out(signal_buf)
    );

    always @ (posedge clk) begin
        signal_buf_2 <= signal_buf;
        if(reset) begin
            started <= 1'b1;
        end
        if(started) begin
            if(buffer_delay < DELAY) begin
                buffer_delay <= buffer_delay + 1;
            end
            else begin
                buffer_ready <= 1'b1;
            end
        end
        if(buffer_ready) begin
            if (phase >= WAVELENGTH - 1) begin
                phase <= 0;
            end
            else begin
                phase <= phase + 1;
            end
        end
        if(phase >= WAVELENGTH - 1) begin
            //sum_in <= 0;
        end
        else begin
            sum_in <= sum_out;
        end
    end

    assign guess = sum_out < 0;
    assign write = (phase >= WAVELENGTH - 1) && (sum_out > DEMOD_THRESHOLD || sum_out < -DEMOD_THRESHOLD);

endmodule