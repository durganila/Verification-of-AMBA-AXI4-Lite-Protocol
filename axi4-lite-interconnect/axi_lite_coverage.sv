import axi_lite_pkg::*;

class axi_lite_coverage;
    virtual axi_lite_if bfm0, bfm1;
/*     function new (virtual axi_lite_if bfm0, bfm1);
        this.bfm0 = bfm0;
        this.bfm1 = bfm1;
    endfunction */
	
	// ------------------------------------------------------- COVERAGES -------------------------------------------------------
	// -----------------------------------------------------------bfm0----------------------------------------------------------
	// Covergroup 1 for Read Address
	covergroup cg_Read_Address0;
	Read_Address_Valid0: coverpoint bfm0.arvalid iff (bfm0.areset_n) {   // Coverpoint for Read Address Valid signal
		bins arvalid_High = {1};
		bins arvalid_Low = {0};
		}
	
	Read_Address_Ready0: coverpoint bfm0.arready iff (bfm0.areset_n) {   // Coverpoint for Read Address Ready signal
		bins arready_High = {1};
		bins arready_Low = {0};
		}
	
	Read_Address0: coverpoint bfm0.araddr {                          	// Coverpoint for Read Address
		bins araddr_First_Location = {0};
		bins araddr_Last_Location = {4096};
		bins araddr_range[] = {[1:4095]};
		}
	endgroup : cg_Read_Address0
	
	
	// Covergroup 2 for Read Data
	covergroup cg_Read_Data0;
	Read_Data_Valid0: coverpoint bfm0.rvalid iff (bfm0.areset_n) {    // Coverpoint for Read Data Valid signal
		bins rvalid_High = {1};
		bins rvalid_Low = {0};
		}
	
	Read_Data_Ready0: coverpoint bfm0.rready iff (bfm0.areset_n) {       // Coverpoint for Read Data Ready signal
		bins rready_High = {1};
		bins rready_Low = {0};
		}
	
	Read_Data0: coverpoint bfm0.rdata {                                 // Coverpoint for Read Data
		bins rdata_All_Zeros = {0};
		bins rdata_All_Ones = {4096};
		bins rdata_range[] = {[1:4095]};
		}
	endgroup : cg_Read_Data0
	
	
	// Covergroup 3 for Write Address
	covergroup cg_Write_Address0;
	Write_Address_Valid0: coverpoint bfm0.awvalid iff (bfm0.areset_n) {  // Coverpoint for Write Address Valid signal
		bins awvalid_High = {1};
		bins awvalid_Low = {0};
		}
	
	Write_Address_Ready0: coverpoint bfm0.awready iff (bfm0.areset_n) {     // Coverpoint for Write Address Ready signal
		bins awready_High = {1};
		bins awready_Low = {0};
		}
	
	Write_Address0: coverpoint bfm0.awaddr {                               // Coverpoint for Write Address signal
		bins awaddr_First_Location = {0};
		bins awaddr_Last_Location = {4096};
		bins awaddr_range[] = {[1:4095]};
		}
	endgroup : cg_Write_Address0
	
	
	// Covergroup 4 for Write Data
	covergroup cg_Write_Data0;
	Write_Data_Valid0: coverpoint bfm0.wvalid iff (bfm0.areset_n) {      // Coverpoint for Write Data Valid signal
		bins wvalid_High = {1};
		bins wvalid_Low = {0};
		}
	
	Write_Data_Ready0: coverpoint bfm0.wready iff (bfm0.areset_n) {         // Coverpoint for Write Data Ready signal
		bins wready_High = {1};
		bins wready_Low = {0};
		}
	
	Write_Data0: coverpoint bfm0.wdata {                               // Coverpoint for Write Data signal
		bins wdata_All_Zeros = {0};
		bins wdata_All_Ones = {4096};
		bins wdata_range[] = {[1:4095]};
		}
	endgroup : cg_Write_Data0
	
	
	// Covergroup 5 for Write Response
	covergroup cg_Write_Response0;
	Write_Response_Valid0: coverpoint bfm0.bvalid iff (bfm0.areset_n) {  // Coverpoint for Write Response Valid signal
		bins bvalid_High = {1};
		bins bvalid_Low = {0};
		}
	
	Write_Response_Ready0: coverpoint bfm0.bready iff (bfm0.areset_n) {     // Coverpoint for Write Response Ready signal
		bins bready_High = {1};
		bins bready_Low = {0};
		}
	endgroup : cg_Write_Response0
	
	
	// Covergroup 6 for Master FSM
	covergroup cg_Master_FSM0;
		Master_Read_FSM0: coverpoint $root.top.master0.state iff (bfm0.areset_n) {   // Coverpoint for Master Read FSM
			bins mr1 = (IDLE => RADDR);
			bins mr2 = (RADDR => RDATA);
			bins mr3 = (RDATA => IDLE);
			bins mr_sequence = (IDLE => RADDR => RDATA => IDLE);
			illegal_bins mr_illegal1 = (RDATA => RADDR);
			illegal_bins mr_illegal3 = (IDLE => RDATA);
		}
	
		Master_Write_FSM0: coverpoint $root.top.master0.state iff (bfm0.areset_n) {    // Coverpoint for Master Write FSM
			bins mw1 = (IDLE => WADDR);
			bins mw2 = (WADDR => WDATA);
			bins mw3 = (WDATA => WRESP);
			bins mw4 = (WRESP => IDLE); 
			bins mw_sequence = (IDLE => WADDR => WDATA => WRESP => IDLE);
			illegal_bins mw_illegal1 = (WDATA => WADDR);
			illegal_bins mw_illegal3 = (WRESP => WDATA);
			illegal_bins mw_illegal4 = (WRESP => WADDR);
			illegal_bins mw_illegal5 = (IDLE => WDATA);
			illegal_bins mw_illegal6 = (IDLE => WRESP);
			illegal_bins mw_illegal7 = (WADDR => WRESP);
		}
	endgroup : cg_Master_FSM0

	
	// Covergroup 7 for Slave FSM
	covergroup cg_Slave_FSM0;
		Slave_Read_FSM0: coverpoint $root.top.slave0.state iff (bfm0.areset_n) {  // Coverpoint for Slave Read FSM
			bins sr1 = (IDLE => RADDR);
			bins sr2 = (RADDR => RDATA);
			bins sr3 = (RDATA => IDLE);
			bins sr_sequence = (IDLE => RADDR => RDATA => IDLE);
			illegal_bins sr_illegal1 = (RDATA => RADDR);
			illegal_bins sr_illegal3 = (IDLE => RDATA);
		}
	
		Slave_Write_FSM0: coverpoint $root.top.slave0.state iff (bfm0.areset_n) {   // Coverpoint for Slave Write FSM
			bins sw1 = (IDLE => WADDR);
			bins sw2 = (WADDR => WDATA);
			bins sw3 = (WDATA => WRESP);
			bins sw4 = (WRESP => IDLE); 
			bins sw_sequence = (IDLE => WADDR => WDATA => WRESP => IDLE);
			illegal_bins sw_illegal1 = (WDATA => WADDR);
			illegal_bins sw_illegal3 = (WRESP => WDATA);
			illegal_bins sw_illegal4 = (WRESP => WADDR);
			illegal_bins sw_illegal5 = (IDLE => WDATA);
			illegal_bins sw_illegal6 = (IDLE => WRESP);
			illegal_bins sw_illegal7 = (WADDR => WRESP);
		}
	endgroup : cg_Slave_FSM0
	
	
	// Covergroup 8 for Reset signals
	covergroup cg_Reset_Signal0;
	
		Read_Address_Valid_Reset0: coverpoint bfm0.arvalid iff (!(bfm0.areset_n)) {   // Coverpoint for Read Address Valid Signal
			bins arvalid_Low_Reset = {0};
			illegal_bins arvalid_High_Reset_illegal = {1};
		}
	
		Read_Address_Ready_Reset0: coverpoint bfm0.arready iff (!(bfm0.areset_n)) {   // Coverpoint for Read Address Ready Signal
			bins arready_Low_Reset = {0};
			illegal_bins arready_High_Reset_illegal = {1};
		}
	
		Read_Data_Valid_Reset0: coverpoint bfm0.rvalid iff (!(bfm0.areset_n)) {       // Coverpoint for Read Data Valid Signal
			bins rvalid_Low_Reset = {0};
			illegal_bins rvalid_High_Reset_illegal = {1};
		}
	
		Read_Data_Ready_Reset0: coverpoint bfm0.rready iff (!(bfm0.areset_n)) {       // Coverpoint for Read Data Ready Signal
			bins rready_Low_Reset = {0};
			illegal_bins rready_High_Reset_illegal = {1};
		}
	
		Write_Address_Valid_Reset0: coverpoint bfm0.awvalid iff (!(bfm0.areset_n)) {  // Coverpoint for Write Address Valid Signal
			bins awvalid_Low_Reset = {0};
			illegal_bins awvalid_High_Reset_illegal = {1};
		}
	
		Write_Address_Ready_Reset0: coverpoint bfm0.awready iff (!(bfm0.areset_n)) {  // Coverpoint for Write Address Ready Signal
			bins awready_Low_Reset = {0};
			illegal_bins awready_High_Reset_illegal = {1};
		}
	
		Write_Data_Valid_Reset0: coverpoint bfm0.wvalid iff (!(bfm0.areset_n)) {      // Coverpoint for Write Data Valid Signal
			bins wvalid_Low_Reset = {0};
			illegal_bins wvalid_High_Reset_illegal = {1};
		}
	
		Write_Data_Ready_Reset0: coverpoint bfm0.wready iff (!(bfm0.areset_n)) {      // Coverpoint for Write Data Ready Signal
			bins wready_Low_Reset = {0};
			illegal_bins wready_High_Reset_illegal = {1};
		}
	
		Write_Response_Valid_Reset0: coverpoint bfm0.bvalid iff (!(bfm0.areset_n)) {   // Coverpoint for Write Response Valid Signal
			bins bvalid_Low_Reset = {0};
			illegal_bins bvalid_High_Reset_illegal = {1};
		}
	
		Write_Response_Ready_Reset0: coverpoint bfm0.bready iff (!(bfm0.areset_n)) {  // Coverpoint for Write Response Ready Signal
			bins bready_Low_Reset = {0};
			illegal_bins bready_High_Reset_illegal = {1};
		}
			
		Master_Read_FSM_Reset0: coverpoint $root.top.master0.state iff (!(bfm0.areset_n)) {   // Coverpoint for Master Read FSM
			bins mr_reset1 = (RADDR => IDLE);
			bins mr_reset2 = (RDATA => IDLE);
			illegal_bins mr_illegal1 = (IDLE => RADDR);
			illegal_bins mr_illegal2 = (RADDR => RDATA);
			illegal_bins mr_illegal4 = (RDATA => RADDR);
			illegal_bins mr_illegal7 = (IDLE => RDATA);
		}
	
		Master_Write_FSM_Reset0: coverpoint $root.top.master0.state iff (!(bfm0.areset_n)) {    // Coverpoint for Master Write FSM
			bins mw_reset1 = (WADDR => IDLE);
			bins mw_reset2 = (WDATA => IDLE);
			bins mw_reset3 = (WRESP => IDLE);
			illegal_bins mw_illegal1 = (IDLE => WADDR);
			illegal_bins mw_illegal2 = (WADDR => WDATA);
			illegal_bins mw_illegal3 = (WDATA => WRESP);
			illegal_bins mw_illegal4 = (WDATA => WADDR);
			illegal_bins mw_illegal5 = (WRESP => WDATA);
			illegal_bins mw_illegal6 = (WRESP => WADDR);
			illegal_bins mw_illegal7 = (IDLE => WDATA);
			illegal_bins mw_illegal8 = (IDLE => WRESP);
			illegal_bins mw_illegal9 = (WADDR => WRESP);
		}
	
		Slave_Read_FSM_Reset0: coverpoint $root.top.slave0.state iff (!(bfm0.areset_n)) {    // Coverpoint for Slave Read FSM
			bins sr_reset1 = (RADDR => IDLE);
			bins sr_reset2 = (RDATA => IDLE);
			illegal_bins sr_illegal1 = (IDLE => RADDR);
			illegal_bins sr_illegal2 = (RADDR => RDATA);
			illegal_bins sr_illegal4 = (RDATA => RADDR);
			illegal_bins sr_illegal7 = (IDLE => RDATA);
		}
	
		Slave_Write_FSM_Reset0: coverpoint $root.top.slave0.state iff (!(bfm0.areset_n)) {     // Coverpoint for Slave Write FSM
			bins sw_reset1 = (WADDR => IDLE);
			bins sw_reset2 = (WDATA => IDLE);
			bins sw_reset3 = (WRESP => IDLE);
			illegal_bins sw_illegal1 = (IDLE => WADDR);
			illegal_bins sw_illegal2 = (WADDR => WDATA);
			illegal_bins sw_illegal3 = (WDATA => WRESP);
			illegal_bins sw_illegal4 = (WDATA => WADDR);
			illegal_bins sw_illegal5 = (WRESP => WDATA);
			illegal_bins sw_illegal6 = (WRESP => WADDR);
			illegal_bins sw_illegal7 = (IDLE => WDATA);
			illegal_bins sw_illegal8 = (IDLE => WRESP);
			illegal_bins sw_illegal9 = (WADDR => WRESP);
		}
	
	endgroup : cg_Reset_Signal0
	
	// -----------------------------------------------------------bfm1----------------------------------------------------------
	// Covergroup 1 for Read Address
	covergroup cg_Read_Address1;
	Read_Address_Valid1: coverpoint bfm1.arvalid iff (bfm1.areset_n) {   // Coverpoint for Read Address Valid signal
		bins arvalid_High = {1};
		bins arvalid_Low = {0};
		}
	
	Read_Address_Ready1: coverpoint bfm1.arready iff (bfm1.areset_n) {   // Coverpoint for Read Address Ready signal
		bins arready_High = {1};
		bins arready_Low = {0};
		}
	
	Read_Address1: coverpoint bfm1.araddr {                          	// Coverpoint for Read Address
		bins araddr_First_Location = {0};
		bins araddr_Last_Location = {4096};
		bins araddr_range[] = {[1:4095]};
		}
	endgroup : cg_Read_Address1
	
	
	// Covergroup 2 for Read Data
	covergroup cg_Read_Data1;
	Read_Data_Valid1: coverpoint bfm1.rvalid iff (bfm1.areset_n) {    // Coverpoint for Read Data Valid signal
		bins rvalid_High = {1};
		bins rvalid_Low = {0};
		}
	
	Read_Data_Ready1: coverpoint bfm1.rready iff (bfm1.areset_n) {       // Coverpoint for Read Data Ready signal
		bins rready_High = {1};
		bins rready_Low = {0};
		}
	
	Read_Data1: coverpoint bfm1.rdata {                                 // Coverpoint for Read Data
		bins rdata_All_Zeros = {0};
		bins rdata_All_Ones = {4096};
		bins rdata_range[] = {[1:4095]};
		}
	endgroup : cg_Read_Data1
	
	
	// Covergroup 3 for Write Address
	covergroup cg_Write_Address1;
	Write_Address_Valid1: coverpoint bfm1.awvalid iff (bfm1.areset_n) {  // Coverpoint for Write Address Valid signal
		bins awvalid_High = {1};
		bins awvalid_Low = {0};
		}
	
	Write_Address_Ready1: coverpoint bfm1.awready iff (bfm1.areset_n) {     // Coverpoint for Write Address Ready signal
		bins awready_High = {1};
		bins awready_Low = {0};
		}
	
	Write_Address1: coverpoint bfm1.awaddr {                               // Coverpoint for Write Address signal
		bins awaddr_First_Location = {0};
		bins awaddr_Last_Location = {4096};
		bins awaddr_range[] = {[1:4095]};
		}
	endgroup : cg_Write_Address1
	
	
	// Covergroup 4 for Write Data
	covergroup cg_Write_Data1;
	Write_Data_Valid1: coverpoint bfm1.wvalid iff (bfm1.areset_n) {      // Coverpoint for Write Data Valid signal
		bins wvalid_High = {1};
		bins wvalid_Low = {0};
		}
	
	Write_Data_Ready1: coverpoint bfm1.wready iff (bfm1.areset_n) {         // Coverpoint for Write Data Ready signal
		bins wready_High = {1};
		bins wready_Low = {0};
		}
	
	Write_Data1: coverpoint bfm1.wdata {                               // Coverpoint for Write Data signal
		bins wdata_All_Zeros = {0};
		bins wdata_All_Ones = {4096};
		bins wdata_range[] = {[1:4095]};
		}
	endgroup : cg_Write_Data1
	
	
	// Covergroup 5 for Write Response
	covergroup cg_Write_Response1;
	Write_Response_Valid1: coverpoint bfm1.bvalid iff (bfm1.areset_n) {  // Coverpoint for Write Response Valid signal
		bins bvalid_High = {1};
		bins bvalid_Low = {0};
		}
	
	Write_Response_Ready1: coverpoint bfm1.bready iff (bfm1.areset_n) {     // Coverpoint for Write Response Ready signal
		bins bready_High = {1};
		bins bready_Low = {0};
		}
	endgroup : cg_Write_Response1
	
	
	// Covergroup 6 for Master FSM
	covergroup cg_Master_FSM1;
		Master_Read_FSM1: coverpoint $root.top.master0.state iff (bfm1.areset_n) {   // Coverpoint for Master Read FSM
			bins mr1 = (IDLE => RADDR);
			bins mr2 = (RADDR => RDATA);
			bins mr3 = (RDATA => IDLE);
			bins mr_sequence = (IDLE => RADDR => RDATA => IDLE);
			illegal_bins mr_illegal1 = (RDATA => RADDR);
			illegal_bins mr_illegal3 = (IDLE => RDATA);
		}
	
		Master_Write_FSM1: coverpoint $root.top.master0.state iff (bfm1.areset_n) {    // Coverpoint for Master Write FSM
			bins mw1 = (IDLE => WADDR);
			bins mw2 = (WADDR => WDATA);
			bins mw3 = (WDATA => WRESP);
			bins mw4 = (WRESP => IDLE); 
			bins mw_sequence = (IDLE => WADDR => WDATA => WRESP => IDLE);
			illegal_bins mw_illegal1 = (WDATA => WADDR);
			illegal_bins mw_illegal3 = (WRESP => WDATA);
			illegal_bins mw_illegal4 = (WRESP => WADDR);
			illegal_bins mw_illegal5 = (IDLE => WDATA);
			illegal_bins mw_illegal6 = (IDLE => WRESP);
			illegal_bins mw_illegal7 = (WADDR => WRESP);
		}
	endgroup : cg_Master_FSM1

	
	// Covergroup 7 for Slave FSM
	covergroup cg_Slave_FSM1;
		Slave_Read_FSM1: coverpoint $root.top.slave0.state iff (bfm1.areset_n) {  // Coverpoint for Slave Read FSM
			bins sr1 = (IDLE => RADDR);
			bins sr2 = (RADDR => RDATA);
			bins sr3 = (RDATA => IDLE);
			bins sr_sequence = (IDLE => RADDR => RDATA => IDLE);
			illegal_bins sr_illegal1 = (RDATA => RADDR);
			illegal_bins sr_illegal3 = (IDLE => RDATA);
		}
	
		Slave_Write_FSM1: coverpoint $root.top.slave0.state iff (bfm1.areset_n) {   // Coverpoint for Slave Write FSM
			bins sw1 = (IDLE => WADDR);
			bins sw2 = (WADDR => WDATA);
			bins sw3 = (WDATA => WRESP);
			bins sw4 = (WRESP => IDLE); 
			bins sw_sequence = (IDLE => WADDR => WDATA => WRESP => IDLE);
			illegal_bins sw_illegal1 = (WDATA => WADDR);
			illegal_bins sw_illegal3 = (WRESP => WDATA);
			illegal_bins sw_illegal4 = (WRESP => WADDR);
			illegal_bins sw_illegal5 = (IDLE => WDATA);
			illegal_bins sw_illegal6 = (IDLE => WRESP);
			illegal_bins sw_illegal7 = (WADDR => WRESP);
		}
	endgroup : cg_Slave_FSM1
	
	
	// Covergroup 8 for Reset signals
	covergroup cg_Reset_Signal1;
	
		Read_Address_Valid_Reset1: coverpoint bfm1.arvalid iff (!(bfm1.areset_n)) {   // Coverpoint for Read Address Valid Signal
			bins arvalid_Low_Reset = {0};
			illegal_bins arvalid_High_Reset_illegal = {1};
		}
	
		Read_Address_Ready_Reset1: coverpoint bfm1.arready iff (!(bfm1.areset_n)) {   // Coverpoint for Read Address Ready Signal
			bins arready_Low_Reset = {0};
			illegal_bins arready_High_Reset_illegal = {1};
		}
	
		Read_Data_Valid_Reset1: coverpoint bfm1.rvalid iff (!(bfm1.areset_n)) {       // Coverpoint for Read Data Valid Signal
			bins rvalid_Low_Reset = {0};
			illegal_bins rvalid_High_Reset_illegal = {1};
		}
	
		Read_Data_Ready_Reset1: coverpoint bfm1.rready iff (!(bfm1.areset_n)) {       // Coverpoint for Read Data Ready Signal
			bins rready_Low_Reset = {0};
			illegal_bins rready_High_Reset_illegal = {1};
		}
	
		Write_Address_Valid_Reset1: coverpoint bfm1.awvalid iff (!(bfm1.areset_n)) {  // Coverpoint for Write Address Valid Signal
			bins awvalid_Low_Reset = {0};
			illegal_bins awvalid_High_Reset_illegal = {1};
		}
	
		Write_Address_Ready_Reset1: coverpoint bfm1.awready iff (!(bfm1.areset_n)) {  // Coverpoint for Write Address Ready Signal
			bins awready_Low_Reset = {0};
			illegal_bins awready_High_Reset_illegal = {1};
		}
	
		Write_Data_Valid_Reset1: coverpoint bfm1.wvalid iff (!(bfm1.areset_n)) {      // Coverpoint for Write Data Valid Signal
			bins wvalid_Low_Reset = {0};
			illegal_bins wvalid_High_Reset_illegal = {1};
		}
	
		Write_Data_Ready_Reset1: coverpoint bfm1.wready iff (!(bfm1.areset_n)) {      // Coverpoint for Write Data Ready Signal
			bins wready_Low_Reset = {0};
			illegal_bins wready_High_Reset_illegal = {1};
		}
	
		Write_Response_Valid_Reset1: coverpoint bfm1.bvalid iff (!(bfm1.areset_n)) {   // Coverpoint for Write Response Valid Signal
			bins bvalid_Low_Reset = {0};
			illegal_bins bvalid_High_Reset_illegal = {1};
		}
	
		Write_Response_Ready_Reset1: coverpoint bfm1.bready iff (!(bfm1.areset_n)) {  // Coverpoint for Write Response Ready Signal
			bins bready_Low_Reset = {0};
			illegal_bins bready_High_Reset_illegal = {1};
		}
			
		Master_Read_FSM_Reset1: coverpoint $root.top.master0.state iff (!(bfm1.areset_n)) {   // Coverpoint for Master Read FSM
			bins mr_reset1 = (RADDR => IDLE);
			bins mr_reset2 = (RDATA => IDLE);
			illegal_bins mr_illegal1 = (IDLE => RADDR);
			illegal_bins mr_illegal2 = (RADDR => RDATA);
			illegal_bins mr_illegal4 = (RDATA => RADDR);
			illegal_bins mr_illegal7 = (IDLE => RDATA);
		}
	
		Master_Write_FSM_Reset1: coverpoint $root.top.master0.state iff (!(bfm1.areset_n)) {    // Coverpoint for Master Write FSM
			bins mw_reset1 = (WADDR => IDLE);
			bins mw_reset2 = (WDATA => IDLE);
			bins mw_reset3 = (WRESP => IDLE);
			illegal_bins mw_illegal1 = (IDLE => WADDR);
			illegal_bins mw_illegal2 = (WADDR => WDATA);
			illegal_bins mw_illegal3 = (WDATA => WRESP);
			illegal_bins mw_illegal4 = (WDATA => WADDR);
			illegal_bins mw_illegal5 = (WRESP => WDATA);
			illegal_bins mw_illegal6 = (WRESP => WADDR);
			illegal_bins mw_illegal7 = (IDLE => WDATA);
			illegal_bins mw_illegal8 = (IDLE => WRESP);
			illegal_bins mw_illegal9 = (WADDR => WRESP);
		}
	
		Slave_Read_FSM_Reset1: coverpoint $root.top.slave0.state iff (!(bfm1.areset_n)) {    // Coverpoint for Slave Read FSM
			bins sr_reset1 = (RADDR => IDLE);
			bins sr_reset2 = (RDATA => IDLE);
			illegal_bins sr_illegal1 = (IDLE => RADDR);
			illegal_bins sr_illegal2 = (RADDR => RDATA);
			illegal_bins sr_illegal4 = (RDATA => RADDR);
			illegal_bins sr_illegal7 = (IDLE => RDATA);
		}
	
		Slave_Write_FSM_Reset1: coverpoint $root.top.slave0.state iff (!(bfm1.areset_n)) {     // Coverpoint for Slave Write FSM
			bins sw_reset1 = (WADDR => IDLE);
			bins sw_reset2 = (WDATA => IDLE);
			bins sw_reset3 = (WRESP => IDLE);
			illegal_bins sw_illegal1 = (IDLE => WADDR);
			illegal_bins sw_illegal2 = (WADDR => WDATA);
			illegal_bins sw_illegal3 = (WDATA => WRESP);
			illegal_bins sw_illegal4 = (WDATA => WADDR);
			illegal_bins sw_illegal5 = (WRESP => WDATA);
			illegal_bins sw_illegal6 = (WRESP => WADDR);
			illegal_bins sw_illegal7 = (IDLE => WDATA);
			illegal_bins sw_illegal8 = (IDLE => WRESP);
			illegal_bins sw_illegal9 = (WADDR => WRESP);
		}
	
	endgroup : cg_Reset_Signal1
	
	
	// Function "new" which instantiates all the Covergroups
	function new (virtual axi_lite_if b0,b1);
		cg_Read_Address0 = new();
		cg_Read_Data0 = new();
		cg_Write_Address0 = new();
		cg_Write_Data0 = new();
		cg_Write_Response0 = new();
		cg_Reset_Signal0 = new();
		cg_Master_FSM0 = new();
		cg_Slave_FSM0 = new();
	
		this.bfm0 = b0;
		
		cg_Read_Address1 = new();
		cg_Read_Data1 = new();
		cg_Write_Address1 = new();
		cg_Write_Data1 = new();
		cg_Write_Response1 = new();
		cg_Reset_Signal1 = new();
		cg_Master_FSM1 = new();
		cg_Slave_FSM1 = new();
		
		this.bfm1 = b1;
		
	endfunction : new
	
	// Task "execute" which samples all the covergroups
	// This task can be called in environment class to sample all the covergroups
	task execute();
		forever begin : sampling_block0
			@(posedge bfm0.aclk);
			cg_Read_Address0.sample();
			cg_Read_Data0.sample();
			cg_Write_Address0.sample();
			cg_Write_Data0.sample();
			cg_Write_Response0.sample();
			cg_Reset_Signal0.sample();
			cg_Master_FSM0.sample();
			cg_Slave_FSM0.sample();
		end : sampling_block0
	
		forever begin : sampling_block1
			@(posedge bfm1.aclk);
			cg_Read_Address1.sample();
			cg_Read_Data1.sample();
			cg_Write_Address1.sample();
			cg_Write_Data1.sample();
			cg_Write_Response1.sample();
			cg_Reset_Signal1.sample();
			cg_Master_FSM1.sample();
			cg_Slave_FSM1.sample();
		end : sampling_block1
	
	endtask : execute
endclass