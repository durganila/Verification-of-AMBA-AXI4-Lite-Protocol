/////////////////////////////////////////////////////////////////////////////////////////////
// axi4_lite_slave.sv - Slave module for AXI4 Lite Bus
//
// Author: Disha Shetty (dshetty@pdx.edu)
// Date: 18-Mar-2020
//
// Description:
// ------------
// Contains a slave module which is driven by the master for the read and write operations.
// Implemented two FSMs for read and write operation and each one has four states to
// traverse through the sequence of steps to complete the transaction.
//////////////////////////////////////////////////////////////////////////////////////////////

// import the global definitions of AXI4 Lite bus
import axi4_lite_Defs::*;


module axi4_lite_slave(
        axi4_lite_bfm.slave_if   S                                                    // interface as a slave
	 );


// declare the state variables for the FSM
// typedef enum logic [1:0] {IDLE,ADDR,DATA,RESP} state;                                // four states for read and write operation
state current_state_read, next_state_read, current_state_write, next_state_write;    // current and next state variables for read and write operation

// declare the internal variables
logic [Data_Width-1:0] readdata, writedata;                                          // read data and write data variables

// declare a memory array of size 4096
integer mem[4096];                                                                   // memory of 4096 locations each of 32 bit wide


//read from memory
always_comb
begin
	if(S.ARVALID == 1'b1)                // when ARVALID is asserted by slave, assign the data in ARADDR location of the memory to readdata variable which will be later given to master
        readdata = mem[S.ARADDR];
end

// write data into memory
always@(posedge S.ACLK)
begin
	if(S.WVALID == 1'b1)                 // when WVALID is asserted by slave, assign the writedata sent from master to the AWADDR location of the memory
	begin
		mem[S.AWADDR] = writedata;
	end
end



/////////////////////////////////////////////////////////////
// FSM's to implement read and write operations of the slave
/////////////////////////////////////////////////////////////

//////////////////FSM to implement read operation////////////


// state register for read operation
always_ff@(posedge S.ACLK, negedge S.ARESETN)
begin
	if(S.ARESETN == 0)                                  // active low reset
        	current_state_read <= IDLE;                 // go to IDLE state
 	else
		current_state_read <= next_state_read;      // else go to next state
end   // state register for read operation


// next state and output logic for read operation
always_comb
begin

	unique case(current_state_read)

	IDLE:	begin                                       // initialize the signals of the read channels to zero
			S.ARREADY = 1'b0;
			S.RVALID  = 1'b0;
			if (S.ARVALID && S.RREADY)          // when ARVALID and ARREADY are asserted by the master, then go to ADDR state else stay in IDLE state
			begin
				next_state_read = ADDR;
			end
			else
 			begin
				next_state_read = IDLE;
			end
   		 end

	ADDR: 	begin
			S.ARREADY = 1'b1;                   // assert ARREADY to indicate that slave is ready to receive the address(ARADDR) from master and go to DATA state
			next_state_read = DATA;
		end

	DATA:  	begin
			S.ARREADY = 1'b0;                   // deassert ARREADY indicating that address has been transferred from master to slave
			S.RDATA   = readdata;               // assign the data from the given location of the memory to RDATA signal of the read data channel
			S.RVALID  = 1'b1;                   // assert RVALID to indicate that RDATA is valid
			if(S.RREADY)                        // when RREADY is asserted by master, then go to RESP state else stay in DATA state
				next_state_read = RESP;
			else
				next_state_read = DATA;
		end

	RESP: 	begin
			S.RVALID = 1'b0;                     // deassert RVALID indicating that data has been transferred from slave to master and go to IDLE state
			next_state_read = IDLE;
		end

	endcase

end   // next state and output logic for read operation



//////////////////////////FSM to implement write operation///////////////////////////////////


// state register for write operation
always_ff@(posedge S.ACLK, negedge S.ARESETN)
begin
	if(S.ARESETN == 0)                                   // active reset low
		current_state_write <= IDLE;                 // go to IDLE state
	else
		current_state_write <= next_state_write;     // else go to next state
end    // state register for write operation


// next state and output logic for write operation
always_comb
begin

	unique case(current_state_write)

	IDLE:	begin	                                      // initialize the signals of the write channels to zero
			S.AWREADY = 1'b0;
			S.WREADY  = 1'b0;
			S.BVALID  = 1'b0;
			if (S.AWVALID && S.WVALID)            // when AWVALID and WVALID are asserted by the master, then go to ADDR state else stay in IDLE state
				next_state_write = ADDR;
			else
				next_state_write = IDLE;
		end


	ADDR:	begin
			S.AWREADY = 1'b1;                     // assert AWREADY to indicate that slave is ready to receive the write address(AWADDR) from master
			S.WREADY  = 1'b1;                     // assert WREADY to indicate that slave is ready to receive that write data(WDATA)
			writedata = S.WDATA;                  // assign the write data received from master to the write data internal variable and go to DATA state
			next_state_write = DATA;
		end

	DATA:	begin
			S.AWREADY = 1'b0;                      // deassert AWREADY indicating that address has been transferred from master to slave
			S.WREADY  = 1'b0;                      // deassert WREADY indicating that data has been transferred from master to slave
			S.BVALID  = 1'b1;                      // assert BVALID to indicate that write response is valid
			if(S.BREADY)                           // when BREADY is asserted by master, then go to RESP state else stay in DATA state
				next_state_write = RESP;
			else
				next_state_write = DATA;
		end


	RESP: 	begin
			S.BVALID = 1'b0;                       // deassert BVALID indicating that write response has been transferred from slave to master and go to IDLE state
			next_state_write = IDLE;
		end

	endcase

end   // next state and output logic for write operation

endmodule: axi4_lite_slave