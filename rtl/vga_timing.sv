/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Vga timing controller for vga 1024x768.
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,
    
    game_if.out out

);

import game_pkg::*;


/**
 * Local variables and signals
 */
logic [11:0] rgb_nxt;
logic [10:0] vcount_nxt, hcount_nxt;
logic vsync_nxt, hsync_nxt, vblnk_nxt, hblnk_nxt;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin 
    // counter 
    if(rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
    end
    else begin
        out.vcount <= vcount_nxt;
        out.vsync <= vsync_nxt;
        out.vblnk <= vblnk_nxt;
        out.hcount <= hcount_nxt;
        out.hsync <= hsync_nxt;
        out.hblnk <= hblnk_nxt;
        out.rgb <= rgb_nxt;
    end
end

always_comb begin 
    if(out.hcount == H_COUNT_TOT - 1) begin
        hcount_nxt = '0; 
        if (out.vcount == V_COUNT_TOT - 1) begin
            vcount_nxt = '0;
        end
        else begin
            vcount_nxt = out.vcount + 1;
        end
    end
    else begin
        hcount_nxt = out.hcount + 1;
        vcount_nxt = out.vcount;
    end

    // synch and blank
    // vertical
    if (vcount_nxt >= V_SYNC_START && vcount_nxt < V_SYNC_END) begin
        vsync_nxt = 1;
    end
    else begin
        vsync_nxt = '0;
    end
    if (vcount_nxt >= V_BLNK_START && vcount_nxt < V_BLNK_END) begin
        vblnk_nxt = 1;
    end
    else begin
        vblnk_nxt = '0;
    end
    
    // horizontal
    if (hcount_nxt >= H_SYNC_START && hcount_nxt < H_SYNC_END) begin
        hsync_nxt = 1;
    end
    else begin
        hsync_nxt = '0;
    end
    if (hcount_nxt >= H_BLNK_START && hcount_nxt < H_BLNK_END) begin
        hblnk_nxt = 1;
    end
    else begin
        hblnk_nxt = '0;
    end

    rgb_nxt = 12'h0_0_0;
end
endmodule
