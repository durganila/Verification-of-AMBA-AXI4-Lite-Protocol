//Packages and includes:

`include "axi_env.sv"

import axi_lite_pkg::*;

module top();

  logic  start_read_0, start_read_1;   //to initiate read transaction
  logic  start_write_0, start_write_1; // to initiate write transaction
  addr_t addr_0, addr_1;  //address values for 2 masters
  data_t data_0, data_1; //data values 
  string test_type = "All";
  logic  aclk;
  logic  areset_n;

  //Instantiate the BFM:
  axi_lite_if bfm0(.aclk(aclk), .areset_n(areset_n));
  axi_lite_if bfm1(.aclk(aclk), .areset_n(areset_n));

  //Instantiate the DUT master and slave:

	axi_lite_master #(addr0) master0 (
            .aclk(aclk),
            .reset_n(reset_n),
		      .m_axi_lite(bfm0.master),
      		.start_read(start_read_0), .start_write(start_write_0), 
      		.addr(addr_0), .data(data_0)
	);

	axi_lite_master #(addr1) master1 (
		.m_axi_lite(bfm1.master),
      		.start_read(start_read_1), .start_write(start_write_1),
      		.addr(addr_1), .data(data_1)
	);

	axi_lite_slave slave0 (
		.s_axi_lite(bfm0.slave)
	);

	axi_lite_slave slave1 (
		.s_axi_lite(bfm1.slave)
	);

	axi_lite_interconnect axi_lite_ic (
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
