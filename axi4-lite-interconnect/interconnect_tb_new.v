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
   
  //repeat count, to specify number of items to generate
  int  repeat_count; 
   
  //main task
  task main();
 
    repeat(repeat_count) begin
      trans = new();
      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");   
    end
  endtask 
endclass


