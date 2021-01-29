`ifndef sine_table_h
`define sine_table_h
localparam [$DATA_WIDTH - 1 : 0] SINE_TABLE [$SINE_TABLE_SIZE - 1 : 0] =
{$sine_table};
localparam [$DATA_WIDTH - 1 : 0] SHIFTED_SINE_TABLE [$SINE_TABLE_SIZE - 1 : 0] =
{$shifted_sine_table};
`endif