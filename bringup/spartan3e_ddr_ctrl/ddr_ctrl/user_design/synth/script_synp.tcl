project -new 
add_file -verilog "../rtl/ddr_ctrl_parameters_0.v"
add_file -verilog "../rtl/ddr_ctrl.v"
add_file -verilog "../rtl/ddr_ctrl_cal_ctl.v"
add_file -verilog "../rtl/ddr_ctrl_cal_top.v"
add_file -verilog "../rtl/ddr_ctrl_clk_dcm.v"
add_file -verilog "../rtl/ddr_ctrl_controller_0.v"
add_file -verilog "../rtl/ddr_ctrl_controller_iobs_0.v"
add_file -verilog "../rtl/ddr_ctrl_data_path_0.v"
add_file -verilog "../rtl/ddr_ctrl_data_path_iobs_0.v"
add_file -verilog "../rtl/ddr_ctrl_data_read_0.v"
add_file -verilog "../rtl/ddr_ctrl_data_read_controller_0.v"
add_file -verilog "../rtl/ddr_ctrl_data_write_0.v"
add_file -verilog "../rtl/ddr_ctrl_dqs_delay_0.v"
add_file -verilog "../rtl/ddr_ctrl_fifo_0_wr_en_0.v"
add_file -verilog "../rtl/ddr_ctrl_fifo_1_wr_en_0.v"
add_file -verilog "../rtl/ddr_ctrl_infrastructure.v"
add_file -verilog "../rtl/ddr_ctrl_infrastructure_iobs_0.v"
add_file -verilog "../rtl/ddr_ctrl_infrastructure_top.v"
add_file -verilog "../rtl/ddr_ctrl_iobs_0.v"
add_file -verilog "../rtl/ddr_ctrl_ram8d_0.v"
add_file -verilog "../rtl/ddr_ctrl_rd_gray_cntr.v"
add_file -verilog "../rtl/ddr_ctrl_s3_dm_iob.v"
add_file -verilog "../rtl/ddr_ctrl_s3_dq_iob.v"
add_file -verilog "../rtl/ddr_ctrl_s3_dqs_iob.v"
add_file -verilog "../rtl/ddr_ctrl_tap_dly.v"
add_file -verilog "../rtl/ddr_ctrl_top_0.v"
add_file -verilog "../rtl/ddr_ctrl_wr_gray_cntr.v"
add_file -constraint "../synth/mem_interface_top_synp.sdc"
impl -add rev_1
set_option -technology spartan3e
set_option -part xc3s1600e
set_option -package fg320
set_option -speed_grade -5
set_option -default_enum_encoding default
set_option -symbolic_fsm_compiler 1
set_option -resource_sharing 0
set_option -use_fsm_explorer 0
set_option -top_module "ddr_ctrl"
set_option -frequency 166.003
set_option -fanout_limit 1000
set_option -disable_io_insertion 0
set_option -pipe 1
set_option -fixgatedclocks 0
set_option -retiming 0
set_option -modular 0
set_option -update_models_cp 0
set_option -verification_mode 0
set_option -write_verilog 0
set_option -write_vhdl 0
set_option -write_apr_constraint 0
project -result_file "../synth/rev_1/ddr_ctrl.edf"
set_option -vlog_std v2001
set_option -auto_constrain_io 0
impl -active "../synth/rev_1"
project -run hdl_info_gen 
project -run
project -save

