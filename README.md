# Pano Logic Zero Client G1

## Introduction

The project log can be found [here](https://hackaday.io/project/136227-panologic-zero-client-g1).

This project starts with the work of The Cranky Sysadmin, and will build on top of that:
 
 * [In Search of FPGAs or Pano Logic Generation 1 Teardown](http://blog.2gn.com/electronics/in-search-of-fpgas-or-pano-logic-generation-1-teardown/)
 * [Exploiting the FPGA in the Pano Logic Zero Client](http://blog.2gn.com/electronics/exploiting-the-fpga-in-the-pano-logic-zero-client/)
 * [More Reverse Engineering of the Pano Logic Thin Client G1](http://blog.2gn.com/electronics/more-reverse-engineering-of-the-panologic-thin-client-g1-2/)
 
 ## Related Projects
 
 * [Pano Man](https://github.com/skiphansen/pano_man) implements the original PacMan on Pano G1

## Main Board

![Main Board PCB](./doc/mainboard_marked.jpg)

## FPGA Connections

The pin constraint file can be found [here](shared/top.ucf).

## JTAG Connector

6 pin connector J8 is the JTAG connector. When the IO connectors are at the bottom, J8 is located
at the top left of the Xilinx chip, and pin 1 is the one on the left.

The pin order does NOT follow the one of my Digilent clone.

Pinout is as follows:

1. VCC
2. TDI
3. TMS
4. TDO
5. TCK
6. GND

## SPI Connector

1. GND
2. CS#
3. DQ1 (MISO)
4. CLK
5. DQ0 (MOSI)
6. VCC

The SPI pins are used to configure the bitstream at power-up. After that, they become user IO.

To program the SPI, use the "Short to Program" jumper and attach SPI programmer to the connector. The
"Short to Program" jumper pulls the PROG\_B pin of the FPGA to ground, which forces all FPGA IOs into
Hi-Z.

During development, since the JTAG is already connected anyway, it's easier to program the SPI flash through
JTAG.

The procedure is simply: Using Impact, create an 'mcs' file that contains the bitstream in SPI programming format. Then use Impact
to program that file into the SPI flash through JTAG.

Detailed instructions are here:

* [Xilinx - Introduction to Indirect Programming – SPI or BPI Flash Memory](https://www.xilinx.com/support/documentation/sw_manuals/xilinx11/pim_c_introduction_indirect_programming.htm)
* [Xilinx - Programming an SPI or BPI Flash Memory through an FPGA](https://www.xilinx.com/support/documentation/sw_manuals/xilinx11/pim_p_configure_spi_bpi_through_fpga.htm)

## Board to Board Connector

![Board 2 Board Connector Footprint](doc/board2board_conn_footprint.jpg)

A\* = inward facing side of the connector

A'\* = outward facing side of the connector

| Pin   | Function          | FPGA | Misc |
|-------|-------------------|------|------|
| A1    | GND               |      |
| A2    | VGA SCL           | D4   | 
| A3    | GND               |      |
| A4    | VGA SDA           | G3   | 
| A5    | GND               |      |
| A6    | VGA B analog      |      |
| A7    | GND               |      |
| A8    | VGA G analog      |      |
| A9    | VGA VSYNC         | D1   |
| A10   | VGA R analog      |      |
| A11   | VGA HSYNC         | C2   |
|       |                   |      |
| A14   | GND               |      |
| A15   | SMSC USB2513 USBDN2\_DP pin 4   | |
| A16   | SMSC USB2513 USBDN2\_DM pin 3   | |
| A17   | GND               |      |
| A18   | SMSC USB2513 USBDN3\_DM pin 6   | E5   |
| A19   | SMSC USB2513 USBDN3\_DP pin 7   | |
| A20   | GND               |      |
|       |                   |      |
| A'1   | GND               |      |
| A'2   | FPGA VCCO 3.3V    | F3, K1, H7, ... |
| A'3   | GND               |      |
| A'4   | ?                 |      | 1.8V | 
| A'5   | GND               |      |
| A'6   | VGA PWR (5V)      |      |
| A'7   | GND               |      |
| A'8   | Button            | R7   | (Pressed is 3.3V) | 
| A'9   | LED Green         | H1   |
| A'10  | LED Blue          | L1   |
| A'11  | LED Red           | L3   | 4.8V (but 3.3V at FPGA)
|       |                   |      |
| A'14  | GND               |      |
| A'15  | ?                 |      | 3.1V
| A'16  | ?                 | B7   | 2.45V
| A'17  | GND               |      |
| A'18  | ?                 |      | 1.2V
| A'19  | ?                 |      | 2.75V
| A'20  | GND               |      |

Notes:
* VGA/SDA: Connected to top right pin of U23
* VGA/SCL: Connected to bottom right pin of U23
* U23: level shifters?

## Resources

* [Xilinx Spartan-3E XCS3S1600E](http://www.xilinx.com/support/documentation/data_sheets/ds312.pdf)

    1600K system gates, 231K distribute RAM bits, 648K block RAM bits, 36 18x18 multipliers.

    Supported by Xilinx ISE 14.7 Free edition!

    Full component name: XC3S1600E-FGG320 320 package. ([Drawing](https://www.xilinx.com/support/documentation/package_specs/fg320.pdf))
    Speed grade 5, Commercial.

    Ordering code: XC3S1600E-5-FGG320C 

    FG320 footprint is on page 208 of DS312.

    Available at [Digikey](https://www.digikey.com/product-detail/en/xilinx-inc/XC3S1600E-4FGG320C/122-1481-ND/1091709)

    Useful Guides:
    * [DS312: Spartan-3E FPGA Family: Functional Description](http://www.xilinx.com/support/documentation/data_sheets/ds312.pdf)
    * [UG331: Spartan-3 Generation FPGA User Guide](https://www.xilinx.com/support/documentation/user_guides/ug331.pdf)

* [Micrel KSZ8721BL 10/100BASE-TX/FX Ethernet MII Physical Layer Transceiver](https://www.mouser.com/ProductDetail/Microchip-Technology-Micrel/KSZ8721BL?qs=kh6iOki%2FeLEk0sRQ0%2FKccQ%3D%3D)

    10/100BASE-TX/FX MII Physical Layer Transceiver

    Information regarding Ethernet has been gathered [here](Ethernet.md)

* [Wolfson WM8750BL](https://www.cirrus.com/products/wm8750/)

    Codec with Speaker Driver 

    The control interface is configured to I2C (2-wire) mode, with the 8-bit address set to 0x34.

* [IDT ICS307M-02LF](https://media.digikey.com/pdf/Data%20Sheets/IDT/ICS307-01,02_RevH.pdf)

    Programmable clock source

* [NXP ISP1760](http://www.mouser.com/ds/2/302/ISP1760_3-197088.pdf)

    Hi-Speed Universal Serial Bus host controller for embedded applications with built-in 3-port HUB. However, for some reason
    there is a separate 3-port HUB on the board, so I assume that only one port is used. (Why?)

* [SMSC USB2513](http://www.mouser.com/catalog/specsheets/2513.pdf)

    USB 2.0 High-Speed 3-Port Hub Controller

    All 3 USB ports are connect to this controller.

* [Micron M25P80](http://www.micron.com/~/media/Documents/Products/Data%20Sheet/NOR%20Flash/Serial%20NOR/M25P/M25P80.pdf)
 
    Serial Flash Embedded Memory, 8Mbit.

    A non-compressed XC3S1600E bitstream needs 5,969,696 bits ([UG332](https://www.xilinx.com/support/documentation/user_guides/ug332.pdf), Table 1-4),
    which leaves ~2Mbit (512KByte) free for other uses.

    It should be possible to replace the M25P80 with a larger version, such as the 16Mbit M25P16. These parts are end-of-life and not available
    anymore on Mouser or Digikey, but [Adesto Tech](http://www.adestotech.com/wp-content/uploads/M25P-SERIES-CONVERSION-GUIDE-08_14_1.pdf) makes
    compatible replacements.

    Useful guides:
    * [UG332 - Spartan-3 Generation Configuration User Guide](https://www.xilinx.com/support/documentation/user_guides/ug332.pdf)
    * [XAPP951 - Configuring Xilinx FPGAs with SPI Serial Flash](https://www.xilinx.com/support/documentation/application_notes/xapp951.pdf)
    * [Using Serial Flash on the Xilinx Spartan-3E Starter Board](http://wwwpub.zih.tu-dresden.de/~ss17/wiki/www.mr.inf.tu-dresden.de/wiki/s3esk_serial_flash05b5.pdf?fileId=319)

* [TI THS8135](http://www.ti.com/lit/ds/symlink/ths8135.pdf)

    10-BIT 240-MSPS VIDEO DAC

    Chip operates in general DAC mode. No analog SYNC pulses are generated because HSYNC and VSYNC are separate digital signals for VGA.

* [Micron Mobile Low-Power DDR SDRAM MT46H8M32LFB5-6](https://www.micron.com/~/media/documents/products/data-sheet/dram/mobile-dram/low-power-dram/lpddr/30-series/t36n_256mb_mobile_lpddr_sdram.pdf)

    [Product page](https://www.micron.com/parts/dram/mobile-ddr-sdram/mt46h8m32lfb5-6)

    Chip has 'D9FSD' marker, which is the FPBA code for MT46H8M32LFB5-6:A.

    2 Meg x 32 x 4 Banks = 8M x 32-bits or 32MByte.

    166MHz clock. Max BW: 2 x 166 x 32 = 10.6 Gbit/s or 1.32 GByte/s. (24bpp 1080p@60 ~ 3Gbps)

    The Xilinx ISE MIG tool only supports 8x and 16x regular DDR, not 32x LPDDR. So it looks like a custom DDR controller must be used for that?

    Information regarding DDR has been gathered [here](DDR.md).

* [Discussion on Hackaday](https://hackaday.com/2013/01/11/ask-hackaday-we-might-have-some-fpgas-to-hack/)

    Includes JTAG pin connector layout 

