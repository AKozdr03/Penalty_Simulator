/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified: Andrzej Kozdrowski
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;


// Add VGA timing parameters here and refer to them in other modules.
// horizontal 
localparam H_COUNT_TOT = 1344; // 1056
localparam H_SYNC_START = 1048; // 840
localparam H_BLNK_START = 1024; // 800
localparam H_SYNC_END = 1184; // 968
localparam H_BLNK_END = 1184; //1056

// vertical 
localparam V_COUNT_TOT = 806; // 628  
localparam V_SYNC_START  = 771; //601
localparam V_BLNK_START = 768; // 600
localparam V_SYNC_END = 777; // 605
localparam V_BLNK_END = 806; // 628

//rect dimensions
localparam RECT_WIDTH = 64;
localparam RECT_LENGTH = 48;
localparam RECT_COLOR = 12'h0_0_f;

// char position
localparam CHAR_X_POS = 600;
localparam CHAR_Y_POS = 100;

endpackage

