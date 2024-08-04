/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski, Aron Lampart
 *
 * Description:
 * Game interfaces.
 */

import game_pkg::*;
interface vga_if;
    logic [10:0] vcount, hcount;
    logic [11:0] rgb;
    logic vsync, vblnk, hsync, hblnk;

    modport in (input vcount, hcount, rgb, vsync, vblnk, hsync, hblnk);
    modport out (output vcount, hcount, rgb, vsync, vblnk, hsync, hblnk);

endinterface

interface timing_if;
    logic [10:0] vcount, hcount;
    logic vsync, vblnk, hsync, hblnk;

    modport in (input vcount, hcount, vsync, vblnk, hsync, hblnk);
    modport out (output vcount, hcount, vsync, vblnk, hsync, hblnk);

endinterface

//redundant if, left just in case
/*interface control_if;
    logic is_scored;
    logic [3:0] round_counter;
    logic [2:0] score;
    g_state game_state;
    g_mode game_mode;

    modport in (input game_mode, game_state, is_scored, score, round_counter);
    modport out (output game_mode, game_state, is_scored, score, round_counter);
    
endinterface*/