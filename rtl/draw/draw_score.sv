/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module writing the score.
 */

 //imports 

 import game_pkg::*;

 //module

 module draw_score( 
    input wire clk,
    input wire rst,
    input g_state game_state,
    input logic [2:0] score_player,
    input logic [2:0] score_enemy,

    vga_if.in in,
    vga_if.out out
);

import draw_pkg::*;

//interfaces

vga_if out_score();
vga_if out_nxt();

//local variables

wire [11:0] char_xy_end ;
wire [6:0] char_code_end ;
wire [3:0] char_line_end ;
wire [7:0] char_pixels_end ;

logic [11:0] rgb_d;
logic [10:0] hcount_d, vcount_d;
logic hblnk_d, vblnk_d, hsync_d, vsync_d;

//modules

write_text #(
    .BEGIN_TXT_X(930),
    .BEGIN_TXT_Y(20),
    .TXT_COLOUR(RED)
    ) 
u_write_text_score(
    .clk,
    .rst,
    .char_pixels(char_pixels_end),
    .char_xy(char_xy_end),
    .char_line(char_line_end),
    .in(in),
    .out(out_score)
);

font_rom u_font_rom (
    .clk,
    .char_line(char_line_end),
    .char_code(char_code_end),
    .char_line_pixels(char_pixels_end)
);

char_rom_score u_char_rom_score(
    .clk,
    .char_xy(char_xy_end),
    .char_code(char_code_end),
    .score_player(score_player),
    .score_enemy(score_enemy)
);

//delay

delay #(
    .CLK_DEL(4),
    .WIDTH(38)
 )
 u_vga_delay(
    .clk,
    .rst,
    .din({in.hblnk, in.hcount, in.hsync, in.vblnk, in.vcount, in.vsync, in.rgb}),
    .dout({hblnk_d,hcount_d,hsync_d, vblnk_d, vcount_d, vsync_d, rgb_d})
 );

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
    end 
    else begin
        out.vcount <= out_nxt.vcount;
        out.vsync  <= out_nxt.vsync;
        out.vblnk  <= out_nxt.vblnk;
        out.hcount <= out_nxt.hcount;
        out.hsync  <= out_nxt.hsync;
        out.hblnk  <= out_nxt.hblnk;
        out.rgb    <= out_nxt.rgb;
    end
 end

 always_comb begin
    if(game_state == START || game_state == WINNER || game_state == LOSER) begin
        out_nxt.vcount = vcount_d;
        out_nxt.vsync  = vsync_d;
        out_nxt.vblnk  = vblnk_d;
        out_nxt.hcount = hcount_d;
        out_nxt.hsync  = hsync_d;
        out_nxt.hblnk  = hblnk_d;
        out_nxt.rgb    = rgb_d;
    end
    else begin
        out_nxt.vcount = out_score.vcount;
        out_nxt.vsync  = out_score.vsync;
        out_nxt.vblnk  = out_score.vblnk;
        out_nxt.hcount = out_score.hcount;
        out_nxt.hsync  = out_score.hsync;
        out_nxt.hblnk  = out_score.hblnk;
        out_nxt.rgb    = out_score.rgb;
    end
 end

 endmodule