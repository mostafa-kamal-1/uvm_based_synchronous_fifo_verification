package FIFO_scoreboard_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(FIFO_scoreboard)
  
  uvm_analysis_export #(FIFO_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
  
  FIFO_seq_item seq_item_sb;
  int erorr_count = 0;
  int correct_count = 0;

  parameter FIFO_WIDTH = 16;
  parameter FIFO_DEPTH = 8;
  localparam max_fifo_addr = $clog2(FIFO_DEPTH);

  bit [FIFO_WIDTH-1:0] data_out_ref;
  bit wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
  bit [max_fifo_addr:0] count;
  bit [6:0] ref_flags, dut_flags;

  bit [FIFO_WIDTH-1:0] mem_queue[$]; 


  function new(string name = "FIFO_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      ref_model(seq_item_sb);
      ref_flags = {full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref};
      dut_flags = {seq_item_sb.full, seq_item_sb.empty, seq_item_sb.almostfull, seq_item_sb.almostempty, seq_item_sb.overflow, seq_item_sb.underflow, seq_item_sb.wr_ack};
      if (seq_item_sb.data_out != data_out_ref && ref_flags != dut_flags) begin
        `uvm_error("run_phase", $sformatf("comparison failed, Transaction received by the DUT: 0b%0b and DUT FLAGS: %b While the reference out: 0b%0b and REF FLAGS: %b", seq_item_sb.convert2string(), data_out_ref, dut_flags, ref_flags));
        erorr_count++;
      end else begin
        `uvm_info("run_phase", $sformatf("correct FIFO out: %s", seq_item_sb.convert2string()), UVM_HIGH);
        correct_count++;
      end
    end
  endtask


task ref_model(FIFO_seq_item seq_item_chk);
     fork
        begin // write
          if (!seq_item_chk.rst_n) begin
            wr_ack_ref = 0;
            overflow_ref = 0;
            full_ref = 0;
            almostfull_ref = 0;
            mem_queue.delete(); 
          end else if (seq_item_chk.wr_en && count < FIFO_DEPTH) begin
            wr_ack_ref = 1;
            mem_queue.push_back(seq_item_chk.data_in); 
          end else begin
            wr_ack_ref = 0;
            overflow_ref = (full_ref && seq_item_chk.wr_en) ? 1 : 0;
          end
        end

        begin //read
          if (!seq_item_chk.rst_n) begin
            empty_ref = 1;
            underflow_ref = 0;
            almostempty_ref = 0;
          end else if (seq_item_chk.rd_en && count != 0) begin
            data_out_ref = mem_queue.pop_front(); 
          end else begin
            underflow_ref = (empty_ref && seq_item_chk.rd_en) ? 1 : 0;
          end
        end
      join

      if (!seq_item_chk.rst_n) begin // count
        count = 0;
      end else if (seq_item_chk.wr_en && !seq_item_chk.rd_en && !full_ref) begin
        count = count + 1;  
      end else if (!seq_item_chk.wr_en && seq_item_chk.rd_en && !empty_ref) begin
        count = count - 1; 
      end else if (seq_item_chk.wr_en && seq_item_chk.rd_en && full_ref) begin
        count = count - 1;  
      end else if (seq_item_chk.wr_en && seq_item_chk.rd_en && empty_ref) begin
        count = count + 1;  
      end
       //flags
      full_ref = (count == FIFO_DEPTH) ? 1 : 0;
      empty_ref = (count == 0) ? 1 : 0;
      almostfull_ref = (count == FIFO_DEPTH - 1) ? 1 : 0;
      almostempty_ref = (count == 1) ? 1 : 0;
endtask


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total Successful Transactions : %0d", correct_count), UVM_MEDIUM);
    `uvm_info("report_phase", $sformatf("Total FAILED Transactions : %0d", erorr_count), UVM_MEDIUM);
  endfunction: report_phase
endclass
endpackage
