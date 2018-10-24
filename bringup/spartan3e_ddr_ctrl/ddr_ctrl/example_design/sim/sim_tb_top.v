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
// \   \   \/    Version	    : 3.6.1
//  \   \        Application	    : MIG
//  /   /        Filename           : sim_tb_top.v
// /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:42 $
// \   \  /  \   Date Created       : Mon May 14 2007
//  \___\/\___\
//
// Device      : Spartan-3/3E/3A/3A-DSP
// Design Name : DDR SDRAM
// Purpose     : This is the simulation testbench which is used to verify the
//               design. The basic clocks and resets to the interface are
//               generated here. This also connects the memory interface to the
//               memory model.
//*****************************************************************************

`timescale 1ns / 100ps

`include "../rtl/ddr_ctrl_parameters_0.v"

  module sim_tb_top;

   localparam DEVICE_WIDTH = 16; // Memory device data width
   localparam REG_ENABLE   = `REGISTERED; // registered addr/ctrl

   localparam real CLK_PERIOD_NS      = 6.02;
   localparam real TCYC_200           = 5.0;
   localparam real TPROP_DQS          = 0.00;      // Delay for DQS signal during Write Operation
   localparam real TPROP_DQS_RD       = 0.05;      // Delay for DQS signal during Read Operation
   localparam real TPROP_PCB_CTRL     = 0.00;      // Delay for Address and Ctrl signals
   localparam real TPROP_PCB_DATA     = 0.00;      // Delay for data signal during Write operation
   localparam real TPROP_PCB_DATA_RD  = 0.00;      // Delay for data signal during Read operation

   reg                       sys_clk;
   reg                       sys_rst_n;
   wire                      sys_rst_out;
   reg [(`ROW_ADDRESS-1):0]  ddr_address_reg;
   reg [(`BANK_ADDRESS-1):0] ddr_ba_reg;
   reg [(`CKE_WIDTH-1):0]    ddr_cke_reg;
   reg                       ddr_ras_l_reg;
   reg                       ddr_cas_l_reg;
   reg                       ddr_we_l_reg;
   reg [(`NO_OF_CS-1):0]     ddr_cs_l_reg;

   wire                              sys_clk_n;
   wire                              sys_clk_p;
   wire [(`DATA_WIDTH-1):0]          ddr_dq_sdram;
   wire [(`DATA_STROBE_WIDTH-1):0]   ddr_dqs_sdram;
   wire [(`DATA_MASK_WIDTH-1):0]     ddr_dm_sdram;
   reg  [(`DATA_MASK_WIDTH-1):0]     ddr_dm_sdram_tmp;
   reg  [(`CLK_WIDTH-1):0]           ddr_clk_sdram;
   reg  [(`CLK_WIDTH-1):0]           ddr_clk_n_sdram;
   reg  [(`ROW_ADDRESS-1):0]         ddr_address_sdram;
   reg  [(`BANK_ADDRESS-1):0]        ddr_ba_sdram;
   reg                               ddr_ras_l_sdram;
   reg                               ddr_cas_l_sdram;
   reg                               ddr_we_l_sdram;
   reg  [(`NO_OF_CS-1):0]            ddr_cs_l_sdram;
   reg  [(`CKE_WIDTH-1):0]           ddr_cke_sdram;

   wire [(`DATA_WIDTH-1):0]          ddr_dq_fpga;
   wire [(`DATA_STROBE_WIDTH-1):0]   ddr_dqs_fpga;
   wire [(`DATA_MASK_WIDTH-1):0]     ddr_dm_fpga;
   wire [(`CLK_WIDTH-1):0]           ddr_clk_fpga;
   wire [(`CLK_WIDTH-1):0]           ddr_clk_n_fpga;
   wire [(`ROW_ADDRESS-1):0]         ddr_address_fpga;
   wire [(`BANK_ADDRESS-1):0]        ddr_ba_fpga;
   wire                              ddr_ras_l_fpga;
   wire                              ddr_cas_l_fpga;
   wire                              ddr_we_l_fpga;
   wire [(`NO_OF_CS-1):0]            ddr_cs_l_fpga;
   wire [(`CKE_WIDTH-1):0]           ddr_cke_fpga;

   // Only RDIMM memory parts support the reset signal,
   // hence the ddr_reset_n signal can be ignored for other memory parts
   wire 			     #(TPROP_PCB_CTRL) ddr_reset_n;

