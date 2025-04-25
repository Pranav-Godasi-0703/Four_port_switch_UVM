`ifndef SWITCH_ENV_SV
`define SWITCH_ENV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;
`include "port_agent.sv"

class switch_env extends uvm_env;
  `uvm_component_utils(switch_env)

  port_agent agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      agent = port_agent::type_id::create($sformatf("agent"), this);
  endfunction

endclass

`endif

