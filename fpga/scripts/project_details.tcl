# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
# Modified: Aron Lampart, Andrzej Kozdrowski
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
    constraints/top_game_basys3.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {

    ../rtl/game_pkg.sv
    ../rtl/draw_pkg.sv
    ../rtl/game_if.sv
    ../rtl/delay.sv
    ../rtl/vga_timing.sv
    ../rtl/draw/draw_mouse.sv
    ../rtl/draw/draw_keeper.sv
    ../rtl/draw/draw_ball.sv
    ../rtl/uart/uart.sv
    ../rtl/uart/uart_tx.sv
    ../rtl/uart/uart_rx.sv
    ../rtl/uart/fifo.sv
    ../rtl/uart/mod_m_counter.sv
    ../rtl/screens/draw_screen_gk.sv
    ../rtl/screens/draw_screen_shooter.sv
    ../rtl/screens/draw_screen_start.sv
    ../rtl/rom/winner_rom.sv
    ../rtl/rom/start_rom.sv
    ../rtl/rom/shooter_rom.sv
    ../rtl/rom/looser_rom.sv
    ../rtl/rom/keeper_rom.sv
    ../rtl/rom/goalkeeper_rom.sv
    ../rtl/rom/ball_rom.sv
    ../rtl/control/screen_selector.sv
    ../rtl/control/game_state_sel.sv
    ../rtl/top_game.sv
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
set mem_files {
    ../rtl/data/ball.dat
    ../rtl/data/keeper_pov.dat
    ../rtl/data/keeper.dat
    ../rtl/data/lose_screen.dat
    ../rtl/data/shooter_pov.dat
    ../rtl/data/start_screen.dat
    ../rtl/data/win_screen.dat
}
