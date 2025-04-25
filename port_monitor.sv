`ifndef PORT_MONITOR_SV
`define PORT_MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;

class port_monitor extends uvm_monitor;
  `uvm_component_utils(port_monitor)

  // Four virtual interfaces, one per port
  virtual port_if vif1;
  virtual port_if vif2;
  virtual port_if vif3;
  virtual port_if vif4;

  //uvm_analysis_port #(packet) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    //ap = new("ap", this);
  endfunction

  // Retrieve all interfaces from the config DB
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif1", vif1))
      `uvm_fatal("PORT_MONITOR", "vif1 not set")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif2", vif2))
      `uvm_fatal("PORT_MONITOR", "vif2 not set")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif3", vif3))
      `uvm_fatal("PORT_MONITOR", "vif3 not set")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif4", vif4))
      `uvm_fatal("PORT_MONITOR", "vif4 not set")
  endfunction

  // Fork multiple threads to collect packets from each port
  task run_phase(uvm_phase phase);
    fork
      collect_from_port(vif1, "port0");
      collect_from_port(vif2, "port1");
      collect_from_port(vif3, "port2");
      collect_from_port(vif4, "port3");
    join
  endtask

  // A generic task for collecting packets from a specific interface
task collect_from_port(virtual port_if vif, string port_name);
  packet pkt;
  forever begin
    @(posedge vif.clk);
    if (vif.valid_ip) begin
      pkt = new("pkt");
      {pkt.data, pkt.source, pkt.target} = vif.data_op;
      //pkt.ptype = derive_type(pkt.target); // Optional if needed

      `uvm_info("PORT_MONITOR", $sformatf("[%s] Captured packet: name=%s, type=%s, source=%b, target=%b, data=%h",
                                         port_name, pkt.getname(), pkt.gettype(), pkt.source, pkt.target, pkt.data),
                                         UVM_MEDIUM)
    end
  end
endtask

endclass

`endif

