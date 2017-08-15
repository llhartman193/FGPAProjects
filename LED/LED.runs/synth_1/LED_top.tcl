# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/VivadoProjects/LED/LED.cache/wt [current_project]
set_property parent.project_path C:/VivadoProjects/LED/LED.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib -sv C:/VivadoProjects/LED/src/rtl/LED_top.sv
read_xdc C:/VivadoProjects/LED/constraints/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/VivadoProjects/LED/constraints/Basys3_Master.xdc]

synth_design -top LED_top -part xc7a35tcpg236-1
write_checkpoint -noxdef LED_top.dcp
catch { report_utilization -file LED_top_utilization_synth.rpt -pb LED_top_utilization_synth.pb }