import axi_lite_pkg::*;
//`include "../generator.sv"

class fully_random_test extends generator;

    function new(mailbox mb_generator2driver);
        super.new(.mb_generator2driver(mb_generator2driver));
    endfunction 

    task execute();

    endtask
endclass