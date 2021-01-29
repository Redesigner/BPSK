`ifndef network_params_h
`define network_params_h

localparam NETWORK_SLICES = 8;

localparam INDEX_WIDTH = $clog2(NETWORK_SLICES);
localparam SORTING_WIDTH = NETWORK_SLICES * INDEX_WIDTH;
localparam NETWORK_WIDTH = (PACKET_WIDTH - 2) / NETWORK_SLICES * 8;


`endif