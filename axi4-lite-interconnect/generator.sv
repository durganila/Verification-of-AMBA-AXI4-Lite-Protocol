import axi_lite_pkg::*;

virtual class generator;

    mailbox mb_generator2driver = new();

    function new(mailbox mb_generator2driver);

        this.mb_generator2driver = mb_generator2driver;
    endfunction 

    task execute();

    endtask
    
endclass