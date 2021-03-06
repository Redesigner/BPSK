// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Oct 28 20:07:02 2020
// Host        : DESKTOP-SN1TKTU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/ip/demod_mult/demod_mult_stub.v
// Design      : demod_mult
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2019.1" *)
module demod_mult(CLK, A, B, C, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[9:0],B[9:0],C[31:0],P[31:0]" */;
  input CLK;
  input [9:0]A;
  input [9:0]B;
  input [31:0]C;
  output [31:0]P;
endmodule
