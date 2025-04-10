# Clock signal constraints
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]

# Pin assignments for Nexys A7-50T
# Modify these pin locations based on your specific board's reference manual
set_property PACKAGE_PIN E3 [get_ports clk]
set_property PACKAGE_PIN C12 [get_ports rst_n]
set_property PACKAGE_PIN D4 [get_ports uart_tx]
set_property PACKAGE_PIN C4 [get_ports uart_rx]

# I/O standards
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

# Set proper clock propagation for AES pipeline
set_property CLOCK_DEDICATED_ROUTE TRUE [get_nets clk]
