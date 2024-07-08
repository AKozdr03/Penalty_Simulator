/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Package with vga related constants.
 */

package game_pkg;

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

// enums required for game
typedef enum bit [2:0] {START, KEEPER, SHOOTER, WINNER, LOOSER} g_state;
typedef enum bit [0:0] {SOLO, MULTI} g_mode;

g_state game_state;
g_state game_state_nxt;
g_mode game_mode;
g_mode game_mode_nxt;

// screen parameters
localparam SCREEN_WIDTH = 1024;
localparam SCREEN_LENGTH = 768;

//rgb colours
localparam WHITE_LINES = 12'hf_f_f ;
localparam WHITE_NET = 12'hd_d_f ;
localparam BLACK = 12'h0_0_0 ;
localparam GREY_GOALPOST = 12'hC_C_C ;
localparam GREEN_GRASS = 12'h0_7_0 ;
localparam BLUE_BG = 12'h7_9_F ;

//bg gk params
localparam POST_OUTER_EDGE = 20 ;
localparam POST_INNER_EDGE = 35 ;
localparam POST_TOP_EDGE = 100 ;
localparam POST_BOTTOM_EDGE = 650 ;

localparam CROSSBAR_TOP_EDGE = 100 ;
localparam CROSSBAR_BOTTOM_EDGE = 115 ;

localparam NET_WIDTH = 41 ;
localparam GRASS_HEIGHT = 380 ;

localparam SIX_YARD_LINE = 500 ;

endpackage

