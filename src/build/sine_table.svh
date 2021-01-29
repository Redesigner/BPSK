`ifndef sine_table_h
`define sine_table_h
localparam [10 - 1 : 0] SINE_TABLE [10 - 1 : 0] =
{511, 811, 996, 996, 811, 511, 210, 25, 25, 210};
localparam [10 - 1 : 0] SHIFTED_SINE_TABLE [10 - 1 : 0] =
{511, 210, 25, 25, 210, 510, 811, 996, 996, 811};
`endif