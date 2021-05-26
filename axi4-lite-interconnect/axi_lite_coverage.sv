import axi_lite_pkg::*;

class axi_lite_coverage;
    virtual axi_lite_if bfm0, bfm1;
    function new (virtual axi_lite_if bfm0, bfm1);
        this.bfm0 = bfm0;
        this.bfm1 = bfm1;
    endfunction
endclass