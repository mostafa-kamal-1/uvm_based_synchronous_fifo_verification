package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_seq_item extends uvm_sequence_item;
`uvm_object_utils(FIFO_seq_item);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
rand logic rst_n,wr_en, rd_en;
rand logic [FIFO_WIDTH-1:0] data_in;
logic [FIFO_WIDTH-1:0] data_out;
logic full, empty, almostfull, almostempty, underflow, wr_ack, overflow;

int RD_EN_ON_DIST = 30;
int WR_EN_ON_DIST = 70;


function new(string name = "FIFO_seq_item");
    super.new(name);
endfunction

function string convert2string();
    return $sformatf("%s rst_n = 0b%b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0b%0b, data_out = 0b%0b, full = 0b%0b, empty = %0s, almostfull = 0b%0b, almostempty = 0b%0b, overflow = 0b%0b, underflow = 0b%0b, wr_ack = 0b%0b"  , super.convert2string(), rst_n, wr_en, rd_en, data_in, data_out, full, empty, almostfull, almostempty,
     overflow, underflow, wr_ack);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst_n = 0b%b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0b%0b",  rst_n, wr_en, rd_en, data_in);
endfunction

constraint rst_dist{rst_n dist {0:=1, 1:=99};} //rst
constraint write_enable_dist { wr_en dist {0 := 100 - WR_EN_ON_DIST, 1 := WR_EN_ON_DIST}; } //write
constraint read_enable_dist { rd_en dist {0 := 100 - RD_EN_ON_DIST, 1 := RD_EN_ON_DIST}; } //read

endclass

endpackage