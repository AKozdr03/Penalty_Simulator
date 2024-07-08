/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Package for gk screen drawing constraints.
 */

 package draw_pkg;

//rgb colours
localparam WHITE_LINES = 12'hf_f_f ;
localparam WHITE_NET = 12'hd_d_f ;
localparam BLACK = 12'h0_0_0 ;
localparam GREY_GOALPOST = 12'hC_C_C ;
localparam GREY_BAND = 12'h7_7_7;
localparam GREEN_GRASS = 12'h0_7_0 ;
localparam BLUE_BG = 12'h7_9_F ;

//bg gk params
localparam GK_POST_OUTER_EDGE = 20 ;
localparam GK_POST_INNER_EDGE = 35 ;
localparam GK_POST_TOP_EDGE = 100 ;
localparam GK_POST_BOTTOM_EDGE = 650 ;

localparam GK_CROSSBAR_TOP_EDGE = 100 ;
localparam GK_CROSSBAR_BOTTOM_EDGE = 115 ;

localparam GK_NET_WIDTH = 41 ;
localparam GK_GRASS_HEIGHT = 380 ;

localparam GK_SIX_YARD_LINE = 500 ;

//bg shooter pkg
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


endpackage