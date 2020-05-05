module signal_modulator
    (
        input clk,                              //clock speed should be signal_freq * DATA_WIDTH / 2
        input data_stream,                      //current bit to modulate
        input enable,                           //generates signal on high, silent on low
        output wire [DATA_WIDTH-1:0] signal_out, //parallel signal to be sent to DAC
        output wire next                         //flips when complete signal has been sent
    );

    reg [31:0] index = 0;
    reg [31:0] phase = 0;
    reg [DATA_WIDTH-1:0] signal;

    wave_table_sine sine_table(phase, signal);
    
    always @ (posedge clk) begin
        if (enable == 1) begin
            if (index + 1 >= WAVELENGTH) begin
                phase <= (((SHIFT * data_stream)) % WAVELENGTH);
                index <= 0;
            end
            else begin
                phase <= ((index + 1 + (SHIFT * data_stream)) % WAVELENGTH);
                index <= index + 1;
            end
        end
    end
    assign signal_out = signal;
    assign next = index + 1 == WAVELENGTH;

endmodule