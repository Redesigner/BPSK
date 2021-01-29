# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Steph/Documents/Dev/Verilog/BPSK/xpr/testbench/testbench.cache/wt [current_project]
set_property parent.project_path C:/Users/Steph/Documents/Dev/Verilog/BPSK/xpr/testbench/testbench.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:cmod_a7-35t:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/Steph/Documents/Dev/Verilog/BPSK/project_files/testbench/testbench.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog {
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/core_params.svh
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/network_params.svh
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/preamble_params.svh
}
set_property file_type "Verilog Header" [get_files C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/core_params.svh]
set_property file_type "Verilog Header" [get_files C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/network_params.svh]
set_property file_type "Verilog Header" [get_files C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/build/preamble_params.svh]
read_verilog -library xil_defaultlib -sv {
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/modules/testbench.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/transmitter/signal_modulator.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/transmitter/sorter.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/transmitter/uart_fast_read.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/reciever/signal_demodulator.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/reciever/peak_detection_v2.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/reciever/uart_fast_write.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/modules/transmitter.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/modules/reciever.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/modules/test_data.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/reciever/reciever_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/transmitter/byte_packet_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/CDC_sync.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/clock_divider.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/PISO_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/ring_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/edge_pulse.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/PIPO_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/sorting/unsort.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/sorting/register/comparison_merge_r.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/sorting/register/comparison_base_r.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/FIFO_buffer.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/reciever/cross_correlation_binary.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/core/tree_adder.sv
  C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/transmitter/modulator_v2.sv
}
read_ip -quiet C:/Users/Steph/Documents/Dev/Verilog/BPSK/project_files/testbench/testbench.srcs/sources_1/ip/MMCM/MMCM.xci
set_property used_in_implementation false [get_files -all c:/Users/Steph/Documents/Dev/Verilog/BPSK/project_files/testbench/testbench.srcs/sources_1/ip/MMCM/MMCM_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Steph/Documents/Dev/Verilog/BPSK/project_files/testbench/testbench.srcs/sources_1/ip/MMCM/MMCM.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Steph/Documents/Dev/Verilog/BPSK/project_files/testbench/testbench.srcs/sources_1/ip/MMCM/MMCM_ooc.xdc]

read_ip -quiet C:/Users/Steph/Documents/Dev/Verilog/BPSK/src/ip/demod_mult/demod_mult.xci
set_property used_in_implementation false [get_files -all c:/Users/Steph/Documents/Dev/Verilog/BPSK/src/ip/demod_mult/demod_mult_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Steph/Documents/Dev/Verilog/BPSK/xdc/cmod35t testbench.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Steph/Documents/Dev/Verilog/BPSK/xdc/cmod35t testbench.xdc}}]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top testbench -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef testbench.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file testbench_utilization_synth.rpt -pb testbench_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
