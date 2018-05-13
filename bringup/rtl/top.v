//
//module top(clk, gpios, out);
//
//    input clk;
//    input [200:0] gpios;
//    output out;
//
//    wire [200:0] gpios;
//    reg out;
//
//    always @(posedge clk)
//        out <= |gpios;
//
//endmodule



module pano_pins(
    input wire osc_clk,

    output wire idt_iclk,
    input wire  idt_clk1,

    output wire idt_sclk,
    output wire idt_strobe,
    output wire idt_data,

    output wire led_green,
    output wire led_blue,

    output wire spi_cs_,
    output wire spi_clk,
    output wire spi_dq0,
    output wire spi_dq1,

    input wire audio_mclk,
    input wire audio_bclk,
    input wire audio_dacdat,
    input wire audio_daclrc,
    input wire audio_adcdat,
    input wire audio_adclrc,
    input wire audio_sdin,
    input wire audio_sclk,

    input wire [11:0] sdram_a,
    output wire sdram_ck,
    output wire sdram_ck_,
    input wire sdram_cke,
    input wire sdram_we_,
    input wire sdram_cas_,
    input wire sdram_ras_,
    input wire [3:0] sdram_dm,
    input wire [1:0] sdram_ba,
    input wire [31:0] sdram_dq,
    input wire [3:0] sdram_dqs,

    output wire vo_clk,
    output wire vo_blank_,
    output wire [7:0] vo_r,
    output wire [7:0] vo_g,
    output wire [7:0] vo_b
);

    reg osc_reset_;

`ifndef SYNTHESIS
    initial begin
        osc_reset_ <= 1'b0;
    end
`endif

    always @(posedge osc_clk)
        osc_reset_ <= 1'b1;

    reg [30:0]             cntr;
    always @(posedge osc_clk) begin
        cntr <= cntr+1;

        if (!osc_reset_)
            cntr <= 0;
    end

    assign led_green = cntr[23];
    assign led_blue  = cntr[24];

    assign vo_clk = idt_clk1;
    assign vo_blank_ = cntr[5];
    assign vo_r = {8{cntr[5]}};
    assign vo_g = {8{cntr[5]}};
    assign vo_b = {8{cntr[5]}};

    assign spi_cs_ = cntr[5];
    assign spi_clk = cntr[5];
    assign spi_dq0 = cntr[5];
    assign spi_dq1 = cntr[5];

    assign sdram_ck  = osc_clk;
    assign sdram_ck_ = !osc_clk;

    reg [6:0] idt_cntr;
    always @(posedge osc_clk) begin
        if (&idt_cntr != 1'b1) begin
            idt_cntr <= idt_cntr + 1;
        end

        if (!osc_reset_)
            idt_cntr <= 0;
    end

    wire [6:0] idt_r;
    wire [8:0] idt_v;
    wire [2:0] idt_s;
    wire [1:0] idt_f;
    wire       idt_ttl;
    wire [1:0] idt_c;

    // Create pre output-divider clock of 266MHz:
    // 50 * 2 * (8+8)/(4+2)
    assign idt_r   = 7'd4;        
    assign idt_v   = 9'd8;
    
    // Final clock should be 66MHz (266/4)
    assign idt_s   = 3'b011;    // CLK1 output divide = 4

    assign idt_f   = 2'b01;     // CLK2 = Fref/2
    assign idt_ttl = 1'b1;      // Measure duty cycles at VDD/2
    assign idt_c   = 2'b00;     // Use clock as ref instead of Xtal

    wire [23:0] idt_config;
    assign idt_config = { idt_c, idt_ttl, idt_f, idt_s, idt_v, idt_r };

    reg [23:0] idt_config_reverse;
    integer i;
    always @(*) 
        for(i=0;i<24;i=i+1)
            idt_config_reverse[23-i] = idt_config[i];

    assign idt_sclk = (idt_cntr < 48) & idt_cntr[0];
    assign idt_data = idt_cntr < 48 ? idt_config_reverse[idt_cntr[5:1]] : 1'b0;
    assign idt_strobe = idt_cntr[5:1] == 31;

    assign idt_iclk = cntr[0];

endmodule

