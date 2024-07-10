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
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);


/**
 * Local variables and signals
 */
wire [11:0] xpos, ypos;
wire left_clicked;
/**
 * Signals assignments
 */

// Interfaces
timing_if vga_timing();
game_if vga_ms();
game_if vga_screen();

assign vs = vga_ms.vsync;
assign hs = vga_ms.hsync;
assign {r,g,b} = vga_ms.rgb;


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
    .right(),
    .setmax_x(),
    .setmax_y(),
    .setx(),
    .sety(),
    .value(),
    .zpos()
);

draw_mouse u_draw_mouse(
    .clk,
    .rst,
    .in_mouse (vga_screen),
    .out_mouse (vga_ms),
    .xpos,
    .ypos
);

/*
draw_screen_gk u_draw_screen(
    .clk,
    .rst,
    .in(vga_timing)
    .out(vga_screen)
);
*/
/*
draw_screen_shooter u_draw_screen_shooter(
    .clk,
    .rst,
    .in(vga_timing),
    .out(vga_screen)
);
*/
/*
draw_screen_start u_draw_screen_start(
    .clk,
    .rst,
    .in(vga_timing),
    .out(vga_screen)
);
*/

draw_screen_winner u_draw_screen_winner(
    .clk,
    .rst,
    .in(vga_timing),
    .out(vga_screen)
);

game_state_sel u_game_state_sel(
    .clk,
    .rst,
    .is_scored(),
    .left_clicked,
    .score(),
    .solo_enable
);

endmodule
