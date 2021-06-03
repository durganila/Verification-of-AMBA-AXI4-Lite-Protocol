///////////////////////////////////////////////////////////////////////////////////////////
// Name         : environment.sv 
// Description  :                                                               
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 05/18/2021                                                                  
// Version      : 1                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

`include "axi_lite_coverage.sv"

class environment;

	virtual axi_lite_if bfm0;					// virtual interface
	string 				testType;				// var for test type
	logic 				debugMode;				// var for debug mode
	int 				numTransactions;		// var number of transactions

	generator 			generator_h; 			// stimulus generator handler 
	driver 				driver_h;				// driver handler	
	monitor 			monitor_h;				// monitor handler
	scoreboard 			scoreboard_h;			// scoreboard handler
	axi_lite_coverage 	coverage_h;				// coverage handler
	testFactory			testFactory_h;			// test factory handler
	
	// mailbox for connection between generator and driver
	mailbox mb_generator2driver = new(); 		

	// mailbox for connection between monitor and scoreboard
	mailbox mb_monitor2scoreboard = new(); 		

	// constructor
	function new (virtual axi_lite_if bfm0, string testType, logic debugMode, int numTransactions );
		this.bfm0 			 = bfm0;
		this.testType 		 = testType;	
		this.debugMode		 = debugMode;
		this.numTransactions = numTransactions;
	endfunction : new
	
	task execute();
		generator_h 	= testFactory_h.Get_TestType(testType, mb_generator2driver, debugMode, numTransactions);
		driver_h 		= new(mb_generator2driver, bfm0, debugMode);
		monitor_h 		= new(mb_monitor2scoreboard, bfm0, debugMode);
		scoreboard_h 	= new(mb_monitor2scoreboard, bfm0);
		coverage_h 		= new(bfm0);

		// run all the execute tasks concurrently
		fork
			monitor_h.execute();
			scoreboard_h.execute();
			generator_h.execute();
			driver_h.execute();
			coverage_h.execute();
		join
	endtask : execute

endclass : environment