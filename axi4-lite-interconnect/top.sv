//Packages and includes:
import axi_lite_pkg::*;

module top();

  logic  aclk;
  logic  areset_n;

  // TODO: Get from plusargs
  string test_type = "full_random";
  logic debugMode = 1'b1;

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
    forever #5 aclk = ~aclk;
  end

  initial begin
    //TODO: move to reset task
    areset_n = 0;
    #20 areset_n = 1;

    env_h = new(bfm0, test_type, debugMode);
    
    env_h.execute();
  end

  initial begin
    #1000;
    $finish();
  end

endmodule
