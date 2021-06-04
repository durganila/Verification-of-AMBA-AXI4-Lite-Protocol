///////////////////////////////////////////////////////////////////////////////////////////
// Name         : monitor.sv 
// Description  : Monitors the virtual interface and send the data to scoreboards class via mailbox.
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 05/21/2021                                                                  
// Version      : 1                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

class monitor;

    mailbox             mb_monitor2scoreboard; // mailbox to send data to scoreboard
    virtual axi_lite_if bfm0;                  // virtual interface to get data from interface
    transaction         txn;                   //object used to send the data to scoreboard
    logic               debugMode;             // debugmode

    // new contructor
    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm0, logic debugMode);
        this.mb_monitor2scoreboard  = mb_monitor2scoreboard;
        this.bfm0                   = bfm0;
        this.debugMode              = debugMode;
    endfunction

    // this task will sample the data forever
    task execute();
        forever begin
            sampleData();
        end
    endtask

    //
    task sampleData();
        @(posedge bfm0.aclk);
    endtask

endclass