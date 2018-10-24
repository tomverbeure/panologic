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
// Copyright 2005, 2006, 2007 Xilinx, Inc.
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
//  /   /        Filename           : ddr_ctrl_addr_gen_0.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP
// Design Name  : DDR SDRAM
// Purpose	: This module generates address and burst done signals to the 
//		  controller. Address consists of bank address at the lsb followed
//		  by column and row address. This module generates address depending 
//                on the addr_rst,addr_inc and r_w signals from the cmd_fsm module. 
//*****************************************************************************

`timescale 1ns/100ps
`include "../rtl/ddr_ctrl_parameters_0.v"

module ddr_ctrl_addr_gen_0
  (
   input                            clk,
   input                            rst180,
   input                            addr_rst,
   input                            addr_inc,
   input                            r_w,
   output [((`ROW_ADDRESS
             + `COLUMN_ADDRESS
             + `BANK_ADDRESS)-1):0] addr_out,
   output                           burst_done,
   output                           cnt_roll
   );


   reg [7:0]               column_counter;
   reg [2:0]               burst_cnt;
   reg [1:0]               cnt;
   reg [1:0]               cnt1;
   reg [`BANK_ADDRESS-1:0] ba_count;
   reg [`ROW_ADDRESS-1:0]  row_address1;
   reg                     burst_done_r1;
   reg                     burst_done_r2;
   reg                     burst_done_r3;
   reg                     burst_done_r4;
   reg                     burst_done_r5;
   reg                     rst180_r;

   wire [2:0]              burst_length;
   wire [3:0]              col_incr;
   wire [1:0]              col_val;
   wire [`ROW_ADDRESS - 1:0] lmr;
   assign lmr          = `LOAD_MODE_REGISTER;

   assign addr_out     = {row_address1,{`COLUMN_ADDRESS -8{1'b0}},
                          column_counter, ba_count};
   assign burst_length = lmr[2:0];
   assign burst_done   = (burst_length == 3'b011 ? burst_done_r4 :
			 (burst_length == 3'b010 ? burst_done_r2 : burst_done_r1));
   assign cnt_roll     = (burst_length == 3'b011 ? burst_done_r3 : burst_done_r1);
   assign col_incr     = ((burst_length == 3'b011) ? 4'b1000 :
                         ((burst_length == 3'b010) ? 4'b0100 : 4'b0010));
   assign col_val      = ((burst_length == 3'b011) ? 2'b11 :
                         ((burst_length == 3'b010) ? 2'b01 : 2'b00));

   always @ (negedge clk) begin
      rst180_r <= rst180;
   end

//row address counter increments after every five writes and five reads
   always @ (negedge clk) begin
      if(rst180_r == 1'b1 || row_address1[5] == 1'b1)
        row_address1 <=  {{(`ROW_ADDRESS-2){1'b0}}, 2'b10};
      else if( r_w == 1'b1 && burst_done_r4 == 1'b0 &&
               burst_done_r5 == 1'b1)
        row_address1 <=  row_address1 + 8'b10;
      else
        row_address1 <=  row_address1;
   end

// bank address counter increments after every five writes and five reads 
// commands
   always @ (negedge clk) begin
      if(rst180_r == 1'b1)
        ba_count <=  2'b00;
      else if( r_w == 1'b1 && burst_done_r4 == 1'b0 &&
               burst_done_r5 == 1'b1)
        ba_count <=  ba_count + 1'b1;
      else
        ba_count <=  ba_count;
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1 || addr_rst == 1'b1)
        cnt <= 2'b0;
      else if (addr_inc == 1'b1 && cnt1 == 2'b01)
        if (cnt == col_val)
          cnt <= 2'b0;
        else
          cnt <= cnt + 1'b1;
   end

// burst cnt to count number of the writes/reads ccommands
   always @ (negedge clk) begin
      if (rst180_r == 1'b1 || addr_rst == 1'b1)
        burst_cnt <= 3'd0;
      else if (addr_inc == 1'b1 && cnt == 2'b00)
        burst_cnt <= burst_cnt + 1'b1;
      else
        burst_cnt <= burst_cnt;
   end

// column address counter increments in multilple of 2,4,8 depending 
// on the burst length 2,4 and 8 respectively 
   always @ (negedge clk) begin
      if (rst180_r == 1'b1 || addr_rst == 1'b1) begin
         column_counter <= 8'b0;
         cnt1           <= 2'b0;
      end
      else if(addr_inc == 1'b1)
        if(cnt1 == 2'b0)
          cnt1 <= cnt1 + 1'b1;
        else if(cnt1 == 2'b01 && cnt == 2'b00 && burst_cnt < 3'b101)
          column_counter <= column_counter + col_incr;
        else
          column_counter <= column_counter;
      else if(!burst_done_r4  && burst_done_r5)
        column_counter <= 8'd0;
   end

// burst done is generated  after five writes/reads
   always @ (negedge clk) begin
      burst_done_r1 <= (!rst180_r && (burst_cnt[2:0] == 3'b101));
   end

   always @ (negedge clk)begin
      burst_done_r2 <= burst_done_r1;
      burst_done_r3 <= burst_done_r2;
      burst_done_r4 <= burst_done_r3;
      burst_done_r5 <= burst_done_r4;
   end

endmodule
