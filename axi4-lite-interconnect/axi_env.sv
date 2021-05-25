import axi_lite_pkg::*;

class environment;

	virtual axi_lite_if bfm0, bfm1;
	string testType = "full_random";		// get which test type to run TODO: get from plusargs

	generator 			generator_h; 		// stimulus geenrator handler 
	driver 				driver_h;
	monitor 			monitor_h;
	scoreboard 			scoreboard_h;
	axi_lite_coverage 	coverage_h;
	testFactory		testFactory_h;
	
	mailbox mb_generator2driver = new(); // mailbox for connection between generator and driver

	mailbox mb_monitor2scoreboard = new(); // mailbox for connection between monitor and scoreboard

	function new (virtual axi_lite_if b0,virtual axi_lite_if b1, string testType );
		this.bfm0 		= b0;
		this.bfm1 		= b1;
		this.testType 	= testType;	
	endfunction : new
	
	task execute();
		//tester_h = new(bfm0, bfm1);	// instantiating the object of axi4_tester class and storing it in the same class handle
		//tester_h.execute();		// calling the execute task of axi4_tester class

		generator_h 	= testFactory_h.Get_TestType(testType, mb_generator2driver);
		driver_h 		= new(mb_generator2driver, bfm0, bfm1);
		monitor_h 		= new(mb_monitor2scoreboard, bfm0, bfm1);
		scoreboard_h 	= new(mb_monitor2scoreboard, bfm0, bfm1);
		coverage_h 		= new(bfm0, bfm1);

		fork
			begin
			end
			begin
				generator_h.execute();
			end
		join
	endtask : execute

endclass : environment