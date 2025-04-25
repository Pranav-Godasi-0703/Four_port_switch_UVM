`ifndef SWITCH_TEST_SV
`define SWITCH_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;
`include "switch_env.sv"
`include "switch_sequence.sv"

class switch_test extends uvm_test;
  `uvm_component_utils(switch_test)

  switch_env env;

  function new(string name = "switch_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = switch_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    // Launch sequences on active agents only
    
      if (env.agent.get_is_active() == UVM_ACTIVE) begin
        switch_sequence seq = switch_sequence::type_id::create("seq",this);
        seq.start(env.agent.sequencer);
      end
    

    // Wait for simulation to progress
    #1000ns;

    phase.drop_objection(this);
  endtask

endclass

`endif

