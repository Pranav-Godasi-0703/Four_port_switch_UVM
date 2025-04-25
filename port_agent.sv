`ifndef PORT_AGENT_SV
`define PORT_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;
`include "port_driver.sv"
`include "port_monitor.sv"

class port_agent extends uvm_agent;
  `uvm_component_utils(port_agent)

  port_driver           driver;
  port_monitor          monitor;
  uvm_sequencer #(packet) sequencer;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: create components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Always create monitor
    monitor   = port_monitor::type_id::create("monitor", this);
    sequencer = uvm_sequencer #(packet)::type_id::create("sequencer", this);

    // Only create driver in ACTIVE mode
    if (get_is_active() == UVM_ACTIVE) begin
      driver = port_driver::type_id::create("driver", this);
    end
  endfunction

  // Connect sequencer to driver
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif

