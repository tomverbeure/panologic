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
// Copyright 2008 Xilinx, Inc.
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
//  /   /        Filename           : wiredly.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Thu Feb 21 2008
//  \___\/\___\
//
// Device      : SPARTAN
// Design Name : DDR
// Description: This module provide
//   the definition of a zero ohm component (A, B).
//
//   The applications of this component include:
//     . Normal operation of a jumper wire (data flowing in both directions)
//
//   The component consists of 2 ports:
//      . Port A: One side of the pass-through switch
//      . Port B: The other side of the pass-through switch

//   The model is sensitive to transactions on all ports.  Once a
//   transaction is detected, all other transactions are ignored
//   for that simulation time (i.e. further transactions in that
//   delta time are ignored).
//
// Model Limitations and Restrictions:
//   Signals asserted on the ports of the error injector should not have
//   transactions occuring in multiple delta times because the model
//   is sensitive to transactions on port A, B ONLY ONCE during
//   a simulation time.  Thus, once fired, a process will
//   not refire if there are multiple transactions occuring in delta times.
//   This condition may occur in gate level simulations with
//   ZERO delays because transactions may occur in multiple delta times.
//*****************************************************************************

`timescale 1ns / 100ps

module WireDelay # (
  parameter Delay_g = 0,
  parameter Delay_rd = 0
)
(
  inout A,
  inout B,
  input reset
);  

  reg A_r;
  reg B_r;
  reg line_en;

  assign A = A_r;
  assign B = B_r;

  always @(*) begin
    if (!reset) begin
      A_r <= 1'bz;
      B_r <= 1'bz;
      line_en <= 1'b0;
    end else begin 
      if (line_en) begin
        A_r <= #Delay_rd B;
	B_r <= 1'bz;
      end else begin
        B_r <= #Delay_g A;
	A_r <= 1'bz;
      end
    end
  end

  always @(A or B) begin
    if (!reset) begin
      line_en <= 1'b0;
    end else if (A !== A_r) begin
      line_en <= 1'b0;
    end else if (B_r !== B) begin
      line_en <= 1'b1;
    end else begin
      line_en <= line_en;
    end
  end
endmodule
