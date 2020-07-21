// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Jul 14 14:55:50 2020
// Host        : DESKTOP-SN1TKTU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub c:/Users/Steph/Documents/Dev/Verilog/BPSK/src/ip/MMCM/MMCM_stub.v
// Design      : MMCM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module MMCM(clk_carrier, clk_in_sys)
/* synthesis syn_black_box black_box_pad_pin="clk_carrier,clk_in_sys" */;
  output clk_carrier;
  input clk_in_sys;
endmodule
