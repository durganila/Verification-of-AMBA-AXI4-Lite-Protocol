import axi_lite_pkg::*;

class transaction;
  
  localparam data_range = 2 ** (DATA_WIDTH) -1;
  
  //declaring the transaction items
  rand logic  reset_n;                        // reset
  
  rand addr_t awaddr_0, awaddr_1;                 // Address vars
  rand data_t wdata_0, wdata_1;                 // data vars
  rand bit    awvalid_0, awvalid_1;           // write address valid
  logic       wvalid_0, wvalid_1;             // write valid 

  logic       arvalid_0, arvalid_1;           // read address valid        
  rand addr_t araddr_0, araddr_1;                 // Address vars
  
  
  function new();

  endfunction
   
  //constaint, to generate any one among write and read
  /*constraint wr_rd { 
	                  start_read_0 != start_write_0;
	                  start_read_1 != start_write_1;
				           }*/
	
  constraint addr_range {
	                      awaddr_0 inside{[0 : 2048]};
                        awaddr_1 inside{[0 : 2048]};
                        araddr_0 inside{[0 : 2048]};
                        araddr_1 inside{[0 : 2048]};
	                      }
	
  constraint dist_data_cn {
                          wdata_0 dist {
		                        0 := 40,
                            [1: data_range] := 60};

                          wdata_1 dist {
		                        0 := 40,
                            [1: data_range] := 60};
                          }
  
endclass