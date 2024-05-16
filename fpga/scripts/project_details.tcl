# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name Penalty_Simulator

# Top module name                               -- EDIT
set top_module top_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/clk_wiz_0.xdc
    constraints/clk_wiz_0_late.xdc
    constraints/top_vga_basys3.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {

    ../rtl/vga_pkg.sv
    ../rtl/vga_if.sv
    ../rtl/delay_pos.sv
    ../rtl/delay_char.sv
    ../rtl/rom/font_rom.sv
    ../rtl/rom/char_16x16.sv
    ../rtl/vga_timing.sv
    ../rtl/draw/draw_bg.sv
    ../rtl/draw/draw_rect_char.sv
    ../rtl/draw/draw_mouse.sv
    ../rtl/top_vga.sv
    rtl/top_basys3.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    rtl/clk_wiz_0.v
    rtl/clk_wiz_0_clk_wiz.v
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
    ../rtl/mouse_vhd/MouseCtl.vhd
    ../rtl/mouse_vhd/MouseDisplay.vhd
    ../rtl/mouse_vhd/Ps2Interface.vhd
}

# Specify files for a memory initialization     -- EDIT
#set mem_files {
#
#}
