///////////////////////////////////////////////////////////////////////////////////////////
// Name         : testFactory.sv 
// Description  : Allows user to select the testbench during run time                                                                
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 06/02/2020                                                                  
// Version      : 1  
// Modified By  :                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

class testFactory;
    static function generator Get_TestType (string testType, 
                                            mailbox mb_generator2driver, 
                                            logic debugMode, 
                                            int numTransactions);

        fully_random_test fully_random_test_h;
		deterministic_tests deterministic_test_h;

        case (testType)
            "full_random" 		: begin
									fully_random_test_h = new(mb_generator2driver, debugMode, numTransactions);
									if(debugMode) $display("Running Full Random Test");
									return fully_random_test_h;
								  end
			"deterministic"		: begin
									deterministic_test_h = new(mb_generator2driver, debugMode, numTransactions);
									if(debugMode) $display("Running Deterministic Test");
									return deterministic_test_h;
								  end
            default				: begin
									$fatal("Invalid test type!!");
									$finish();
								  end
        endcase
    endfunction
endclass