/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Draw mouse cursor.
 */

 module draw_mouse (
    input  logic clk,
    input  logic rst,
    input logic [11:0] xpos,
    input logic [11:0] ypos,  
    vga_if.in in_mouse,
    vga_if.out out_mouse
);

logic [11:0] xpos_delay;
logic [11:0] ypos_delay;

delay#(        
    .WIDTH(24),
    .CLK_DEL(1)) 
u_delay_pos(
    .clk,
    .rst,
    .din({xpos, ypos}),
    .dout({xpos_delay, ypos_delay})
);

MouseDisplay u_Mouse_Display(
    .pixel_clk(clk),
    .blank (in_mouse.hblnk | in_mouse.vblnk),
    .rgb_in (in_mouse.rgb),
    .rgb_out (out_mouse.rgb),
    .vcount (in_mouse.vcount),
    .xpos(xpos_delay),
    .ypos(ypos_delay),
    .hcount (in_mouse.hcount),
    .enable_mouse_display_out()
);


always_ff @(posedge clk) begin 
    if(rst) begin
        out_mouse.vcount <= '0;
        out_mouse.vsync <= '0;
        out_mouse.vblnk <= '0;
        out_mouse.hcount <= '0;
        out_mouse.hsync <= '0;
        out_mouse.hblnk <= '0;
    end
    else begin
        out_mouse.vcount <= in_mouse.vcount;
        out_mouse.vsync <= in_mouse.vsync;
        out_mouse.vblnk <= in_mouse.vblnk;
        out_mouse.hcount <= in_mouse.hcount;
        out_mouse.hsync <= in_mouse.hsync;
        out_mouse.hblnk <= in_mouse.hblnk;
    end
end

 endmodule