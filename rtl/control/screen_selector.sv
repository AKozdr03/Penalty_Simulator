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
    input g_state game_state,

    timing_if.in in,
    vga_if.out out
);

import game_pkg::*;

//Local variables

// wire [11:0] char_xy_end ;
// wire [6:0] char_code_end ;
// wire [3:0] char_line_end ;
// wire [7:0] char_pixels_end ;

// Interfaces
vga_if in_screen_end();

vga_if in_keeper();
vga_if in_shooter();
vga_if in_end();
vga_if in_start();
vga_if in_lose();
vga_if in_win();

vga_if out_sel();

// submodules

draw_screen_start u_draw_screen_start(
    .clk,
    .rst,
    .in,
    .out(in_start)
);

draw_screen_gk u_draw_screen(
    .clk,
    .rst,
    .in,
    .out(in_keeper)
);


draw_screen_shooter u_draw_screen_shooter(
    .clk,
    .rst,
    .in,
    .out(in_shooter)
);

draw_screen_lose u_draw_screen_lose(
    .clk,
    .rst,
    .in,
    .out(in_lose)
);

draw_screen_win u_draw_screen_win(
    .clk,
    .rst,
    .in,
    .out(in_win)
);

// DRAW SCREEN END - for future text writing
/*
draw_screen_end u_draw_screen_end(
    .clk,
    .rst,
    .in,
    .out(in_screen_end)
);

write_text u_write_text_end (
    .clk,
    .rst,
    .char_pixels(char_pixels_end),
    .char_xy(char_xy_end),
    .char_line(char_line_end),
    .in(in_screen_end),
    .out(in_end)
);

font_rom u_font_rom_end (
    .clk,
    .char_line(char_line_end),
    .char_code(char_code_end),
    .char_line_pixels(char_pixels_end)
);

char_rom_16x16 u_char_rom_16x16(
    .clk,
    .char_xy(char_xy_end),
    .char_code(char_code_end)
);
*/

 //logic 

always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end 
    else begin
        out.vcount <= out_sel.vcount;
        out.vsync  <= out_sel.vsync;
        out.vblnk  <= out_sel.vblnk;
        out.hcount <= out_sel.hcount;
        out.hsync  <= out_sel.hsync;
        out.hblnk  <= out_sel.hblnk;
        out.rgb    <= out_sel.rgb;   
    end
 end



 always_comb begin : screen_selected_control
    
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
            out_sel.hblnk = in_win.hblnk;
            out_sel.hcount = in_win.hcount;
            out_sel.hsync = in_win.hsync;
            out_sel.rgb = in_win.rgb;
            out_sel.vblnk = in_win.vblnk;
            out_sel.vcount = in_win.vcount;
            out_sel.vsync = in_win.vsync;
        end
        LOSER: begin
            out_sel.hblnk = in_lose.hblnk;
            out_sel.hcount = in_lose.hcount;
            out_sel.hsync = in_lose.hsync;
            out_sel.rgb = in_lose.rgb;
            out_sel.vblnk = in_lose.vblnk;
            out_sel.vcount = in_lose.vcount;
            out_sel.vsync = in_lose.vsync;
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