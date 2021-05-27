import axi_lite_pkg::*;

class monitor;

    // mailboxt to send data to scoreboard
    mailbox mb_monitor2scoreboard;

    // virtual interface to get data from interface
    virtual axi_lite_if bfm0;

    // transactionclass object used to send the data to scoreboard
    transaction txn;

    logic debugMode;

    // new contructor
    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm0, logic debugMode);
        this.mb_monitor2scoreboard = mb_monitor2scoreboard;
        this.bfm0 = bfm0;
        this.debugMode = debugMode;
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