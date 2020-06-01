`include "../built-src/parameters.svh"
`timescale 1ns/10ps


module signal_modulator
    (
        input clk,                              //clock speed should be signal_freq * DATA_WIDTH / 2
        input wire data_stream,                 //current bit to modulate
        input wire enable,                      //generates signal on high, silent on low
        output reg [DATA_WIDTH-1:0] signal_out = '0,//parallel signal to be sent to DAC
        output reg next = 0,                       //flips when complete signal has been sent
        output reg done = 0
    );

    reg [$clog2(SINE_RESOLUTION):0] index = 0;
    reg [$clog2(SINE_RESOLUTION):0] phase = 0;
    reg [$clog2(PACKET_WIDTH_OVERHEAD):0] counter = 0;
    reg enabled = 0;
    wire [DATA_WIDTH-1:0] signal;

    wave_table_sine sine_table(clk, phase, signal);
    
    always @ (posedge clk) begin
        signal_out <= signal;
        if(enable) begin
            enabled <= 1;
        end
        if(counter >= PACKET_WIDTH_OVERHEAD) begin
            done <= 1;
            counter <= 0;
            enabled <= 0;
        end
        //stay on until out packet is sent
        else begin
            done <= 0;
            if (enabled) begin
                if (index >= WAVELENGTH) begin
                    index <= 0;
                    next <= 1;
                    counter <= counter + 1;
                end
                else begin
                    index <= index + 1;
                    next <= 0;
                end

                if(data_stream) begin
                    if(index + SHIFT > WAVELENGTH) begin
                        phase <= index + SHIFT - WAVELENGTH;
                    end
                    else begin
                        phase <= index + SHIFT;
                    end
                end
                else begin
                    phase <= index;
                end
            end
        end
    end
    /*
    assign phase = data_stream ?
        ((index + SHIFT > WAVELENGTH) ?
            index + SHIFT - WAVELENGTH:
            index + SHIFT):
        index;
    */
endmodule