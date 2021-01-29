`include "../build/core_params.svh"
`include "../build/sine_table.svh"

module signal_demodulator
    (
        input wire clk,
        input wire init,
        input wire stp,
        input wire [SIGNAL_WIDTH-1:0] sig,
        output wire guess,
        output wire write
    );
    localparam DELAY = WAVELENGTH * 1;

    wire signed [31:0] sum_out;
    reg signed [31:0] sum_in = 0;
    logic state = 0;

    reg [$clog2(WAVELENGTH):0] phase = 0;
    reg [$clog2(WAVELENGTH):0] buffer_delay = '0;
    wire unsigned [SIGNAL_WIDTH-1:0] sig_ref;
    wire unsigned [SIGNAL_WIDTH-1:0] sig_dly;
    reg unsigned [SIGNAL_WIDTH-1:0] sig_buf;
    wire [$clog2(WAVELENGTH):0] phase_o;

    reg started = 1'b0;
    reg buffer_ready = 1'b0;

    wire [9:0] factorA = (sig_buf - AMPLITUDE);
    wire [9:0] factorB = (sig_ref - AMPLITUDE);
    //A*B + C = P
    demod_mult demod_slice (
      .CLK(~clk),  // input wire CLK
      .A(factorA),
      .B(factorB),
      .C(sum_in),
      .P(sum_out)
    );
    
    PIPO_buffer #(SINE_RESOLUTION * SIGNAL_WIDTH, SIGNAL_WIDTH) sine_table
    (
        .clk(clk),
        .read(1'b1),
        .write(init),
        .data_in({>>{SHIFTED_SINE_TABLE}}),
        .data_out(sig_ref)
    );

    FIFO_buffer#(SIGNAL_WIDTH, DELAY) signal_FIFO
    (
        .clk(clk),
        .data_in(sig),
        .rw(1'b1),
        .data_out(sig_dly)
    );

    always @ (posedge clk) begin
        sig_buf <= sig_dly;

        if(stp) begin;
            state <= 0;
        end
        else if(init) begin
            state <= 1;
        end


        if(state == 1) begin
            if(~active) begin
                buffer_delay <= buffer_delay + 1;
            end
            else if(write) begin
                phase <= 0;
                sum_in <= 0;
            end
            else begin
                phase <= phase + 1;
                sum_in <= sum_out;
            end
        end
        if(state == 0) begin
            buffer_delay <= 0;
        end
    end

    assign active = buffer_delay >= DELAY;
    assign guess = sum_out < 0;
    assign write = (phase >= WAVELENGTH - 1);

endmodule