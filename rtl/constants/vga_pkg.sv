/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Package with vga related constants.
 */

 package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;
    
    
// Add VGA timing parameters here and refer to them in other modules.
// horizontal 
localparam H_COUNT_TOT = 1344; 
localparam H_SYNC_START = 1048;
localparam H_BLNK_START = 1024;
localparam H_SYNC_END = 1184;
localparam H_BLNK_END = 1344;

// vertical 
localparam V_COUNT_TOT = 806;
localparam V_SYNC_START  = 771;
localparam V_BLNK_START = 768;
localparam V_SYNC_END = 777;
localparam V_BLNK_END = 806;

 endpackage