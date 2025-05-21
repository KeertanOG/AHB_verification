
compile:
	vlog -coveropt 3 +cover +acc +incdir+../ENV +incdir+../TEST ../TEST/AHB_pkg.sv ../TOP/AHB_tb_top.sv ../RTL/AHB_slave.svp
 
sim:
	@echo "Running with test $(TEST)"
	vsim -voptargs=+acc AHB_tb_top 
 
sim_cmd:
	@echo "Running in command-line mode with test"
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "run -all; exit;" 

run_regression:
	@echo "Running in command-line mode with test $(TEST)"
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall write_cover.ucdb;run -all; exit;" +WRITE +no_of_trans=2000
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall read_cover.ucdb;run -all; exit;" +READ +no_of_trans=2000
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall sim_rw_cover.ucdb;run -all; exit;" +SIM_RW +no_of_trans=2000
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall b2b_cover.ucdb;run -all; exit;" +BACK2BACK +no_of_trans=2000
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall random_cover.ucdb;run -all; exit;" +RANDOMIZE +no_of_trans=2000
	vsim -voptargs=+acc -coverage AHB_tb_top  -c -do "coverage save -onexit -directive -cvg -codeall random_cover.ucdb;run -all; exit;" +IDLE +no_of_trans=2000

merge_cover:
	vcover merge final_cover.ucdb write_cover.ucdb read_cover.ucdb sim_rw_cover.ucdb b2b_cover.ucdb random_cover.ucdb

vcover:
	vcover report -details -html -htmldir coverage final_cover.ucdb

