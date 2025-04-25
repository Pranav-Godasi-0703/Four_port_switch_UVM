/*-----------------------------------------------------------------
File name     : port_if.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab6 4-Port Switch interface
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

interface port_if(input clk,reset);
 

  import packet_pkg::*;
  // input port signals
  logic suspend_ip, valid_ip;
  logic [15:0] data_ip;
  // output port signals
  logic suspend_op, valid_op;
  logic [15:0] data_op;

  // reset for interface signals
  always@(posedge reset) begin 
    valid_ip = 1'b0;
    suspend_op = 1'b0;
  end

  // drive packet onto signals (for driver component)
  task drive_packet(input packet pkt);
     // packet drive
     @(negedge clk iff suspend_ip == 0);
     data_ip =  {pkt.data, pkt.source, pkt.target};
     valid_ip = 1'b1;
     @(negedge clk iff suspend_ip == 0);
     valid_ip = 1'b0;
     repeat (2) @(negedge clk);
  endtask

 // collect packet from signals (for monitor component)
 task collect_packet(output packet pkt);
   @(posedge valid_ip)
   pkt = new("pkt");
   {pkt.data, pkt.source, pkt.target} = data_ip;
    pkt.p = derive_type(pkt.target);
    $display("hi-----------------------------------------------------------------------");
  endtask
    
 // monitor task for output signals
task monitor(int portno);
    packet pkt;
    int log_file;
    string filename;
    
    // Generate filename based on port number
    case (portno)
        0: filename = "port_o_0.txt";
        1: filename = "port_o_1.txt";
        2: filename = "port_o_2.txt";
        3: filename = "port_o_3.txt";
        default: filename = "port_unknown.txt";
    endcase

    // Open the log file in append mode
    log_file = $fopen(filename, "a");
    if (!log_file) begin
        $fatal(1, "Error: Failed to open log file %s", filename);
    end

    $display("MONITOR started for port %0d", portno);

    forever begin
        @(posedge valid_op);
        pkt = new("pkt");
        {pkt.data, pkt.source, pkt.target} = data_op;
        pkt.p = derive_type(pkt.target);
        
        // Display message and write to the respective log file
        $display("port%0d interface monitor: packet OUT @%t", portno, $time);
        pkt.print();
        
        $fwrite(log_file, "port%0d interface monitor: packet OUT @%t\n", portno, $time);
        $fwrite(log_file, "Packet Details:\n");
        $fwrite(log_file, "Data: %h, Source: %b, Target: %b, PType: %s\n\n",
                pkt.data, pkt.source, pkt.target, pkt.p);
    end
endtask


 // function to derive packet type from target address
 function ptype derive_type(logic[3:0] target);
   case (target) inside
     1,2,4,8: derive_type = SINGLE;
     15     : derive_type = BROADCAST;
     3,[5:7],[8:14]: derive_type = MULTICAST;
     0      : $display("ERROR: target 0 found in task monitor");
     default: $display("ERROR: unknown target %b found in task monitor",target);
   endcase
  endfunction
   
      
endinterface
