import axi_lite_pkg::*;

class transaction;
  
  localparam data_range = 2 ** (DATA_WIDTH) -1;
  
  //declaring the transaction items
  logic  reset_n;                             // reset
  
  rand addr_t addr_0, addr_1;                 // Address vars
  rand data_t data_0, data_1;                 // data vars
  bit    start_read_0, start_read_1;          // start a read
  bit    start_write_0, start_write_1;        // start a write
  
  function new();

  endfunction
   
  //constaint, to generate any one among write and read
  /*constraint wr_rd { 
	                  start_read_0 != start_write_0;
	                  start_read_1 != start_write_1;
				           }*/
	
  constraint addr_range {
	                      addr_0 inside{[0 : 2048]};
                        addr_1 inside{[0 : 2048]};
	                      }
	
  constraint dist_data_cn {
                          data_0 dist {
		                        0 := 40,
                            [1: data_range] := 60};

                          data_1 dist {
		                        0 := 40,
                            [1: data_range] := 60};
                          }
  
endclass