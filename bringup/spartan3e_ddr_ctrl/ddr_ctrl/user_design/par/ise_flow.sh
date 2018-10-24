./rem_files.sh



echo Synthesis Tool: XST

mkdir "../synth/__projnav" > ise_flow_results.txt
mkdir "../synth/xst" >> ise_flow_results.txt
mkdir "../synth/xst/work" >> ise_flow_results.txt

xst -ifn ise_run.txt -ofn mem_interface_top.syr -intstyle ise >> ise_flow_results.txt
ngdbuild -intstyle ise -dd ../synth/_ngo -uc ddr_ctrl.ucf -p xc3s1600efg320-5 ddr_ctrl.ngc ddr_ctrl.ngd >> ise_flow_results.txt

map -intstyle ise -detail -cm speed -pr off -c 100 -o ddr_ctrl_map.ncd ddr_ctrl.ngd ddr_ctrl.pcf >> ise_flow_results.txt
par -w -intstyle ise -ol std -t 1 ddr_ctrl_map.ncd ddr_ctrl.ncd ddr_ctrl.pcf >> ise_flow_results.txt
trce -e 100 ddr_ctrl.ncd ddr_ctrl.pcf >> ise_flow_results.txt
bitgen -intstyle ise -f mem_interface_top.ut ddr_ctrl.ncd >> ise_flow_results.txt

echo done!
