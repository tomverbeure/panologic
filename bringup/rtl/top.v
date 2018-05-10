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
    input wire clk,

    output wire [1:0] leds,

    input wire spi_cs_,
    input wire spi_clk,
    input wire spi_dq0,
    input wire spi_dq1,

    input wire audio_mclk,
    input wire audio_bclk,
    input wire audio_dacdat,
    input wire audio_daclrc,
    input wire audio_adcdat,
    input wire audio_adclrc,
    input wire audio_sdin,
    input wire audio_sclk,

    input wire [11:0] sdram_a,
    input wire sdram_ck,
    input wire sdram_ck_,
    input wire sdram_cke,
    input wire sdram_we_,
    input wire sdram_cas_,
    input wire sdram_ras_,
    input wire [3:0] sdram_dm,
    input wire [1:0] sdram_ba,
    input wire [31:0] sdram_dq,
    input wire [3:0] sdram_dqs

);

    reg [30:0]             cntr;

    always @(posedge clk)
        cntr=cntr+1;

    assign leds = cntr [24:23];

endmodule

