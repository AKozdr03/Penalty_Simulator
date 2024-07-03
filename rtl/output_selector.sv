/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Output controler.
 */

 module output_selector(
    input wire clk,
    input wire rst,

    game_if.in in_keeper,
    game_if.in in_shooter,
    game_if.in in_winner,
    game_if.in in_looser,
    game_if.in in_start,

    game_if.out out
);

import game_pkg::*;

game_if out_sel();

always_ff @(posedge clk) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
        game_state <= START;
    end else begin
        out.vcount <= out_sel.vcount;
        out.vsync  <= out_sel.vsync;
        out.vblnk  <= out_sel.vblnk;
        out.hcount <= out_sel.hcount;
        out.hsync  <= out_sel.hsync;
        out.hblnk  <= out_sel.hblnk;
        out.rgb    <= out_sel.rgb;
        game_state <= game_state_nxt;
    end
 end

 always_comb begin
    case(game_state)
        START: begin
            out_sel.hblnk = in_start.hblnk;
            out_sel.hcount = in_start.hcount;
            out_sel.hsync = in_start.hsync;
            out_sel.rgb = in_start.rgb;
            out_sel.vblnk = in_start.vblnk;
            out_sel.vcount = in_start.vcount;
            out_sel.vsync = in_start.vsync;
        end
        KEEPER: begin
            //out_sel = in_keeper;
        end
        SHOOTER: begin
            //out_sel = in_shooter;
        end
        WINNER: begin
            //out_sel = in_winner;
        end
        LOOSER: begin
            //out_sel = in_looser;
        end
        default:
        begin

        end
    endcase
end
      
endmodule