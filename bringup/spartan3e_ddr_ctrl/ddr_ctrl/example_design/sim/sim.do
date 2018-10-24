###############################################################################
## DISCLAIMER OF LIABILITY
##
## This file contains proprietary and confidential information of
## Xilinx, Inc. ("Xilinx"), that is distributed under a license
## from Xilinx, and may be used, copied and/or disclosed only
## pursuant to the terms of a valid license agreement with Xilinx.
##
## XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
## ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
## EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
## LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
## MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
## does not warrant that functions included in the Materials will
## meet the requirements of Licensee, or that the operation of the
## Materials will be uninterrupted or error-free, or that defects
## in the Materials will be corrected. Furthermore, Xilinx does
## not warrant or make any representations regarding use, or the
## results of the use, of the Materials in terms of correctness,
## accuracy, reliability or otherwise.
##
## Xilinx products are not designed or intended to be fail-safe,
## or for use in any application requiring fail-safe performance,
## such as life-support or safety devices or systems, Class III
## medical devices, nuclear facilities, applications related to
## the deployment of airbags, or any other applications that could
## lead to death, personal injury or severe property or
## environmental damage (individually and collectively, "critical
## applications"). Customer assumes the sole risk and liability
## of any use of Xilinx products in critical applications,
## subject only to applicable laws and regulations governing
## limitations on product liability.
##
## Copyright 2007, 2008 Xilinx, Inc.
## All rights reserved.
##
## This disclaimer and copyright notice must be retained as part
## of this file at all times.
###############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /    Vendor             : Xilinx
## \   \   \/     Version            : 3.6.1
##  \   \         Application        : MIG
##  /   /         Filename           : sim.do
## /___/   /\     Date Last Modified : $Date: 2010/11/26 18:25:42 $
## \   \  /  \    Date Created       : Mon May 14 2007
##  \___\/\___\
##
## Device: Spartan-3/3A/3A-DSP/3E
## Design Name : DDR SDRAM
## Purpose:
##    Sample sim .do file to compile and simulate memory interface
##    design and run the simulation for specified period of time. Display the
##    waveforms that are listed with "add wave" command.
##    Assumptions:
##      - Simulation takes place in \sim folder of MIG output directory
## Reference:
## Revision History:
###############################################################################
vlib work
#Map the required libraries here.#
#Complie design parameter file first. This is required for VHDL designs which #
#include a parameter file.#
vlog  ../rtl/*parameters*
#Compile all modules#
vlog  ../rtl/*
#Compile files in sim folder (excluding model parameter file)#
#$XILINX variable must be set
vlog  $env(XILINX)/verilog/src/glbl.v
vlog  ../sim/*.v

#Pass the parameters for memory model parameter file#
vlog  +incdir+. +define+x1Gb +define+sg5B +define+x16 ddr_model.v
#Load the design. Use required libraries.#
vsim -t ps -novopt +notimingchecks -L unisims_ver work.sim_tb_top glbl
onerror {resume}

#Log all the objects in design. These will appear in .wlf file#
log -r /*
#View sim_tb_top signals in waveform#
add wave sim:/sim_tb_top/*
#Change radix to Hexadecimal#
radix hex
#Supress Numeric Std package and Arith package warnings.#
#For VHDL designs we get some warnings due to unknown values on some signals at startup#
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0#
#We may also get some Arithmetic package warnings because of unknown values on#
#some of the signals that are used in an Arithmetic operation.#
#In order to suppress these warnings, we use following two commands#
set NumericStdNoWarnings 1
set StdArithNoWarnings 1
#Choose simulation run time by inserting a breakpoint and then run for specified #
#period. For more details, refer to Simulation Guide section of MIG user guide (UG086).#
when {/sim_tb_top/init_done = 1} {
if {[when -label a_100] == ""} {
when -label a_100 { $now = 50 us } {
nowhen a_100
report simulator control
report simulator state
if {[examine /sim_tb_top/error] == 0} {
echo "TEST PASSED"
stop
}
if {[examine /sim_tb_top/error] != 0} {
echo "TEST FAILED: DATA ERROR"
stop
}
}
}
}
#In case calibration fails to complete, choose the run time and then quit#
when {$now = @500 us and /sim_tb_top/init_done != 1} {
echo "TEST FAILED: INITIALIZATION DID NOT COMPLETE"
stop
}
run -all
stop
