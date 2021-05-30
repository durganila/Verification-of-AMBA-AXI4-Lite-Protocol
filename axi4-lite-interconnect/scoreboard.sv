///////////////////////////////////////////////////////////////////////////////////////////
// Name         : scoreboard.sv 
// Description  : Checker & Scoreboard object for an object oriented AXI4 testbench.                                        
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 05/21/2021                                                                  
// Version      : 1                                                                         
///////////////////////////////////////////////////////////////////////////////////////////
/*
import axi_lite_pkg::*;

class scoreboard;
    mailbox             mb_monitor2scoreboard; // mailbox to send data to scoreboard
    virtual axi_lite_if bfm0;                  // virtual interface to get data from interface
    transaction         txn;                   // transaction object

    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm0);
        this.mb_monitor2scoreboard  = mb_monitor2scoreboard;
        this.bfm0                   = bfm0;
        txn                         = new();
    endfunction

    task execute();
        forever begin
            //update scoreboard at positive edge of the clock
            @(posedge bfm0.aclk);

            // Store transaction from monitor to the mailbox
            mb_monitor2scoreboard.get(txn);
        end

    endtask
endclass
*/

import axi_lite_pkg::*;

class scoreboard;

	mailbox             mb_monitor2scoreboard; 	// mailbox to send data to scoreboard
    virtual axi_lite_if bfm;                  	// virtual interface to get data from interface
    transaction         txn;                   	// transaction object

	int score = 0;
	
	//To store values for comparison:
	logic [DATA_WIDTH-1:0] local_mem[BUFFER_SIZE];
	int i;
  
    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm);
        this.mb_monitor2scoreboard  = mb_monitor2scoreboard;
        this.bfm                    = bfm;
        txn                         = new();
		for (i = 0; i < BUFFER_SIZE; i++) begin
			local_mem[i] = 0;
		end
    endfunction

  //Read the write data line and store the value to local memory.
  protected task save_val();
  begin
  @(posedge bfm.aclk);
  mb_monitor2scoreboard.get(txn);
  //If the WRITE ADDR value is true, we can store the value to local mem.
  if (bfm.awvalid) begin
    local_mem[bfm.awaddr] = bfm.wdata; 
    $display("CHECKING ADDR %d, FINDING VALUE %d\n", bfm.awaddr, bfm.wdata);
  end
  end

  endtask: save_val

  //Read the read value line and check local memory to confirm
  protected task check_val();
  begin
  @(posedge bfm.aclk);
  mb_monitor2scoreboard.get(txn);
  //If the rvalid is true, then a valid read op is in progress so we can compare.
  if (bfm.rvalid) begin
    //So we just compare it to local mem.
    if (!(bfm.rdata == local_mem[bfm.araddr])) begin
		score = score + 1;
    end
  end
end
endtask : check_val
	
  task execute();
  int k = 0;
  for (k = 0; k < BUFFER_SIZE; k++) begin
    @(posedge bfm.aclk);
            // Store transaction from monitor to the mailbox
	mb_monitor2scoreboard.get(txn);
    fork
		save_val();
		check_val();
    join
    if (k == (BUFFER_SIZE-1)) begin
		$display("SCORE IS: %d\n", score);
    end
  end

endtask: execute

endclass: scoreboard