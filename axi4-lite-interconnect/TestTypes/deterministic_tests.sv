import axi_lite_pkg::*;

class deterministic_tests extends generator;

    transaction txn;

    function new(mailbox mb_generator2driver, logic debugMode, int numTransactions);
        super.new(mb_generator2driver, debugMode, numTransactions);
    endfunction 

    task execute();
		int i,j;
		
		 //write and read 1 byte data
		driver_send(1'b1, 12'h4, 8'hEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10; 
		 
		//write and read 2 bytes of data
		driver_send(1'b1, 12'h4, 16'hBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
		
		//write and read 3 bytes data
		driver_send(1'b1, 12'h4, 24'hADBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
		
        //simple write and read txns to existing slave address
		driver_send(1'b1, 12'h4, 32'hDEADBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10; 
		
		//simple write and read txns to non-existing slave address
		driver_send(1'b1, 12'hFFF, 32'hFEEDBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'hFFF, '0, '1, '0);
        #10;
		
		//write  and read address -'0 and 2047
		driver_send(1'b1, 12'h0, 32'h0FEDBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h0, '0, '1, '0);
        #10;
        driver_send(1'b1, 12'h7FF, '0, '0, '1);
        #10;
        driver_send(1'b1, 32'h7FF, '0, '1, '0);
        #10;  
		
		/* //write to locations from 0 to 2048 and read in reverse order
		for(i = 0; i < 7FF; i=i+1) begin 
			driver_send(1'b1, i, i+10, '0, '1);
			#10;
		end
		for(i = 7FF; i >=0; i=i-1) begin 
			driver_send(1'b1, i, '0, '1, '0);
			#10;
		end */

		//write  and read data - all zeros & all ones
		driver_send(1'b1, 32'h4, '0, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
        driver_send(1'b1, 32'h4, 32'hFFFFFFFF, '0, '1);
        #10;
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;  
		
		// consecutive writes (overwriting)  to same location followed by a read
		driver_send(1'b1, 32'h4, 32'hDEADBEEF, '0, '1);
        #10;
		 driver_send(1'b1, 32'h4, 32'hFEEDBEEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
		
		/* //read and write to same location at same time
		fork
		driver_send(1'b1, 32'h4, 32'hFFFF, '0, '1);
        driver_send(1'b1, 32'h4, '0, '1, '0);
		join
        #10; */
		
		/* //write to different locations at same time
		driver_send(1'b1, 32'h4, 32'hFBFBF, '0, '1);
        driver_send(1'b1, 32'h14, 32'hAAAAA, '0, '1);
        #10;
		 */
		//Modifying alternate locations and reading all the locations
		for(j = 0; j < 10; j=j+1) begin 
			driver_send(1'b1, j, j+10, '0, '1);
			#10;
		end
		#10;
		for(j = 0; j < 10; j=j+1) begin 
			driver_send(1'b1, j, '0, '1, '0);
			#10;
		end
		#20;
		for(j = 0; j < 10; j=j+2) begin 
			driver_send(1'b1, j, '0, '0, '1);
			#10;
		end
		#10;
		for(j = 0; j < 10; j=j+1) begin 
			driver_send(1'b1, j, '0, '1, '0);
			#10;
		end 
		
		//reset after write
		driver_send(1'b1, 12'h4, 8'hEF, '0, '1);
        #10;
        driver_send(1'b0, '0, '0, '1, '0);
        #10; 
		 driver_send(1'b1, 12'h4, '0, '1, '0);
        #10; 
		
		//reset after read
		driver_send(1'b1, 12'h4, 8'hEF, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
		driver_send(1'b0, '0, '0, '1, '0);
        #10;
		
		//both read and write start signal asserted
		driver_send(1'b1, 12'h4, 8'hEF, '1, '1);
        #10;
		
		//neither read and write start signal asserted
		driver_send(1'b1, 12'h4, 8'hEF, '0, '0);
        #10;
		
		//read when reset asserted
		driver_send(1'b1, 12'h4, 8'hEF, '0, '1);
        #10;
        driver_send(1'b0, 12'h4, '0, '1, '0);
        #10; 
		
		//write when reset asserted
		driver_send(1'b0, 12'h4, 8'hEF, '0, '1);
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
            $display($time," deterministic_tests.driver_send: reset_n %b, addr %h, data %h read %b, write %b", 
                                reset_n, addr, data, start_read, start_write);
        mb_generator2driver.put(txn);
    endtask
endclass
