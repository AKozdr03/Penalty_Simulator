/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_basys3 (
    input  wire clk,
    inout wire PS2Clk,
    inout wire PS2Data,

    input  wire btnC,
    input  wire sw,
    input  wire RsRx,
    output wire RsTx,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1

);


/**
 * Local variables and signals
 */


wire pclk;
wire pclk_mirror;

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

/**
 * Signals assignments
 */

assign JA1 = pclk_mirror;


/**
 * FPGA submodules placement
 */


 clk_wiz_0_clk_wiz CLK (
    .clk (clk),
    .clk100MHz (),
    .clk65MHz (pclk),
    .locked()

 );
 
// Mirror pclk on a pin for use by the testbench;
// not functionally required for this design to work.
ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);

/**
 *  Project functional top module
 */

top_game u_top_game (
    .ps2_clk (PS2Clk),
    .ps2_data (PS2Data),
    .clk(pclk),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .solo_enable(sw),
    .rx(RsRx),
    .tx(RsTx)
);

endmodule
