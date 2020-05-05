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
localparam NETWORK_WIDTH = 11;
localparam INDEX_WIDTH = 3;

localparam THRESHOLD = AMPLITUDE * 5 / 4;
parameter PACKET_WIDTH = 16; //PACKET SIZE (IN BYTES)
`endif