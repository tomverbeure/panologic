define_global_attribute         syn_global_buffers {2}
define_attribute          {v:work.ddr_ctrl_parameters_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_addr_gen_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_cal_ctl} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_cal_top} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_clk_dcm} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_cmd_fsm_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_cmp_data_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_controller_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_controller_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_gen_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_path_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_path_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_read_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_read_controller_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_data_write_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_dqs_delay_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_fifo_0_wr_en_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_fifo_1_wr_en_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_infrastructure} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_infrastructure_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_infrastructure_top} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_main_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_ram8d_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_rd_gray_cntr} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_s3_dm_iob} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_s3_dq_iob} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_s3_dqs_iob} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_tap_dly} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_test_bench_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_top_0} syn_hier {hard}
define_attribute          {v:work.ddr_ctrl_wr_gray_cntr} syn_hier {hard}

#clock constraints
 define_clock -disable   -name {clk_dcm0}  -period 6.024 -clockgroup default_clkgroup_2

 define_clock            -name {infrastructure_top0.lvds_clk_input}  -period 6.024 -clockgroup default_clkgroup_3

 define_clock -disable   -name {DCM_INST1}  -period 6.024 -clockgroup default_clkgroup_4


