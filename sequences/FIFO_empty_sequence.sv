package FIFO_empty_sequence_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_empty_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_empty_sequence);
FIFO_seq_item seq_item;

function new(string name = "FIFO_empty_sequence");
    super.new(name);
endfunction

task body;
seq_item = FIFO_seq_item::type_id::create("seq_item");
repeat (seq_item.FIFO_DEPTH) begin
seq_item = FIFO_seq_item::type_id::create("seq_item");
start_item(seq_item);
assert(seq_item.randomize()  with {
                wr_en == 0;    // Write disabled
                rd_en == 1;    // Read enabled
                rst_n == 1;
            });
finish_item(seq_item);
end

repeat (5) begin
seq_item = FIFO_seq_item::type_id::create("seq_item");
start_item(seq_item);
assert(seq_item.randomize()  with {
                wr_en == 0;    // Write disabled
                rd_en == 1;    // Read enabled
                rst_n == 1;
            });
finish_item(seq_item);
end
endtask
endclass
endpackage
