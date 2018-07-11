
`ifdef VGA_TB
    localparam h_active = 96;
    localparam h_fp = 2;
    localparam h_sync = 5;
    localparam h_bp = 4;
    localparam h_sync_positive = 1;

    localparam v_active = 64;
    localparam v_fp = 2;
    localparam v_sync = 3;
    localparam v_bp = 4;
    localparam v_sync_positive = 1;
`endif

`ifdef VGA640X480
    localparam h_active = 640;
    localparam h_fp = 16;
    localparam h_sync = 96;
    localparam h_bp = 48;
    localparam h_sync_positive = 0;

    localparam v_active = 480;
    localparam v_fp = 11;
    localparam v_sync = 2;
    localparam v_bp = 31;
    localparam v_sync_positive = 0;
`endif

`ifdef VGA800X600
    localparam h_active = 800;
    localparam h_fp = 40;
    localparam h_sync = 128;
    localparam h_bp = 88;
    localparam h_sync_positive = 1;

    localparam v_active = 600;
    localparam v_fp = 1;
    localparam v_sync = 4;
    localparam v_bp = 23;
    localparam v_sync_positive = 1;
`endif


`ifdef VGA1024X768
    localparam h_active = 1024;
    localparam h_fp = 24;
    localparam h_sync = 136;
    localparam h_bp = 160;
    localparam h_sync_positive = 0;

    localparam v_active = 768;
    localparam v_fp = 3;
    localparam v_sync = 6;
    localparam v_bp = 29;
    localparam v_sync_positive = 0;
`endif

`ifdef VGA1440X900
    localparam h_active = 1440;
    localparam h_fp = 80;
    localparam h_sync = 152;
    localparam h_bp = 232;
    localparam h_sync_positive = 0;

    localparam v_active = 900;
    localparam v_fp = 1;
    localparam v_sync = 3;
    localparam v_bp = 28;
    localparam v_sync_positive = 1;
`endif

`ifdef VGA1680X1050
    localparam h_active = 1680;
    localparam h_fp = 104;
    localparam h_sync = 184;
    localparam h_bp = 288;
    localparam h_sync_positive = 0;

    localparam v_active = 1050;
    localparam v_fp = 1;
    localparam v_sync = 3;
    localparam v_bp = 33;
    localparam v_sync_positive = 1;
`endif

`ifdef VGA1080P
    localparam h_active = 1920;
    localparam h_fp = 88;
    localparam h_sync = 44;
    localparam h_bp = 148;
    localparam h_sync_positive = 1;

    localparam v_active = 1080;
    localparam v_fp = 4;
    localparam v_sync = 5;
    localparam v_bp = 36;
    localparam v_sync_positive = 1;
`endif

    localparam h_blank = h_fp + h_sync + h_bp;
    localparam h_total = h_blank + h_active;

    localparam v_blank = v_fp + v_sync + v_bp;
    localparam v_total = v_active + v_blank;

