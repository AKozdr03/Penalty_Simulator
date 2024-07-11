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

control_if control_state_in();
control_if control_state_out();
control_if control_sc_sel();
control_if control_sc_sel2();

vga_if vga_ms();
vga_if vga_screen();

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


wire [11:0] rgb_test;
wire [19:0] addr_nxt;

draw_gloves u_draw_gloves(
    .clk,
    .rst,
    .in(vga_screen),
    .out(vga_ms),
    .xpos,
    .ypos,
    .pixel_addr(addr_nxt),
    .rgb_pixel(rgb_test)
);

gloves_rom u_gloves_rom(
    .clk,
    .addrA(addr_nxt),
    .dout(rgb_test)
);

screen_selector u_screen_selector(
    .clk,
    .rst,
    .in_control(control_state_out),
    .out_control(control_sc_sel),
    .in(vga_timing),
    .out(vga_screen)
);

game_state_sel u_game_state_sel(
    .clk,
    .rst,
    .left_clicked,
    .solo_enable,
    .in_control(control_state_in),
    .out_control(control_state_out)
);

endmodule
