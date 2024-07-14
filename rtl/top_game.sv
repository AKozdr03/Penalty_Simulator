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
control_if control_glovesctl();
control_if control_mousectl();

vga_if vga_ms();
vga_if vga_screen();
vga_if vga_glovesctl();

//for testing of write_text

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
    .in(vga_glovesctl),
    .out(vga_ms),
    .in_control(control_glovesctl),
    .out_control(control_mousectl)
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
    //.connect_corrected,
    .in_control(control_mousectl),
    .out_control(control_state_out)
);

gloves_control u_gloves_control(
    .clk,
    .rst,
    .in(vga_screen),
    .out(vga_glovesctl),
    .in_control(control_sc_sel),
    .out_control(control_glovesctl),
    .xpos,
    .ypos
);

ball_control u_ball_control(
    .clk,
    .rst,
    .in(), // tu wpisz na razie to co do testów
    .out(),
    .in_control(), 
    .out_control(),
    .shot_xpos(), // pozycja piłki po strzale (x)
    .shot_ypos(), // pozycja piłki po strzale (y)
    .x_shooter(), // to dla multi na razie nic nie wpisywać
    .y_shooter() // to dla multi na razie nic nie wpisywać
);

endmodule
