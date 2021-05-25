class monitor;
    mailbox mb_monitor2scoreboard;
    virtual axi_lite_if bfm0, bfm1;

    function new (mailbox mb_monitor2scoreboard,  virtual axi_lite_if bfm0, bfm1);
        this.mb_monitor2scoreboard = mb_monitor2scoreboard;
        this.bfm0 = bfm0;
        this.bfm1 = bfm1;
    endfunction
endclass