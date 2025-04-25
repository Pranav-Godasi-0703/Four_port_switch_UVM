vlog switch_port.sv port_if.sv switch_test.sv testbench.sv
vsim -voptargs=+acc -c tb
run -all
