import axi_lite_pkg::*;

class driver;

    // mailbox to connect to generator
	mailbox mb_generator2driver = new();

    // virtual interface
    virtual axi_lite_if bfm0, bfm1;
    
    // transaction objs for 2 devices to store data send from generator
    transaction txn; 

    // constructor
    function new(mailbox mb_generator2driver, virtual axi_lite_if bfm0, bfm1);

        this.mb_generator2driver = mb_generator2driver;
        this.bfm0 = bfm0;
        this.bfm1 = bfm1;
    endfunction 

    task execute();
        txn = new();

        forever begin
            mb_generator2driver.get(txn);

            drive_device_1_pins(txn);
            drive_device_2_pins(txn);
        end
    endtask

    task drive_device_1_pins(transaction txn);
        
        // set writes
        bfm0.awvalid    = txn.awvalid_0;
        bfm0.wvalid     = txn.wvalid_0;
        bfm0.awaddr     = txn.awaddr_0;
        bfm0.wdata      = txn.wdata_0;
        // set read
        bfm0.arvalid    = txn.arvalid_0;
        bfm0.araddr     = txn.araddr_0;
        // set read and write to invalid after 1 cycle
        @(posedge bfm0.aclk);
        bfm0.wvalid     = 0;
        bfm0.awvalid    = 0;
        bfm0.wvalid     = 0;
        bfm0.awvalid    = 0;
        @(posedge bfm0.aclk);
    endtask

    task drive_device_2_pins(transaction txn);
        // set writes
        bfm1.awvalid    = txn.awvalid_1;
        bfm1.wvalid     = txn.wvalid_1;
        bfm1.awaddr     = txn.awaddr_1;
        bfm1.wdata      = txn.wdata_1;
        // set read
        bfm1.arvalid    = txn.arvalid_1;
        bfm1.araddr     = txn.araddr_1;
        // set read and write to invalid after 1 cycle
        @(posedge bfm0.aclk);
        bfm1.wvalid     = 0;
        bfm1.awvalid    = 0;
        bfm1.wvalid     = 0;
        bfm1.awvalid    = 0;
        @(posedge bfm0.aclk);
    endtask

endclass