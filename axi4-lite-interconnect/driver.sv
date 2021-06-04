///////////////////////////////////////////////////////////////////////////////////////////
// Name         : driver.sv 
// Description  :                                                               
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 05/20/2021                                                                  
// Version      : 1                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

class driver;

	mailbox             mb_generator2driver = new(); // mailbox to connect to generator  
    virtual axi_lite_if bfm0;                        // virtual interface
    transaction         txn;                         // obj to store data send from generator
    logic               debugMode;                   // debug mode

    // constructor
    function new(mailbox mb_generator2driver, virtual axi_lite_if bfm0, logic debugMode);
        this.mb_generator2driver = mb_generator2driver;
        this.bfm0                = bfm0;
        this.debugMode           = debugMode;
    endfunction 

    task execute();
        txn = new();

        forever begin
            mb_generator2driver.get(txn);
            drive_master(txn);
        end
    endtask

    task drive_master(transaction txn);    
        // set writes
		bfm0.areset_n		= txn.reset_n;
        bfm0.addr           = txn.addr;
        bfm0.data           = txn.data;
        bfm0.start_write    = txn.start_write;
        bfm0.start_read     = txn.start_read;

        if(debugMode) $display($time, " driver.drive_master addr %h, data %h, start_write %h start_read %h ", 
                                        txn.addr, txn.data, txn.start_write, txn.start_read);

        // set read and write to invalid after 1 cycle
        @(posedge bfm0.aclk);
        bfm0.start_write    = '0;
        bfm0.start_read     = '0;

        @(posedge bfm0.aclk);
    endtask

endclass