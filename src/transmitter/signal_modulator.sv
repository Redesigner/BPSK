`include "../built-src/parameters.svh"


module signal_modulator #(DATA_SIZE = 16)
    (
        input clk,                              //clock speed should be signal_freq * DATA_WIDTH / 2
        input wire [DATA_SIZE - 1:0]
        data,                                   //current bit to modulate
        input wire enable,                      //generates signal on high, silent on low
        (*IOB="TRUE"*) output reg [DATA_WIDTH-1:0] signal_out = '0,//parallel signal to be sent to DAC
        //output reg next = 0,                       //flips when complete signal has been sent
        output wire done
    );

    reg next = 0;
    reg [$clog2(WAVELENGTH):0] index = 0;
    reg [$clog2(PACKET_WIDTH_OVERHEAD):0] counter = 0;
    wire [$clog2(SINE_RESOLUTION):0] phase;
    reg enabled = 0;
    reg done_i = 0;
    wire [DATA_WIDTH-1:0] signal;

    PISO_buffer #(DATA_SIZE) modulator_stream 
    (
        //IN
        .clk(clk),
        .active(next), .reset(enable),
        .parallel(data),
        //OUT
        .serial_signal(serial)
    );

    (* keep_hierarchy = "yes" *)
    wave_table_sine sine_table(clk, phase, signal);
    (* keep_hierarchy = "yes" *)
    phase_table phase_shifter(clk, serial, index, phase);
    edge_pulse edge_pulser(clk, done_i, done);
    edge_pulse edge_pulser2(clk, enable, enable_o);
    always @ (posedge clk) begin
        if(enable_o) begin
            enabled <= 1;
        end
        else if(index >= WAVELENGTH - 1) begin
            if(counter > DATA_SIZE - 1) begin
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
            if(index < WAVELENGTH - 2) begin
                index <= index + 1;
                next <= 0;
            end
            //Queue up the next bit
            else if (index == WAVELENGTH - 2) begin
                index <= index + 1;
                next <= 1;
            end
            else begin
                index <= 0;
                next <= 0;
            end
        end
    end

endmodule