///////////////////////////////////////////////////////////////////////////////////////////
// Name         : testFactory.sv                                                                
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 06/02/2020                                                                  
// Version      : 1  
// Modified By  :                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

//Packages and includes:
import axi_lite_pkg::*;
`include "axi_env.sv"


module top();

  logic  aclk;                                  // var for clock
 // logic  areset_n;                              // var for reset

  string test_type       = "deterministic";     // var for test type
  logic  debugMode       = 1'b1;                // var for debug mode
  int    numTransactions = 10;                  // var for number of transactions

  //Instantiate the virtual interface:
  axi_lite_if bfm0(.aclk(aclk));

  //Instantiate the DUT master and slave:
	axi_lite_master #(addr0) master0 (
		      .m_axi_lite(bfm0.master)
	);

	axi_lite_slave slave0 (
		.s_axi_lite(bfm0.slave)
	);

  //Object handles:
  environment env_h;

//Start the clock:
  initial begin
    aclk = 0;
    forever #1 aclk = ~aclk;
  end

  initial begin
    // get runtime debug mode option
    if($value$plusargs("IS_DEBUG_MODE=%0b", debugMode))
      $display("IS_DEBUG_MODE is %d", debugMode);

    // get runtime test type
    if($value$plusargs("TEST_TYPE=%s", test_type))
      $display("TEST_TYPE is %s", test_type);

    // get runtime number of transactions
    if($value$plusargs("NUM_TRANSACTIONS=%d", numTransactions))
      $display("NUM_TRANSACTIONS is %d", numTransactions);

   bfm0.InitialReset();
    env_h = new(bfm0, test_type, debugMode, numTransactions);
    env_h.execute();
  end

  initial begin
    #10000;
    $finish();
  end


endmodule
