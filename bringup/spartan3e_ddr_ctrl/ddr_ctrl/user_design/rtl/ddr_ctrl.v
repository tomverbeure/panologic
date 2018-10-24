//*****************************************************************************
// DISCLAIMER OF LIABILITY
//
// This file contains proprietary and confidential information of
// Xilinx, Inc. ("Xilinx"), that is distributed under a license
// from Xilinx, and may be used, copied and/or disclosed only
// pursuant to the terms of a valid license agreement with Xilinx.
//
// XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
// ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
// LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
// MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
// does not warrant that functions included in the Materials will
// meet the requirements of Licensee, or that the operation of the
// Materials will be uninterrupted or error-free, or that defects
// in the Materials will be corrected. Furthermore, Xilinx does
// not warrant or make any representations regarding use, or the
// results of the use, of the Materials in terms of correctness,
// accuracy, reliability or otherwise.
//
// Xilinx products are not designed or intended to be fail-safe,
// or for use in any application requiring fail-safe performance,
// such as life-support or safety devices or systems, Class III
// medical devices, nuclear facilities, applications related to
// the deployment of airbags, or any other applications that could
// lead to death, personal injury or severe property or
// environmental damage (individually and collectively, "critical
// applications"). Customer assumes the sole risk and liability
// of any use of Xilinx products in critical applications,
// subject only to applicable laws and regulations governing
// limitations on product liability.
//
// Copyright 2005, 2006, 2007, 2008 Xilinx, Inc.
// All rights reserved.
//
// This disclaimer and copyright notice must be retained as part
// of this file at all times.
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor             : Xilinx
// \   \   \/    Version            : 3.6.1
//  \   \        Application	    : MIG
//  /   /        Filename           : ddr_ctrl.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP
// Design Name  : DDR SDRAM
// Purpose      : This module has the instantiations infrastructure_top and
//                main modules.
//*****************************************************************************

