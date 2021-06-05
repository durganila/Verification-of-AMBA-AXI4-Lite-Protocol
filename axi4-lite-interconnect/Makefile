#Runtime Args
DEBUG ?= 0
NUM_TRANSACTIONS ?= 100

all: clean lib compile opt makedir runsim_randomtest run_deterministictest report

help:
	@echo -e "\nMakeInfo: This is a MakeFile running\nMakeInfo: Following commands present--\n"   
	@echo -e "	--	all		 				-> Simulates design and runs all related commands\n"
	@echo -e "	--	clean	 				-> Cleans all simulation related files\n"
	@echo -e "	--	lib		 				-> Forms work directory\n"
	@echo -e "	--	compile	 				-> Compiles testbench and DUT files\n"
	@echo -e "	--	runsim_randomtest		-> Runs simulation with random tests\n"
	@echo -e "	--	run_deterministictest 	-> Runs simulation with deterministic tests\n"

clean:
	rm -rf transcript vsim.wlf modelsim.ini coverage/func_cover_report_random.ucdb coverage/func_cover_report_deter.ucdb work
	@echo -e "\nMakeInfo: All simulation related files cleared\n"

lib: 
	vlib work
	vmap work work 
	@echo -e "\nMakeInfo: Work directory created!\n"
	
compile:
	vlog axi_lite_pkg.sv
	vlog ./DUT/axi_lite_master.sv
	vlog ./DUT/axi_lite_slave.sv
	vlog axi_lite_if.sv
	vlog ./TB/axi_env.sv
	vlog ./TB/top.sv
	
opt:
	vopt +acc +cover=bcesxf top -o top_optimized 

makedir:	
	mkdir -p coverage

runsim_randomtest:
	@echo -e "\nMakeInfo: Running fully random Simulation with Coverage......!\n"
	vsim -c -coverage -voptargs="+acc" +IS_DEBUG_MODE=$(DEBUG) +TEST_TYPE=full_random +NUM_TRANSACTIONS=$(NUM_TRANSACTIONS) top_optimized \
	-do "coverage save -onexit coverage/func_cover_report_random.ucdb; run -all; quit"

run_deterministictest:	
	@echo -e "\nMakeInfo: Running deterministic test Simulation with Coverage......!\n"
	vsim -c -coverage -voptargs="+acc" +IS_DEBUG_MODE=$(DEBUG) +TEST_TYPE=deterministic +NUM_TRANSACTIONS=$(NUM_TRANSACTIONS) top_optimized \
	-do "coverage save -onexit coverage/func_cover_report_deter.ucdb; run -all; quit"
	
report:
	vcover merge coverage/all_tests.ucdb coverage/func_cover_report_random.ucdb coverage/func_cover_report_deter.ucdb	
	vsim -cvgperinstance -viewcov coverage/all_tests.ucdb -do "coverage report -file final_report.txt -byfile -detail -noannotate -option -cvg"


