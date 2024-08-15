/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module that controls player output based on game state.
 */

 module output_mux(
    input wire clk, rst,
    input logic shot_taken, round_done,
    input g_state game_state,

    output logic player_output
 );

 //imports

 import game_pkg::*;

 //local variables
 logic player_output_nxt ;
 

 //logic

 always_ff @(posedge clk) begin
    if(rst) begin
        player_output <= '0 ;
    end
    else begin
        player_output <= player_output_nxt ;
    end
 end

 always_comb begin
    case(game_state)
        KEEPER: begin
            player_output_nxt = round_done ;
        end
        SHOOTER: begin
            player_output_nxt = shot_taken ;
        end
        default: begin
            player_output_nxt = 1'b0 ;
        end
    endcase
 end

 endmodule