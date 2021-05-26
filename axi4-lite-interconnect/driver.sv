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

            drive_device_1_master(txn);
            drive_device_2_master(txn);
        end
    endtask

    task drive_device_1_master(transaction txn);
        
        // set writes
        bfm0.addr           = txn.addr_0;
        bfm0.data           = txn.data_0;
        bfm0.start_write    = txn.start_write_0;
        bfm0.start_read     = txn.start_read_0;

        // set read and write to invalid after 1 cycle
        @(posedge bfm0.aclk);
        bfm0.start_write    = '0;
        bfm0.start_read     = '0;

        @(posedge bfm0.aclk);
    endtask

    task drive_device_2_master(transaction txn);
         // set writes
        bfm1.addr           = txn.addr_1;
        bfm1.data           = txn.data_1;
        bfm1.start_write    = txn.start_write_1;
        bfm1.start_read     = txn.start_read_1;

        // set read and write to invalid after 1 cycle
        @(posedge bfm1.aclk);
        bfm1.start_write    = '0;
        bfm1.start_read     = '0;

        @(posedge bfm1.aclk);
    endtask

endclass