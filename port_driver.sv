`ifndef PORT_DRIVER_SV
`define PORT_DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;

class port_driver extends uvm_driver #(packet);
  `uvm_component_utils(port_driver)

  // Virtual interfaces for each port
  virtual port_if vif1;
  virtual port_if vif2;
  virtual port_if vif3;
  virtual port_if vif4;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Retrieve all virtual interfaces from the config DB
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif1", vif1))
      `uvm_fatal("PORT_DRIVER", "No vif1 specified for driver")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif2", vif2))
      `uvm_fatal("PORT_DRIVER", "No vif2 specified for driver")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif3", vif3))
      `uvm_fatal("PORT_DRIVER", "No vif3 specified for driver")
    if (!uvm_config_db#(virtual port_if)::get(this, "", "vif4", vif4))
      `uvm_fatal("PORT_DRIVER", "No vif4 specified for driver")
  endfunction

  // Main run loop: fetch packet and drive on correct interface based on source
  task run_phase(uvm_phase phase);
    packet pkt;
    virtual port_if selected_vif;

    forever begin
      seq_item_port.get_next_item(pkt);

      // Choose correct virtual interface based on source field
      case (pkt.source)
        4'b0001: selected_vif = vif1;
        4'b0010: selected_vif = vif2;
        4'b0100: selected_vif = vif3;
        4'b1000: selected_vif = vif4;
        default: begin
          `uvm_error("PORT_DRIVER", $sformatf("Unknown source %h. Defaulting to vif1", pkt.source))
          selected_vif = vif1;
        end
      endcase

      `uvm_info("PORT_DRIVER", $sformatf("Driving packet: name=%s, type=%s, source=%h, target=%h, data=%h",
                                         pkt.getname(), pkt.gettype(), pkt.source, pkt.target, pkt.data), UVM_MEDIUM)

      // Call the interface's drive task
      selected_vif.drive_packet(pkt);

      seq_item_port.item_done();
    end
  endtask

endclass

`endif

