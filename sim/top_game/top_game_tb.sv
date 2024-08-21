/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2024  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 * Andrzej Kozdrowski
 * Aron Lampart
 * Description:
 * Testbench for top_game.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

`timescale 1 ns / 1 ps

module top_game_tb;

import game_pkg::*;

/**
 *  Local parameters
 */

localparam CLK_PERIOD = (200/13);     // 65 MHz

localparam CLK100_PERIOD = 10;  //100 MHz

/**
 * Local variables and signals
 */

logic clk, rst, clk100MHz, solo_enable, rx;
wire vs, hs;
wire [3:0] r, g, b;


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    clk100MHz= 1'b0;
    forever #(CLK100_PERIOD/2) clk100MHz = ~clk100MHz;
end

/**
 * Submodules instances
 */

top_game dut (
    .ps2_clk(),
    .conn_led(),
    .rx,
    .tx(),
    .ps2_data(),
    .clk(clk),
    .rst(rst),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b),
    .solo_enable(solo_enable)
);

tiff_writer #(
    .XDIM(16'd1344),
    .YDIM(16'd806),
    .FILE_DIR("../../results")
) u_tiff_writer (
    .clk(clk),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    rx = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    # 30 solo_enable = 1'b1;
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
    $display("Smacznej kawusi");

    wait (hs == 1'b0);
    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);

    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
