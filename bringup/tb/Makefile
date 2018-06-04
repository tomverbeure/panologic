
RTL_DIR=../rtl/

VERILOG = $(RTL_DIR)/top.v \
		$(RTL_DIR)/vid_cntr.v \
		$(RTL_DIR)/vi_gen.v \
		$(RTL_DIR)/cursor.v \
		$(RTL_DIR)/char_gen.v \
		$(RTL_DIR)/vo.v \
		$(RTL_DIR)/gpio.v \
		$(RTL_DIR)/local_ram.v \
		$(RTL_DIR)/pads_generic.v \
		$(RTL_DIR)/pll_div4.v \
		$(RTL_DIR)/reset_gen.v \
		$(RTL_DIR)/soc.v \
		$(RTL_DIR)/VexRiscv_FullNoMmuNoCacheNoCsrNoDbg.v \
		$(RTL_DIR)/vexriscv_wrapper.v

VERILOG_TB = testbench.v

DEFINES = -D JTAG_TAP_GENERIC -D USE_VEXRISCV -D VGA_TB

all: progmem c64_font.hex sim
	./sim

sim: $(VERILOG_TB) $(VERILOG) 
	iverilog $(DEFINES) -I $(RTL_DIR) $(VERILOG_TB) $(VERILOG) -o $@

.PHONY: progmem
progmem:
	cd ../sw && make
	cp ../sw/progmem*.hex .

.PHONY: c64_font.hex
c64_font.hex:
	cd ../misc && make
	cp ../misc/$@ $@


waves:
	gtkwave waves.gtkw &

clean:
	rm -f sim *.vcd