`timescale 1ns/100ps

(* X_CORE_INFO = "mig_v3_61_ddr_sp3, Coregen 12.4" ,
   CORE_GENERATION_INFO = "ddr_sp3,mig_v3_61,{component_name=ddr_sp3, data_width=16, memory_width=8, clk_width=1, bank_address=2, row_address=14, column_address=10, no_of_cs=1, cke_width=1, registered=0, data_mask=1, mask_enable=1, load_mode_register=14'b00000000110001, ext_load_mode_register=14'b00000000000000, language=Verilog, synthesis_tool=ISE, interface_type=DDR_SDRAM, no_of_controllers=1}" *)
module ddr_ctrl
  (
   inout  [15:0]   cntrl0_ddr_dq,
   output [13:0]   cntrl0_ddr_a,
   output [1:0]    cntrl0_ddr_ba,
   output          cntrl0_ddr_cke,
   output          cntrl0_ddr_cs_n,
   output          cntrl0_ddr_ras_n,
   output          cntrl0_ddr_cas_n,
   output          cntrl0_ddr_we_n,
   output [1:0]    cntrl0_ddr_dm,
   input           cntrl0_rst_dqs_div_in,
   output          cntrl0_rst_dqs_div_out,
   input           sys_clkb,
   input           sys_clk,
   input           reset_in_n,
   input           cntrl0_burst_done,
   output          cntrl0_init_val,
   output          cntrl0_ar_done,
   output          cntrl0_user_data_valid,
   output          cntrl0_auto_ref_req,
   input  [2:0]    cntrl0_user_command_register,
   output          cntrl0_user_cmd_ack,
   output          cntrl0_clk_tb,
   output          cntrl0_clk90_tb,
   output          cntrl0_sys_rst_tb,
   output          cntrl0_sys_rst90_tb,
   output          cntrl0_sys_rst180_tb,
   input  [3:0]    cntrl0_user_data_mask,
   output [31:0]   cntrl0_user_output_data,
   input  [31:0]   cntrl0_user_input_data,
   input  [25:0]   cntrl0_user_input_address,
   inout  [1:0]    cntrl0_ddr_dqs,
   output [0:0]    cntrl0_ddr_ck,
   output [0:0]    cntrl0_ddr_ck_n
   );

   wire       wait_200us;
   wire       clk_0;
   wire       clk90_0;
   wire       sys_rst;
   wire       sys_rst90;
   wire       sys_rst180;
   wire [4:0] delay_sel_val;
// debug signals declarations
   wire [4:0] dbg_delay_sel;
   wire [4:0] dbg_phase_cnt;
   wire [5:0] dbg_cnt;
   wire       dbg_trans_onedtct;
   wire       dbg_trans_twodtct;
   wire       dbg_enb_trans_two_dtct;
   wire       dbg_rst_calib;
//chipscope signals
   wire [19:0] dbg_data;
   wire [3:0]  dbg_trig;
   wire [35:0] control0;
   wire [35:0] control1;
   wire [11:0] vio_out;
   wire [4:0]  vio_out_dqs;
   wire        vio_out_dqs_en;
   wire [4:0]  vio_out_rst_dqs_div;
   wire        vio_out_rst_dqs_div_en;
  wire sys_clk_in;

  assign sys_clk_in = 1'b0;

ddr_ctrl_top_0 top_00
 (
     .ddr_dq                    (cntrl0_ddr_dq),
     .ddr_a                     (cntrl0_ddr_a),
     .ddr_ba                    (cntrl0_ddr_ba),
     .ddr_cke                   (cntrl0_ddr_cke),
     .ddr_cs_n                  (cntrl0_ddr_cs_n),
     .ddr_ras_n                 (cntrl0_ddr_ras_n),
     .ddr_cas_n                 (cntrl0_ddr_cas_n),
     .ddr_we_n                  (cntrl0_ddr_we_n),
     .ddr_dm                    (cntrl0_ddr_dm),
     .rst_dqs_div_in            (cntrl0_rst_dqs_div_in),
     .rst_dqs_div_out           (cntrl0_rst_dqs_div_out),
     .burst_done                (cntrl0_burst_done),
     .init_val                  (cntrl0_init_val),
     .ar_done                   (cntrl0_ar_done),
     .user_data_valid           (cntrl0_user_data_valid),
     .auto_ref_req              (cntrl0_auto_ref_req),
     .user_command_register     (cntrl0_user_command_register),
     .user_cmd_ack              (cntrl0_user_cmd_ack),
     .clk_tb                    (cntrl0_clk_tb),
     .clk90_tb                  (cntrl0_clk90_tb),
     .sys_rst_tb                (cntrl0_sys_rst_tb),
     .sys_rst90_tb              (cntrl0_sys_rst90_tb),
     .sys_rst180_tb             (cntrl0_sys_rst180_tb),
     .user_data_mask            (cntrl0_user_data_mask),
     .user_output_data          (cntrl0_user_output_data),
     .user_input_data           (cntrl0_user_input_data),
     .user_input_address        (cntrl0_user_input_address),
     .ddr_dqs                   (cntrl0_ddr_dqs),
     .ddr_ck                    (cntrl0_ddr_ck),
     .ddr_ck_n                  (cntrl0_ddr_ck_n),
   .wait_200us         (wait_200us),
   .clk_int           (clk_0),
   .clk90_int         (clk90_0),
   .sys_rst_val       (sys_rst),
   .sys_rst90_val     (sys_rst90),
   .sys_rst180_val    (sys_rst180),
   .delay_sel_val     (delay_sel_val),

    //Debug signals

     .dbg_delay_sel            (dbg_delay_sel),
     .dbg_rst_calib            (dbg_rst_calib),
     .vio_out_dqs              (vio_out_dqs),
     .vio_out_dqs_en           (vio_out_dqs_en),
     .vio_out_rst_dqs_div      (vio_out_rst_dqs_div),
     .vio_out_rst_dqs_div_en   (vio_out_rst_dqs_div_en)
  );
ddr_ctrl_infrastructure_top infrastructure_top0
  (
     .sys_clk_in                (sys_clk_in),
     .sys_clkb                  (sys_clkb),
     .sys_clk                   (sys_clk),
     .reset_in_n                (reset_in_n),
   .wait_200us_rout        (wait_200us),
   .delay_sel_val1_val     (delay_sel_val),
   .sys_rst_val            (sys_rst),
   .sys_rst90_val          (sys_rst90),
   .clk_int_val            (clk_0),
   .clk90_int_val          (clk90_0),
   .sys_rst180_val         (sys_rst180),
   .dbg_phase_cnt          (dbg_phase_cnt),
   .dbg_cnt                (dbg_cnt),
   .dbg_trans_onedtct      (dbg_trans_onedtct),
   .dbg_trans_twodtct      (dbg_trans_twodtct),
   .dbg_enb_trans_two_dtct (dbg_enb_trans_two_dtct)
   );


endmodule

