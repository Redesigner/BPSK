`include "../built-src/parameters.svh"
`timescale 1ns/10ps


module signal_modulator
    (
        input clk,                              //clock speed should be signal_freq * DATA_WIDTH / 2
        input wire data_stream,                 //current bit to modulate
        input wire enable,                      //generates signal on high, silent on low
        output reg [DATA_WIDTH-1:0] signal_out,//parallel signal to be sent to DAC
        output reg next                        //flips when complete signal has been sent
    );

    reg [$clog2(SINE_RESOLUTION):0] index = 0;
    wire [$clog2(SINE_RESOLUTION):0] phase;
    wire [DATA_WIDTH-1:0] signal;

    wave_table_sine sine_table(clk, phase, signal);
    
    always @ (posedge clk) begin
        signal_out <= signal;
        if (enable == 1) begin
            if (index >= WAVELENGTH) begin
                index <= 0;
                next <= 1;
            end
            else begin
                index <= index + 1;
                next <= 0;
            end
        end
    end
    assign phase = data_stream ?
        ((index + SHIFT > WAVELENGTH) ?
            index + SHIFT - WAVELENGTH:
            index + SHIFT):
        index;

endmodule