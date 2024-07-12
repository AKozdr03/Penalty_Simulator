/**
 * MTM UEC2
 * Author: Aron Lampart
 *
 * Description:
 * Draw text.
 */

 `timescale 1 ns / 1 ps

 module write_text (
     input  logic clk,
     input  logic rst,
     input  logic [7:0] char_pixels,
 
     output logic  [7:0] char_xy,
     output logic  [3:0] char_line,
 
     vga_if.in in,
     vga_if.out out
 );
 
 import vga_pkg::*;
 
 /**
  * Local variables and signals
  */
  logic hsync_delay, vsync_delay, hblnk_delay, vblnk_delay, hsync_delay2, vsync_delay2, hblnk_delay2, vblnk_delay2, 
  hsync_delay3, vsync_delay3, hblnk_delay3, vblnk_delay3;
  logic [10:0] hcount_delay, vcount_delay, hcount_delay2, vcount_delay2, hcount_delay3, vcount_delay3;
  logic [11:0] rgb_nxt, rgb_delay, rgb_delay2, rgb_delay3;
  logic [7:0] char_xy_nxt, char_line_calc,char_xy_calc;
  logic [3:0] char_line_nxt;

  localparam BEGIN_TXT_X = 300;
  localparam BEGIN_TXT_Y = 300;

 /**
  * Internal logic
  */
 
  always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         out.vcount <= '0;
         out.vsync  <= '0;
         out.vblnk  <= '0;
         out.hcount <= '0;
         out.hsync  <= '0;
         out.hblnk  <= '0;
         out.rgb    <= '0;

         hsync_delay    <= '0;
         vsync_delay    <= '0;
         hblnk_delay    <= '0;
         vblnk_delay    <= '0;
         hcount_delay   <= '0;
         vcount_delay   <= '0;
         rgb_delay      <= '0;

         hsync_delay2   <= '0;
         vsync_delay2   <= '0;
         hblnk_delay2   <= '0;
         vblnk_delay2   <= '0;
         hcount_delay2  <= '0;
         vcount_delay2  <= '0;
         rgb_delay2     <= '0;

         hsync_delay3   <= '0;
         vsync_delay3   <= '0;
         hblnk_delay3   <= '0;
         vblnk_delay3   <= '0;
         hcount_delay3  <= '0;
         vcount_delay3  <= '0;
         rgb_delay3     <= '0;

         char_xy        <= '0;
         char_line      <= '0 ;

     end else begin
        //TWO DELAYS
        
         vcount_delay  <= in.vcount;
         hcount_delay  <= in.hcount;
         vsync_delay   <= in.vsync;
         hsync_delay   <= in.hsync;
         vblnk_delay   <= in.vblnk;
         hblnk_delay   <= in.hblnk;
         rgb_delay     <= in.rgb;

         vcount_delay2  <= vcount_delay;
         hcount_delay2  <= hcount_delay;
         vsync_delay2   <= vsync_delay;
         hsync_delay2   <= hsync_delay;
         vblnk_delay2   <= vblnk_delay;
         hblnk_delay2   <= hblnk_delay;
         rgb_delay2     <= rgb_delay;

         vcount_delay3  <= vcount_delay2;
         hcount_delay3  <= hcount_delay2;
         vsync_delay3   <= vsync_delay2;
         hsync_delay3   <= hsync_delay2;
         vblnk_delay3   <= vblnk_delay2;
         hblnk_delay3   <= hblnk_delay2;
         rgb_delay3     <= rgb_delay2;

         out.vcount <= vcount_delay3;
         out.hcount <= hcount_delay3;
         out.vsync  <= vsync_delay3;
         out.hsync  <= hsync_delay3;
         out.vblnk  <= vblnk_delay3;
         out.hblnk  <= hblnk_delay3;
         

         out.rgb    <= rgb_nxt;
         char_xy        <= char_xy_nxt ;
         char_line      <= char_line_nxt ;
     end
 end
 
 always_comb begin

    char_xy_calc = in.hcount - BEGIN_TXT_X;
    char_line_calc = in.vcount - BEGIN_TXT_Y;

    char_xy_nxt = {char_line_calc[7:4],char_xy_calc[6:3]}; 
    char_line_nxt = {char_line_calc[3:0]}; 

    if( hcount_delay3 >= (BEGIN_TXT_X) && 
        hcount_delay3 <= (BEGIN_TXT_X + 127) && 
        vcount_delay3 >= BEGIN_TXT_Y && 
        vcount_delay3 <= (BEGIN_TXT_Y + 256)) begin

        if(in.vblnk || in.hblnk) begin
            rgb_nxt = 12'h0_0_0;
        end
        else
            if(char_pixels[7-3'(hcount_delay3-BEGIN_TXT_X)]) begin
                rgb_nxt = 12'hf_0_0; //red
            end
            else begin
                rgb_nxt = rgb_delay3;
            end
    end
    else begin
        rgb_nxt = rgb_delay3;
    end
end
 
 endmodule