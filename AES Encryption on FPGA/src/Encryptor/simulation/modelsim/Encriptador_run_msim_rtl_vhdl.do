transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/ricki/Documents/TEC/4Semestre/QuartusProjects/AES/Encriptador/Top.vhd}

vcom -93 -work work {E:/ricki/Documents/TEC/4Semestre/QuartusProjects/AES/Encriptador/Modules/AddRound/AddRound_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  AddRound_tb

add wave *
view structure
view signals
run 200 ns
