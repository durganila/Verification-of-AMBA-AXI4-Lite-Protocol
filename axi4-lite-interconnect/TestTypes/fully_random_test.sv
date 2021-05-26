import axi_lite_pkg::*;
//`include "../generator.sv"

class fully_random_test extends generator;

    transaction txn;
    transaction generate_pkt;

    function new(mailbox mb_generator2driver);
        super.new(.mb_generator2driver(mb_generator2driver));
    endfunction 

    task execute();
            // perform reset low
            driver_send(1'b0, '0, '0, '0, '0, 1'b0, 1'b0, 1'b0, 1'b0);
            driver_send(1'b0, '0, '0, '0, '0, 1'b1, 1'b0, 1'b0, 1'b0);
            driver_send(1'b0, '0, '0, '0, '0, 1'b0, 1'b1, 1'b0, 1'b0);
            driver_send(1'b0, '0, '0, '0, '0, 1'b0, 1'b0, 1'b1, 1'b0);
            driver_send(1'b0, '0, '0, '0, '0, 1'b0, 1'b0, 1'b1, 1'b1);
            #10;
            // dsable reset
            driver_send(1'b1, '0, '0, '0, '0, 1'b0, 1'b0, 1'b1, 1'b1);

            repeat(1) begin
                // randomize transactions
                RandomizeTransactions: assert (generate_pkt)
                    else $error($time, "fully_random_test: Assertion RandomizeTransactions failed!");

                $display("%p", generate_pkt);
                driver_send(1'b1, generate_pkt.addr_0, generate_pkt.data_0, '0, '1, generate_pkt.addr_1, generate_pkt.data_1, '0, '1);
            end
    endtask

    task driver_send(
                    input 
                    logic reset_n,
                    addr_t addr_0, 
                    data_t data_0,
                    logic start_read_0,
                    logic start_write_0,  
                    addr_t addr_1,
                    data_t data_1,
                    logic start_read_1,
                    logic start_write_1
    );
        txn = new();
        txn.addr_0            = addr_0;
        txn.data_0            = data_0; 
        txn.start_read_0      = start_read_0;
        txn.start_write_0     = start_write_0; 
        txn.addr_1            = addr_1;
        txn.data_1            = data_1;
        txn.start_read_1      = start_read_1;
        txn.start_write_1     = start_write_1;
    endtask
endclass