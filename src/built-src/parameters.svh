//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 10;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 130;
localparam SHIFT = 5;
localparam UART_WIDTH = 11;

//SEPARATE INTO DIFFERENT PARAM FILE?
localparam NETWORK_WIDTH = 8;
localparam INDEX_WIDTH = 3;

localparam THRESHOLD = AMPLITUDE * 10 / 4;
parameter PACKET_WIDTH = 8; //PACKET SIZE (IN BYTES)
localparam PREAMBLE_LENGTH = 8;
localparam PREAMBLE = 8'b00000000;
parameter PACKET_WIDTH_OVERHEAD = (PACKET_WIDTH * (INDEX_WIDTH + 8)) + PREAMBLE_LENGTH;

localparam PREAMBLE_THRESHOLD = 1029;
`endif