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
import draw_pkg::*;
//Local variables

wire [11:0] char_xy_title, char_xy_solo, char_xy_instr, char_xy_end_l, char_xy_end_w ;
wire [6:0] char_code_title, char_code_solo, char_code_instr, char_code_end_l, char_code_end_w  ;
wire [3:0] char_line_title, char_line_solo, char_line_instr, char_line_end_l, char_line_end_w  ;
wire [7:0] char_pixels_title, char_pixels_solo, char_pixels_instr, char_pixels_end_l, char_pixels_end_w ;

// Interfaces
vga_if in_screen_end();

vga_if in_keeper();
vga_if in_shooter();
vga_if in_end();
vga_if in_start();
vga_if in_lose();
vga_if in_win();

vga_if out_sel();

vga_if in_screen_start();
vga_if in_solo();
vga_if in_title();
vga_if in_end_l();
vga_if in_end_w();
// submodules

draw_screen_start u_draw_screen_start(
    .clk,
    .rst,
    .in,
    .out(in_screen_start)
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
    .out(in_end_l)
);

draw_screen_win u_draw_screen_win(
    .clk,
    .rst,
    .in,
    .out(in_end_w)
);

// DRAW TEXT 

write_text
     #(
    .BEGIN_TXT_X(450),
    .BEGIN_TXT_Y(380),
    .TXT_COLOUR(BLACK)
    ) 
    u_write_title (
    .clk,
    .rst,
    .char_pixels(char_pixels_title),
    .char_xy(char_xy_title),
    .char_line(char_line_title),
    .in(in_screen_start),
    .out(in_title)
);

font_rom u_font_rom_title (
    .clk,
    .char_line(char_line_title),
    .char_code(char_code_title),
    .char_line_pixels(char_pixels_title)
);

char_rom_title u_char_rom_16x16_title(
    .clk,
    .char_xy(char_xy_title),
    .char_code(char_code_title)
);

write_text
#(
    .BEGIN_TXT_X(50),
    .BEGIN_TXT_Y(570),
    .TXT_COLOUR(BLACK)
    ) 
     u_write_solo_mode (
    .clk,
    .rst,
    .char_pixels(char_pixels_solo),
    .char_xy(char_xy_solo),
    .char_line(char_line_solo),
    .in(in_title),
    .out(in_solo)
);

font_rom u_font_rom_solo (
    .clk,
    .char_line(char_line_solo),
    .char_code(char_code_solo),
    .char_line_pixels(char_pixels_solo)
);

char_rom_solo u_char_rom_16x16_solo(
    .clk,
    .char_xy(char_xy_solo),
    .char_code(char_code_solo)
);

write_text
     #(
    .BEGIN_TXT_X(700),
    .BEGIN_TXT_Y(570),
    .TXT_COLOUR(BLACK)
    )
     u_write_instruction (
    .clk,
    .rst,
    .char_pixels(char_pixels_instr),
    .char_xy(char_xy_instr),
    .char_line(char_line_instr),
    .in(in_solo),
    .out(in_start)
);

font_rom u_font_rom_inst (
    .clk,
    .char_line(char_line_instr),
    .char_code(char_code_instr),
    .char_line_pixels(char_pixels_instr)
);

char_rom_instr u_char_rom_16x16_instr(
    .clk,
    .char_xy(char_xy_instr),
    .char_code(char_code_instr)
);

// TEXT ON ENDING SCREENS
write_text
#(
    .BEGIN_TXT_X(700),
    .BEGIN_TXT_Y(700),
    .TXT_COLOUR(BLACK)
    ) 
     u_write_end_l (
    .clk,
    .rst,
    .char_pixels(char_pixels_end_l),
    .char_xy(char_xy_end_l),
    .char_line(char_line_end_l),
    .in(in_end_l),
    .out(in_lose)
);

font_rom u_font_rom_end_l (
    .clk,
    .char_line(char_line_end_l),
    .char_code(char_code_end_l),
    .char_line_pixels(char_pixels_end_l)
);

char_rom_end u_char_rom_16x16_end_l(
    .clk,
    .char_xy(char_xy_end_l),
    .char_code(char_code_end_l)
);


write_text
#(
    .BEGIN_TXT_X(700),
    .BEGIN_TXT_Y(700),
    .TXT_COLOUR(BLACK)
    ) 
     u_write_end_w (
    .clk,
    .rst,
    .char_pixels(char_pixels_end_w),
    .char_xy(char_xy_end_w),
    .char_line(char_line_end_w),
    .in(in_end_w),
    .out(in_win)
);

font_rom u_font_rom_end_w (
    .clk,
    .char_line(char_line_end_w),
    .char_code(char_code_end_w),
    .char_line_pixels(char_pixels_end_w)
);

char_rom_end u_char_rom_16x16_end_w(
    .clk,
    .char_xy(char_xy_end_w),
    .char_code(char_code_end_w)
);
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