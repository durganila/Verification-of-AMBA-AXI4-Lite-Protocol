//Packages and includes:
import axi_lite_pkg::*;

module top();

  logic  aclk;
  logic  areset_n;

  string test_type = "All";

  //Instantiate the BFM:
  axi_lite_if bfm0(.aclk(aclk), .areset_n(areset_n));
  axi_lite_if bfm1(.aclk(aclk), .areset_n(areset_n));

  //Instantiate the DUT master and slave:

	axi_lite_master #(addr0) master0 (
		      .m_axi_lite(bfm0.master)
	);

	axi_lite_master #(addr1) master1 (
		.m_axi_lite(bfm1.master)
	);

	axi_lite_slave slave0 (
		.s_axi_lite(bfm0.slave)
	);

	axi_lite_slave slave1 (
		.s_axi_lite(bfm1.slave)
	);

	axi_lite_interconnect axi_lite_ic (.aclk(aclk), .areset_n(areset_n),
		.axim('{bfm0.master, bfm1.master}), .axis('{bfm0.slave, bfm1.slave})
	);

  //Object handles:
  environment env_h;

//Start the clock:
  initial begin
    aclk = 0;
    forever #5 aclk = ~aclk;
  end

  initial begin
    areset_n = 0;
    #20 areset_n = 1;

    env_h = new(bfm0, bfm1, test_type);
    
    env_h.execute();

  end

endmodule
