module signal_modulator
    (
        input clk,                          //clock speed should be signal_freq * DATA_WIDTH / 2
        input data_stream,                  //current bit to modulate
        input enable,                       //generates signal on high, silent on low
        output reg [DATA_WIDTH-1:0] signal, //parallel signal to be sent to DAC
        output reg next = 0                 //flips when complete signal has been sent
    );

    reg [DATA_WIDTH-1:0] index = 0;
    reg [DATA_WIDTH-1:0] phase;

    wave_table_sine sine_table(phase, signal);
    
    always @ (posedge clk, posedge enable) begin
        if (enable == 1) begin
            if (index + 1 >= WAVELENGTH) begin
                index <= 0;
                next <= 1;
            end
            else begin
                index <= index + 1;
                next <= 0;
            end
            phase <= ((index + (SHIFT * data_stream)) % WAVELENGTH);
        end
    end
endmodule