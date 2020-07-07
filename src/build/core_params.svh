`ifndef core_params_h
`define core_params_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 10;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 10;
localparam SHIFT = 5;
localparam UART_WIDTH = 11;

localparam DEMOD_THRESHOLD = 1000;
localparam PACKET_WIDTH = 34; //PACKET SIZE (IN BYTES)
localparam PACKET_WIDTH_BITS = PACKET_WIDTH * 8;

`endif