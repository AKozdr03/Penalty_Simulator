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
wire left_clicked, connect_corrected;
/**
 * Signals assignments
 */

// Interfaces
timing_if vga_timing();

control_if control_state_in();
control_if control_state_out();
control_if control_sc_sel();

vga_if vga_ms();
vga_if vga_screen();

//for testing of write_text
/*
assign vs = vga_ms.vsync;
assign hs = vga_ms.hsync;
assign {r,g,b} = vga_ms.rgb;
*/
vga_if vga_txt();
assign vs = vga_txt.vsync;
assign hs = vga_txt.hsync;
assign {r,g,b} = vga_txt.rgb;
wire [7:0] char_xy ;
wire [6:0] char_code ;
wire [3:0] char_line ;
wire [7:0] char_pixels ;

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


mouse_control u_mouse_control(
    .clk,
    .rst,
    .xpos,
    .ypos,
    .in(vga_screen),
    .out(vga_ms),
    .in_control(control_sc_sel),
    .out_control(control_state_in)
);



screen_selector u_screen_selector(
    .clk,
    .rst,
    .in_control(control_state_out),
    .out_control(control_sc_sel),
    .in(vga_timing),
    .out(vga_screen)
);

/*uart_decoder u_uart_decoder(
    .clk,
    .rst,
    .connect_corrected,
    .keeper_pos()
);*/
game_state_sel u_game_state_sel(
    .clk,
    .rst,
    .left_clicked,
    .solo_enable,
    //.connect_corrected,
    .in_control(control_state_in),
    .out_control(control_state_out)
);

write_text u_write_text (
    .clk,
    .rst,
    .char_pixels,
    .char_xy,
    .char_line,
    .in(vga_ms),
    .out(vga_txt)
);

font_rom u_font_rom (
    .clk,
    .char_line,
    .char_code,
    .char_line_pixels(char_pixels)
);

char_rom_16x16 u_char_rom_16x16(
    .clk,
    .char_xy,
    .char_code
);

endmodule
