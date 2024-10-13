package FIFO_coverage_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_coverage extends uvm_component;
`uvm_component_utils(FIFO_coverage)
uvm_analysis_export #(FIFO_seq_item) cov_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
FIFO_seq_item seq_item_cov;

    covergroup FIFO_cvgr;
    // Coverpoints 
    wr_en_cp:       coverpoint seq_item_cov.wr_en;
    rd_en_cp:       coverpoint seq_item_cov.rd_en;
    full_cp:        coverpoint seq_item_cov.full;
    empty_cp:       coverpoint seq_item_cov.empty;
    almostfull_cp:  coverpoint seq_item_cov.almostfull;
    almostempty_cp: coverpoint seq_item_cov.almostempty;
    overflow_cp:    coverpoint seq_item_cov.overflow;
    underflow_cp:   coverpoint seq_item_cov.underflow;
    wr_ack_cp:      coverpoint seq_item_cov.wr_ack;

    // Cross coverage 
    wr_full:        cross wr_en_cp, full_cp;
    wr_empty:       cross wr_en_cp, empty_cp;
    wr_almostfull:  cross wr_en_cp, almostfull_cp;
    wr_almostempty: cross wr_en_cp, almostempty_cp;
    wr_overflow:    cross wr_en_cp, overflow_cp{
         
        ignore_bins wr_en0_overflow1 = !binsof(wr_en_cp) intersect{1} && binsof(overflow_cp) intersect{1};    
    }
    wr_underflow:   cross wr_en_cp, underflow_cp;
    wr_wr_ack:      cross wr_en_cp, wr_ack_cp{
         
        ignore_bins wr_en0_wr_ack1 = !binsof(wr_en_cp) intersect{1} && binsof(wr_ack_cp) intersect{1};    
    }

    rd_full:        cross rd_en_cp, full_cp{
         
        ignore_bins rd_en1_full1 = binsof(rd_en_cp) intersect{1} && binsof(full_cp) intersect{1};    
    }
    rd_empty:       cross rd_en_cp, empty_cp;
    rd_almostfull:  cross rd_en_cp, almostfull_cp;
    rd_almostempty: cross rd_en_cp, almostempty_cp;
    rd_overflow:    cross rd_en_cp, overflow_cp;
    rd_underflow:   cross rd_en_cp, underflow_cp{
         
        ignore_bins rd_en0_underflow1 = !binsof(rd_en_cp) intersect{1} && binsof(underflow_cp) intersect{1};    
    }
    rd_wr_ack:      cross rd_en_cp, wr_ack_cp;
endgroup

 function new(string name = "FIFO_coverage", uvm_component parent = null);
    super.new(name, parent);
    FIFO_cvgr = new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
cov_export = new("cov_export", this);
cov_fifo = new("cov_fifo", this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
cov_fifo.get(seq_item_cov);
FIFO_cvgr.sample();
end
endtask
endclass
endpackage