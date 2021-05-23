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

class tester;

axi4_lite_if bfm;

transaction trans = new();
if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
// Directed Test: Write to 1 master with address '0
task directed_write_op( );

  begin
  @(posedge bfm.aclk);
  bfm.start_read_0 = 0;
  bfm.start_read_1 = 0;
  bfm.start_write_0 = 1;
  bfm.start_write_1 = 0;
  bfm.awvalid = 1;
  bfm.wvalid = 1;
  bfm.awaddr = '0;
  bfm.wdata = 8'hAB;
  $display("WRITING %d TO %d", wdata, awaddr);
  end
  repeat(5) @(posedge bfm.aclk)
  begin
  bfm.start_write_0 = 0;
  bfm.wvalid = 0;
  bfm.awvalid = 0;
  end
  endtask: directed_write_op
 
 task run(input int number_of_transactions);
 int i= 0;
 for (i = 0; i < 4096; i++) begin
	directed_write_op();
 endtask 
 
endclass