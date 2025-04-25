module tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import packet_pkg::*;
  `include "switch_test.sv"


  logic clk, reset;
  // Instantiate interfaces for all 4 ports
  port_if port0(clk, reset);
  port_if port1(clk, reset);
  port_if port2(clk, reset);
  port_if port3(clk, reset);

  // Instantiate DUT
  switch_port dut (
    .clk(clk),
    .reset(reset),
    .port0(port0),
    .port1(port1),
    .port2(port2),
    .port3(port3)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset sequence
  initial begin
    reset = 1;
    #20 reset = 0;
  end

  // Set virtual interfaces in config_db
  initial begin
    uvm_config_db#(virtual port_if)::set(null, "*", "vif1", port0);
    uvm_config_db#(virtual port_if)::set(null, "*", "vif2", port1);
    uvm_config_db#(virtual port_if)::set(null, "*", "vif3", port2);
    uvm_config_db#(virtual port_if)::set(null, "*", "vif4", port3);

    // Call UVM run
    run_test("switch_test");  // <- Match this name to your test class
  end

endmodule

