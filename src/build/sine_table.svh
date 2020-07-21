`ifndef sine_table_h
`define sine_table_h
localparam [12 - 1 : 0] SINE_TABLE [10 - 1 : 0] =
{2047, 3250, 3993, 3993, 3250, 2047, 843, 100, 100, 843};
localparam [12 - 1 : 0] SHIFTED_SINE_TABLE [10 - 1 : 0] =
{2047, 843, 100, 100, 843, 2046, 3250, 3993, 3993, 3250};
`endif