
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

