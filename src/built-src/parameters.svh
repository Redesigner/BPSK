//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = 12;
localparam SINE_RESOLUTION = 12;
localparam AMPLITUDE = 2047;
localparam WAVELENGTH = 12;
localparam SHIFT = 6;
localparam UART_WIDTH = 11;
localparam NETWORK_WIDTH = 11;
localparam INDEX_WIDTH = 3;

localparam THRESHOLD = AMPLITUDE * 5 / 4;
parameter PACKET_WIDTH = 8; //PACKET SIZE (IN BYTES)
`endif