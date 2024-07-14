/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Package for drawing constraints.
 */

 package draw_pkg;

//rgb colours
localparam WHITE_LINES = 12'hF_F_F ;
localparam WHITE_NET = 12'hD_D_F ;
localparam WHITE_BG = 12'hF_F_F ;
localparam BLACK = 12'h0_0_0 ;
localparam GREY_GOALPOST = 12'hC_C_C ;
localparam GREY_BAND = 12'h7_7_7;
localparam GREEN_GRASS = 12'h0_7_0 ;
localparam BLUE_BG = 12'h7_9_F ;

localparam WHITE_START = 12'hC_D_D ;
localparam RED_START = 12'hC_0_2 ;
localparam BLUE_START = 12'h0_3_8 ;
localparam GREEN_START = 12'h0_8_4 ;
localparam YELLOW_START = 12'hE_C_0 ;
localparam BLACK_START = 12'h2_2_2 ;

//bg gk screen
localparam GK_POST_OUTER_EDGE = 20 ;
localparam GK_POST_INNER_EDGE = 35 ;
localparam GK_POST_TOP_EDGE = 100 ;
localparam GK_POST_BOTTOM_EDGE = 650 ;

localparam GK_CROSSBAR_TOP_EDGE = 100 ;
localparam GK_CROSSBAR_BOTTOM_EDGE = 115 ;

localparam GK_NET_WIDTH = 41 ;
localparam GK_GRASS_HEIGHT = 380 ;

localparam GK_SIX_YARD_LINE = 500 ;

//bg shooter screen
localparam SH_POST_OUTER_EDGE = 145 ;
localparam SH_POST_INNER_EDGE = 155 ;
localparam SH_POST_TOP_EDGE = 190 ;
localparam SH_POST_BOTTOM_EDGE = 550 ;

localparam SH_CROSSBAR_TOP_EDGE = 190 ;
localparam SH_CROSSBAR_BOTTOM_EDGE = 200 ;

localparam SH_NET_WIDTH = 12 ;
localparam SH_GRASS_HEIGHT = 500 ;

localparam SH_BANNER_TOP = 400 ;

localparam SH_SIX_YARD_LINE = 670 ;
localparam SH_SIX_YARD_LINE_EDGE = 50 ;
localparam SH_LINE_WIDTH = 5 ;

//start screen
localparam ST_STRIPE_WIDTH = 41 ;
localparam ST_STRIPE_HEIGHT = 150 ;

//end screen
localparam END_RECT_OUTER_HEIGHT = 150 ;
localparam END_RECT_OUTER_WIDTH = 170 ;
localparam END_RECT_INNER_HEIGHT = 200 ;
localparam END_RECT_INNER_WIDTH = 220 ;

 endpackage