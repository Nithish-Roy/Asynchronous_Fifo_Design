
# ================================
# Vivado TCL Script for Synthesis
# ================================

# Set project details
set proj_name async_fifo_project
set top_module async_fifo
set part xc7a35tftg256-1         ;# Artix-7 FPGA (change this if needed)

# Create Vivado project in 'vivado_project' folder
create_project $proj_name ./vivado_project -part $part -force

# Add RTL source files from your path
add_files [glob {./src/*.v}]

# Set the top module
set_property top $top_module [current_fileset]

# Run synthesis
launch_runs synth_1
wait_on_run synth_1

# Open synthesized design
open_run synth_1

# Generate reports (optional)
report_utilization -file ./vivado_project/fifo_utilization.rpt
report_timing_summary -file ./vivado_project/fifo_timing.rpt



