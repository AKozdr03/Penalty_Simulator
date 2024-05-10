# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# tcl script being sourced to Vivado to build a project from sources and generate a bitstream.
# Some project details and paths to the source files are read from project_details.tcl


# Source the project details file
# (it should provide: project_name, top_module, target, and paths to all the sources)
source scripts/project_details.tcl

# Create project
proc create_new_project {project_name target top_module} {
    file mkdir build
    create_project ${project_name} build -part ${target} -force

    # read files from the variables provided by the project_details.tcl
    if {[info exists ::xdc_files]}     {read_xdc ${::xdc_files}}
    if {[info exists ::sv_files]}      {read_verilog -sv ${::sv_files}}
    if {[info exists ::verilog_files]} {read_verilog ${::verilog_files}}
    if {[info exists ::vhdl_files]}    {read_vhdl ${::vhdl_files}}
    if {[info exists ::mem_files]}     {read_mem ${::mem_files}}

    set_property top ${top_module} [current_fileset]
    update_compile_order -fileset sources_1
}


# Generate bitstream
proc generate_bitstream {} {
    # Run synthesis
    reset_run synth_1
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    # Run implemenatation up to bitstream generation
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
}


# MAIN
create_new_project $project_name $target $top_module
generate_bitstream
exit
