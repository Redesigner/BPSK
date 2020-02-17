/*parameter DATA_WIDTH = 12;
parameter SINE_RESOLUTION = 32;
parameter WAVELENGTH = 64;
parameter SHIFT = 32;*/
//because the sin table is represented in integers,
//the wavelength is always twice the SINE_RESOLUTION

`ifndef parameters_h
`define parameters_h
localparam DATA_WIDTH = $DATA_WIDTH;
localparam SINE_RESOLUTION = $SINE_TABLE_SIZE;
localparam WAVELENGTH = $WAVELENGTH;
localparam SHIFT = $SHIFT;

parameter PACKET_SIZE = 184;
`endif