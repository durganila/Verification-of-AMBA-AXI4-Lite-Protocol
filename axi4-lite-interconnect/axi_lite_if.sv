///////////////////////////////////////////////////////////////////////////////////////////
// Name         : axi_lite_if.sv 
// Description  :                                                               
// Authors      :   				                                 
// Date         : 05/29/2021                                                                  
// Version      : 1  
// Modified	By	: Amrutha | Durganila | Manjari                                                                    
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

interface axi_lite_if (
			input logic aclk
			);

	logic areset_n;
	logic start_write;
	logic start_read;
	addr_t addr;
	data_t data;

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
	

	modport master (
		input aclk,
		input areset_n,
		input start_read,
		input start_write,
		input addr,
		input data,
		input arready,
		input rdata, rresp, rvalid,
		input bresp, bvalid,
		input awready,
		input wready,
		output araddr, arvalid, 
		output rready,
		output awaddr, awvalid, 
		output wdata, wstrb, wvalid, 
		output bready
	);

	modport slave (
		input aclk,
		input areset_n,
		input rready,
		input bready,
		input araddr, arvalid,
		input awaddr, awvalid,
		input wdata, wstrb, wvalid,
		output arready,
		output rdata, rresp, rvalid, 
		output awready,
		output wready,
		output bresp, bvalid      //output dump_ack, output slave_buff_addr, output slave_buff_data, input start_dump
	);

	task InitialReset();
    areset_n = 0;
    repeat(2) @(posedge aclk);
    areset_n = 1;
  endtask 
  
endinterface
