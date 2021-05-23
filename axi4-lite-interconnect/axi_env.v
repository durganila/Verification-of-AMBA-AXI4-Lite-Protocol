import axi_lite_pkg::*;

class axi4_environment;

	axi4_lite_bfm bfm;

	tester axi4_tester;		// declaring a tester class handle
	
	task run();
		axi4_tester = new(bfm);	// instantiating the object of axi4_tester class and storing it in the same class handle
		axi4_tester.execute();		// calling the execute task of axi4_tester class
	endtask : execute

endclass : axi4_environment