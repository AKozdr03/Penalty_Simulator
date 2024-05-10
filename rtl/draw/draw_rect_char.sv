/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Draw characters.
 */

module draw_rect_char (
 
    vga_if.out out,
    vga_if.in in,

    input logic [0:7] char_pixels,
    input  logic clk,
    input  logic rst,

    output logic [7:0] char_xy,
    output logic [3:0] char_line

);
import vga_pkg ::*;

vga_if vga_char_delay();
wire [11:0] rgb_delay;
wire [3:0] char_line_delay;
logic [11:0] rgb_nxt;
logic [7:0] char_xy_nxt;
logic [3:0] char_line_nxt;

delay #(        
    .WIDTH(26),
    .CLK_DEL(3)) 
u_delay_char(
    .din({in.hblnk, in.hsync, in.vblnk, in.vsync, in.hcount, in.vcount}),
    .clk,
    .rst,
    .dout({vga_char_delay.hblnk, vga_char_delay.hsync, vga_char_delay.vblnk, vga_char_delay.vsync, vga_char_delay.hcount, vga_char_delay.vcount})

);

delay #(        
    .WIDTH(12),
    .CLK_DEL(3)) 
u_delay_rgb(
    .din(in.rgb),
    .clk,
    .rst,
    .dout(rgb_delay)

);

delay #(        
    .WIDTH(4),
    .CLK_DEL(1)) 
u_delay_char_line(
    .din(char_line_nxt),
    .clk,
    .rst,
    .dout(char_line_delay)

);



always_ff @(posedge clk) begin 
    if(rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
        char_xy <= '0;
        char_line <= '0;

    end
    else begin
        out.vcount <= vga_char_delay.vcount;
        out.vsync <= vga_char_delay.vsync;
        out.vblnk <= vga_char_delay.vblnk;
        out.hcount <= vga_char_delay.hcount;
        out.hsync <= vga_char_delay.hsync;
        out.hblnk <= vga_char_delay.hblnk;
        out.rgb <= rgb_nxt;
        char_xy <= char_xy_nxt;
        char_line <= char_line_delay;
    end
end
logic [10:0] hcount_param;

always_comb begin
    hcount_param = in.hcount - CHAR_X_POS;
    if((char_pixels[3'(vga_char_delay.hcount - CHAR_X_POS) ] == 1'b1) && (vga_char_delay.hcount < 128 + CHAR_X_POS) && (vga_char_delay.vcount < 256 + CHAR_Y_POS) && (vga_char_delay.hcount >= CHAR_X_POS) && (vga_char_delay.vcount >= CHAR_Y_POS)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else begin
        rgb_nxt = rgb_delay;
    end
    char_xy_nxt = {4'((in.vcount-CHAR_Y_POS) / 16),hcount_param[6:3]};
    

    char_line_nxt =  4'(in.vcount - CHAR_Y_POS);

end

endmodule