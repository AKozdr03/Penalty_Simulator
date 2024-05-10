/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Testbech for control rectangle drawing
 */

`timescale 1 ns / 1 ps

 module draw_rect_ctl_tb;

localparam CLK_PERIOD = 25;     // 40 MHz

/**
 * Local variables and signals
 */

logic clk, rst;
logic mouse_left;
logic [11:0] mouse_xpos_tb, mouse_ypos_tb, xpos, ypos;


/**
 * Clock generation (40 MHz, 100MHz)
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end




draw_rect_ctl dut(
    .clk(clk),
    .rst(rst),
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos_tb),
    .mouse_ypos(mouse_ypos_tb),
    .xpos(xpos),
    .ypos(ypos)
);

/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");

    mouse_xpos_tb = 12'b0;
    mouse_ypos_tb = 12'b0;

    #30 mouse_left = 1'b1;
    #30 mouse_left = 1'b0;
    
    wait (ypos == 535);

    #100000
    #30 mouse_left = 1'b1;
    #30 mouse_left = 1'b0;

    #100000

    #30 mouse_left = 1'b1;
    #30 mouse_left = 1'b0; 
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end
 endmodule