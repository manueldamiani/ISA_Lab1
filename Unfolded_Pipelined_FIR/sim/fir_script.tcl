vcom -93 -work ./work ../src/constants.vhd
vcom -93 -work ./work ../src/regn.vhd
vcom -93 -work ./work ../src/gr13_fir.vhd
#vlog -work ./work ../netlist/gr13_fir.v
#vlog -work ./work ../innovus/gr13_fir.v
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_gen.vhd
vcom -93 -work ./work ../tb/data_save.vhd
vlog -work ./work ../tb/tb_fir.v
