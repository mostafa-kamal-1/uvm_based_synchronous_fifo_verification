package FIFO_write_then_read_sequence_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_write_then_read_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_then_read_sequence);
FIFO_seq_item seq_item;

function new(string name = "FIFO_write_then_read_sequence");
    super.new(name);
endfunction

task body;
repeat (8) begin
seq_item = FIFO_seq_item::type_id::create("seq_item");
start_item(seq_item);
assert(seq_item.randomize()  with {
                wr_en == 1;    // Write enabled
                rd_en == 0;    // Read disabled
                rst_n == 1;
            });
finish_item(seq_item);
end
repeat (8) begin
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
