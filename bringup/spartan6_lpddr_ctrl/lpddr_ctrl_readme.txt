
The design files are located at
/home/tom/projects/panologic/bringup/spartan6_lpddr_ctrl:

   - lpddr_ctrl.veo:
        veo template file containing code that can be used as a model
        for instantiating a CORE Generator module in a HDL design.

   - lpddr_ctrl.xco:
       CORE Generator input file containing the parameters used to
       regenerate a core.

   - lpddr_ctrl_flist.txt:
        Text file listing all of the output files produced when a customized
        core was generated in the CORE Generator.

   - lpddr_ctrl_readme.txt:
        Text file indicating the files generated and how they are used.

   - lpddr_ctrl_xmdf.tcl:
        ISE Project Navigator interface file. ISE uses this file to determine
        how the files output by CORE Generator for the core can be integrated
        into your ISE project.

   - lpddr_ctrl directory.

In the lpddr_ctrl directory, three folders are created:
   - docs:
        This folder contains user guide.

   - example_design:
        This folder includes the design with synthesizable test bench.

   - user_design:
        This folder includes the design without test bench modules.

The example_design and user_design folders contain several other folders
and files. All these output folders are discussed in more detail in
Spartan-6 FPGA Memory Controller user guide (ug388.pdf) located in docs folder.
    