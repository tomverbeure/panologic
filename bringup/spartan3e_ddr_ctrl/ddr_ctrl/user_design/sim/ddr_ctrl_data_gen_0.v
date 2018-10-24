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
//  /   /        Filename           : ddr_ctrl_data_gen_0.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP
// Design Name  : DDR SDRAM
// Purpose	: This module generate write data during the write command 
//                and compare data during read command. For write command,
//                mask data is also generated. Mask data is tied to low. 
//*****************************************************************************

`timescale 1ns/100ps
`include "../rtl/ddr_ctrl_parameters_0.v"

module ddr_ctrl_data_gen_0
  (
   input                               clk90,
   input                               rst90,
   input                               data_rst,
   input                               data_ena,
   output [((`DATA_MASK_WIDTH*2)-1):0] mask_data,
   output [((`DATA_WIDTH*2)-1):0]      data_out
    );


   reg [7:0] rise_data;
   reg [7:0] fall_data;
   reg 	     rst90_r;
   wire [7:0]rise_data1;

   localparam PATTERN = 8'H96;

   assign mask_data = `DATA_MASK_WIDTH*2'd0;
   assign data_out    = {rise_data,rise_data ,fall_data,fall_data};

   always @( posedge clk90 )
           rst90_r <= rst90;

   assign rise_data_xnor = rise_data[7] ^~ rise_data[5];
   assign rise_data1 = {rise_data[6:0],rise_data_xnor};

   always @ (posedge clk90) begin
      if (rst90_r == 1'b1) begin
         rise_data <= PATTERN;
         fall_data <= ~PATTERN;
      end
      else begin
         if (data_rst == 1'b1) begin
            rise_data <= PATTERN;
            fall_data <= ~PATTERN;
         end
         else if (data_ena == 1'b1) begin
            rise_data <= rise_data1;
            fall_data <= ~rise_data1;
         end
         else begin
            fall_data <= fall_data ;
            rise_data <= rise_data;
         end
      end
   end
   
endmodule
