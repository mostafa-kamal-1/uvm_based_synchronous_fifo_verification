import FIFO_test_pkg::*;
import FIFO_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module FIFO_top();
    bit clk;  
    bit rst_n;  

   // clock generation
    initial begin
        clk = 0;  
        forever 
            #1 clk = ~clk;  
    end

    //instantiates DUT, interface and bind assertions
    FIFO_if f_if(clk);  
    FIFO DUT (f_if);
    bind FIFO FIFO_SVA FIFO_SVA_INSTA(f_if);

    initial begin //passes the interface using config. database
        uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", f_if);
        
        run_test("FIFO_test");  //run the test
    end
endmodule
