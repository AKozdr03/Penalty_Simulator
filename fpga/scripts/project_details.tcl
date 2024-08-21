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

    ../rtl/constants/game_pkg.sv
    ../rtl/constants/draw_pkg.sv
    ../rtl/constants/vga_pkg.sv
    ../rtl/constants/game_if.sv
    ../rtl/delay.sv
    ../rtl/vga_timing.sv
    ../rtl/draw/draw_mouse.sv
    ../rtl/draw/draw_keeper.sv
    ../rtl/draw/draw_gloves.sv
    ../rtl/draw/draw_char.sv
    ../rtl/draw/draw_score.sv
    ../rtl/uart/uart.sv
    ../rtl/uart/uart_tx.sv
    ../rtl/uart/uart_rx.sv
    ../rtl/uart/fifo.sv
    ../rtl/uart/mod_m_counter.sv
    ../rtl/screens/draw_screen_gk.sv
    ../rtl/screens/draw_screen_shooter.sv
    ../rtl/screens/draw_screen_start.sv
    ../rtl/screens/draw_screen_win.sv
    ../rtl/screens/draw_screen_lose.sv
    ../rtl/rom/goalkeeper_rom.sv
    ../rtl/rom/gloves_rom.sv
    ../rtl/control/screen_selector.sv
    ../rtl/control/game_state_sel.sv
    ../rtl/control/mouse_control.sv
    ../rtl/control/score_control.sv
    ../rtl/control/gloves_control.sv
    ../rtl/control/shoot_control.sv
    ../rtl/control/ball_control.sv
    ../rtl/control/uart_decoder.sv
    ../rtl/control/scale_pos_control.sv
    ../rtl/text/write_text.sv
    ../rtl/text/font_rom.sv
    ../rtl/text/char_rom_score.sv
    ../rtl/text/char_rom_end.sv
    ../rtl/top_uart.sv
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
    ../rtl/data/keeper.dat
    ../rtl/data/gloves.dat
}
