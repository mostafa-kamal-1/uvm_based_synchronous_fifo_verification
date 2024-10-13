package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_write_read_sequence_pkg::*;
import FIFO_read_only_sequence_pkg::*;
import FIFO_write_only_sequence_pkg::*;
import FIFO_write_then_read_sequence_pkg::*;
import FIFO_full_sequence_pkg::*;
import FIFO_empty_sequence_pkg::*;
import FIFO_reset_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)

FIFO_env env;
FIFO_config FIFO_cfg;
FIFO_write_read_sequence write_read_seq;
FIFO_write_then_read_sequence write_then_read_seq;
FIFO_write_only_sequence write_seq;
FIFO_read_only_sequence read_seq;
FIFO_reset_sequence reset_seq;
FIFO_full_sequence full_seq;
FIFO_empty_sequence empty_seq;

function new(string name = "FIFO_test", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = FIFO_env::type_id::create("env",this);
FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg");
write_read_seq = FIFO_write_read_sequence::type_id::create("write_read_seq"); 
write_seq = FIFO_write_only_sequence::type_id::create("write_seq");
read_seq = FIFO_read_only_sequence::type_id::create("read_seq");
write_then_read_seq = FIFO_write_then_read_sequence::type_id::create("write_then_read_seq");
reset_seq = FIFO_reset_sequence::type_id::create("reset_seq"); 
full_seq = FIFO_full_sequence::type_id::create("full_seq"); 
empty_seq = FIFO_empty_sequence::type_id::create("empty_seq"); 

if(!uvm_config_db #(virtual FIFO_if)::get(this,"", "FIFO_IF", FIFO_cfg.FIFO_vif))
`uvm_fatal("build_phase", "Test - Unable to get the virtual interface of thr FIFO from the uvm_config_db");

uvm_config_db #(FIFO_config)::set(this,"*", "CFG", FIFO_cfg);
endfunction: build_phase

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    // start different sequences
    `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset Desserted", UVM_LOW)
    
    `uvm_info("run_phase", "write_read Sequence Generation Started", UVM_LOW)
    write_read_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "write_read Sequence Generation Ended", UVM_LOW)

    `uvm_info("run_phase", "Write Sequence Generation Started", UVM_LOW)
    write_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Write Sequence Generation Ended", UVM_LOW)

    `uvm_info("run_phase", "Read Sequence Generation Started", UVM_LOW)
    read_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Read Sequence Generation Ended", UVM_LOW)

    `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset Desserted", UVM_LOW)

    `uvm_info("run_phase", "Write then Read Sequence Generation Started", UVM_LOW)
    write_then_read_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Write then Read Sequence Generation Ended", UVM_LOW)

    `uvm_info("run_phase", "Full Sequence Generation Started", UVM_LOW)
    full_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Full Sequence Generation Ended", UVM_LOW)

    `uvm_info("run_phase", "Empty Sequence Generation Started", UVM_LOW)
    empty_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Empty Sequence Generation Ended", UVM_LOW)
    phase.drop_objection(this);
endtask: run_phase
endclass: FIFO_test
endpackage
