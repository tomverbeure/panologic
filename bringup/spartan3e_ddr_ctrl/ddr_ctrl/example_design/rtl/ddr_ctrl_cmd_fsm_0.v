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
//  /   /        Filename           : ddr_ctrl_cmd_fsm_0.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP/3A
// Design Name  : DDR SDRAM
// Purpose	: This module consists of s/m which will generate user commands 
//                like initialization, write and read.It also generates control 
//                signals addr_inc,addr_rst,data_rst for addr_gen and data_gen 
//                modules.This control signals are used to generate address 
//                during write and read commands and data for write command. 
//*****************************************************************************

`timescale 1ns/100ps

module ddr_ctrl_cmd_fsm_0
  (
   input            clk,
   input            clk90,
   input            rst180,
   input            rst90,
   input            cmd_ack,
   input            cnt_roll,
   input            refresh_done,
   input            auto_ref_req,
   input            init_val,
   output reg       r_w,
   output reg       addr_inc,
   output           addr_rst,
   output reg [2:0] u_cmd,
   output           data_rst
   );

   localparam RST_ST        = 3'b000;
   localparam INIT_START_ST = 3'b001;
   localparam INIT_ST       = 3'b010;
   localparam WR_ST         = 3'b011;
   localparam DLY_ST        = 3'b100;
   localparam RD_ST         = 3'b101;

   reg [2:0]  current_state;
   reg [2:0]  next_state;
   reg [5:0]  init_dly;
   reg        data_rst_180;
   reg        data_rst_90;
   reg        init_done;
   reg        rst180_r;
   reg        rst90_r;
   reg        rst_flag;
   reg        temp;

   wire [5:0] init_dly_p;
   wire [2:0] u_cmd_p;
   wire       addr_inc_p;
   wire       data_rst_p;
   wire       next_cmd;

   assign data_rst   = data_rst_90;
   assign u_cmd_p    = ((current_state == RD_ST ) ? 3'b110 :
			(current_state == WR_ST)         ? 3'b100 :
			(current_state == INIT_START_ST) ? 3'b010 :
			3'b000);
   assign addr_inc_p = ((cmd_ack == 1'b1) &&
                        (current_state == WR_ST || current_state == RD_ST));
   assign addr_rst   = rst_flag ;

   always @ (negedge clk)
     rst180_r <= rst180;

   always @ (posedge clk90)
     rst90_r  <= rst90;

   always @ (negedge clk) begin
      rst_flag <= ( !rst180_r && !cmd_ack && !temp);
      temp     <= ( !rst180_r && !cmd_ack);
   end

   assign data_rst_p =  r_w  ;
   assign init_dly_p = ((current_state == INIT_START_ST) ? 6'b111111 :
			(init_dly != 6'b000000) ? init_dly - 1'b1 :
			6'b000000);
   assign next_cmd   = ((cmd_ack == 1'b0) && current_state == DLY_ST);
   
   always @ (negedge clk) begin
      if(rst180_r == 1'b1)
        r_w <= 1'b0;
      else
        if(cmd_ack == 1'b0 && current_state == RD_ST )
          r_w <= 1'b1;
        else if(cmd_ack == 1'b0 && current_state == WR_ST )
          r_w <= 1'b0;
        else
          r_w <= r_w;
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1)
        data_rst_180  <= 1'b0;
      else
        data_rst_180  <= data_rst_p;
   end

   always @ (posedge clk90) begin
      if (rst90_r == 1'b1)
        data_rst_90  <= 1'b0;
      else
        data_rst_90  <= data_rst_180;
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1) begin
         u_cmd <= 3'b000;
      end
      else begin
         u_cmd <= u_cmd_p;
      end
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1) begin
         addr_inc  <= 1'b0;
         init_dly  <= 6'b000000;
      end
      else begin
         addr_inc  <= addr_inc_p;
         init_dly  <= init_dly_p;
      end
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1)
        init_done <= 1'b0;
      else
        init_done <= init_val;
   end

   always @ (current_state or rst180_r or cnt_roll or r_w or refresh_done
             or init_done or next_cmd) begin
      if (rst180_r == 1'b1)
        next_state = RST_ST;
      else begin
         case (current_state)
           RST_ST : begin
              next_state = INIT_START_ST;
           end
           INIT_START_ST : begin
              next_state = INIT_ST;
           end
           INIT_ST : begin
              if (init_done == 1'b1)
                next_state = WR_ST;
              else
                next_state = INIT_ST;
           end
           WR_ST : begin
              if (cnt_roll == 1'b0)
                next_state = WR_ST;
              else
                next_state = DLY_ST;
           end
           DLY_ST : begin
              if(next_cmd == 1'b1 && r_w == 1'b0)
                next_state = RD_ST;
              else if(next_cmd == 1'b1 && r_w == 1'b1)
                next_state = WR_ST;
              else
                next_state = DLY_ST;
           end
           RD_ST : begin
              if (cnt_roll == 1'b0)
                next_state = RD_ST;
              else
                next_state = DLY_ST;
           end
           default : begin
              next_state = RST_ST;
           end
         endcase
      end
   end

   always @ (negedge clk) begin
      if (rst180_r == 1'b1)     begin
         current_state    <= RST_ST;
      end
      else begin
         current_state    <= next_state;
      end
   end

endmodule
