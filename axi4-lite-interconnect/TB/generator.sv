///////////////////////////////////////////////////////////////////////////////////////////
// Name         : generator.sv   
// Description  : Parent class for test classes.                                                             
// Authors      : Amrutha | Durganila | Manjari  				                                 
// Date         : 06/02/2020                                                                  
// Version      : 1                                                                       
///////////////////////////////////////////////////////////////////////////////////////////

import axi_lite_pkg::*;

virtual class generator;

    mailbox mb_generator2driver = new();    // mailbox for generator to driver
    logic   debugMode           = '0;       // var for debug mode
    int     numTransactions     = 0;        // var for number of transactions

    // constructor 
    function new(mailbox mb_generator2driver, logic debugMode, int numTransactions);
        this.mb_generator2driver    = mb_generator2driver;
        this.debugMode              = debugMode;
        this.numTransactions        = numTransactions;
    endfunction 

    // ensures that all the child class has execute definition
    pure virtual task execute();
    
endclass