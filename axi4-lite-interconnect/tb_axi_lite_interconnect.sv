`timescale 1ns / 1ps

import axi_lite_pkg::*;

module tb_axi_lite_interconnect;

	localparam STEP = 10;
	localparam addr0 = 32'h4;
	localparam addr1 = 32'h14;

	logic aclk, areset_n;
	logic start_read_0, start_read_1;
	logic start_write_0, start_write_1;
    addr_t addr_0, addr_1;
  	data_t data_0, data_1;

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

	always begin
		aclk = 1; #(STEP / 2);
		aclk = 0; #(STEP / 2);
	end

	initial begin

		start_read_0 = 0; start_write_0 = 0;
		start_read_1 = 0; start_write_1 = 0;
		areset_n = 1;
		#(STEP * 10) areset_n = 0;
		#(STEP * 10) areset_n = 1;
		start_write_0 = 1; start_write_1 = 1;
        addr_0 = 12'h1; data_0 = 8'h10;
		addr_1 = 12'h2; data_1 = 8'h20;
        #(STEP) start_write_0 = 0; start_write_1 = 0;
		#(STEP * 20)
		start_read_0 = 1; start_read_1 = 1; 
		addr_0 = 1; addr_1 = 2;
		#(STEP) start_read_0 = 0; start_read_1 = 0; 
		#(STEP * 20);

		test_write();
		test_read();

		$finish;
	end
  
	int flag_w = 1, flag_r = 1;
	
	task test_write();
      if (slave0.buffer[addr_0] != data_0) flag_w = 0;
      $display("addr %h, actual:%h expected:%h\n", addr_0, slave0.buffer[addr_0], data_0);
      
      if (slave1.buffer[addr_1] != data_1) flag_w = 0;
      $display("addr %h, actual:%h expected:%h\n", addr_1, slave1.buffer[addr_1], data_1);

		if (flag_w) $display("Pass");
		else $display("Fail");
	endtask : test_write

	task test_read();
      if (master0.rdata != data_0) flag_r = 0;
		$display("actual:%h expected:%h\n", master0.rdata, data_0);
      if (master1.rdata != data_1) flag_r = 0;
      $display("actual:%h expected:%h\n", master1.rdata, data_1);

		if (flag_r) $display("Pass");
		else $display("Fail");
	endtask : test_read

endmodule
