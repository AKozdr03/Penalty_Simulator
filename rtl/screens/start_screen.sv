/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Start screen controler.
 */

 module start_screen(
   input wire clk,
   input wire rst,
   input wire [11:0] rgb_pixel,

   game_if.in in,
   game_if.out out,
   output logic [19:0] pixel_addr
);

import game_pkg::*;

// Local variables
logic [11:0] rgb_nxt;
logic [19:0] addr_nxt;
logic [10:0] imag_x;
logic [10:0] imag_y;

always_ff @(posedge clk) begin
   if (rst) begin
       out.vcount <= '0;
       out.vsync  <= '0;
       out.vblnk  <= '0;
       out.hcount <= '0;
       out.hsync  <= '0;
       out.hblnk  <= '0;
       out.rgb    <= '0;
      pixel_addr <= '0;
   end else begin
       out.vcount <= in.vcount;
       out.vsync  <= in.vsync;
       out.vblnk  <= in.vblnk;
       out.hcount <= in.hcount;
       out.hsync  <= in.hsync;
       out.hblnk  <= in.hblnk;
       out.rgb    <= rgb_nxt;
       pixel_addr <= addr_nxt;
   end
end

always_comb begin
   imag_y = in.vcount;
   imag_x = in.hcount;
   addr_nxt = imag_y * SCREEN_WIDTH + imag_x;
   rgb_nxt = rgb_pixel;
end

endmodule