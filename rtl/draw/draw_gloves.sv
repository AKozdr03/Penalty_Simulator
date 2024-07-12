/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Drawing gloves on the screen.
 */

 module draw_gloves(
    input wire clk,
    input wire rst,
    input logic [11:0] xpos, ypos,
    input logic [11:0] rgb_pixel,

    output logic [19:0] pixel_addr,

    vga_if.in in,   
    vga_if.out out
);

import game_pkg::*;
import draw_pkg::*;

// local variables

logic [11:0] x_ow, x_ow_nxt;
logic [9:0] y_ow, y_ow_nxt;

logic [11:0] rgb_nxt;
logic [19:0] addr_nxt;
logic [10:0] imag_x;
logic [10:0] imag_y;
logic [11:0] rgb_d;
logic [10:0] hcount_d, vcount_d;
logic hblnk_d, vblnk_d, hsync_d, vsync_d;

//logic

always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
        pixel_addr <= '0;

        x_ow <= '0;
        y_ow <= '0;
    end else begin
        out.vcount <= vcount_d;
        out.vsync  <= vsync_d;
        out.vblnk  <= vblnk_d;
        out.hcount <= hcount_d;
        out.hsync  <= hsync_d;
        out.hblnk  <= hblnk_d;
        out.rgb    <= rgb_nxt;
        pixel_addr <= addr_nxt;

        x_ow <= x_ow_nxt;
        y_ow <= y_ow_nxt;
    end
 end

 delay #(
    .CLK_DEL(2),
    .WIDTH(38)
 )
 u_gloves_delay(
    .clk,
    .rst,
    .din({in.hblnk, in.hcount, in.hsync, in.vblnk, in.vcount, in.vsync, in.rgb}),
    .dout({hblnk_d,hcount_d,hsync_d, vblnk_d, vcount_d, vsync_d, rgb_d})
 );
 
 always_comb begin : gloves_drawing
    if((in.hcount + 50 >= x_ow) && (in.hcount + 50 < (x_ow + GLOVES_LENGTH)) && (in.vcount + 50 >= y_ow) && (in.vcount + 50 < (y_ow + GLOVES_LENGTH))) begin
        if( xpos >= 1024 && ypos >= 768) begin
            imag_y = in.vcount - y_ow + 50;
            imag_x = in.hcount - x_ow + 50;
            x_ow_nxt = 1024;
            y_ow_nxt = 768 ;
        end
        else if(xpos > 1024) begin
            imag_y = in.vcount - y_ow + 50;
            imag_x = in.hcount - x_ow + 50;
            x_ow_nxt = 1024;
            y_ow_nxt = ypos[9:0] ;
        end
        else if(ypos > 768) begin
            imag_y = in.vcount - y_ow + 50;
            imag_x = in.hcount - x_ow + 50;
            x_ow_nxt = xpos ;
            y_ow_nxt = 768;
        end
        else begin
            imag_y = in.vcount - ypos + 50;
            imag_x = in.hcount - xpos + 50;
            x_ow_nxt = xpos ;
            y_ow_nxt = ypos[9:0] ;
        end
        addr_nxt = imag_y * GLOVES_WIDTH + imag_x;
    end
    else begin
        addr_nxt = '0;
        x_ow_nxt = '0 ;
        y_ow_nxt = '0 ;
    end

    if((in.hcount + 50 >= x_ow) && (in.hcount + 50 < (x_ow + GLOVES_LENGTH)) && (in.vcount + 50 >= y_ow)  && (in.vcount + 50 < (y_ow + GLOVES_LENGTH)) ) begin
        if(rgb_pixel == BLACK) begin // this is to delete background of gloves image
            rgb_nxt = rgb_d;
        end
        else begin
            rgb_nxt = rgb_pixel;
        end
    end
    else begin
        rgb_nxt = rgb_d;
    end

 end


endmodule