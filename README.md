# Pano Logic Zero Client G1

## Introduction

The project log can be found [here](https://hackaday.io/project/136227-panologic-zero-client-g1).

This project starts with the work of The Cranky Sysadmin, and will build on top of that:
 
 * [In Search of FPGAs or Pano Logic Generation 1 Teardown](http://blog.2gn.com/electronics/in-search-of-fpgas-or-pano-logic-generation-1-teardown/)
 * [Exploiting the FPGA in the Pano Logic Zero Client](http://blog.2gn.com/electronics/exploiting-the-fpga-in-the-pano-logic-zero-client/)
 * [More Reverse Engineering of the Pano Logic Thin Client G1](http://blog.2gn.com/electronics/more-reverse-engineering-of-the-panologic-thin-client-g1-2/)

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
3. MOSI
4. CLK
5. MISO
6. VCC

## Board to Board Connector

* A1  : GND
* A2  : ?
* A3  : GND
* A4  : ?
* A5  : GND
* A6  : VGA B analog
* A7  : GND
* A8  : VGA G analog
* A9  : VGA VSYNC - FPGA D1
* A10 : VGA R analog
* A11 : VGA HSYNC - FPGA C2 

* A14 : GND
* A15 : ? 
* A16 : USB DN / SMSC USB2513 USBDN2\_DM pin 3
* A17 : GND
* A18 : FPGA E5
* A19 : USB DP / SMSC USB2513 USBDN3\_DP pin 7
* A20 : GND

* A'1  : GND
* A'2  : FPGA VCCO: F3, K1, H7, ...
* A'3  : GND
* A'4  : GND
* A'5  : GND
* A'6  : VGA PWR (5V)
* A'7  : GND
* A'8  : FPGA R7 
* A'9  : FPGA H1 / LED Green
* A'10 : ?
* A'11 : ?

* A'14 : GND
* A'15 : ?
* A'16 : FPGA B7
* A'17 : GND
* A'18 : ? 
* A'19 : ?
* A'20 : GND

* VGA/SDA: Connected to top right pin of U23
* VGA/SCL: Connected to bottom right pin of U23
* U23: level shifters?

## Resources

* [Xilinx Spartan-3E XCS3S1600E](http://www.xilinx.com/support/documentation/data_sheets/ds312.pdf)

    1600K system gates, 231K distribute RAM bits, 648K block RAM bits, 36 multipliers.

    Supported by Xilinx ISE 14.7 Free edition!

    Full component name: XC3S1600E-FGG320 320 package. ([Drawing](https://www.xilinx.com/support/documentation/package_specs/fg320.pdf))
    Speed grade 5, Commercial.

    Ordering code: XC3S1600E-5-FGG320C 

    FG320 footprint is on page 208 of DS312.

    Available at [Digikey](https://www.digikey.com/product-detail/en/xilinx-inc/XC3S1600E-4FGG320C/122-1481-ND/1091709)

* [Micrel KSZ8721BL 10/100BASE-TX/FX MII Physical Layer Transceiver](https://www.mouser.com/ProductDetail/Microchip-Technology-Micrel/KSZ8721BL?qs=kh6iOki%2FeLEk0sRQ0%2FKccQ%3D%3D)

    10/100BASE-TX/FX MII Physical Layer Transceiver

* [Wolfson WM8750BL](https://www.cirrus.com/products/wm8750/)

    Codec with Speaker Driver 

* [IDT ICS307M-02LF](https://media.digikey.com/pdf/Data%20Sheets/IDT/ICS307-01,02_RevH.pdf)

    Programmable clock source

* [NXT ISP1760](http://www.mouser.com/ds/2/302/ISP1760_3-197088.pdf)

    Hi-Speed Universal Serial Bus host controller for embedded applications

* [SMSC USB2513](http://www.mouser.com/catalog/specsheets/2513.pdf)

    USB 2.0 High-Speed 3-Port Hub Controller

* [Micron M25P80](http://www.micron.com/~/media/Documents/Products/Data%20Sheet/NOR%20Flash/Serial%20NOR/M25P/M25P80.pdf)
 
    Serial Flash Embedded Memory

* [TI THS8135](http://www.ti.com/lit/ds/symlink/ths8135.pdf)

    10-BIT 240-MSPS VIDEO DAC

* [Micron Automotive LPDDR SDRAM](http://www.micron.com/~/media/Documents/Products/Data%20Sheet/DRAM/Mobile%20DRAM/Low-Power%20DRAM/LPDDR/60-series/t67m_512mb_embedded_lpddr.pdf)

* [Discussion on Hackaday](https://hackaday.com/2013/01/11/ask-hackaday-we-might-have-some-fpgas-to-hack/)

    Includes JTAG pin connector layout 

