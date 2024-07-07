/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module drawing the background.
 */

 module draw_screen(
    input wire clk,
    input wire rst,
    game_if.in in,
    game_if.out out
 );

 import game_pkg::*;

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

 /*
 always_comb begin : data_passed_through
   vcount_nxt = in.vcount ;
   vsync_nxt = in.vsync ;
   vblnk_nxt = in.vblnk ;
   hcount_nxt = in.hcount ;
   hsync_nxt = in.hsync ;
   hblnk_nxt = in.hblnk ;
 end
   */
 
 always_comb begin : drawing_loop
  //left goalpost
  if(       (in.hcount >= POST_OUTER_EDGE  && in.hcount < POST_INNER_EDGE) 
  &&        (in.vcount >= POST_TOP_EDGE    && in.vcount < POST_BOTTOM_EDGE) ) 
    rgb_nxt = GREY_GOALPOST ;
  //right goalpost
  else if(  (in.hcount > HOR_PIXELS - POST_INNER_EDGE  && in.hcount <= HOR_PIXELS - POST_OUTER_EDGE) 
  &&        (in.vcount >= POST_TOP_EDGE                 && in.vcount < POST_BOTTOM_EDGE)  ) 
    rgb_nxt = GREY_GOALPOST ;
  //crossbar
  else if(  (in.hcount >= POST_OUTER_EDGE   && in.hcount <= HOR_PIXELS - POST_OUTER_EDGE) 
  &&        (in.vcount >= CROSSBAR_TOP_EDGE && in.vcount < CROSSBAR_BOTTOM_EDGE)  ) 
    rgb_nxt = GREY_GOALPOST ;
  //net vertical
  else if(  (in.hcount >= POST_OUTER_EDGE && in.hcount <= HOR_PIXELS - POST_OUTER_EDGE && !((in.hcount - POST_OUTER_EDGE) % (NET_WIDTH)))
  &&        (in.vcount < CROSSBAR_TOP_EDGE) )
    rgb_nxt = WHITE_NET ;
  //net left 45deg
  else if(  in.hcount == ((POST_OUTER_EDGE - (in.vcount + 24) % NET_WIDTH)) // +24 is offset nessesary because I said so
  &&        (in.vcount >= POST_TOP_EDGE && in.vcount <= (POST_BOTTOM_EDGE + 3)) )
    rgb_nxt = WHITE_NET ;
  //net right 45deg
  else if(  (SCREEN_WIDTH - in.hcount) == ((POST_OUTER_EDGE - (in.vcount + 24) % NET_WIDTH)) // +24 is offset nessesary because I said so
  &&        (in.vcount >= POST_TOP_EDGE && in.vcount <= (POST_BOTTOM_EDGE + 3)) )
      rgb_nxt = WHITE_NET ;
  //goal line
  else if(  in.vcount >= (POST_BOTTOM_EDGE - 6)  && in.vcount < POST_BOTTOM_EDGE  )
    rgb_nxt = WHITE_LINES ;
  //6 yard line
  else if(  in.vcount >= SIX_YARD_LINE  && in.vcount < (SIX_YARD_LINE + 3)  )
    rgb_nxt = WHITE_LINES ;
  //penalty spot
  else if(  (((in.vcount - 450) * (in.vcount - 450))/50 + ((in.hcount - (SCREEN_WIDTH / 2)) * (in.hcount - (SCREEN_WIDTH / 2)))/300) <= 1  )
    rgb_nxt = WHITE_LINES ;
  //grass
  else if(in.vcount > GRASS_HEIGHT) 
    rgb_nxt = GREEN_GRASS ;
  //sky
  else 
    rgb_nxt = BLUE_BG ;
  
  //other
  vcount_nxt = in.vcount ;
  vsync_nxt = in.vsync ;
  vblnk_nxt = in.vblnk ;
  hcount_nxt = in.hcount ;
  hsync_nxt = in.hsync ;
  hblnk_nxt = in.hblnk ;

 end

 endmodule