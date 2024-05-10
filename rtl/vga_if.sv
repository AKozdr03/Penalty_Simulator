/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Vga interface.
 */

interface vga_if;
    logic [10:0] vcount, hcount;
    logic [11:0] rgb;
    logic vsync, vblnk, hsync, hblnk;

    modport in (input vcount, hcount, rgb, vsync, vblnk, hsync, hblnk);
    modport out (output vcount, hcount, rgb, vsync, vblnk, hsync, hblnk);

endinterface