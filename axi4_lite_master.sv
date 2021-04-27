///////////////////////////////////////////////////////////////////////////////
// axi4_lite_master.sv - Master module for AXI4 Lite Bus
//
// Author: Rutuja Patil (rutuja@pdx.edu)
// Date: 18-Mar-2020
//
// Description:
// ------------
// Contains a master module which initiates the read and write operations.
// Implemented two FSMs for read and write operation and each one has four
// states to traverse through the sequence of steps to complete the transaction.
////////////////////////////////////////////////////////////////////////////////

// import the global definitions of AXI4 Lite bus
import axi4_lite_Defs::*;

module axi4_lite_master(

input logic rd_en,                                   // read enable signal
input logic wr_en,                                   // write enable signal
input logic [Addr_Width-1:0] Read_Address,           // input read address
input logic [Addr_Width-1:0] Write_Address,          // input write address
input logic [Data_Width-1:0] Write_Data,             // input write data
axi4_lite_bfm.master_if M                             // interface as a master
);


// declare the state variables for the FSM
// typedef enum logic [1:0] {IDLE, ADDR, DATA, RESP} state;                                // four states for read and write operation
state current_state_read, next_state_read, current_state_write, next_state_write;       // current and next state variables for read and write operation


/////////////////////////////////////////////////////////////
// FSM's to implement read and write operations of the master
/////////////////////////////////////////////////////////////

//////////////////FSM to implement read operation////////////

// state register for read operation
always_ff@ (posedge M.ACLK, negedge M.ARESETN)
begin
	if(M.ARESETN == 0)                                           // active low reset
		current_state_read <= IDLE;	                     // go to IDLE state
	else
		current_state_read <= next_state_read;               // else go to next state
end    // state register for read operation

// next state and output logic for read operation
always_comb
begin
	unique case(current_state_read)

	IDLE:	begin                                                 // initialize the signals of the read channels to zero
			M.RREADY  = 1'b0;
			M.ARVALID = 1'b0;
			if(rd_en)                                     // when read enable is asserted, go to ADDR state if there is a new input address else stay in IDLE state
			begin
				if (Read_Address == M.ARADDR)
				begin
					next_state_read = IDLE;
				end
				else
				begin
					next_state_read = ADDR;
				end
			end
			else
			begin
				next_state_read = IDLE;
			end
		end


	ADDR: 	begin
			M.ARADDR  = Read_Address;                    // assign the input address to the read address(ARADDR) signal of the read address channel
			M.ARVALID = 1'b1;                            // assert ARVALID to indicate that ARADDR is valid
			M.RREADY  = 1'b1;                            // assert RREADY to indicate that master is ready to receive the data from slave
			if(M.ARREADY)                                // when ARREADY is asserted by the slave, then go to DATA state else stay in ADDR state
				next_state_read = DATA;
			else
				next_state_read = ADDR;
		end


	DATA:	begin
			M.ARVALID = 1'b0;                            // deassert ARVALID indicating that address has been transferred from master to slave
			if(M.RVALID)                                 // when RVALID is asserted by slave, then go to RESP state else stay in the same state
				next_state_read = RESP;
			else
				next_state_read = DATA;
		end


	RESP:	begin
			M.RREADY = 1'b0;                             // deassert RREADY indicating that data has been transferred from slave to master and go to IDLE state
			next_state_read = IDLE;
		end

	endcase

end    // next state and output logic for read operation



//////////////////////////FSM to implement write operation///////////////////////////////////

// state register for write operation
always_ff@(posedge M.ACLK, negedge M.ARESETN)
begin
	if(M.ARESETN == 0)                                           // active low reset
		current_state_write <= IDLE;                         // go to IDLE state
	else
		current_state_write <= next_state_write;	     // else go to next state
end   // state register for write operation


// next state and output logic for write operation
always_comb
begin
	unique case(current_state_write)

	IDLE:	begin                                                // initialize the signals of the write channels to zero
			M.AWVALID = 1'b0;
			M.WVALID  = 1'b0;
			M.BREADY  = 1'b0;
			if(wr_en)                                    // when write enable is asserted, go to ADDR state if there is a new input address and data else stay in IDLE state
			begin
				if (Write_Address == M.AWADDR && Write_Data == M.WDATA)
				begin
					next_state_write = IDLE;
				end
				else
				begin
					next_state_write = ADDR;
				end
			end
			else
			begin
				next_state_write = IDLE;
			end
		end


	ADDR: 	begin

			M.AWADDR  = Write_Address;                  // assign the input write address to the write address(AWADDR) signal of the write address channel
			M.AWVALID = 1'b1;                           // asssert AWVALID to indicate that AWADDR is valid
			M.WDATA   = Write_Data;                     // assign the input write data to the write data(WDATA) signal of the write data channel
			M.WVALID  = 1'b1;                           // assert WVALID to indicate that WDATA is valid
			M.BREADY  = 1'b1;                           // assert BREADY to indicate that master is ready to receive the response from the slave
			if(M.WREADY)                                // when AWREADY is asserted by the slave, then go to DATA state else stay in ADDR state
				next_state_write = DATA;
			else
				next_state_write = ADDR;
		end



	DATA:	begin
			M.AWVALID = 1'b0;                            // deassert AWVALID indicating that address has been transferred from master to slave
			M.WVALID  = 1'b0;                            // deassert WVALID indicating that data has been transferred from master to slave
			if(M.BVALID)                                 // when BVALID is asserted by the slave, then go to RESP state else stay in DATA state
				next_state_write = RESP;
			else
				next_state_write = DATA;
		end


	RESP:	begin
			M.BREADY = 1'b0;                             // deassert BREADY indicating that write response transaction is over and go to IDLE state
			next_state_write = IDLE;
		end

	endcase
end    // next state and output logic for write operation


endmodule: axi4_lite_master