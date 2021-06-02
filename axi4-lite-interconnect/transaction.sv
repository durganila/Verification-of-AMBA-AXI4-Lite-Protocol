import axi_lite_pkg::*;

class transaction;
  
  localparam data_range = 2 ** (DATA_WIDTH) -1;
  
  //declaring the transaction items
  logic  reset_n;                  // reset
  
  rand addr_t addr;                // Address vars
  rand data_t data;                // data vars
  rand bit       start_read;          // start a read
  rand bit       start_write;         // start a write
  data_t      rd_data;             // read data
  

  function new();

  endfunction
  //constaint, to generate any one among write and read
  /*constraint wr_rd { 
	                  start_read_0 != start_write_0;
	                  start_read_1 != start_write_1;
				           } */

	
  constraint addr_range {
                        addr inside{[0 : 2048]};
	                      }
	
  constraint dist_data_cn {
                          data dist {
		                        0 := 40,
                            [1: data_range] := 60};
                          }
  
endclass
