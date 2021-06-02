import axi_lite_pkg::*;

class deterministic_test extends generator;

    transaction txn;

    function new(mailbox mb_generator2driver, logic debugMode, int numTransactions);
        super.new(mb_generator2driver, debugMode, numTransactions);
    endfunction 

    task execute();
		int i,j;
        //simple write and read txns to existing slave address
		driver_send(1'b1, 32'h4, 8'b10101010, '0, '1);
        #10;
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;
		
		//simple write and read txns to non-existing slave address
		driver_send(1'b1, 32'h1003, 8'b00001010, '0, '1);
        #10;
        driver_send(1'b1, 32'h1003, '0, '1, '0);
        #10;
		
		//write  and read address -'0 and 4098
		driver_send(1'b1, 32'h0, '0, '0, '1);
        #10;
        driver_send(1'b1, 32'h0, '0, '1, '0);
        #10;
        driver_send(1'b1, 32'h1001, 8'hFF, '0, '1);
        #10;
        driver_send(1'b1, 32'h1001, '0, '1, '0);
        #10;  
		
		//write to locations from 0 to 4098 and read in reverse order
		for(i = 0; i < 4098; i=i+1) begin 
			driver_send(1'b1, i, i+10, '0, '1);
			#10;
		end
		for(i = 4097; i >0; i=i+1) begin 
			driver_send(1'b1, i, '0, '1, '0);
			#10;
		end

		//write  and read data - all zeros & all ones
		driver_send(1'b1, 32'h4, '0, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
        driver_send(1'b1, 32'h4, 8'hFF, '0, '1);
        #10;
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;  
		
		// consecutive writes (overwriting)  to same location followed by a read
		driver_send(1'b1, 32'h4, 8'hBE, '0, '1);
        #10;
		 driver_send(1'b1, 32'h4, 8'b10101110, '0, '1);
        #10;
        driver_send(1'b1, 12'h4, '0, '1, '0);
        #10;
		
		//read and write to same location at same time
		driver_send(1'b1, 32'h4, 8'h0F, '0, '1);
        driver_send(1'b1, 32'h4, '0, '1, '0);
        #10;
		
		//write to different locations at same time
		driver_send(1'b1, 32'h4, 8'hBF, '0, '1);
        driver_send(1'b1, 32'h14, 8'hAA, '0, '1);
        #10;
		
		//Modifying alternate locations and reading all the locations
		for(j = 0; j < 4096; j=j+1) begin 
			driver_send(1'b1, j, j+10, '0, '1);
			#10;
		end
		for(j = 0; j < 4096; j=j+1) begin 
			driver_send(1'b1, j, '0, '1, '0);
			#10;
		end
		for(j = 0; j < 4096; j=j+10) begin 
			driver_send(1'b1, j, '0, '0, '1);
			#10;
		end
		for(j = 0; j < 4096; j=j+1) begin 
			driver_send(1'b1, j, '0, '1, '0);
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
            $display($time," deterministic_tests.driver_send: reset_n %b, addr %h, data %h read %b, write %b", 
                                reset_n, addr, data, start_read, start_write);
        mb_generator2driver.put(txn);
    endtask
endclass
