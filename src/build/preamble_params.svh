`ifndef preamble_params_h
`define preamble_params_h

localparam PREAMBLE_LENGTH = 4;
localparam PREAMBLE = 4'b1010;
localparam PREAMBLE_THRESHOLD = 79;
localparam START_CHAR = 8'b01000000; //Start of text in ASCII
localparam END_CHAR = 8'b00100000; //End of transmission in ASCII

`endif