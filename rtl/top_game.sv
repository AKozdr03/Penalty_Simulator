/**
 * 2024  AGH University of Science and Technology
 * MTM UEC2
 * Aron Lampart, Andrzej Kozdrowski
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_game (
    input  logic clk,
    input  logic rst,
    input  logic solo_enable,
    inout  logic ps2_clk,
    inout  logic ps2_data,
    input  logic rx,

    output logic conn_led,
    output  logic tx,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);

//imports

import game_pkg::*;

/**
 * Local variables and signals
 */

wire [11:0] xpos, ypos;
wire left_clicked, right_clicked;
wire is_scored_gk, is_scored_sh;
wire round_done_gk, round_done_sh;
wire match_end;
wire match_result;
wire [2:0] score_player ;
wire [2:0] score_enemy ;
g_state game_state;
g_mode game_mode;
wire [9:0] shot_xpos, shot_ypos;
wire [7:0] read_data, w_data;
wire connect_corrected, game_starts, enemy_shooter, is_shooted;
wire rx_empty, rd_uart, tx_full, wr_uart;
wire [7:0] data_game_state_sel, data_gloves_control, data_mouse_control, data_score_control;
wire [9:0] x_shooter, y_shooter;
wire end_sh, end_gk;

/**
 * Signals assignments
 */

// Interfaces
timing_if vga_timing();

vga_if vga_ms();
vga_if vga_screen();
vga_if vga_glovesctl();
vga_if vga_ballctl();
vga_if vga_shootctl();
vga_if vga_score();

//outputs assigns

assign vs = vga_ms.vsync;
assign hs = vga_ms.hsync;
assign {r,g,b} = vga_ms.rgb;
// connection led
assign conn_led = connect_corrected;

/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .out(vga_timing)
);

MouseCtl u_MouseCtl(
    .clk,
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos,
    .ypos,
    .left(left_clicked),
    .middle(),
    .new_event(),
    .right(right_clicked),
    .setmax_x('0),
    .setmax_y('0),
    .setx('0),
    .sety('0),
    .value('0),
    .zpos()
);


mouse_control u_mouse_control(
    .clk,
    .rst,
    .xpos,
    .ypos,
    .in(vga_score),
    .out(vga_ms),
    .game_state,
    .data_to_transmit(data_mouse_control) // keeper_pos
);



screen_selector u_screen_selector(
    .clk,
    .rst,
    .game_state,
    .in(vga_timing),
    .out(vga_screen)
);

game_state_sel u_game_state_sel(
    .clk,
    .rst,
    .left_clicked,
    .right_clicked,
    .solo_enable,
    .match_end,
    .match_result,
    .game_state,
    .game_mode,,
    .end_gk,
    .end_sh
    .connect_corrected,
    .enemy_shooter,
    .game_starts,
    .is_shooted,
    .data_to_transmit(data_game_state_sel) // connect
);

gloves_control u_gloves_control(
    .clk,
    .rst,
    .in(vga_screen),
    .out(vga_glovesctl),
    .game_state,
    .xpos,
    .ypos,
    .is_scored(is_scored_gk),
    .round_done(round_done_gk),
    .shot_xpos,
    .shot_ypos,
    .data_to_transmit(data_gloves_control) // shot_pos,
    .end_gk
);

score_control u_score_control(
    .clk,
    .rst,
    .round_done_sh,
    .round_done_gk,
    .is_scored_sh,
    .is_scored_gk,
    .game_state,
    .match_end,
    .match_result,
    .score_player,
    .score_enemy,
    .data_to_transmit(data_score_control) // score data
);

draw_score u_draw_score(
    .clk,
    .rst,
    .game_state,
    .score_player,
    .score_enemy,
    .in(vga_shootctl),
    .out(vga_score)
);


ball_control u_ball_control(
    .clk,
    .rst,
    .game_state,
    .game_mode,
    .round_done(round_done_gk),
    .shot_xpos, // pozycja piłki po strzale (x)
    .shot_ypos, // pozycja piłki po strzale (y)
    .x_shooter, 
    .y_shooter 
);

uart u_uart(
    .clk,
    .reset(rst),
    .rx,
    .tx,
    .r_data(read_data),
    .rd_uart,
    .rx_empty,
    .tx_full,
    .w_data,
    .wr_uart
);

top_uart u_top_uart(
    .clk,
    .rst,
    .data_game_state_sel,
    .data_gloves_control,
    .data_mouse_control,
    .data_score_control,
    .tx_full,
    .w_data,
    .wr_uart
);

uart_decoder u_uart_decoder( 
    .clk,
    .rst,
    .rd_uart,
    .rx_empty,
    .connect_corrected,
    .keeper_pos(), // do podłączenia
    .opponent_score(), // do podłączenia
    .read_data,
    .x_shooter,
    .y_shooter,
    .is_shooted,
    .enemy_shooter,
    .game_starts
);

endmodule
