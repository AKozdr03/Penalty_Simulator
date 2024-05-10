/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 800 x 600 @ 60fps using a 40 MHz clock;
localparam HOR_PIXELS = 800;
localparam VER_PIXELS = 600;

// Add VGA timing parameters here and refer to them in other modules.
// horizontal 
localparam H_COUNT_TOT = 1055; // not 1056 because we count from 0 
localparam H_SYNC_START = 840;
localparam H_BLNK_START = 800;
localparam H_SYNC_END = 968;
localparam H_BLNK_END = 1056; 

// vertical 
localparam V_COUNT_TOT = 627;  // not 628 because we count from 0 
localparam V_SYNC_START  = 601;
localparam V_BLNK_START= 600;
localparam V_SYNC_END = 605;
localparam V_BLNK_END = 628; 

localparam RECT_WIDTH = 64;
localparam RECT_LENGTH = 48;
localparam RECT_COLOR = 12'h0_0_f;

localparam CHAR_X_POS = 600;
localparam CHAR_Y_POS = 100;
endpackage

