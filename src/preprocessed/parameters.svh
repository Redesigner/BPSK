//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = $DATA_WIDTH;
localparam SINE_RESOLUTION = $SINE_TABLE_SIZE;
localparam AMPLITUDE = $AMPLITUDE;
localparam WAVELENGTH = $WAVELENGTH;
localparam SHIFT = $SHIFT;
localparam UART_WIDTH = 11;

//SEPARATE INTO DIFFERENT PARAM FILE?
localparam NETWORK_WIDTH = 8;
localparam INDEX_WIDTH = 3;
localparam DEMOD_THRESHOLD = 1000;

localparam signed THRESHOLD = AMPLITUDE * 10 / 4;
parameter PACKET_WIDTH = 8; //PACKET SIZE (IN BYTES)
localparam PREAMBLE_LENGTH = $preamble_length;
localparam PREAMBLE = $preamble;
parameter PACKET_WIDTH_OVERHEAD = (PACKET_WIDTH * (INDEX_WIDTH + 8)) + PREAMBLE_LENGTH;

localparam PREAMBLE_THRESHOLD = $threshold;
`endif