import axi_lite_pkg::*;

class scoreboard;
    mailbox mb_monitor2scoreboard;
    virtual axi_lite_if bfm0;
    transaction txn;

    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm0);
        this.mb_monitor2scoreboard = mb_monitor2scoreboard;
        this.bfm0 = bfm0;
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
