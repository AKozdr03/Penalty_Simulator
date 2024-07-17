/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Mouse controller.
 */

 module mouse_control(
    input wire clk, rst,
    input wire [11:0] xpos, ypos,
    vga_if.in in,
    vga_if.out out,

    control_if.in in_control
);

import game_pkg::*;

//local viariables
wire [11:0] rgb_gloves;
wire [19:0] addr_gloves;

//Interfaces
vga_if out_mouse();
vga_if out_gloves();

vga_if out_sel();

//submodules
draw_mouse u_draw_mouse(
    .clk,
    .rst,
    .in_mouse(in),
    .out_mouse(out_mouse),
    .xpos,
    .ypos

);

draw_gloves u_draw_gloves(
    .clk,
    .rst,
    .in(in),
    .out(out_gloves),
    .xpos,
    .ypos,
    .pixel_addr(addr_gloves),
    .rgb_pixel(rgb_gloves)
);

gloves_rom u_gloves_rom(
    .clk,
    .addrA(addr_gloves),
    .dout(rgb_gloves)
);


always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end 
    else begin
        out.vcount <= out_sel.vcount;
        out.vsync  <= out_sel.vsync;
        out.vblnk  <= out_sel.vblnk;
        out.hcount <= out_sel.hcount;
        out.hsync  <= out_sel.hsync;
        out.hblnk  <= out_sel.hblnk;
        out.rgb    <= out_sel.rgb;
    end
 end

 always_comb begin : mouse_selector
    if(in_control.game_state == KEEPER) begin
        out_sel.hblnk = out_gloves.hblnk;
        out_sel.hcount = out_gloves.hcount;
        out_sel.hsync = out_gloves.hsync;
        out_sel.rgb = out_gloves.rgb;
        out_sel.vblnk = out_gloves.vblnk;
        out_sel.vcount = out_gloves.vcount;
        out_sel.vsync = out_gloves.vsync;
    end
    else begin
        out_sel.hblnk = out_mouse.hblnk;
        out_sel.hcount = out_mouse.hcount;
        out_sel.hsync = out_mouse.hsync;
        out_sel.rgb = out_mouse.rgb;
        out_sel.vblnk = out_mouse.vblnk;
        out_sel.vcount = out_mouse.vcount;
        out_sel.vsync = out_mouse.vsync;
    end

 end

endmodule