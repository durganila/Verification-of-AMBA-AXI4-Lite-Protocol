import axi_lite_pkg::*;

class environment;

	virtual axi_lite_if bfm0, bfm1;

	tester	tester_h;	// declaring a tester class handle
	//create handles for coverage and checker too
	
	function new (virtual axi_lite_if b0,virtual axi_lite_if b1 );
		bfm0 = b0;
		bfm1 = b1;
	endfunction : new
	
	task execute();
		tester_h = new(bfm0, bfm1);	// instantiating the object of axi4_tester class and storing it in the same class handle
		tester_h.execute();		// calling the execute task of axi4_tester class
	endtask : execute

endclass : environment