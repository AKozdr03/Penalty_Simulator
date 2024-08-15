/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Mouse controller.
 */

 module mouse_control(
    input wire clk, rst,
    input wire [11:0] xpos, ypos,
    input g_state game_state,
    input wire tx_full,

    output logic [7:0] data_to_transmit, // keeper_pos
    vga_if.in in,
    vga_if.out out
);

import game_pkg::*;

//local viariables
wire [11:0] rgb_gloves;
wire [19:0] addr_gloves;
logic [7:0] data_to_transmit_nxt;
logic pos_update, pos_update_nxt;
typedef enum bit [1:0] {WAIT, READY, SEND} uart_machine;
uart_machine uart_state, uart_state_nxt ;
//Interfaces
vga_if out_mouse();
vga_if out_gloves();

vga_if out_sel();

//submodules
draw_mouse u_draw_mouse(
    .clk,
    .rst,
    .in_mouse(in),
    .out_mouse(out_mouse),
    .xpos,
    .ypos

);

draw_gloves u_draw_gloves(
    .clk,
    .rst,
    .in(in),
    .out(out_gloves),
    .xpos,
    .ypos,
    .pixel_addr(addr_gloves),
    .rgb_pixel(rgb_gloves)
);

gloves_rom u_gloves_rom(
    .clk,
    .addrA(addr_gloves),
    .dout(rgb_gloves)
);


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

 
 always_ff @(posedge clk) begin : data_transmision
    if(rst) begin
        data_to_transmit <= 8'b00000000;
        pos_update <= '0;
        uart_state <= WAIT ;
    end
    else begin
        data_to_transmit <= data_to_transmit_nxt;
        pos_update <= pos_update_nxt;
        uart_state <= uart_state_nxt ;
    end
end

always_comb begin
    if(!tx_full && uart_state == READY)
        uart_state_nxt = SEND ;
    else if(tx_full && uart_state == WAIT)
        uart_state_nxt = READY ;
    else 
        uart_state_nxt = uart_state ;

    if(uart_state == SEND) begin
        if(pos_update == 0) begin
            data_to_transmit_nxt = {xpos[4:0], 3'b001};
            pos_update_nxt = 1'b1;
        end
        else begin
            data_to_transmit_nxt = {xpos[9:5], 3'b010};
            pos_update_nxt = 1'b0;
        end
        uart_state_nxt = WAIT ;
    end
    else begin
        uart_state_nxt = uart_state;
        data_to_transmit_nxt = data_to_transmit;
        pos_update_nxt = pos_update;
    end

end

 always_comb begin : mouse_selector
    if(game_state == KEEPER) begin
        out_sel.hblnk = out_gloves.hblnk;
        out_sel.hcount = out_gloves.hcount;
        out_sel.hsync = out_gloves.hsync;
        out_sel.rgb = out_gloves.rgb;
        out_sel.vblnk = out_gloves.vblnk;
        out_sel.vcount = out_gloves.vcount;
        out_sel.vsync = out_gloves.vsync;
    end
    else begin
        out_sel.hblnk = out_mouse.hblnk;
        out_sel.hcount = out_mouse.hcount;
        out_sel.hsync = out_mouse.hsync;
        out_sel.rgb = out_mouse.rgb;
        out_sel.vblnk = out_mouse.vblnk;
        out_sel.vcount = out_mouse.vcount;
        out_sel.vsync = out_mouse.vsync;
    end

 end

endmodule