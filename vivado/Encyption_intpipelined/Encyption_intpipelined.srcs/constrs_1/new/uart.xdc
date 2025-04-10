# UART pins - adjust pins for your Nexys A7-50T board
set_property PACKAGE_PIN C4 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN D4 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
