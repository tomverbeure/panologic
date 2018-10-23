
* [The Love/Hate Relationship with DDR SDRAM Controllers](https://www.design-reuse.com/articles/13805/the-love-hate-relationship-with-ddr-sdram-controllers.html)

    Interesting the history of DLL, DQS etc. in SDRAMs.

* [Micron TN4615 - Low-Power Versus Standard DDR SDRAM](https://www.micron.com/~/media/documents/products/technical-note/dram/tn4615.pdf)

* [UG331 - Spartan-3 Generation FPGA User Guide](https://www.xilinx.com/support/documentation/user_guides/ug331.pdf)

    Information about [DCMs](https://www.xilinx.com/support/documentation/user_guides/ug331.pdf#page=65&zoom=100,0,194), 
    [DDR IOs](https://www.xilinx.com/support/documentation/user_guides/ug331.pdf#page=328&zoom=100,0,408) etc.

* [SpinalHDL Example SDRAM Controller](https://github.com/SpinalHDL/SpinalHDL/tree/master/lib/src/main/scala/spinal/lib/memory/sdram)

    Doesn't do DDR. Only SDR.

* [FreeCores Spartan 3E DDR Controller](https://github.com/freecores/sdram_controller)

    Uses DDR IOs and DCM to create phase clocks, but doesn't use DQS on input: that just gets ignored. Probably still good enough for slower speeds?

* [Implementing an all-digital PHY and delay-locked loop for high-speed DDR2/3 memory interfaces](https://www.edn.com/design/integrated-circuit-design/4312975/Implementing-an-all-digital-PHY-and-delay-locked-loop-for-high-speed-DDR2-3-memory-interfaces)

    Talks about master/slave DLL configuration.

* [Lattice LPDDR SDRAM Controller](https://www.latticesemi.com/en/Products/DesignSoftwareAndIP/IntellectualProperty/IPCore/IPCores01/LPDDRSDRAMController)

    This data sheet of an LPDDR controller talks about read retraining due to lack of DLL inside the SDRAM. Every so many auto-refresh cycles, it does
    a bunch of reads and writes to a reserved location in DRAM location to retrain the settings.

* [Lattice DDR Interface Design Implementation White Paper](http://www.latticesemi.com/dynamic/view_document.cfm?document_id=9187)

    Talks about how to implement a DDR interface with DLLs etc.

* [High-Bandwidth Memory Interface Design](https://courses.soe.ucsc.edu/courses/ee222/Winter13/01/attachments/18097)

    Excellent course presentation about various aspects of DRAM design.

* Fastest and slowest tAC and tDQSCK timing diagrams for Micron chip: see page 84 of datasheet.

    When running at fastest speed, in both cases, the risign edge of DQS falls between the same CK rising edges (at the DRAM side!), but it's close.

    There needs to be logic to compensate for this. (This logic has nothing to do with adding a 90 degree delay to DQS to capture the data at the
    receive side.)

