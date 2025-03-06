# Clock constraints
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Reset synchronization constraint
set_false_path -from [get_ports reset_n] -to [all_registers]

# PUF-specific constraints for symmetry
# Guide placement to ensure balanced routing for PUF stages
create_pblock puf_region
add_cells_to_pblock [get_pblocks puf_region] [get_cells puf_core]
resize_pblock [get_pblocks puf_region] -add {SLICE_X50Y50:SLICE_X80Y80}

# Allow combinational loops in the PUF paths
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *path*]

# Set DONT_TOUCH property on PUF delay elements
set_property DONT_TOUCH TRUE [get_cells -hierarchical *puf_stage*]

# Set RLOC constraints for paired muxes to ensure symmetry
set cells [get_cells -hierarchical -filter {PRIMITIVE_TYPE =~ *.LUT.*}]
set count 0
foreach cell $cells {
    if {[regexp {puf_stage\[(\d+)\]} $cell -> num]} {
        set_property RLOC X0Y${num} $cell
    }
}
