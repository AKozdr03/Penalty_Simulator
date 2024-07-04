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
logic [10:0] hcount_d, vcount_d;
logic hblnk_d, vblnk_d, hsync_d, vsync_d;

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
       out.vcount <= vcount_d;
       out.vsync  <= vsync_d;
       out.vblnk  <= vblnk_d;
       out.hcount <= hcount_d;
       out.hsync  <= hsync_d;
       out.hblnk  <= hblnk_d;
       out.rgb    <= rgb_nxt;
       pixel_addr <= addr_nxt;
   end
end
delay #(
   .CLK_DEL(2),
   .WIDTH(26)
)
u_rgb_delay(
   .clk,
   .rst,
   .din({in.hblnk, in.hcount, in.hsync, in.vblnk, in.vcount, in.vsync}),
   .dout({hblnk_d,hcount_d,hsync_d, vblnk_d, vcount_d, vsync_d})
);

always_comb begin
   imag_y = in.vcount;
   imag_x = in.hcount;
   addr_nxt = imag_y * SCREEN_WIDTH + imag_x;
   rgb_nxt = rgb_pixel;
end

endmodule