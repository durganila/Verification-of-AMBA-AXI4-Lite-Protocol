import axi_lite_pkg::*;

virtual class generator;

    mailbox mb_generator2driver = new();
    logic debugMode = '0;

    function new(mailbox mb_generator2driver, logic debugMode);

        this.mb_generator2driver = mb_generator2driver;
        this.debugMode = debugMode;
    endfunction 

    pure virtual task execute();
    
endclass