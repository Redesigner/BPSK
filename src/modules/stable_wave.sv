`include "../build/core_params.svh"

module stable_wave
    (
        input wire sysclk,
        output wire [DATA_WIDTH - 1 : 0]wave,
        output wire clk_out
    );
    
    wire [DATA_WIDTH - 1 : 0]wave;
    modulator_v2 #(32) modulator (
        .clk(clk_carrier),
        .reset(reset_clk),
        .data('b0),
        .signal(wave)
    );
    clock_divider #(WAVELENGTH) clk_divider
    (
    .I(clk_carrier),
    .O(reset_clk)
    );
    
    MMCM clock
   (
    // Clock out ports
    .clk_carrier(clk_carrier),     // output clk_carrier
    // Status and control signals
   // Clock in ports
    .clk_in_sys(sysclk));
    assign clk_out = clk_carrier;
endmodule