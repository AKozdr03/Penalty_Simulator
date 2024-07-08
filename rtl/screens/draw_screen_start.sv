/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module drawing the background for gk pov.
 */

 module draw_screen_start(
    input wire clk,
    input wire rst,
    timing_if.in in,
    game_if.out out
 );

 import game_pkg::*;
 import draw_pkg::*;

 // Local variables
 logic [11:0] rgb_nxt;
 logic [10:0] hcount_nxt, vcount_nxt;
 logic hblnk_nxt, vblnk_nxt, hsync_nxt, vsync_nxt;
 
 always_ff @(posedge clk) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end else begin
        out.vcount <= vcount_nxt;
        out.vsync  <= vsync_nxt;
        out.vblnk  <= vblnk_nxt;
        out.hcount <= hcount_nxt;
        out.hsync  <= hsync_nxt;
        out.hblnk  <= hblnk_nxt;
        out.rgb    <= rgb_nxt;
    end
 end

 always_comb begin : data_passed_through
   vcount_nxt = in.vcount ;
   vsync_nxt = in.vsync ;
   vblnk_nxt = in.vblnk ;
   hcount_nxt = in.hcount ;
   hsync_nxt = in.hsync ;
   hblnk_nxt = in.hblnk ;
 end
 
 always_comb begin : drawing_loop
  
  //background
  rgb_nxt = WHITE_BG ;

 end

 endmodule