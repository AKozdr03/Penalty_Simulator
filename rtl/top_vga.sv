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
 * 2023  AGH University of Science and Technology
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
wire [11:0] xpos_delay;
wire [11:0] ypos_delay;
wire [11:0] rgb_pixel;
wire [11:0] rgb_addr;
wire [11:0] xpos_ctl;
wire [11:0] ypos_ctl;
wire left;
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
 vga_if vga_rect();
 vga_if vga_ms();
 vga_if vga_rect_delay();
 vga_if vga_char();

 vga_if vga_char_i_rgb();
 vga_if vga_po_char_i_rgb();
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

draw_rect u_draw_rect (
    .clk,
    .xpos (xpos_ctl),
    .ypos (ypos_ctl),
    .rst,
    .in (vga_char),
    .out (vga_rect),
    .rgb_pixel (rgb_pixel),
    .pixel_addr (rgb_addr)
);

MouseCtl u_MouseCtl(
    .clk (clk100MHz),
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos,
    .ypos,
    .left(left),
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

delay_pos u_delay_pos(
    .xpos_in (xpos),
    .clk,
    .rst,
    .ypos_in (ypos),
    .xpos_out (xpos_delay),
    .ypos_out (ypos_delay)
);

draw_rect_ctl u_draw_rect_ctl(
    .clk,
    .mouse_left(left),
    .mouse_xpos(xpos_delay),
    .mouse_ypos(ypos_delay),
    .rst,
    .xpos(xpos_ctl),
    .ypos(ypos_ctl)
);

delay_rect u_delay_rect(
    .clk,
    .rst,
    .in(vga_rect),
    .hblnk (vga_rect_delay.hblnk),
    .vblnk (vga_rect_delay.vblnk),
    .hcount (vga_rect_delay.hcount),
    .vcount (vga_rect_delay.vcount),
    .hsync (vga_rect_delay.hsync),
    .vsync (vga_rect_delay.vsync)

);

assign vga_rect_delay.rgb = vga_rect.rgb;

draw_mouse u_draw_mouse(
    .clk,
    .rst,
    .in_mouse (vga_rect_delay),
    .out_mouse (vga_ms),
    .xpos (xpos_delay),
    .ypos (ypos_delay)
);

image_rom u_image_rom(
    .address (rgb_addr),
    .clk,
    .rgb (rgb_pixel)
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
