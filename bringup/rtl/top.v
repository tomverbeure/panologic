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
    output reg vo_vsync,
    output reg vo_hsync,
    output reg vo_blank_,
    inout  wire vo_scl,
    inout  wire vo_sda,
    output reg [7:0] vo_r,
    output reg [7:0] vo_g,
    output reg [7:0] vo_b
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

    //============================================================
    //
    // VGA Test Image Generator
    //
    //============================================================
    
//`define VGA640X480
`ifdef VGA640X480
    localparam h_active = 640;
    localparam h_fp = 16;
    localparam h_sync = 96;
    localparam h_bp = 48;
    localparam h_total = h_active + h_fp + h_sync + h_bp;
    localparam h_sync_positive = 0;

    localparam v_active = 480;
    localparam v_fp = 11;
    localparam v_sync = 2;
    localparam v_bp = 31;
    localparam v_total = v_active + v_fp + v_sync + v_bp;
    localparam v_sync_positive = 0;
`else
    localparam h_active = 1920;
    localparam h_fp = 88;
    localparam h_sync = 44;
    localparam h_bp = 148;
    localparam h_total = h_active + h_fp + h_sync + h_bp;
    localparam h_sync_positive = 1;

    localparam v_active = 1080;
    localparam v_fp = 4;
    localparam v_sync = 5;
    localparam v_bp = 36;
    localparam v_total = v_active + v_fp + v_sync + v_bp;
    localparam v_sync_positive = 1;
`endif

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

	always @(posedge vo_clk) begin

        if (col_cntr < h_total-1) begin
            col_cntr <= col_cntr + 1;
        end
        else begin
            col_cntr <= 0;

            if (line_cntr < v_total-1) begin
                line_cntr <= line_cntr + 1;
            end
            else begin
                line_cntr <= 0;
            end
        end

        if (!vo_reset_) begin
			col_cntr <= 0;
            line_cntr <= 0;
        end
	end
    
    wire cursor;
    wire vo_blank;
    assign vo_blank = (line_cntr >= v_active) || (col_cntr >= h_active);

	always @(posedge vo_clk) begin
        vo_blank_ <= !vo_blank;
		vo_hsync  <= (col_cntr  >= (h_active + h_fp) && col_cntr  < (h_active + h_fp + h_sync)) ^ !(h_sync_positive);
		vo_vsync  <= (line_cntr >= (v_active + v_fp) && line_cntr < (v_active + v_fp + v_sync)) ^ !(v_sync_positive);

		vo_r <= vo_blank ? 8'd0 : {8{cursor}} ^ {12{1'b1}};
		vo_g <= vo_blank ? 8'd0 : {8{cursor}} ^ line_cntr << 3;
		vo_b <= vo_blank ? 8'd0 : {8{cursor}} ^ col_cntr << 3;
	end

    localparam x_size = 50;
    localparam y_size = 50;

    reg [11:0] x_pos;
    reg [11:0] y_pos;
    reg x_dir;
    reg y_dir;

    assign cursor =    (col_cntr  >= x_pos && col_cntr  < x_pos+x_size) 
                    && (line_cntr >= y_pos && line_cntr < y_pos+y_size);

    always @(posedge vo_clk) begin
        if (col_cntr == 0 && line_cntr == v_active) begin
            if (x_dir == 1'b0) begin
                if (x_pos + x_size < h_active-1) begin
                    x_pos <= x_pos + 1;
                end
                else begin
                    x_dir <= 1'b1;
                end
            end
            else begin
                if (x_pos > 0) begin
                    x_pos <= x_pos - 1;
                end
                else begin
                    x_dir <= 1'b0;
                end
            end

            if (y_dir == 1'b0) begin
                if (y_pos + y_size < v_active-1) begin
                    y_pos <= y_pos + 1;
                end
                else begin
                    y_dir <= 1'b1;
                end
            end
            else begin
                if (y_pos > 0) begin
                    y_pos <= y_pos - 1;
                end
                else begin
                    y_dir <= 1'b0;
                end
            end
        end

        if (!vo_reset_) begin
            x_pos <= 0;
            y_pos <= 0;
            x_dir <= 1'b0;
            y_dir <= 1'b0;
        end
    end

    assign spi_cs_ = cntr[5];
    assign spi_clk = cntr[5];
    assign spi_dq0 = cntr[5];
    assign spi_dq1 = cntr[5];

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

    // I2C interface
    assign audio_sclk = 1'bz;
    assign audio_sdin = 1'bz;

endmodule

