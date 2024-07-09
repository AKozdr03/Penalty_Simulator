/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module drawing the background for gk pov.
 */

 module draw_screen_gk(
    input wire clk,
    input wire rst,
    timing_if.in in,
    vga_if.out out
 );

 import game_pkg::*;
 import vga_pkg::*;
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
  if(  (     (in.hcount >= GK_POST_OUTER_EDGE  && in.hcount < HOR_PIXELS - GK_POST_OUTER_EDGE) 
  &&        (in.vcount >= GK_POST_TOP_EDGE    && in.vcount < GK_POST_BOTTOM_EDGE) )
  && !((in.hcount >= GK_POST_INNER_EDGE && in.hcount <= HOR_PIXELS - GK_POST_INNER_EDGE) && (in.vcount >= GK_CROSSBAR_BOTTOM_EDGE    && in.vcount < GK_POST_BOTTOM_EDGE)))
    rgb_nxt = GREY_GOALPOST ;
    
  //net vertical
  else if((  (in.hcount >= GK_POST_OUTER_EDGE && in.hcount <= HOR_PIXELS - GK_POST_OUTER_EDGE && !((in.hcount - GK_POST_OUTER_EDGE) % (GK_NET_WIDTH)))
  &&        (in.vcount < GK_CROSSBAR_TOP_EDGE) )
  //net left 45deg
  ||    (  in.hcount == ((GK_POST_OUTER_EDGE - (in.vcount + 24) % GK_NET_WIDTH)) // +24 is offset nessesary because I said so
  &&        (in.vcount >= GK_POST_TOP_EDGE && in.vcount <= GK_POST_BOTTOM_EDGE + 3)) 
  //net right 45deg
  ||(  (SCREEN_WIDTH - in.hcount) == ((GK_POST_OUTER_EDGE - (in.vcount + 24) % GK_NET_WIDTH)) // +24 is offset nessesary because I said so
  &&        (in.vcount >= GK_POST_TOP_EDGE && in.vcount <= (GK_POST_BOTTOM_EDGE + 3)) ))
      rgb_nxt = WHITE_NET ;

  //goal line
  else if((  in.vcount >= (GK_POST_BOTTOM_EDGE - 6)  && in.vcount < GK_POST_BOTTOM_EDGE  )
  //6 yard line
  ||(  in.vcount >= GK_SIX_YARD_LINE  && in.vcount < (GK_SIX_YARD_LINE + 3)  )
  //penalty spot
  ||( in.hcount >= ((SCREEN_WIDTH / 2) - 15) && in.hcount <= ((SCREEN_WIDTH / 2) + 15)) 
  && ( in.vcount >= 445 && in.vcount <= 455 ) 
  ||( in.hcount >= ((SCREEN_WIDTH / 2) - 10) && in.hcount <= ((SCREEN_WIDTH / 2) + 10)) 
  && ( in.vcount >= 442 && in.vcount <= 458 ) )
    rgb_nxt = WHITE_LINES ;

  //grass
  else if(in.vcount > GK_GRASS_HEIGHT) 
    rgb_nxt = GREEN_GRASS ;

  //sky
  else 
    rgb_nxt = BLUE_BG ;

 end

 endmodule