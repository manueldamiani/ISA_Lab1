analyze -f vhdl -lib WORK ../src/constants.vhd
analyze -f vhdl -lib WORK ../src/regn.vhd
analyze -f vhdl -lib WORK ../src/gr13_fir.vhd
set power_preserve_rtl_hier_names true
elaborate gr13_fir -arch bhv -lib WORK > ./elaborate.txt
create_clock -name MY_CLK -period 5.52 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
compile
report_timing > ./report_timing.txt
report_area > ./report_area.txt
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/gr13_fir.sdf
write -f verilog -hierarchy -output ../netlist/gr13_fir.v
write_sdc ../netlist/gr13_fir.sdc
