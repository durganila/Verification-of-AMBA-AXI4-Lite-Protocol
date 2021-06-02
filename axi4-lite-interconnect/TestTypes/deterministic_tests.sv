import axi_lite_pkg::*;

class deterministic_tests extends generator;

    transaction txn;

    function new(mailbox mb_generator2driver, logic debugMode, int numTransactions);
        super.new(mb_generator2driver, debugMode, numTransactions);
    endfunction 

    task execute();
        //simple write and read txns to existing slave address
		driver_send(1'b1, 32'h4, 8'b10101010, '0, '1);
        #10;
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;
		
		//simple write and read txns to non-existing slave address
		driver_send(1'b1, 32'h16, 8'b00001010, '0, '1);
        #10;
        driver_send(1'b1, 32'h16, '0, '1, '0);
        #10;
		
		//write  and read data - all zeros & all ones
		driver_send(1'b1, 32'h4, '0, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
        driver_send(1'b1, 32'h4, 8'hFF, '0, '1);
        #10;
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;  
		
		// concurrent writes followed by a read
		driver_send(1'b1, 32'h4, 8'hBE, '0, '1);
        #10;
		 driver_send(1'b1, 32'h4, 8'b10101110, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
       
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
