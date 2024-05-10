/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Draw rectangle.
 */

 module draw_rect (
    input  logic clk,
    input  logic rst,
    input logic [11:0] xpos,
    input logic [11:0] ypos, 
    input logic [11:0] rgb_pixel,

    output logic [11:0] pixel_addr,

    vga_if.in in,   
    vga_if.out out
);

import vga_pkg::*;


// local variables

logic [11:0] x_start;
logic [11:0] x_end;
logic [11:0] y_start;
logic [11:0] y_end;

logic [11:0] rgb_nxt;
logic [11:0] addr_nxt;

logic [11:0] rgb_d1;
logic [11:0] rgb_d2;
// assigns

assign x_start = xpos;
assign x_end = xpos + RECT_LENGTH;
assign y_start = ypos;
assign y_end = ypos + RECT_WIDTH;

// Internal logic

always_ff @(posedge clk) begin 
    if(rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
        pixel_addr <= '0;
        rgb_d1 <= '0;
        rgb_d2 <= '0;
    end
    else begin
        out.vcount <= in.vcount;
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync <= in.hsync;
        out.hblnk <= in.hblnk;
        rgb_d1 <= rgb_d2;
        rgb_d2 <= in.rgb;
        out.rgb <= rgb_nxt;
        pixel_addr <= addr_nxt;
    end
end


always_comb begin
    if ((in.hcount >= x_start) && (in.hcount < x_end) && (in.vcount >= y_start && in.vcount < y_end) ) begin
        addr_nxt = {6'(in.vcount - y_start), 6'(in.hcount - x_start)};
    end
    else begin
        addr_nxt = '0;
    end
    if ((in.hcount >= x_start + 2) && (in.hcount < x_end + 2) && (in.vcount >= y_start  && in.vcount < y_end) ) begin
        rgb_nxt = rgb_pixel;
    end    
    else begin
        rgb_nxt = rgb_d1;
    end
end

 endmodule