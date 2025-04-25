# Four_port_switch_UVM

This repository contains the code of 4 port switch implemented using UVM. The codes for all the basic components such as sequence_item, sequencer, driver, monitor, agent , environment, test, testbench are written. The packets are going through DUT in a correct way. But the monitor is not properly capturing them. The port which is sending the packet is itself capturing them. Need to work on it and make changes in agent, i.e, need to implement active, passive agents.
