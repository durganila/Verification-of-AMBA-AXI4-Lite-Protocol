import axi_lite_pkg::*;
//`include "../generator.sv"
//`include "../transaction.sv"

class fully_random_test extends generator;

    transaction txn;
    transaction generate_pkt;

    function new(mailbox mb_generator2driver, logic debugMode);
        super.new(mb_generator2driver, debugMode);
    endfunction 

    task execute();
            // perform reset low
            driver_send(1'b0, '0, '0, '0, '0);
            driver_send(1'b0, '0, '0, '0, '0);
            driver_send(1'b0, '0, '0, '0, '0);
            driver_send(1'b0, '0, '0, '0, '0);
            driver_send(1'b0, '0, '0, '0, '0);
            #10;
            // dsable reset
            driver_send(1'b1, '0, '0, '0, '0);
            #10;
            driver_send(1'b1, 12'h1, 8'h8, '0, '1);
            #20;
            driver_send(1'b1, 12'h1, 8'h8, '1, '0);

            repeat(2) begin
                // randomize transactions
                generate_pkt = new();
                assert (generate_pkt.randomize())
                    else $error($time, "fully_random_test: Assertion RandomizeTransactions failed!");

                if(debugMode) $display($time," fully_random_test: addr %h, data %h read %b, write %b", generate_pkt.addr, generate_pkt.data, '0, '1);
                driver_send(1'b1, generate_pkt.addr, generate_pkt.data, '0, '1);
                #20;
                 if(debugMode) $display($time," fully_random_test: addr %h, data %h read %b, write %b", generate_pkt.addr, generate_pkt.data, '1, '0);
                driver_send(1'b1, generate_pkt.addr, generate_pkt.data, '1, '0);
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
        txn = new();
        txn.reset_n         = reset_n;
        txn.addr            = addr;
        txn.data            = data; 
        txn.start_read      = start_read;
        txn.start_write     = start_write; 

        mb_generator2driver.put(txn);
    endtask
endclass