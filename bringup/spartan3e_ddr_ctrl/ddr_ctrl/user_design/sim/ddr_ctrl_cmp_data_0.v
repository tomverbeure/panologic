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
//  /   /        Filename           : ddr_ctrl_cmp_data_0.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
// \   \  /  \   Date Created       : Mon May 2 2005
//  \___\/\___\
// Device       : Spartan-3/3E/3A/3A-DSP
// Design Name  : DDR SDRAM
// Purpose	: This module compare the read data with compare data and 
//		  generates the error signal in case of data mismatch. 
//*****************************************************************************

`timescale 1ns/100ps
`include "../rtl/ddr_ctrl_parameters_0.v"

module ddr_ctrl_cmp_data_0
  (
   input                         clk90,
   input                         data_valid,
   input [((`DATA_WIDTH*2)-1):0] cmp_data,
   input [((`DATA_WIDTH*2)-1):0] read_data,
   input                         rst90,
   output                        led_error_output,
   output                        data_valid_out
   );

   reg                          led_state;
   reg                          valid;
   reg [((`DATA_WIDTH/8)-1):0]  byte_err_fall/* synthesis syn_preserve=1 */;
   reg [((`DATA_WIDTH/8)-1):0]  byte_err_rise/* synthesis syn_preserve=1 */;
   reg                          val_reg;
   reg [((`DATA_WIDTH*2)-1):0]  read_data_reg;
   reg                          rst90_r;
   wire				error;

   assign data_valid_out = valid;
   
   always @ (posedge clk90)
     rst90_r <= rst90;

   always @ (posedge clk90)
     read_data_reg  <= read_data;

   always @ (posedge clk90) begin
      if (rst90_r == 1'b1) begin
         valid     <= 1'b0;
         val_reg   <= 1'b0;
      end
      else begin
         valid     <= data_valid;
         val_reg   <= valid;
      end
   end

// byte wise data compare logic
   genvar err_i;
   generate for(err_i = 0; err_i < `DATA_WIDTH/8; 
		err_i = err_i + 1) begin: gen_err
      always @ (posedge clk90) begin
         byte_err_fall[err_i]  <= (read_data_reg[err_i*8+:8]   != 
			      cmp_data[err_i*8+:8]);
         byte_err_rise[err_i] <= (read_data_reg[`DATA_WIDTH+err_i*8+:8] != 
			      cmp_data[`DATA_WIDTH+err_i*8+:8]);
      end
   end
   endgenerate

   assign error = ((|(byte_err_fall[((`DATA_WIDTH/8)-1):0])) ||
                   (|(byte_err_rise[((`DATA_WIDTH/8)-1):0]))) && val_reg;

   always @ (posedge clk90) begin
      led_state <= ( !rst90_r  && ( error || led_state));
   end

   //synthesis translate_off
   always @ (posedge clk90) begin
      if (rst90_r == 1'b0)
        if (error == 1'b1)
          $display ("DATA ERROR at time %t byte_err_fall= %b ,byte_err_rise= %b" , 
		    $time,byte_err_fall,byte_err_rise);
   end
   //synthesis translate_on

   assign led_error_output = led_state;
   
endmodule
