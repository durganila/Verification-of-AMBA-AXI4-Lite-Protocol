import axi_lite_pkg::*;

module axi_lite_master#(
	parameter int ADDR = 12'h4
)(	axi_lite_if.master m_axi_lite
);

	typedef enum logic [2 : 0] {IDLE, RADDR, RDATA, WADDR, WDATA, WRESP} state_type;
	state_type state, next_state;

	data_t rdata;
	logic start_read_delay, start_write_delay;

	// AR
	assign m_axi_lite.araddr  = (state == RADDR) ? m_axi_lite.addr : 12'h0;
	assign m_axi_lite.arvalid = (state == RADDR) ? 1 : 0;

	// R
	assign m_axi_lite.rready = (state == RDATA) ? 1 : 0;

	// AW
	assign m_axi_lite.awvalid = (state == WADDR) ? 1 : 0;
	assign m_axi_lite.awaddr  = (state == WADDR) ? m_axi_lite.addr : 12'h0;

	// W
	assign m_axi_lite.wvalid = (state == WDATA) ? 1 : 0;
	assign m_axi_lite.wdata  = (state == WDATA) ? m_axi_lite.data : 8'h0;
	assign m_axi_lite.wstrb  = 4'b0000;

	// B
	assign m_axi_lite.bready = ((state == WADDR) | (state == WDATA) |(state == WRESP)) ? 1 : 0;


	always_ff @(posedge m_axi_lite.aclk) begin
		if (~m_axi_lite.areset_n) begin
			rdata <= 0;
		end else begin
			if (state == RDATA) rdata <= m_axi_lite.rdata;
		end
	end

	always_ff @(posedge m_axi_lite.aclk) begin
		if (~m_axi_lite.areset_n) begin
			start_read_delay  <= 0;
			start_write_delay <= 0;
		end else begin
			start_read_delay  <= m_axi_lite.start_read;
			start_write_delay <= m_axi_lite.start_write;
		end
	end

	always_comb begin
		case (state)
			IDLE : next_state = (start_read_delay) ? RADDR : ((start_write_delay) ? WADDR : IDLE);
			RADDR : if (m_axi_lite.arvalid && m_axi_lite.arready) next_state = RDATA;
			RDATA : if (m_axi_lite.rvalid  && m_axi_lite.rready ) next_state = IDLE;
			WADDR : if (m_axi_lite.awvalid && m_axi_lite.awready) next_state = WDATA;
			WDATA : if (m_axi_lite.wvalid  && m_axi_lite.wready ) next_state = WRESP;
			WRESP : if (m_axi_lite.bvalid  && m_axi_lite.bready ) next_state = IDLE;
			default : next_state = IDLE;
		endcase
	end

	always_ff @(posedge m_axi_lite.aclk) begin
		if (~m_axi_lite.areset_n) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end

endmodule // axi_lite_master
