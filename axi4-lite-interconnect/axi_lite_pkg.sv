/////////////////////////////////////////////////////////////////////////////////////////////
// Name         : axi_lite_pkg.sv 
// Description  : Contains shared parameters, structures and enums used in DUV and testbench
// Authors      : N/A  				                                 
// Date         : 05/29/2021                                                                  
// Version      : 1  
// Modified	By	: Amrutha | Durganila | Manjari                                                                    
/////////////////////////////////////////////////////////////////////////////////////////////

package axi_lite_pkg;

	localparam STEP = 10;
	localparam addr0 = 32'h4;
	localparam addr1 = 32'h14;
	
	localparam ADDR_WIDTH = 12;
	localparam DATA_WIDTH = 32;
	localparam STRB_WIDTH = DATA_WIDTH / 8;

	localparam RESP_OKAY   = 2'b00;
	localparam RESP_EXOKAY = 2'b01;
	localparam RESP_SLVERR = 2'b10;
	localparam RESP_DECERR = 2'b11;

	typedef logic [ADDR_WIDTH - 1 : 0] addr_t;
	typedef logic [DATA_WIDTH - 1 : 0] data_t;
	typedef logic [STRB_WIDTH - 1 : 0] strb_t;
	typedef logic [1 : 0] resp_t;

	typedef enum logic [2 : 0] {IDLE, RADDR, RDATA, WADDR, WDATA, WRESP} state_type;

	// buffer size, used in slave/scoreboard
    parameter BUFFER_SIZE = 2**12;

	// Read Address Channel
	typedef struct packed {
		addr_t addr;
		logic valid;
		logic ready;
	} ar_chan_t;

	// Read Data Channel
	typedef struct packed {
		data_t data;
		resp_t resp;
		logic valid;
		logic ready;
	} r_chan_t;

	// Write Address Channel
	typedef struct packed {
		addr_t addr;
		logic valid;
		logic ready;
	} aw_chan_t;

	// Write Data Channel
	typedef struct packed {
		data_t data;
		strb_t strb;
		logic valid;
		logic ready;
	} w_chan_t;

	// Write Response Channel
	typedef struct packed {
		resp_t resp;
		logic valid;
		logic ready;
	} b_chan_t;


	typedef struct packed {
		ar_chan_t ar;
		r_chan_t r;
		aw_chan_t aw;
		w_chan_t w;
		b_chan_t b;
	} axi_lite_bus_t;


`include "./TB/transaction.sv"
`include "./TB/generator.sv"
`include "./TB/driver.sv"
`include "./TB/TestTypes/fully_random_test.sv"
`include "./TB/TestTypes/deterministic_tests.sv"
`include "./TB/testFactory.sv"
`include "./TB/monitor.sv"
`include "./TB/scoreboard.sv"

endpackage
