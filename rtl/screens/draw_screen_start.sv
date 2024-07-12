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
    vga_if.out out
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
  if((in.hblnk == 1) || (in.vblnk == 1))
    rgb_nxt = BLACK;
  //background
  else if( (in.vcount >= ST_STRIPE_HEIGHT && in.vcount <= (SCREEN_LENGTH - ST_STRIPE_HEIGHT)))
    rgb_nxt = WHITE_START; 
  else if(   (in.hcount < ST_STRIPE_WIDTH)
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 9) && in.hcount < (ST_STRIPE_WIDTH * 10))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 11) && in.hcount < (ST_STRIPE_WIDTH * 12))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 14) && in.hcount < (ST_STRIPE_WIDTH * 15))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 21) && in.hcount < (ST_STRIPE_WIDTH * 22)) )
    rgb_nxt = YELLOW_START;

  else if(   (in.hcount >= ST_STRIPE_WIDTH && in.hcount < (ST_STRIPE_WIDTH * 2))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 5) && in.hcount < (ST_STRIPE_WIDTH * 6))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 8) && in.hcount < (ST_STRIPE_WIDTH * 9))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 13) && in.hcount < (ST_STRIPE_WIDTH * 14))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 19) && in.hcount < (ST_STRIPE_WIDTH * 20))
  ||    (in.hcount >= ST_STRIPE_WIDTH * 24) )
    rgb_nxt = RED_START;
  else if(   (in.hcount >= (ST_STRIPE_WIDTH * 6) && in.hcount < (ST_STRIPE_WIDTH * 7))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 15) && in.hcount < (ST_STRIPE_WIDTH * 16))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 20) && in.hcount < (ST_STRIPE_WIDTH * 21)) )
    rgb_nxt = BLUE_START;
  
  else if(   (in.hcount >= (ST_STRIPE_WIDTH * 3) && in.hcount < (ST_STRIPE_WIDTH * 4))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 12) && in.hcount < (ST_STRIPE_WIDTH * 13))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 18) && in.hcount < (ST_STRIPE_WIDTH * 19))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 23) && in.hcount < (ST_STRIPE_WIDTH * 24)) )
    rgb_nxt = GREEN_START;

  else if(   (in.hcount >= (ST_STRIPE_WIDTH * 2) && in.hcount < (ST_STRIPE_WIDTH * 3))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 10) && in.hcount < (ST_STRIPE_WIDTH * 11))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 16) && in.hcount < (ST_STRIPE_WIDTH * 17)) )
    rgb_nxt = BLACK_START;

  else if(   (in.hcount >= (ST_STRIPE_WIDTH * 4) && in.hcount < (ST_STRIPE_WIDTH * 5))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 7) && in.hcount < (ST_STRIPE_WIDTH * 8))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 17) && in.hcount < (ST_STRIPE_WIDTH * 18))
  ||    (in.hcount >= (ST_STRIPE_WIDTH * 22) && in.hcount < (ST_STRIPE_WIDTH * 23)) )
    rgb_nxt = WHITE_START;
  else 
    rgb_nxt = BLACK;

 end

 endmodule