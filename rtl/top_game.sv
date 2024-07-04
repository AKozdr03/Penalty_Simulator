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
wire [11:0] rgb_pixel_start, rgb_pixel_keeper, rgb_pixel_winner, rgb_pixel_looser ,rgb_pixel_shooter;
wire [19:0] pixel_addr_start, pixel_addr_keeper, pixel_addr_winner, pixel_addr_looser, pixel_addr_shooter;
/**
 * Signals assignments
 */

// Interfaces
game_if vga_bg();
game_if vga_ms();
game_if vga_screen();
game_if vga_start_screen();
game_if vga_keeper_screen();
game_if vga_shooter_screen();
game_if vga_winner_screen();
game_if vga_looser_screen();

assign vs = vga_ms.vsync;
assign hs = vga_ms.hsync;
assign {r,g,b} = vga_ms.rgb;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .out (vga_bg)
);

MouseCtl u_MouseCtl(
    .clk,
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos,
    .ypos,
    .left(),
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

output_selector u_output_selector(
    .clk,
    .rst,
    .in_keeper(vga_keeper_screen),
    .in_looser(vga_looser_screen),
    .in_shooter(vga_shooter_screen),
    .in_start(vga_start_screen),
    .in_winner(vga_winner_screen),
    .out(vga_screen)
);
start_screen u_start_screen(
    .clk,
    .rst,
    .pixel_addr(pixel_addr_start),
    .rgb_pixel(rgb_pixel_start),
    .in(vga_bg),
    .out(vga_start_screen)
);

start_rom u_start_rom(
    .clk,
    .addrA(pixel_addr_start),
    .dout(rgb_pixel_start)
);

keeper_screen u_keeper_screen(
    .clk,
    .rst,
    .pixel_addr(pixel_addr_keeper),
    .rgb_pixel(rgb_pixel_keeper),
    .in(vga_bg),
    .out(vga_keeper_screen)
);

keeper_rom u_keeper_rom(
    .clk,
    .addrA(pixel_addr_keeper),
    .dout(rgb_pixel_keeper)
);

shooter_screen u_shooter_screen(
    .clk,
    .rst,
    .pixel_addr(pixel_addr_shooter),
    .rgb_pixel(rgb_pixel_shooter),
    .in(vga_bg),
    .out(vga_shooter_screen)
);

shooter_rom u_shooter_rom(
    .clk,
    .addrA(pixel_addr_shooter),
    .dout(rgb_pixel_shooter)
);

winner_screen u_winner_screen(
    .clk,
    .rst,
    .pixel_addr(pixel_addr_winner),
    .rgb_pixel(rgb_pixel_winner),
    .in(vga_bg),
    .out(vga_winner_screen)
);

winner_rom u_winner_rom(
    .clk,
    .addrA(pixel_addr_winner),
    .dout(rgb_pixel_winner)
);

looser_screen u_looser_screen(
    .clk,
    .rst,
    .pixel_addr(pixel_addr_looser),
    .rgb_pixel(rgb_pixel_looser),
    .in(vga_bg),
    .out(vga_looser_screen)
);

looser_rom u_looser_rom(
    .clk,
    .addrA(pixel_addr_looser),
    .dout(rgb_pixel_looser)
);

endmodule
