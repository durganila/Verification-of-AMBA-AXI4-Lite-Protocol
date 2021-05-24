import axi_lite_pkg::*;

class transaction;
  
  localparam data_range = 2 ** (DATA_WIDTH) -1;
  
  //declaring the transaction items
  rand addr_t addr_0, addr_1;
  rand data_t data_0, data_1;
  rand bit       start_read_0, start_read_1;
  rand bit       start_write_0, start_write_1;
  
   
  //constaint, to generate any one among write and read
  constraint wr_rd { 
	start_read_0 != start_write_0;
	start_read_1 != start_write_1;
				}
	
  constraint addr_range {
	addr_0, addr_1 inside{[0 : 2048]};
	}
	
  constraint dist_data_cn {
    data_0 dist {
		0 := 40,
       [1: data_range] := 60};
  }
  
endclass


//Tester class

class tester;

  virtual axi_lite_if bfm0, bfm1;

  function new (virtual axi_lite_if b0, virtual axi_lite_if b1 );
    bfm0 = b0;
	bfm1 = b1;
  endfunction: new

//randomisation of transaction
transaction trans = new();
if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");

///////////////////////
//
//    DIRECTED INPUTS
//
//////////////////////

//write_task for bfm0:
task write_op0(input addr_t write_address, input data_t write_data);

  begin
  @(posedge bfm0.aclk);
  bfm0.awvalid = 1;
  bfm0.wvalid = 1;
  bfm0.awaddr = write_address;
  bfm0.wdata = write_data;
  $display("WRITING %d TO %d", write_data, write_address);
  end
  repeat(1) @(posedge bfm0.aclk)
  begin
  bfm0.wvalid = 0;
  bfm0.awvalid = 0;
  end
  repeat(5) @(posedge bfm0.aclk);
endtask

//read_task for bfm0:
task read_op0(input addr_t read_address);

  begin
  @(posedge bfm0.aclk);
  bfm0.arvalid = 1;
  bfm0.rready = 1;
  bfm0.araddr = read_address;
  $display("Readding from %d and read value is: %d ", read_address, bfm0.rdata);
  end
  repeat(1) @(posedge bfm0.aclk)
  begin
  bfm0.wvalid = 0;
  bfm0.awvalid = 0;
  end
  repeat(5) @(posedge bfm0.aclk);
endtask


//write_task for bfm1
task write_op1(input addr_t write_address, input data_t write_data);

  begin
  @(posedge bfm1.aclk);
  bfm1.awvalid = 1;
  bfm1.wvalid = 1;
  bfm1.awaddr = write_address;
  bfm1.wdata = write_data;
  $display("WRITING %d TO %d", write_data, write_address);
  end
  repeat(1) @(posedge bfm1.aclk)
  begin
  bfm1.wvalid = 0;
  bfm1.awvalid = 0;
  end
  repeat(5) @(posedge bfm1.aclk);
endtask

//read_task for bfm1:
task read_op1(input addr_t read_address);

  begin
  @(posedge bfm1.aclk);
  bfm1.arvalid = 1;
  bfm1.rready = 1;
  bfm1.araddr = read_address;
  $display("Readding from %d and read value is: %d ", read_address, bfm1.rdata);
  end
  repeat(1) @(posedge bfm1.aclk)
  begin
  bfm1.wvalid = 0;
  bfm1.awvalid = 0;
  end
  repeat(5) @(posedge bfm1.aclk);
endtask


////////////////////////////
//
//    RANDOMIZED INPUTS
//
///////////////////////////

//write_task for bfm0:
task random_write_op0();

  begin
  @(posedge bfm0.aclk);
  bfm0.awvalid = 1;
  bfm0.wvalid = 1;
  bfm0.awaddr = addr_0;
  bfm0.wdata = data_0;
  $display("WRITING %d TO %d", data_0, addr_0);
  end
  repeat(1) @(posedge bfm0.aclk)
  begin
  bfm0.wvalid = 0;
  bfm0.awvalid = 0;
  end
  repeat(5) @(posedge bfm0.aclk);
endtask

