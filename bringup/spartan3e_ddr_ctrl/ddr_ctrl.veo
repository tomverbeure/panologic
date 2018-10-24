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
// Copyright 2007, 2008 Xilinx, Inc.
// All rights reserved.
//
// This disclaimer and copyright notice must be retained as part
// of this file at all times.
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor             : Xilinx
// \   \   \/    Version            : 3.6.1
//  \   \        Application        : MIG
//  /   /        Filename           : ddr_ctrl.veo
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:26:31 $
// \   \  /  \   Date Created       : Wed May 2 2007
//  \___\/\___\
//
// Purpose     : Template file containing code that can be used as a model
//               for instantiating a CORE Generator module in a HDL design.
// Revision History:
//*****************************************************************************

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ddr_ctrl u_ddr_ctrl 
 ( 

      .cntrl0_ddr_dq             (cntrl0_ddr_dq),
      .cntrl0_ddr_a              (cntrl0_ddr_a),
      .cntrl0_ddr_ba             (cntrl0_ddr_ba),
      .cntrl0_ddr_cke            (cntrl0_ddr_cke),
      .cntrl0_ddr_cs_n           (cntrl0_ddr_cs_n),
      .cntrl0_ddr_ras_n          (cntrl0_ddr_ras_n),
      .cntrl0_ddr_cas_n          (cntrl0_ddr_cas_n),
      .cntrl0_ddr_we_n           (cntrl0_ddr_we_n),
      .cntrl0_ddr_dm             (cntrl0_ddr_dm),
      .cntrl0_rst_dqs_div_in     (cntrl0_rst_dqs_div_in),
      .cntrl0_rst_dqs_div_out    (cntrl0_rst_dqs_div_out),
      .sys_clkb                  (sys_clkb),
      .sys_clk                   (sys_clk),
      .reset_in_n                (reset_in_n),
      .cntrl0_burst_done         (cntrl0_burst_done),
      .cntrl0_init_val           (cntrl0_init_val),
      .cntrl0_ar_done            (cntrl0_ar_done),
      .cntrl0_user_data_valid    (cntrl0_user_data_valid),
      .cntrl0_auto_ref_req       (cntrl0_auto_ref_req),
      .cntrl0_user_command_register  (cntrl0_user_command_register),
      .cntrl0_user_cmd_ack       (cntrl0_user_cmd_ack),
      .cntrl0_clk_tb             (cntrl0_clk_tb),
      .cntrl0_clk90_tb           (cntrl0_clk90_tb),
      .cntrl0_sys_rst_tb         (cntrl0_sys_rst_tb),
      .cntrl0_sys_rst90_tb       (cntrl0_sys_rst90_tb),
      .cntrl0_sys_rst180_tb      (cntrl0_sys_rst180_tb),
      .cntrl0_user_data_mask     (cntrl0_user_data_mask),
      .cntrl0_user_output_data   (cntrl0_user_output_data),
      .cntrl0_user_input_data    (cntrl0_user_input_data),
      .cntrl0_user_input_address  (cntrl0_user_input_address),
      .cntrl0_ddr_dqs            (cntrl0_ddr_dqs),
      .cntrl0_ddr_ck             (cntrl0_ddr_ck),
      .cntrl0_ddr_ck_n           (cntrl0_ddr_ck_n)
);

// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file ddr_ctrl.v when simulating
// the core, ddr_ctrl. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

