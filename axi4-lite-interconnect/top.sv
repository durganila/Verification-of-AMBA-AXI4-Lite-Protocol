///////////////////////////////////////////////////////////////////////////////////////////
// Name         : testFactory.sv                                                                
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 06/02/2020                                                                  
// Version      : 1  
// Modified By  :                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

//Packages and includes:
import axi_lite_pkg::*;

module top();

  logic  aclk;                            // var for clock
  logic  areset_n;                        // var for reset

  // TODO: Get from plusargs
  string test_type       = "full_random";      // var for test type
  logic  debugMode       = 1'b1;               // var for debug mode
  int    numTransactions = 10;                 // var for number of transactions

  //Instantiate the BFM:
  axi_lite_if bfm0(.aclk(aclk), .areset_n(areset_n));

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
    InitialReset();
    env_h = new(bfm0, test_type, debugMode, numTransactions);
    env_h.execute();
  end

  initial begin
    #10000;
    $finish();
  end

  task InitialReset();
    areset_n = 0;
    repeat(2) @(posedge aclk);
    areset_n = 1;
  endtask

endmodule
