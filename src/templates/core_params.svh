`ifndef core_params_h
`define core_params_h
localparam DATA_WIDTH = $DATA_WIDTH;
localparam SINE_RESOLUTION = $SINE_TABLE_SIZE;
localparam AMPLITUDE = $AMPLITUDE;
localparam WAVELENGTH = $WAVELENGTH;
localparam SHIFT = $SHIFT;
localparam UART_WIDTH = 11;

localparam DEMOD_THRESHOLD = 1000;
localparam PACKET_WIDTH = 10; //PACKET SIZE (IN BYTES)
localparam PACKET_WIDTH_BITS = PACKET_WIDTH * 8;

`endif