import axi_lite_pkg::*;

class testFactory;
    static function generator Get_TestType (string testType, mailbox mb_generator2driver, logic debugMode);
        
        fully_random_test fully_random_test_h;

        case (testType)
            "full_random" : begin
                fully_random_test_h = new(mb_generator2driver, debugMode);
                return fully_random_test_h;
            end
            default: begin
                $fatal("Invalid test type!!");
                $finish();
            end
        endcase
    endfunction
endclass