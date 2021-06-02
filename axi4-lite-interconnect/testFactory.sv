///////////////////////////////////////////////////////////////////////////////////////////
// Name         : testFactory.sv                                                                
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
		deterministic_test deterministic_test_h;

        case (testType)
            "full_random" 		: begin
									fully_random_test_h = new(mb_generator2driver, debugMode, numTransactions);
									return fully_random_test_h;
								  end
			"deterministic_test": 	begin
									deterministic_test_h = new(mb_generator2driver, debugMode, numTransactions);
									return deterministic_test_h;
								  end
            default				: begin
									$fatal("Invalid test type!!");
									$finish();
								  end
        endcase
    endfunction
endclass