//read_task for bfm0:
task random_read_op0();

  begin
  @(posedge bfm0.aclk);
  bfm0.arvalid = 1;
  bfm0.rready = 1;
  bfm0.araddr = addr_0;
  $display("Readding from %d and read value is: %d ", addr_0, bfm0.rdata);
  end
  repeat(1) @(posedge bfm0.aclk)
  begin
  bfm0.wvalid = 0;
  bfm0.awvalid = 0;
  end
  repeat(5) @(posedge bfm0.aclk);
endtask


//write_task for bfm1
task random_write_op1();

  begin
  @(posedge bfm1.aclk);
  bfm1.awvalid = 1;
  bfm1.wvalid = 1;
  bfm1.awaddr = addr_1;
  bfm1.wdata = data_1;
  $display("WRITING %d TO %d", data_1, addr_1);
  end
  repeat(1) @(posedge bfm1.aclk)
  begin
  bfm1.wvalid = 0;
  bfm1.awvalid = 0;
  end
  repeat(5) @(posedge bfm1.aclk);
endtask

//read_task for bfm1:
task random_read_op1();

  begin
  @(posedge bfm1.aclk);
  bfm1.arvalid = 1;
  bfm1.rready = 1;
  bfm1.araddr = addr_1;
  $display("Readding from %d and read value is: %d ", addr_1, bfm1.rdata);
  end
  repeat(1) @(posedge bfm1.aclk)
  begin
  bfm1.wvalid = 0;
  bfm1.awvalid = 0;
  end
  repeat(5) @(posedge bfm1.aclk);
endtask

///////////////////////
//
//  TESTCASES
//
//////////////////////

//CONTROL:

//TEST: 1 :Continous Writes with known values and consecutive reads - master 0
task write_rd_txn_m0();
	for (int i =0; i< 2048; i=i+1) begin
		write_op0(i, i+10);
	end
	for (int i =0; i< 2048; i=i+1) begin
		read_op0(i);
	end
endtask

//TEST: 2 :Continous Writes with known values and consecutive reads - master 0
task write_rd_txn_m1();
	for (int i =0; i< 2048; i=i+1) begin
		write_op1(i, i+20);
	end
	for (int i =0; i< 2048; i=i+1) begin
		read_op1(i);
	end
endtask

//TEST : 3: Writing to start address: '0 and a following read : master0
task write_to_startaddress_txn_m0();
	write_op0(11'h0, 8'hFF);
	read_op0(11'h0);
	end
endtask

//TEST : 4: Writing to end address: 2047 and a following read : master0
task write_to_endaddress_txn_m0();
	write_op0(11'h7FF, 8'hFE);
	read_op0(11'h7FF);
	end
endtask

//TEST : 3: Writing to start address: '0 and a following read : master1
task write_to_startaddress_txn_m1();
	write_op1(11'h0, 8'hFF);
	read_op1(11'h0);
	end
endtask

//TEST : 4: Writing to end address: 2047 and a following read : master0
task write_to_endaddress_txn_m1();
	write_op1(11'h7FF, 8'hFE);
	read_op1(11'h7FF);
	end
endtask

//TEST: 5 :Modifying non-consecutive locations and reading back entire location - master1
task modifying_nonconsecutive_m1();
	for (int i =0; i< 2048; i=i+1) begin
		write_op1(i, i+20);
	end
	for (int i =0; i< 2048; i=i+1) begin
		read_op1(i);
	end
	for (int i =0; i< 2038; i=i+10) begin
		write_op1(i, i+10);
	end
	for (int i =0; i< 2048; i=i+1) begin
		read_op1(i);
	end
endtask


//CONCUREENT OPERATIONS:

//TEST:3 :Concurrent writes to 2 masters followed by concurrent reads
task Single_write_read_txn();
	fork
    write_op0(11'h001, 8'hFF);
	write_op1(11'h001, 8'hFF);
	join
	fork
	read_op0(11'h001);
	read_op0(11'h001);
	join
endtask

//TEST:3 :Concurrent writes to 2 masters followed by concurrent reads
task Single_write_read_txn();
	fork
    write_op0(11'h001, 8'hFF);
	write_op1(11'h001, 8'hFF);
	join
	fork
	read_op0(11'h001);
	read_op0(11'h001);
	join
endtask



 task execute(input int number_of_transactions);
 int i= 0;
 for (i = 0; i < 2048; i++) begin
	directed_write_op();
 endtask 
 
endclass