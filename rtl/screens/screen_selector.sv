/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * This module selects data for the displayed screen.
 */

 module screen_selector(
    input logic clk,
    input logic rst,
    //input g_state [2:0] game_state,
    input logic [19:0] addr_in,
    output logic [11:0] rgb_pixel
 );

 import game_pkg::*;

 //VARIABLES

 logic [11:0] rgb_start, rgb_keeper, rgb_shooter, rgb_looser, rgb_winner, rgb_pixel_nxt;

 g_state game_state; //for testing
 logic [31:0] counter, counter_nxt; //for testing

//MODULES

 start_rom u_start_rom(
    .clk,
    .addrA(addr_in),
    .dout(rgb_start)
);
/*keeper_rom u_keeper_rom(
    .clk,
    .addrA(addr_in),
    .dout(rgb_keeper)
);
shooter_rom u_shooter_rom(
    .clk,
    .addrA(addr_in),
    .dout(rgb_shooter)
);
looser_rom u_looser_rom(
    .clk,
    .addrA(addr_in),
    .dout(rgb_looser)
);
winner_rom u_winner_rom(
    .clk,
    .addrA(addr_in),
    .dout(rgb_winner)
);*/

//LOGIC

 always_ff @(posedge clk) begin
    if(rst) rgb_pixel <= 0;
    else rgb_pixel <= rgb_pixel_nxt;
 end

/* always_ff @(posedge clk) begin : test_counter_setup
    counter <= counter_nxt; 
 end
always_comb begin : test_sequence
    if(counter < 6501950) game_state = START;
    else if(counter >= 6501950 && counter < 13003901) game_state = KEEPER;
    else if(counter >= 13003901 && counter < 19505851) game_state = KEEPER;
    else if(counter >= 19505851 && counter < 26007802) game_state = KEEPER;
    else if(counter >= 26007802) game_state = KEEPER;
    else game_state = START;

    counter_nxt = (counter + 1) % 32509753 ;
end

always_comb begin
    case(game_state)
        START: rgb_pixel_nxt = rgb_start; 
        KEEPER: rgb_pixel_nxt = rgb_keeper; 
        SHOOTER: rgb_pixel_nxt = rgb_shooter; 
        WINNER: rgb_pixel_nxt = rgb_winner; 
        LOOSER: rgb_pixel_nxt = rgb_looser; 
        default: rgb_pixel_nxt = rgb_start; 
    endcase
end*/

always_comb begin
    rgb_pixel_nxt = rgb_start;
end

 endmodule