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
//  /   /        Filename           : ddr_ctrl_test_bench_0.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP
// Design Name  : DDR SDRAM
// Purpose	: This module generate the commands, address and data associated
//                with a write and a read command. This module consists of 
//                addr_gen, data_gen, cmd_fsm and cmp_data modules. 
//*****************************************************************************

`timescale 1ns/100ps
`include "../rtl/ddr_ctrl_parameters_0.v"

module    ddr_ctrl_test_bench_0
  (
   input                               fpga_clk,
   input                               fpga_rst90,
   input                               fpga_rst180,
   input                               clk90,
   input                               init_done,
   input                               ar_done,
   input                               u_ack,
   input                               u_data_val,
   input [(2*`DATA_WIDTH)-1:0]         u_data_o,
   input                               auto_ref_req,
   output                              burst_done,
   output [((`ROW_ADDRESS
	     + `COLUMN_ADDRESS +
	     `BANK_ADDRESS)-1):0]      u_addr,
   output [2:0]                        u_cmd,
   output [(2*`DATA_WIDTH)-1:0]        u_data_i,
   output [((`DATA_MASK_WIDTH*2)-1):0] u_data_m,
   output                              led_error_output,
   output                              data_valid_out
  );

   reg 				     rst90_r;
   reg 				     data_ena_r;
   reg 				     data_ena_w;
   reg 				     u_dat_flag;
   reg [(2*`DATA_WIDTH)-1:0] 	     app_data_w1;
   reg [(2*`DATA_WIDTH)-1:0] 	     app_data_w2;
   reg [(2*`DATA_WIDTH)-1:0] 	     app_data_w3;
   reg [(2*`DATA_WIDTH)-1:0] 	     app_data_w4;
   reg [(`DATA_MASK_WIDTH*2)-1:0]    app_data_m_w1;
   reg [(`DATA_MASK_WIDTH*2)-1:0]    app_data_m_w2;
   reg [(`DATA_MASK_WIDTH*2)-1:0]    app_data_m_w3;
   reg [(`DATA_MASK_WIDTH*2)-1:0]    app_data_m_w4;
   reg 				     data_rst_r;
   
   wire 			     clk;
   wire 			     addr_inc;
   wire 			     addr_rst;
   wire 			     cmd_ack;
   wire 			     cnt_roll;
   wire 			     data_valid;
   wire 			     data_rst_w;
   wire 			     r_w;
   wire [(2*`DATA_WIDTH)-1:0] 	     app_data_w0;
   wire [((`DATA_MASK_WIDTH*2)-1):0] app_data_m_w0;
   wire [(2*`DATA_WIDTH)-1:0] 	     cmp_data_r;
   wire [((`DATA_MASK_WIDTH*2)-1):0] cmp_data_m_r;
   wire [((`ROW_ADDRESS + 
	   `COLUMN_ADDRESS +
	   `BANK_ADDRESS)-1):0]      addr_out;
   wire 			     u_dat_fl;
   wire 			     data_rst_r1;

///////////////////////////////////////////////////////////////////////////////
// Current test bench generates consecutive five write bursts followed by five 
// read burst commands. For every consecutive of five write/read commands, 
// controller issues active command followed by five write/read commands 
// and then a precharge command to the memory. For all five burst commands
// it takes maximum of 20 clock cycles. So within 20 clocks,test bench will 
// issue burst_done signal to stop write of read commands to the controller.
// After every precharge command controller s/m will go to idle state and looks 
// for auto_ref_req. When auto_ref_req is asserted controller will issue an auto 
// refresh command to the memory if it is in idle state. Worst case the controller 
// will take 20 clocks from burst_done to auto refresh command to the memory. 
// So total number of clocks from auto_ref_req to auto refresh command to memmory 
// is 40.The test bench is not required to use the auto_ref_req and ar_done signals 
// inorder to terminate the read or write transactions since it takes maximum of 20 
// clock cycles for any transaction.
//
// Example:
// At 77Mhz the auto_ref_req will be generated for every 7.292us and for 
// 166Mhz it will be generated for every 7.572us which will take care of 
// 40 clocks as shown in the below expression
//
// Average periodic refresh = 7.8125us
// MAX_REF_CNT = (7812.5ns - 40*clk_period)/clk_period
// At 77Mhz(13ns) MAX_REF_CNT = (7812.5ns - 40*13)/13 = 7292.5/13 = 560
// At 166Mhz(6ns) MAX_REF_CNT = (7812.5ns - 40*6)/6   = 7572.5/6  = 1262

// User need to use the auto_ref_req and ar_done input signals in their 
// application in order to terminate the ongoing transaction by asserting 
// a burst_done signal, when the nunber of clocks is more then 20 between 
// auto_ref_req and burst_done signal. The ar_done signal is asserted for 
// one clock period by the controller on completion of auto refresh 
// command(i.e after tRFC time). User can issue normal read/write commands 
// to the controller any time after ar_done is asserted.
///////////////////////////////////////////////////////////////////////////////


//  Test_bench uses two clock phases clk180 and clk90. User write 
//  data is generated with clk90 phase, for memory write command 
//  data and strobe are center aligned. Write data to the memory 
//  is clk90 phase w.r.t strobe. So user write data is generated 
//  with clk90 phase.Address and commands are generated w.r.t 
//  clk180. To meet the setup/hold time for memory, memory clk is 
//  clk0 and all the commands and address are generated with 
//  clk180 phase.


// Output : COMMAND REGISTER FORMAT
//          000  - NOP
//          010  - initialize_memory
//          100  - Write Request
//          110  - Read request

// Output : Address format
//   row address  = address((`ROW_ADDRESS + `COLUMN_ADDRESS + `BANK_ADDRESS) -1 :
//                                      (`COLUMN_ADDRESS + `BANK_ADDRESS))
//   column address = address((`COLUMN_ADDRESS + `BANK_ADDRESS)-1 : `BANK_ADDRESS)
//   Bank addrs   = address(`BANK_ADDRESS - 1 : 0)

   assign clk        = fpga_clk;
   assign cmd_ack    = u_ack;
   assign data_valid = u_data_val;
   assign u_addr     = addr_out;
         assign                         u_data_i       = app_data_w0;
   assign                         u_data_m       = app_data_m_w0;


   always @ (posedge clk90) begin
      rst90_r <= fpga_rst90;
   end
   
   always @ (posedge clk90) begin
      if (rst90_r == 1'b1) begin
         app_data_w1 <= 'b0;
         app_data_w2 <= 'b0;
         app_data_w3 <= 'b0;
         app_data_w4 <= 'b0;
         app_data_m_w1 <= 'b0;
         app_data_m_w2 <= 'b0;
         app_data_m_w3 <= 'b0;
         app_data_m_w4 <= 'b0;	 
      end
      else begin
         app_data_w1 <= app_data_w0;
         app_data_w2 <= app_data_w1;
         app_data_w3 <= app_data_w2;
         app_data_w4 <= app_data_w3;
         app_data_m_w1 <= app_data_m_w0;
         app_data_m_w2 <= app_data_m_w1;
         app_data_m_w3 <= app_data_m_w2;
         app_data_m_w4 <= app_data_m_w3;
      end
   end

   always @ (posedge clk90) begin
      if (rst90_r == 1'b1)
        data_ena_r <= 1'b0;
      else if (u_data_val == 1'b1)
        data_ena_r <= 1'b1;
      else
        data_ena_r <= 1'b0;
   end

   always @ (posedge clk90) begin
      if (rst90_r == 1'b1)
        data_ena_w <= 1'b0;
      else if ((r_w == 1'b0) && (u_ack == 1'b1))
        data_ena_w <= 1'b1;
      else
        data_ena_w <= 1'b0;
   end

   always@(posedge clk90) begin
      if(rst90_r == 1'b1)
        u_dat_flag <= 1'b0;
      else
        u_dat_flag  <= cmd_ack;
   end
   
   assign u_dat_fl    = cmd_ack && !u_dat_flag && r_w ;
   assign data_rst_r1 = u_dat_fl ;

   always@(posedge clk90) begin
      if(rst90_r == 1'b1)
        data_rst_r <= 1'b0;
      else
        data_rst_r <= data_rst_r1;
   end
  
   ddr_ctrl_addr_gen_0 INST1
     (
      .clk        (clk),
      .rst180     (fpga_rst180),
      .r_w        (r_w),
      .addr_rst   (addr_rst),
      .addr_inc   (addr_inc),
      .addr_out   (addr_out),
      .burst_done (burst_done),
      .cnt_roll   (cnt_roll)
       );

   ddr_ctrl_cmd_fsm_0 INST_2
     (
      .clk          (clk),
      .clk90        (clk90),
      .cmd_ack      (cmd_ack),
      .cnt_roll     (cnt_roll),
      .r_w          (r_w),
      .refresh_done (ar_done),
      .auto_ref_req (auto_ref_req),
      .rst90        (fpga_rst90),
      .rst180       (fpga_rst180),
      .init_val     (init_done),
      .addr_inc     (addr_inc),
      .addr_rst     (addr_rst),
      .u_cmd        (u_cmd),
      .data_rst     (data_rst_w)
      );

   ddr_ctrl_cmp_data_0 INST3
     (
      .clk90            (clk90),
      .data_valid       (data_valid),
      .cmp_data         (cmp_data_r),
      .read_data        (u_data_o),
      .rst90            (fpga_rst90),
      .led_error_output (led_error_output),
      .data_valid_out   (data_valid_out)
      );

   ddr_ctrl_data_gen_0 INST5
     (
      .clk90       (clk90),
      .rst90       (fpga_rst90),
      .data_rst    (data_rst_r),
      .data_ena    (data_ena_r),
      .mask_data   (cmp_data_m_r),
      .data_out    (cmp_data_r)
      );

   ddr_ctrl_data_gen_0 INST7
     (
      .clk90       (clk90),
      .rst90       (fpga_rst90),
      .data_rst    (data_rst_w),
      .data_ena    (data_ena_w),
      .mask_data   (app_data_m_w0),
      .data_out    (app_data_w0)
      );
   
endmodule
