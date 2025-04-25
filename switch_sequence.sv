`ifndef SWITCH_SEQUENCE_SV
`define SWITCH_SEQUENCE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
import packet_pkg::*;

class switch_sequence extends uvm_sequence #(packet);
  `uvm_object_utils(switch_sequence)

  function new(string name = "switch_sequence");
    super.new(name);
  endfunction

  task body();
    packet pkt;
    psingle ps;
    pmulticast pm;
    pbroadcast pb;
    int port_no;

    `uvm_info("SWITCH_SEQ", "Sending SINGLE packet", UVM_MEDIUM)
    ps = psingle::type_id::create("single_pkt");
    assert(ps.randomize()); // From port 0
    pkt = ps;
    start_item(pkt); finish_item(pkt);

    `uvm_info("SWITCH_SEQ", "Sending MULTICAST packet", UVM_MEDIUM)
    pm = pmulticast::type_id::create("multi_pkt");
    assert(pm.randomize()); // From port 0
    pkt = pm;
    start_item(pkt); finish_item(pkt);

    `uvm_info("SWITCH_SEQ", "Sending BROADCAST packet", UVM_MEDIUM)
    pb = pbroadcast::type_id::create("bcast_pkt");
    assert(pb.randomize()); // From port 0
    pkt = pb;
    start_item(pkt); finish_item(pkt);
  endtask

endclass

`endif