//ddr2_dm_8_16 signal will be driven only for x16 components are selected
   wire [1:0]                                          ddr_dm_8_16_sdram;
   wire 			                       init_done;
   wire 			                       rst_dqs_div_loop;


   

   initial
     sys_clk = 1'b0;
   always
     sys_clk = #(CLK_PERIOD_NS/2) ~sys_clk;

   assign sys_clk_p = sys_clk;
   assign sys_clk_n = ~sys_clk;


 // Generate Reset
   initial begin
      sys_rst_n = 1'b0;
      #200;
      sys_rst_n = 1'b1;
   end

   assign sys_rst_out = `RESET_ACTIVE_LOW ? sys_rst_n : ~sys_rst_n;


   

// =============================================================================
//                             BOARD Parameters
// =============================================================================
// These parameter values can be changed to model varying board delays
// between the Spartan device and the memory model

  always @(*) begin
    ddr_clk_sdram       <=  #(TPROP_PCB_CTRL) ddr_clk_fpga;
    ddr_clk_n_sdram     <=  #(TPROP_PCB_CTRL) ddr_clk_n_fpga;
    ddr_address_sdram   <=  #(TPROP_PCB_CTRL) ddr_address_fpga;
    ddr_ba_sdram        <=  #(TPROP_PCB_CTRL) ddr_ba_fpga;
    ddr_ras_l_sdram     <=  #(TPROP_PCB_CTRL) ddr_ras_l_fpga;
    ddr_cas_l_sdram     <=  #(TPROP_PCB_CTRL) ddr_cas_l_fpga;
    ddr_we_l_sdram      <=  #(TPROP_PCB_CTRL) ddr_we_l_fpga;
    ddr_cs_l_sdram      <=  #(TPROP_PCB_CTRL) ddr_cs_l_fpga;
    ddr_cke_sdram       <=  #(TPROP_PCB_CTRL) ddr_cke_fpga;
    ddr_dm_sdram_tmp    <=  #(TPROP_PCB_CTRL) ddr_dm_fpga;
  end

  assign ddr_dm_sdram = ddr_dm_sdram_tmp;

// Controlling the bi-directional BUS
  genvar dqwd;
  generate
    for (dqwd = 0;dqwd < `DATA_WIDTH;dqwd = dqwd+1) begin : dq_delay
      WireDelay #
       (
        .Delay_g     (TPROP_PCB_DATA),
        .Delay_rd    (TPROP_PCB_DATA_RD)
       )
      u_delay_dq
       (
        .A           (ddr_dq_fpga[dqwd]),
        .B           (ddr_dq_sdram[dqwd]),
	.reset       (sys_rst_n)
       );
    end
  endgenerate

  genvar dqswd;
  generate
    for (dqswd = 0;dqswd < `DATA_STROBE_WIDTH;dqswd = dqswd+1) begin : dqs_delay
      WireDelay #
       (
        .Delay_g     (TPROP_DQS),
        .Delay_rd    (TPROP_DQS_RD)
       )
      u_delay_dqs
       (
        .A           (ddr_dqs_fpga[dqswd]),
        .B           (ddr_dqs_sdram[dqswd]),
	.reset       (sys_rst_n)
       );
    end
  endgenerate

   //***************************************************************************
   // FPGA memory controller
   //***************************************************************************
   ddr_ctrl mem_interface_top0
      (
       .sys_clk                      (sys_clk_p),
       .sys_clkb                     (sys_clk_n),

       .reset_in_n                   (sys_rst_out),
       .cntrl0_ddr_dq                (ddr_dq_fpga),
       .cntrl0_ddr_dqs               (ddr_dqs_fpga),
       .cntrl0_ddr_dm                (ddr_dm_fpga),
       .cntrl0_ddr_ck                (ddr_clk_fpga),
       .cntrl0_ddr_ck_n              (ddr_clk_n_fpga),
       .cntrl0_ddr_a                 (ddr_address_fpga),
       .cntrl0_ddr_ba                (ddr_ba_fpga),
       .cntrl0_ddr_ras_n             (ddr_ras_l_fpga),
       .cntrl0_ddr_cas_n             (ddr_cas_l_fpga),
       .cntrl0_ddr_we_n              (ddr_we_l_fpga),
       .cntrl0_ddr_cs_n              (ddr_cs_l_fpga),
       .cntrl0_ddr_cke               (ddr_cke_fpga),
       .cntrl0_led_error_output1     (error),
       .cntrl0_data_valid_out        (cntrl0_data_valid_out),
       .cntrl0_init_done             (init_done),
       .cntrl0_rst_dqs_div_in        (rst_dqs_div_loop),
       .cntrl0_rst_dqs_div_out       (rst_dqs_div_loop)
       );

   //***************************************************************************
   // Extra one clock pipelining for RDIMM address and
   // control signals is implemented here (Implemented external to memory model)
   //***************************************************************************
   always @( posedge ddr_clk_sdram[0] ) begin
      if ( ddr_reset_n == 1'b0 ) begin
         ddr_ras_l_reg <= 1'b1;
         ddr_cas_l_reg <= 1'b1;
         ddr_we_l_reg  <= 1'b1;
         ddr_cs_l_reg  <= 1'b1;
         ddr_cke_reg   <= 1'b0;
      end
      else begin
         ddr_address_reg <= #(CLK_PERIOD_NS/2) ddr_address_sdram;
         ddr_ba_reg      <= #(CLK_PERIOD_NS/2) ddr_ba_sdram;
         ddr_ras_l_reg   <= #(CLK_PERIOD_NS/2) ddr_ras_l_sdram;
         ddr_cas_l_reg   <= #(CLK_PERIOD_NS/2) ddr_cas_l_sdram;
         ddr_we_l_reg    <= #(CLK_PERIOD_NS/2) ddr_we_l_sdram;
         ddr_cs_l_reg    <= #(CLK_PERIOD_NS/2) ddr_cs_l_sdram;
         ddr_cke_reg     <= #(CLK_PERIOD_NS/2) ddr_cke_sdram;
      end
   end

   /////////////////////////////////////////////////////////////////////////////
   // Memory model instances
   /////////////////////////////////////////////////////////////////////////////

   genvar i;
   generate
      if (DEVICE_WIDTH == 16) begin
// if memory part is x16
         if ( REG_ENABLE ) begin
// if the memory part is Registered DIMM
            for(i = 0; i < `DATA_STROBE_WIDTH/2; i = i+1) begin : GEN
               
               ddr_model u_mem0
                 (
                  .Dq    (ddr_dq_sdram[(16*(i+1))-1 : i*16]),
                  .Dm    (ddr_dm_sdram[(2*(i+1))-1 : i*2]),
                  .Dqs   (ddr_dqs_sdram[(2*(i+1))-1 : i*2]),
                  .Addr  (ddr_address_reg),
                  .Ba    (ddr_ba_reg),
                  .Clk   (ddr_clk_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                  .Clk_n (ddr_clk_n_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                  .Cke   (ddr_cke_reg),
                  .Cs_n  (ddr_cs_l_reg[0]),
                  .Ras_n (ddr_ras_l_reg),
                  .Cas_n (ddr_cas_l_reg),
                  .We_n  (ddr_we_l_reg)
                  );
            end
         end
         else begin
            if ( `DATA_WIDTH%16 ) begin
// if the memory part is component or unbuffered DIMM
               for(i = 0; i < `DATA_WIDTH/16 ; i = i+1) begin : GEN
// for the memory part x16, if the data width is not multiple
// of 16, memory models are instantiated for all data with x16
// memory model and except for MSB data. For the MSB data
// of 8 bits, all memory data, strobe and mask data signals are
// replicated to make it as x16 part. For example if the design
// is generated for data width of 72, memory model x16 parts
// instantiated for 4 times with data ranging from 0 to 63.
// For MSB data ranging from 64 to 71, one x16 memory model
// by replicating the 8-bit data twice and similarly
// the case with data mask and strobe.
                  
                  ddr_model u_mem0
                    (
                     .Dq    (ddr_dq_sdram[(16*(i+1))-1 : i*16]),
                     .Dqs   (ddr_dqs_sdram[(2*(i+1))-1 : i*2]),
                     .Addr  (ddr_address_sdram),
                     .Ba    (ddr_ba_sdram),
                     .Clk   (ddr_clk_sdram[i]),
                     .Clk_n (ddr_clk_n_sdram[i]),
                     .Cke   (ddr_cke_sdram),
                     .Cs_n  (ddr_cs_l_sdram[0]),
                     .Ras_n (ddr_ras_l_sdram),
                     .Cas_n (ddr_cas_l_sdram),
                     .We_n  (ddr_we_l_sdram),
                     .Dm    (ddr_dm_sdram[(2*(i+1))-1 : i*2])
                     );
               end

               assign ddr_dm_8_16_sdram = {ddr_dm_sdram[`DATA_MASK_WIDTH - 1],ddr_dm_sdram[`DATA_MASK_WIDTH - 1]};
               
               ddr_model u_mem1
                 (
                  .Dq    ({ddr_dq_sdram[`DATA_WIDTH - 1 : `DATA_WIDTH - 8],
                           ddr_dq_sdram[`DATA_WIDTH - 1 : `DATA_WIDTH - 8]}),
                  .Dqs   ({ddr_dqs_sdram[`DATA_STROBE_WIDTH - 1],
                           ddr_dqs_sdram[`DATA_STROBE_WIDTH - 1]}),
                  .Addr  (ddr_address_sdram),
                  .Ba    (ddr_ba_sdram),
                  .Clk   (ddr_clk_sdram[`CLK_WIDTH - 1]),
                  .Clk_n (ddr_clk_n_sdram[`CLK_WIDTH - 1]),
                  .Cke   (ddr_cke_sdram),
                  .Cs_n  (ddr_cs_l_sdram[0]),
                  .Ras_n (ddr_ras_l_sdram),
                  .Cas_n (ddr_cas_l_sdram),
                  .We_n  (ddr_we_l_sdram),
                  .Dm    (ddr_dm_8_16_sdram)
                  );
            end
            else begin
// if the data width is multiple of 16
               for(i = 0; i < `DATA_STROBE_WIDTH/2; i = i+1) begin : GEN
                  
                  ddr_model u_mem0
                    (
                     .Dq    (ddr_dq_sdram[(16*(i+1))-1 : i*16]),
                     .Dqs   (ddr_dqs_sdram[(2*(i+1))-1 : i*2]),
                     .Addr  (ddr_address_sdram),
                     .Ba    (ddr_ba_sdram),
                     .Clk   (ddr_clk_sdram[i]),
                     .Clk_n (ddr_clk_n_sdram[i]),
                     .Cke   (ddr_cke_sdram),
                     .Cs_n  (ddr_cs_l_sdram[0]),
                     .Ras_n (ddr_ras_l_sdram),
                     .Cas_n (ddr_cas_l_sdram),
                     .We_n  (ddr_we_l_sdram),
                     .Dm    (ddr_dm_sdram[(2*(i+1))-1 : i*2])
                     );
               end
            end
         end
      end else
        if (DEVICE_WIDTH == 8) begin
// if the memory part is x8
           if ( REG_ENABLE ) begin
// if the memory part is Registered DIMM
              for(i = 0; i < `DATA_STROBE_WIDTH; i = i+1) begin : GEN
                 
                 ddr_model u_mem0
                   (
                    .Dq    (ddr_dq_sdram[(8*(i+1))-1 : i*8]),
                    .Dm    (ddr_dm_sdram[i]),
                    .Dqs   (ddr_dqs_sdram[i]),
                    .Addr  (ddr_address_reg),
                    .Ba    (ddr_ba_reg),
                    .Clk   (ddr_clk_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                    .Clk_n (ddr_clk_n_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                    .Cke   (ddr_cke_reg),
                    .Cs_n  (ddr_cs_l_reg[0]),
                    .Ras_n (ddr_ras_l_reg),
                    .Cas_n (ddr_cas_l_reg),
                    .We_n  (ddr_we_l_reg)
                    );
              end
           end
           else begin
// if the memory part is component or unbuffered DIMM
              for(i = 0; i < `DATA_STROBE_WIDTH; i = i+1) begin : GEN
                 
                 ddr_model u_mem0
                   (
                    .Dq    (ddr_dq_sdram[(8*(i+1))-1 : i*8]),
                    .Dqs   (ddr_dqs_sdram[i]),
                    .Addr  (ddr_address_sdram),
                    .Ba    (ddr_ba_sdram),
                     .Clk   (ddr_clk_sdram[i]),
                     .Clk_n (ddr_clk_n_sdram[i]),
                    .Cke   (ddr_cke_sdram),
                    .Cs_n  (ddr_cs_l_sdram[0]),
                    .Ras_n (ddr_ras_l_sdram),
                    .Cas_n (ddr_cas_l_sdram),
                    .We_n  (ddr_we_l_sdram),
                    .Dm    (ddr_dm_sdram[i])
                    );
              end
           end
        end else
          if (DEVICE_WIDTH == 4) begin
// if the memory part is x4
             if ( REG_ENABLE ) begin
// if the memory part is Registered DIMM
                for(i = 0; i < `DATA_STROBE_WIDTH; i = i+1) begin : GEN
                   
                   ddr_model u_mem0
                     (
                      .Dq    (ddr_dq_sdram[(4*(i+1))-1 : i*4]),
                      .Dm    (ddr_dm_sdram[i/2]),
                      .Dqs   (ddr_dqs_sdram[i]),
                      .Addr  (ddr_address_reg),
                      .Ba    (ddr_ba_reg),
                      .Clk   (ddr_clk_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                      .Clk_n (ddr_clk_n_sdram[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                      .Cke   (ddr_cke_reg[`NO_OF_CS*i/`DATA_STROBE_WIDTH]),
                      .Cs_n  (ddr_cs_l_reg[0]),
                      .Ras_n (ddr_ras_l_reg),
                      .Cas_n (ddr_cas_l_reg),
                      .We_n  (ddr_we_l_reg)
                      );
                end
             end
             else begin
// if the memory part is component or unbuffered DIMM
                for(i = 0; i < `DATA_STROBE_WIDTH; i = i+1) begin : GEN
                   
                   ddr_model u_mem0
                     (
                      .Dq    (ddr_dq_sdram[(4*(i+1))-1 : i*4]),
                      .Dqs   (ddr_dqs_sdram[i]),
                      .Addr  (ddr_address_sdram),
                      .Ba    (ddr_ba_sdram),
                     .Clk   (ddr_clk_sdram[i]),
                     .Clk_n (ddr_clk_n_sdram[i]),
                      .Cke   (ddr_cke_sdram),
                      .Cs_n  (ddr_cs_l_sdram[0]),
                      .Ras_n (ddr_ras_l_sdram),
                      .Cas_n (ddr_cas_l_sdram),
                      .We_n  (ddr_we_l_sdram),
                      .Dm    (ddr_dm_sdram[i/2])
                      );
                end
             end
          end
   endgenerate

   

 endmodule
