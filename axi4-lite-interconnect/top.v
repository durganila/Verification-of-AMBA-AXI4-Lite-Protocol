//Packages and includes:
import axi_lite_pkg::*;
`include "axi4_env.sv"


module top();

  logic aclk, areset_n;
  logic start_read_0, start_read_1;   //to initiate read transaction
  logic start_write_0, start_write_1; // to initiate write transaction
  addr_t addr_0, addr_1;  //address values for 2 masters
  data_t data_0, data_1; //data values 
  

  //Instantiate the BFM:
  axi4_lite_if bfm(.aclk(aclk), .areset_n(areset_n));

  //Instantiate the DUT master and slave:

  axi_lite_if axi_lite_if_m0();
	axi_lite_if axi_lite_if_m1();
	axi_lite_if axi_lite_if_s0();
	axi_lite_if axi_lite_if_s1();

	axi_lite_master #(addr0) master0 (
		.aclk(aclk), .areset_n(areset_n),
		.m_axi_lite(axi_lite_if_m0),
      		.start_read(start_read_0), .start_write(start_write_0), 
      		.addr(addr_0), .data(data_0)
	);

	axi_lite_master #(addr1) master1 (
		.aclk(aclk), .areset_n(areset_n),
		.m_axi_lite(axi_lite_if_m1),
      		.start_read(start_read_1), .start_write(start_write_1),
      		.addr(addr_1), .data(data_1)
	);

	axi_lite_slave slave0 (
		.aclk(aclk), .areset_n(areset_n),
		.s_axi_lite(axi_lite_if_s0)
	);

	axi_lite_slave slave1 (
		.aclk(aclk), .areset_n(areset_n),
		.s_axi_lite(axi_lite_if_s1)
	);

	axi_lite_interconnect axi_lite_ic (
		.aclk(aclk), .areset_n(areset_n),
		.axim('{axi_lite_if_m0, axi_lite_if_m1}), .axis('{axi_lite_if_s0, axi_lite_if_s1})
	);

  //Object handles:
  axi4_environment axi_env;

//Start the clock:
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    areset_n = 0;
    #20 areset_n = 1;

    axi4_env = new(bfm);
    
    axi4_env.run();
    #10000
    $display("Testing finished!");

  end

endmodule
