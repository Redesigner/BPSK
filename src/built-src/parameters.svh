/*parameter DATA_WIDTH = 12;
parameter SINE_RESOLUTION = 32;
parameter WAVELENGTH = 64;
parameter SHIFT = 32;*/
//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 6;
localparam WAVELENGTH = 12;
localparam SHIFT = 6;
localparam THRESHOLD = 1000;


parameter PACKET_SIZE = 192;
`endif