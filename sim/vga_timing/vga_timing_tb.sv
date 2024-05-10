/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 25;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

wire [10:0] vcount, hcount;
wire        vsync,  hsync;
wire        vblnk,  hblnk;


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    .out (vga_timing)
);

/**
 * Tasks and functions
 */

task reset_test;
    assert (vcount == 0)
        else $error("vcount is not reset on rst");
    assert (hcount == 0)
        else $error("hcount is not reset on rst");
    assert (vblnk == 0)
        else $error("vblnk is not reset on rst");
    assert (vsync == 0)
        else $error("vsync is not reset on rst");
    assert (hsync == 0)
        else $error("hsync is not reset on rst");
    assert (hblnk == 0)
        else $error("hblnk is not reset on rst");

endtask


/**
 * Assertions
 */

// scale test
assert property (@(posedge clk) (hcount === 'x || hcount <= H_COUNT_TOT))
    else $error("hcount is out of scale");
assert property (@(posedge clk) (vcount === 'x || vcount <= V_COUNT_TOT))
    else $error("vcount is out of scale");

// blank test
assert property (@(posedge clk) (hblnk == 0 || hblnk === 'x || hcount === 'x || (hcount >= H_BLNK_START && hcount < H_BLNK_END && hblnk == 1))) 
    else $error("horizontal blank error");
assert property (@(posedge clk) (hblnk == 1 || hblnk === 'x || hcount === 'x || (hcount < H_BLNK_START && hblnk == 0)))
    else $error("horizontal blank error");

assert property (@(posedge clk) (vblnk == 0 || vblnk === 'x || vcount === 'x || ((vcount >= V_BLNK_START && vcount < V_BLNK_END) && vblnk == 1)))
    else $error("vertical blank error ");
assert property (@(posedge clk) (vblnk == 1 || vblnk === 'x || vcount === 'x || (vcount < V_BLNK_START && vblnk == 0)))
   else $error("vertical blank error");



// synch test
assert property (@(posedge clk) (hsync == 0 || hsync === 'x || hcount === 'x || ((hcount >= H_SYNC_START && hcount < H_SYNC_END) && hsync == 1)))
    else $error("horizontal sync error ");
assert property (@(posedge clk) (hsync == 1 || hsync === 'x || hcount === 'x || ((hcount < H_SYNC_START || hcount >= H_SYNC_END) && hsync == 0)))
   else $error("horizontal sync error 6");

assert property (@(posedge clk) (vsync == 0 || vsync === 'x || vcount === 'x || ((vcount >= V_SYNC_START && vcount < V_SYNC_END) && vsync == 1)))
    else $error("vertical sync error");
assert property (@(posedge clk) (vsync == 1 || vsync === 'x || vcount === 'x || ((vcount < V_SYNC_START || vcount >= V_SYNC_END) && vsync == 0)))
   else $error("vertical sync error 8");

/**
 * Main test
 */

initial begin
    @(posedge rst);
    @(negedge rst);

    reset_test();
    
    wait (vsync == 1'b0);
    @(negedge vsync)
    @(negedge vsync)

    $finish;
end

endmodule
