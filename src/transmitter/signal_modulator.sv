`include "../built-src/parameters.svh"
`timescale 1ns/10ps


module signal_modulator
    (
        input clk,                              //clock speed should be signal_freq * DATA_WIDTH / 2
        input wire data_stream,                 //current bit to modulate
        input wire enable,                      //generates signal on high, silent on low
        (*IOB="TRUE"*) output reg [DATA_WIDTH-1:0] signal_out = '0,//parallel signal to be sent to DAC
        output reg next = 0,                       //flips when complete signal has been sent
        output wire done
    );

    reg [$clog2(WAVELENGTH):0] index = 0;
    reg [$clog2(PACKET_WIDTH_OVERHEAD):0] counter = 0;
    wire [$clog2(SINE_RESOLUTION):0] phase;
    reg enabled = 0;
    reg done_i = 0;
    wire [DATA_WIDTH-1:0] signal;

    (* keep_hierarchy = "yes" *)
    wave_table_sine sine_table(clk, phase, signal);
    (* keep_hierarchy = "yes" *)
    phase_table phase_shifter(clk, data_stream, index, phase);
    edge_pulse edge_pulser(clk, done_i, done);
    always @ (posedge clk) begin
        if(enable) begin
            enabled <= 1;
        end
        else if(index >= WAVELENGTH) begin
            if(counter >= PACKET_WIDTH_OVERHEAD) begin
                done_i <= 1;
                counter <= 0;
                enabled <= 0;
            end
            else begin
                counter <= counter + 1;
                done_i <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if(enabled) begin
            signal_out <= signal;
            if(index < WAVELENGTH) begin
                index <= index + 1;
                next <= 0;
            end
            else begin
                index <= 0;
                next <= 1;
            end
        end
    end

endmodule