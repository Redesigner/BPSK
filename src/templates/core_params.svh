`ifndef core_params_h
`define core_params_h
localparam SIGNAL_WIDTH = $DATA_WIDTH;
localparam SINE_RESOLUTION = $SINE_TABLE_SIZE;
localparam AMPLITUDE = $AMPLITUDE;
localparam WAVELENGTH = $WAVELENGTH;
localparam SHIFT = $SHIFT;

//1 start, 1 end, 1 parity, 8 payload bits
localparam UART_WIDTH = 11;

localparam DEMOD_THRESHOLD = 1000;

//Payload
localparam PAYLOAD_BYTES = 8;
localparam PAYLOAD_WIDTH = PAYLOAD_BYTES * 8;

//Preamble
localparam PREAMBLE_WIDTH = $preamble_length;
localparam PREAMBLE_BYTES = 2;
localparam PREAMBLE = $preamble;
localparam PREAMBLE_THRESHOLD = $threshold;

//Frame
localparam FRAME_WIDTH = 24;
localparam FRAME_BYTES = 3;
localparam FRAME_HEADSTART =    8'b00000001;
localparam FRAME_START =        8'b00000010;
localparam FRAME_END =          8'b00000100;

localparam SORTING_SLICES = 8;

//The smallest register size for storing index values is a log2 value
localparam INDEX_WIDTH = $$clog2(SORTING_SLICES);
localparam SLICE_WIDTH = (PAYLOAD_WIDTH) / (SORTING_SLICES);
localparam REFERENCE_WIDTH = SORTING_SLICES * INDEX_WIDTH;
localparam REFERENCE_BYTES = REFERENCE_WIDTH / 8;

//Packet
localparam PACKET_BYTES = PREAMBLE_BYTES + PAYLOAD_BYTES + REFERENCE_BYTES + FRAME_BYTES;
localparam PACKET_WIDTH = PREAMBLE_WIDTH + PAYLOAD_WIDTH + REFERENCE_WIDTH + FRAME_WIDTH;

typedef bit [SIGNAL_WIDTH - 1 : 0]  signal;
typedef bit [PACKET_WIDTH - 1 : 0]  packet;
typedef bit [UART_WIDTH  -  1 : 0]  uart;

`endif
