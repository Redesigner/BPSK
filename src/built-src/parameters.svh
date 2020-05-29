//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 27;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 27;
localparam SHIFT = 13;
localparam UART_WIDTH = 11;

//SEPARATE INTO DIFFERENT PARAM FILE?
localparam NETWORK_WIDTH = 8;
localparam INDEX_WIDTH = 4;

localparam THRESHOLD = AMPLITUDE * 10 / 4;
parameter PACKET_WIDTH = 8; //PACKET SIZE (IN BYTES)
localparam PREAMBLE_LENGTH = 8;
localparam PREAMBLE = 8'b11111111;
`endif