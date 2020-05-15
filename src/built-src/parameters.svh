//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 20;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 20;
localparam SHIFT = 10;
localparam UART_WIDTH = 11;

//SEPARATE INTO DIFFERENT PARAM FILE?
localparam NETWORK_WIDTH = 11;
localparam INDEX_WIDTH = 5;

localparam THRESHOLD = AMPLITUDE * 5 / 4;
parameter PACKET_WIDTH = 16; //PACKET SIZE (IN BYTES)
`endif