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
	addr_0, addr_1 inside{[0 : 20]};
	}
	
  constraint dist_data_cn {
    data_0 dist {
		0 := 40,
       [1: data_range] := 60};
  }
	
endclass

class generator;
   
  //declaring transaction class
  rand transaction trans;
   
  //declaring mailbox
  mailbox gen2driv;
   
  //repeat count, to specify number of items to generate
  int  repeat_count; 
 
  //event
  event ended;
 
  //constructor
  function new(mailbox gen2driv,event ended);
    //getting the mailbox handle from env
    this.gen2driv = gen2driv;
    this.ended    = ended;
  endfunction
   
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
 
    repeat(repeat_count) begin
      trans = new();
      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");   
      gen2driv.put(trans);
    end
   -> ended;
  endtask 
endclass

interface axi_lite_intf(input logic clk,reset);
   
  //declaring the signals
  logic start_read_0, start_read_1;
  logic start_write_0, start_write_1;
  addr_t addr_0, addr_1;
  data_t data_0, data_1;
   
endinterface

class driver;
   
  //used to count the number of transactions
  int no_transactions;
   
  //creating virtual interface handle
  virtual axi_lite_intf axi_vif;
   
  //creating mailbox handle
  mailbox gen2driv;
   
  //constructor
  function new(virtual axi_lite_intf axi_vif,mailbox gen2driv);
    //getting the interface
    this.axi_vif = axi_vif;
    //getting the mailbox handle from  environment
    this.gen2driv = gen2driv;
  endfunction
   
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(axi_vif.reset);
    $display("--------- [DRIVER] Reset Started ---------");
    axi_vif.start_read_0 <= 0;
    axi_vif.start_read_1 <= 0;
    axi_vif.addr_0  <= 0;
	axi_vif.addr_1  <= 0;
    axi_vif.data_0 <= 0;
	axi_vif.data_1 <= 0;
    wait(!axi_vif.reset);
    $display("--------- [DRIVER] Reset Ended---------");
  endtask
   
  //drive the transaction items to interface signals
  task drive;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
      @(posedge axi_vif.clk);
      if(trans.start_write_0) begin
        axi_vif.start_write_0 <= trans.start_write_0;
        axi_vif.data_0 <= trans.data_0;
		axi_vif.addr_0 < = trans.addr_0;
        $display("\tADDR = %0h \tWDATA = %0h",trans.addr,trans.wdata);
        @(posedge axi_vif.clk);
      end
      if(trans.rd_en) begin
        `DRIV_IF.rd_en <= trans.rd_en;
        @(posedge axi_vif.DRIVER.clk);
        `DRIV_IF.rd_en <= 0;
        @(posedge axi_vif.DRIVER.clk);
        trans.rdata = `DRIV_IF.rdata;
        $display("\tADDR = %0h \tRDATA = %0h",trans.addr,`DRIV_IF.rdata);
      end
      $display("-----------------------------------------");
      no_transactions++;
    end
  endtask
          
endclass

