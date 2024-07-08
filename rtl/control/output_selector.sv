/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Output controler.
 */

 module output_selector( // zastosować logikę odwrotną tj. najpierw wybieramy ekran a później go rysujemy!!!! (aby procesora nie palić)
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
            out_sel.hblnk = in_keeper.hblnk;
            out_sel.hcount = in_keeper.hcount;
            out_sel.hsync = in_keeper.hsync;
            out_sel.rgb = in_keeper.rgb;
            out_sel.vblnk = in_keeper.vblnk;
            out_sel.vcount = in_keeper.vcount;
            out_sel.vsync = in_keeper.vsync;
        end
        SHOOTER: begin
            out_sel.hblnk = in_shooter.hblnk;
            out_sel.hcount = in_shooter.hcount;
            out_sel.hsync = in_shooter.hsync;
            out_sel.rgb = in_shooter.rgb;
            out_sel.vblnk = in_shooter.vblnk;
            out_sel.vcount = in_shooter.vcount;
            out_sel.vsync = in_shooter.vsync;
        end
        WINNER: begin
            out_sel.hblnk = in_winner.hblnk;
            out_sel.hcount = in_winner.hcount;
            out_sel.hsync = in_winner.hsync;
            out_sel.rgb = in_winner.rgb;
            out_sel.vblnk = in_winner.vblnk;
            out_sel.vcount = in_winner.vcount;
            out_sel.vsync = in_winner.vsync;
        end
        LOOSER: begin
            out_sel.hblnk = in_looser.hblnk;
            out_sel.hcount = in_looser.hcount;
            out_sel.hsync = in_looser.hsync;
            out_sel.rgb = in_looser.rgb;
            out_sel.vblnk = in_looser.vblnk;
            out_sel.vcount = in_looser.vcount;
            out_sel.vsync = in_looser.vsync;
        end
        default:
        begin
            out_sel.hblnk = in_start.hblnk;
            out_sel.hcount = in_start.hcount;
            out_sel.hsync = in_start.hsync;
            out_sel.rgb = in_start.rgb;
            out_sel.vblnk = in_start.vblnk;
            out_sel.vcount = in_start.vcount;
            out_sel.vsync = in_start.vsync;
        end
    endcase
end
      
endmodule