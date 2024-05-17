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

module top_vga (
    input  logic clk,
    input  logic clk100MHz,
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
wire [7:0] char_pixels;
wire [7:0] char_xy;
wire [3:0] char_line;
wire [6:0] char_code;
/**
 * Signals assignments
 */

// Interfaces
vga_if vga_timing();
vga_if vga_bg();
vga_if vga_ms();
vga_if vga_char();

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
    .clk (clk100MHz),
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


font_rom u_font_rom(
    .clk,
    .addr({char_code[6:0], char_line[3:0]}),
    .char_line_pixels(char_pixels)
);


draw_rect_char u_draw_rect_char(
    .clk,
    .rst,
    .in (vga_bg),
    .out(vga_char),
    .char_line,
    .char_xy,
    .char_pixels
);

char_16x16 u_char_16x16(
    .clk,
    .char_code,
    .char_xy
);

endmodule
