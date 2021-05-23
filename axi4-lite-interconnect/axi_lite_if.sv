import axi_lite_pkg::*;

interface axi_lite_if (
			input logic aclk,
			input areset_n);

	// Read Address Channel
	addr_t araddr;
	logic arvalid;
	logic arready;

	// Read Data Channel
	data_t rdata;
	resp_t rresp;
	logic rvalid;
	logic rready;

	// Write Address Channel
	addr_t awaddr;
	logic awvalid;
	logic awready;

	// Write Data Channel
	data_t wdata;
	strb_t wstrb;
	logic wvalid;
	logic wready;

	// Write Response Channel
	resp_t bresp;
	logic bvalid;
	logic bready;
	
	/*// Buffer Scan (only for emulation verification)
	logic start_dump;
	data_t slave_buff_data;
	addr_t slave_buff_addr;
	logic dump_ack;*/

	//data_t [31:0] buff;

	modport master (
		input aclk,
		input areset_n,
		input arready,
		input rdata, rresp, rvalid,
		input bresp, bvalid,
		input awready,
		input wready,
		output araddr, arvalid, 
		output rready,
		output awaddr, awvalid, 
		output 	wdata, wstrb, wvalid, 
		output bready
	);

	modport slave (
		input aclk,
		input areset_n,
		input rready,
		input bready
		input araddr, arvalid,
		input awaddr, awvalid,
		input wdata, wstrb, wvalid,
		output arready,
		output rdata, rresp, rvalid, 
		output awready,
		output wready,
		output bresp, bvalid      //output dump_ack, output slave_buff_addr, output slave_buff_data, input start_dump
	);

endinterface
