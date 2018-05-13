
RTL_DIR=../rtl/

VERILOG = $(RTL_DIR)/top.v 

VERILOG_TB = testbench.v

all: sim
	./sim

sim: $(VERILOG_TB) $(VERILOG) 
	iverilog -D JTAG_TAP_GENERIC -I $(RTL_DIR) $(VERILOG_TB) $(VERILOG) -o $@

wave:
	gtkwave waves.gtkw &

clean:
	rm -f sim *.vcd
