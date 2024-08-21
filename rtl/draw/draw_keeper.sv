/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Drawing keeper on the screen.
 */

 module draw_keeper(
    input wire clk,
    input wire rst,

    input logic [9:0] keeper_x_pos,
    input logic [11:0] rgb_pixel,

    output logic [19:0] pixel_addr,

    vga_if.in in,   
    vga_if.out out
);
   
import game_pkg::*;
import draw_pkg::*;


// local variables
localparam Y_POS_KEEPER = 250;
localparam KEEPER_LENGTH = 300;
localparam KEEPER_WIDTH = 200;

logic [11:0] rgb_nxt;
logic [19:0] addr_1, addr_2, addr_3 ;
logic [19:0] addr_nxt, addr_1_nxt, addr_2_nxt, addr_3_nxt;
logic [10:0] imag_x, imag_x_nxt;
logic [10:0] imag_y, imag_y_nxt;
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

        imag_x <= '0;
        imag_y <= '0;
        addr_1 <= '0 ;
        addr_2 <= '0 ;
        addr_3 <= '0 ;

    end else begin
        out.vcount <= vcount_d;
        out.vsync  <= vsync_d;
        out.vblnk  <= vblnk_d;
        out.hcount <= hcount_d;
        out.hsync  <= hsync_d;
        out.hblnk  <= hblnk_d;
        out.rgb    <= rgb_nxt;
        pixel_addr <= addr_nxt;

        imag_x <= imag_x_nxt;
        imag_y <= imag_y_nxt;
        addr_1 <= addr_1_nxt ;
        addr_2 <= addr_2_nxt ;
        addr_3 <= addr_3_nxt ;
    end
 end

 delay #(
    .CLK_DEL(6), //3
    .WIDTH(38)
 )
 u_keeper_delay(
    .clk,
    .rst,
    .din({in.hblnk, in.hcount, in.hsync, in.vblnk, in.vcount, in.vsync, in.rgb}),
    .dout({hblnk_d,hcount_d,hsync_d, vblnk_d, vcount_d, vsync_d, rgb_d})
 );
 
 always_comb begin : keeper_drawing
    if((in.hcount >= keeper_x_pos) && (in.hcount < (keeper_x_pos + KEEPER_WIDTH)) && (in.vcount >= Y_POS_KEEPER) && (in.vcount < (Y_POS_KEEPER + KEEPER_LENGTH) )) begin
        imag_y_nxt = Y_POS_KEEPER;
        imag_x_nxt = in.hcount - keeper_x_pos;
        addr_1_nxt = imag_y * 5 ;
        addr_2_nxt = addr_1 * 5 ;
        addr_3_nxt = addr_2 * 4 ;
        addr_nxt = addr_3 + imag_x ;

    end
    else begin
        addr_nxt = '0;
        addr_1_nxt = '0 ;
        addr_2_nxt = '0 ;
        addr_3_nxt = '0 ;
        imag_y_nxt = imag_y;
        imag_x_nxt = imag_x;
    end

    if((in.hcount >= keeper_x_pos) && (in.hcount < (keeper_x_pos + KEEPER_WIDTH)) && (in.vcount >= Y_POS_KEEPER)  && (in.vcount  < (Y_POS_KEEPER + KEEPER_LENGTH)) ) begin
        if(rgb_pixel == BLACK) begin // this is to delete background of keeper image
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