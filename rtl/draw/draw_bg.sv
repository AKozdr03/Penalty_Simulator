/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps

module draw_bg (
    input  logic clk,
    input  logic rst,
    vga_if.in in,
    vga_if.out out
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;


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
    end else begin
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= rgb_nxt;
    end
end

always_comb begin : bg_comb_blk
    if (in.vblnk || in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if (in.vcount == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if (in.vcount == VER_PIXELS - 1)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if (in.hcount == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if (in.hcount == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line.
        // LETTER A
        else if (in.hcount == 330 && in.vcount >= 250 && in.vcount <= 350) begin // I left
            rgb_nxt = 12'h0_f_0;
        end
        else if (in.hcount == 380 && in.vcount >= 250 && in.vcount <= 350) begin // I right
            rgb_nxt = 12'h0_f_0;
        end
        else if (in.vcount == 250 && in.hcount >= 330 && in.hcount <= 380) begin // - down
            rgb_nxt = 12'h0_f_0;
        end
        else if (in.vcount == 280 && in.hcount >= 330 && in.hcount <= 380) begin // -up
            rgb_nxt = 12'h0_f_0;
        end

        //LETTER K
        else if (in.hcount == 420 && in.vcount >= 250 && in.vcount <= 350) begin  // I
            rgb_nxt = 12'h0_f_0;
        end
        else if ((in.hcount == in.vcount + 120) && in.vcount >= 300 && in.vcount <= 350) begin // incline down, 120 is offset of this line
            rgb_nxt = 12'h0_f_0;
        end   
        else if ((in.hcount == VER_PIXELS - in.vcount + 120) && in.vcount >= 250 && in.vcount <= 300) begin // incline up, 120 is offset of this line
            rgb_nxt = 12'h0_f_0;
        end      
        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
    end
end

endmodule
