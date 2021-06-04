///////////////////////////////////////////////////////////////////////////////////////////
// Name         : fully_random_test.sv 
// Description  :                                                               
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 05/20/2021                                                                  
// Version      : 1                                                                         
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

class fully_random_test extends generator;

    transaction txn;
    transaction generate_pkt;

    function new(mailbox mb_generator2driver, logic debugMode, int numTransactions);
        super.new(mb_generator2driver, debugMode, numTransactions);
    endfunction 

    task execute();
        // fully random transactions
        repeat(numTransactions) begin
            // randomize transactions
            generate_pkt = new();
            assert (generate_pkt.randomize())
                else $error($time, "fully_random_test: Assertion RandomizeTransactions failed!");
            
            driver_send(1'b1, generate_pkt.addr, generate_pkt.data, generate_pkt.start_read, generate_pkt.start_write);
            #10;
        end
    endtask

    task driver_send(
                    input 
                    logic reset_n,
                    addr_t addr, 
                    data_t data,
                    logic start_read,
                    logic start_write
    );
        txn                 = new();
        txn.reset_n         = reset_n;
        txn.addr            = addr;
        txn.data            = data; 
        txn.start_read      = start_read;
        txn.start_write     = start_write; 

        if(debugMode) 
            $display($time," fully_random_test.driver_send: reset_n %b, addr %h, data %h read %b, write %b", 
                                reset_n, addr, data, start_read, start_write);
        mb_generator2driver.put(txn);
    endtask
endclass