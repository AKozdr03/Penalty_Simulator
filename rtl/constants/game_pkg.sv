/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Package with game related constants.
 */

package game_pkg;

// enums required for game
typedef enum bit [2:0] {START, KEEPER, SHOOTER, WINNER, LOSER} g_state;
typedef enum bit [0:0] {SOLO, MULTI} g_mode;

// screen parameters
localparam SCREEN_WIDTH = 11'd1024;
localparam SCREEN_LENGTH = 10'd768;

//gloves parameters
localparam GLOVES_LENGTH = 7'd100;
localparam GLOVES_WIDTH = 7'd100;
endpackage
