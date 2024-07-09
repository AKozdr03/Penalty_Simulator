/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module drawing the background for shooter pov.
 */

 module draw_screen_shooter(
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
  //goal
  if(  (     (in.hcount >= SH_POST_OUTER_EDGE  && in.hcount < HOR_PIXELS - SH_POST_OUTER_EDGE) 
  &&        (in.vcount >= SH_POST_TOP_EDGE    && in.vcount < SH_POST_BOTTOM_EDGE) )
  &&  !((in.hcount >= SH_POST_INNER_EDGE && in.hcount <= HOR_PIXELS - SH_POST_INNER_EDGE) 
      && (in.vcount > SH_CROSSBAR_BOTTOM_EDGE    && in.vcount < SH_POST_BOTTOM_EDGE)))
    rgb_nxt = GREY_GOALPOST ;
  
  
  //net vertical
  else if((  (in.hcount >= SH_POST_INNER_EDGE && in.hcount <= HOR_PIXELS - SH_POST_INNER_EDGE && !((in.hcount - SH_POST_INNER_EDGE) % (SH_NET_WIDTH)))
  &&        (in.vcount > SH_CROSSBAR_BOTTOM_EDGE && in.vcount <= SH_GRASS_HEIGHT) ) )
    rgb_nxt = WHITE_NET ;
  //net vertical
  else if((  (in.hcount >= SH_POST_INNER_EDGE && in.hcount <= HOR_PIXELS - SH_POST_INNER_EDGE)
  &&        (in.vcount > SH_CROSSBAR_BOTTOM_EDGE && in.vcount < SH_GRASS_HEIGHT)  && !((in.vcount - SH_CROSSBAR_BOTTOM_EDGE) % (SH_NET_WIDTH))) )
    rgb_nxt = WHITE_NET ;
  //goal line
  else if((  in.vcount >= SH_POST_BOTTOM_EDGE  && in.vcount < (SH_POST_BOTTOM_EDGE + 5)  )
 
  //6 yard line
  ||(  (     (in.hcount >= SH_SIX_YARD_LINE_EDGE  && in.hcount < SCREEN_WIDTH - SH_SIX_YARD_LINE_EDGE) 
  &&        (in.vcount >= SH_POST_BOTTOM_EDGE    && in.vcount < SH_SIX_YARD_LINE + SH_LINE_WIDTH) )
  &&  !((in.hcount >= SH_SIX_YARD_LINE_EDGE + SH_LINE_WIDTH  && in.hcount <= SCREEN_WIDTH - SH_SIX_YARD_LINE_EDGE - SH_LINE_WIDTH) 
      && (in.vcount >= SH_POST_BOTTOM_EDGE    && in.vcount < SH_SIX_YARD_LINE)))
  
  //penalty spot
  ||( in.hcount >= ((SCREEN_WIDTH / 2) - 25) && in.hcount <= ((SCREEN_WIDTH / 2) + 25)) 
  && ( in.vcount >= 720 && in.vcount <= 740 ) 
  ||( in.hcount >= ((SCREEN_WIDTH / 2) - 20) && in.hcount <= ((SCREEN_WIDTH / 2) + 20)) 
  && ( in.vcount >= 715 && in.vcount <= 745 )   
  ||( in.hcount >= ((SCREEN_WIDTH / 2) - 15) && in.hcount <= ((SCREEN_WIDTH / 2) + 15)) 
  && ( in.vcount >= 710 && in.vcount <= 750 )   )
  rgb_nxt = WHITE_LINES ;

  //banner
  else if(  in.vcount >= SH_BANNER_TOP  && in.vcount <= SH_GRASS_HEIGHT  )
    rgb_nxt = GREY_BAND ;

  //grass
  else if(in.vcount > SH_GRASS_HEIGHT) 
    rgb_nxt = GREEN_GRASS ;

  //sky
  else 
    rgb_nxt = BLUE_BG ;

 end

 endmodule