//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 10;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 10;
localparam SHIFT = 5;
localparam UART_WIDTH = 11;

//SEPARATE INTO DIFFERENT PARAM FILE?
localparam NETWORK_WIDTH = 8;
localparam INDEX_WIDTH = 3;
localparam DEMOD_THRESHOLD = 1000;

localparam signed THRESHOLD = AMPLITUDE * 10 / 4;
parameter PACKET_WIDTH = 8; //PACKET SIZE (IN BYTES)
localparam PREAMBLE_LENGTH = 4;
localparam PREAMBLE = 4'b1010;
parameter PACKET_WIDTH_OVERHEAD = (PACKET_WIDTH * (INDEX_WIDTH + 8)) + PREAMBLE_LENGTH;

localparam PREAMBLE_THRESHOLD = 79;
`endif