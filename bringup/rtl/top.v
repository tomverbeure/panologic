
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

    output wire audio_mclk,
    input  wire audio_bclk,
    input  wire audio_dacdat,
    input  wire audio_daclrc,
    input  wire audio_adcdat,
    input  wire audio_adclrc,

    output wire audio_sclk,
    inout  wire audio_sdin,

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
    output wire vo_vsync,
    output wire vo_hsync,
    output wire vo_blank_,
    inout  wire vo_scl,
    inout  wire vo_sda,
    output wire [7:0] vo_r,
    output wire [7:0] vo_g,
    output wire [7:0] vo_b
);

    wire cpu_clk, cpu_reset_;

    reg osc_reset_;

    wire [7:0] gpio_oe, gpio_do, gpio_di;

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

    assign led_green = gpio_do[0];
    assign led_blue  = gpio_do[1];

    //============================================================
    //
    // VGA Test Image Generator
    //
    //============================================================

`include "video_timings.v"

	reg [11:0] col_cntr;
	reg [11:0] line_cntr;

`ifdef VGA640X480
    // osc_clk = 100MHz, so use 25MHz for standard 640x480 @ 60
    assign vo_clk = cntr[1];
`else
    assign vo_clk = idt_clk1;
`endif

    assign vo_scl = 1'bz;
    assign vo_sda = 1'bz;

    reg vo_reset_;

    always @(posedge vo_clk) begin
        vo_reset_ <= 1'b1;

        if (!osc_reset_)
            vo_reset_ <= 1'b0;
    end

    wire        vi_gen_out_vsync;
    wire        vi_gen_out_req;
    wire        vi_gen_out_eol;
    wire        vi_gen_out_eof;
    wire [23:0] vi_gen_out_pixel;

    vi_gen u_vi_gen(
        .vo_clk   (vo_clk),
        .vo_reset_(vo_reset_),

        .out_vsync(vi_gen_out_vsync),
        .out_req  (vi_gen_out_req),
        .out_eol  (vi_gen_out_eol),
        .out_eof  (vi_gen_out_eof),
        .out_pixel(vi_gen_out_pixel)
    );

    wire        cursor_out_vsync;
    wire        cursor_out_req;
    wire        cursor_out_eol;
    wire        cursor_out_eof;
    wire [23:0] cursor_out_pixel;

    cursor u_cursor(
        .vo_clk   (vo_clk),
        .vo_reset_(vo_reset_),

        .in_vsync(vi_gen_out_vsync),
        .in_req  (vi_gen_out_req),
        .in_eol  (vi_gen_out_eol),
        .in_eof  (vi_gen_out_eof),
        .in_pixel(vi_gen_out_pixel),

        .out_vsync(cursor_out_vsync),
        .out_req  (cursor_out_req),
        .out_eol  (cursor_out_eol),
        .out_eof  (cursor_out_eof),
        .out_pixel(cursor_out_pixel)
    );

    wire        char_gen_out_vsync;
    wire        char_gen_out_req;
    wire        char_gen_out_eol;
    wire        char_gen_out_eof;
    wire [23:0] char_gen_out_pixel;

    wire        sbuf_wr;
    wire        sbuf_rd;
    wire [11:0] sbuf_addr;
    wire [7:0]  sbuf_wdata;
    wire [7:0]  sbuf_rdata;

    char_gen u_char_gen(
        .vo_clk   (vo_clk),
        .vo_reset_(vo_reset_),

        .in_vsync(cursor_out_vsync),
        .in_req  (cursor_out_req),
        .in_eol  (cursor_out_eol),
        .in_eof  (cursor_out_eof),
        .in_pixel(cursor_out_pixel),

        .out_vsync(char_gen_out_vsync),
        .out_req  (char_gen_out_req),
        .out_eol  (char_gen_out_eol),
        .out_eof  (char_gen_out_eof),
        .out_pixel(char_gen_out_pixel),

        .cpu_clk   (cpu_clk),
        .cpu_reset_(cpu_reset_),

        .sbuf_wr   (sbuf_wr),
        .sbuf_rd   (sbuf_rd),
        .sbuf_addr (sbuf_addr),
        .sbuf_wdata(sbuf_wdata),
        .sbuf_rdata(sbuf_rdata)
    );

    vo u_vo(
        .vo_clk   (vo_clk),
        .vo_reset_(vo_reset_),

        .in_vsync(char_gen_out_vsync),
        .in_req  (char_gen_out_req),
        .in_eol  (char_gen_out_eol),
        .in_eof  (char_gen_out_eof),
        .in_pixel(char_gen_out_pixel),

        .vo_blank_(vo_blank_),
        .vo_vsync (vo_vsync),
        .vo_hsync (vo_hsync),
        .vo_r     (vo_r),
        .vo_g     (vo_g),
        .vo_b     (vo_b)
    );

    //============================================================
    //
    //  SPI
    //
    //============================================================

    assign spi_cs_ = cntr[5];
    assign spi_clk = cntr[5];
    assign spi_dq0 = cntr[5];
    assign spi_dq1 = cntr[5];

    //============================================================
    //
    //  SDRAM
    //
    //============================================================

    assign sdram_ck  = osc_clk;
    assign sdram_ck_ = !osc_clk;

    //============================================================
    //
    // IDT Configuration
    // CLK1 = iclk * 2 * (V + 8) / (R + 2) / <S>
    //
    //============================================================

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

    // Input: 100MHz
    // Output: 148.50MHz
    // Ratio: 49/33
    // 100 * 2 * (41+8) / (31+2) / 2
    assign idt_r   = 7'd31;
    assign idt_v   = 9'd41;

    assign idt_s   = 3'b001;    // CLK1 output divide = 2

    assign idt_f   = 2'b10;     // CLK2 = OFF
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

    assign idt_iclk = osc_clk;

    //============================================================
    //
    //
    // AUDIO
    //
    //============================================================

    assign audio_mclk = 1'b0;

    // I2C interface
//    assign audio_sclk = 1'bz;
//    assign audio_sdin = 1'bz;

    wire i2c_scl_oe, i2c_sda_oe;
    assign i2c_scl_oe = gpio_oe[2] && !gpio_do[2];
    assign i2c_sda_oe = gpio_oe[3] && !gpio_do[3];

    pad_inout u_audio_scl (.pad(audio_sclk), .pad_ena(i2c_scl_oe), .to_pad(1'b0), .from_pad(gpio_di[2]));
    pad_inout u_audio_sda (.pad(audio_sdin), .pad_ena(i2c_sda_oe), .to_pad(1'b0), .from_pad(gpio_di[3]));

    //============================================================
    //
    //
    // SOC
    //
    //============================================================


    pll u_cpu_pll(.osc_clk(osc_clk), .clk(cpu_clk) );
    reset_gen u_cpu_reset_gen( .clk(cpu_clk), .reset_(cpu_reset_) );

    soc #(
        .LOCAL_RAM_SIZE_KB(8),
        .NR_GPIOS(8)
    )
    u_soc (
        .clk(cpu_clk),
        .reset_(cpu_reset_),

        .gpio_oe(gpio_oe),
        .gpio_do(gpio_do),
        .gpio_di(gpio_di),

        .sbuf_wr   (sbuf_wr),
        .sbuf_rd   (sbuf_rd),
        .sbuf_addr (sbuf_addr),
        .sbuf_wdata(sbuf_wdata),
        .sbuf_rdata(sbuf_rdata)
    );


endmodule

