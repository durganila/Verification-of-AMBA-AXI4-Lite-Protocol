import axi_lite_pkg::*;

class environment;

	virtual axi_lite_if bfm0;
	string testType;
	logic debugMode;

	generator 			generator_h; 		// stimulus generator handler 
	driver 				driver_h;
	monitor 			monitor_h;
	scoreboard 			scoreboard_h;
	axi_lite_coverage 	coverage_h;
	testFactory			testFactory_h;
	
	mailbox mb_generator2driver = new(); // mailbox for connection between generator and driver

	mailbox mb_monitor2scoreboard = new(); // mailbox for connection between monitor and scoreboard

	function new (virtual axi_lite_if bfm0, string testType, logic debugMode );
		this.bfm0 		= bfm0;
		this.testType 	= testType;	
		this.debugMode		= debugMode;
	endfunction : new
	
	task execute();
		//tester_h = new(bfm0, bfm1);	// instantiating the object of axi4_tester class and storing it in the same class handle
		//tester_h.execute();		// calling the execute task of axi4_tester class

		generator_h 	= testFactory_h.Get_TestType(testType, mb_generator2driver, debugMode);
		driver_h 		= new(mb_generator2driver, bfm0, debugMode);
		monitor_h 		= new(mb_monitor2scoreboard, bfm0, debugMode);
		scoreboard_h 	= new(mb_monitor2scoreboard, bfm0);
		coverage_h 		= new(bfm0);

		fork
			begin
				//scoreboard_h.execute();
			end
			begin
				generator_h.execute();
				driver_h.execute();
			end
		join
	endtask : execute

endclass : environment