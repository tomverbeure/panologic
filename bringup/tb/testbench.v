
`timescale 1 ns / 1 ps

module testbench;

    reg osc_clk;

    pano_pins u_pano_pins(
        .osc_clk(osc_clk)
    );

    initial begin
        osc_clk     = 0;
        forever begin
            #5 osc_clk  = ~osc_clk;
        end
    end

    initial begin
        $display("%t: Start of simulation!", $time);
        $dumpfile("waves.vcd");
        $dumpvars(0, testbench);

        repeat(10000) @(posedge osc_clk);
        $display("%t: Simulation complete...", $time);
        $finish;
    end


endmodule

