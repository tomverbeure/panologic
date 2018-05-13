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

    reg [30:0]             cntr;
    always @(posedge osc_clk)
        cntr=cntr+1;

    assign idt_sclk = 1'b0;
    assign idt_strobe = 1'b0;
    assign idt_data = 1'b0;

    assign idt_iclk = cntr[0];

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

endmodule

