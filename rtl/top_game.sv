/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * 2024  AGH University of Science and Technology
 * MTM UEC2
 * Aron Lampart, Andrzej Kozdrowski
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_game (
    input  logic clk,
    input  logic rst,
    inout  logic ps2_clk,
    inout  logic ps2_data,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);


/**
 * Local variables and signals
 */
wire [11:0] xpos;
wire [11:0] ypos;

/**
 * Signals assignments
 */

// Interfaces
game_if vga_timing();
game_if vga_bg();
game_if vga_ms();
game_if vga_char();

assign vs = vga_ms.vsync;
assign hs = vga_ms.hsync;
assign {r,g,b} = vga_ms.rgb;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .out (vga_timing)
);

draw_bg u_draw_bg (
    .clk,
    .rst,
    .in (vga_timing),
    .out (vga_bg)
);

MouseCtl u_MouseCtl(
    .clk,
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos,
    .ypos,
    .left(),
    .middle(),
    .new_event(),
    .right(),
    .setmax_x(),
    .setmax_y(),
    .setx(),
    .sety(),
    .value(),
    .zpos()
);

draw_mouse u_draw_mouse(
    .clk,
    .rst,
    .in_mouse (vga_char),
    .out_mouse (vga_ms),
    .xpos,
    .ypos
);



endmodule
