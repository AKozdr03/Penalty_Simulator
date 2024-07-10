/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Screen controler.
 */

 module screen_selector( 
    input wire clk,
    input wire rst,

    timing_if.in in,
    vga_if.out out,

    control_if.in in_control,
    control_if.out out_control
);

import game_pkg::*;

// Interfaces
vga_if in_keeper();
vga_if in_shooter();
vga_if in_winner();
vga_if in_looser();
vga_if in_start();

vga_if out_sel();

// submodules

draw_screen_start u_draw_screen_start(
    .clk,
    .rst,
    .in,
    .out(in_keeper) //for tests it is changed
);

draw_screen_gk u_draw_screen(
    .clk,
    .rst,
    .in,
    .out(in_start)
);


draw_screen_shooter u_draw_screen_shooter(
    .clk,
    .rst,
    .in,
    .out(in_shooter)
);



always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;

        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= '0;
        out_control.game_mode <= MULTI;
        out_control.game_state <= START;

    end else begin
        out.vcount <= out_sel.vcount;
        out.vsync  <= out_sel.vsync;
        out.vblnk  <= out_sel.vblnk;
        out.hcount <= out_sel.hcount;
        out.hsync  <= out_sel.hsync;
        out.hblnk  <= out_sel.hblnk;
        out.rgb    <= out_sel.rgb;
    
        out_control.is_scored <= in_control.is_scored;
        out_control.round_counter <= in_control.round_counter;
        out_control.score <= in_control.score;
        out_control.game_mode <= in_control.game_mode;
        out_control.game_state <= in_control.game_state;       
    end
 end

 always_comb begin : screen_selected_control
    
    case(in_control.game_state)
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