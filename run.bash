vcs -timescale=1ns/1ps +vcs+flush+all +warn=all -debug_all -cm line+cond+tgl+fsm+branch+assert -cm_name test1 -sverilog testbench.sv -R
urg -dir ./simv.vdb -report cov -format both
