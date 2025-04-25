package packet_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ENUMS
  typedef enum {ANY, SINGLE, MULTICAST, BROADCAST} ptype;
  typedef enum {HEX, DEC, BIN} base;

  // BASE CLASS
  class packet extends uvm_sequence_item;

    // Fields
    rand bit [3:0] target;
    rand bit [3:0] source;
    rand bit [7:0] data;
    ptype p;
    local string name;

    // Constraints
    constraint target_notzero     { target != 4'b0000; }
    constraint target_not_source { if (p != BROADCAST) !(target & source); }
    /*
    constraint ptype_S { if (p == SINGLE)    target inside {1,2,4,8}; }
    constraint ptype_M { if (p == MULTICAST) target inside {3,[5:7],[9:14]}; }
    constraint ptype_B { if (p == BROADCAST) target == 15; }
    */
    // UVM macro
    `uvm_object_utils(packet)

    // Constructor
    //
    function new(string name = "packet");
      super.new(name);
      this.name = name;/*
        case (n)
          0: source = 4'b0001;
          1: source = 4'b0010;
          2: source = 4'b0100;
          3: source = 4'b1000;
          default: source = 4'b0001;
        endcase*/
    endfunction

    // Utility functions
    function string gettype();
      return p.name();
    endfunction

    function string getname();
      return name;
    endfunction

    function void print(base b = HEX);
      case (b)
        HEX: $display("Name:%s, Target:%h, Source:%h, Data:%h, PType:%s", getname(), target, source, data, gettype());
        DEC: $display("Name:%s, Target:%0d, Source:%0d, Data:%0d, PType:%s", getname(), target, source, data, gettype());
        BIN: $display("Name:%s, Target:%b, Source:%b, Data:%b, PType:%s", getname(), target, source, data, gettype());
      endcase
    endfunction

  endclass

  // SINGLE PACKET CLASS
  class psingle extends packet;
    constraint ptype_SINGLE { target inside {1,2,4,8}; source == 4'b0010; }
    `uvm_object_utils(psingle)
    function new(string name = "psingle");
      super.new(name);
      p = SINGLE;
    endfunction
  endclass

  // MULTICAST PACKET CLASS
  class pmulticast extends packet;
    constraint ptype_MULTICAST { target inside {3,[5:7],[9:14]}; source == 4'b0010;}
    `uvm_object_utils(pmulticast)
    function new(string name = "pmulticast");
      super.new(name);
      p = MULTICAST;
    endfunction
  endclass

  // BROADCAST PACKET CLASS
  class pbroadcast extends packet;
    constraint ptype_BROADCAST { target == 15; source == 4'b0010; }
    `uvm_object_utils(pbroadcast)
    function new(string name = "pbroadcast");
      super.new(name);
      p = BROADCAST;
    endfunction
  endclass

endpackage
