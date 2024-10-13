package FIFO_write_only_sequence_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_write_only_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_only_sequence);
FIFO_seq_item seq_item;

function new(string name = "FIFO_write_only_sequence");
    super.new(name);
endfunction

task body;
repeat (10000) begin
seq_item = FIFO_seq_item::type_id::create("seq_item");
start_item(seq_item);
assert(seq_item.randomize()  with {
                wr_en == 1;    // Write enabled
                rd_en == 0;    // Read disabled
            });
finish_item(seq_item);
end
endtask
endclass
endpackage
