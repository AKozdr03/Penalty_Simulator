/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Score controller.
 */

module score_control(
    input wire clk, rst,
    input g_state game_state,
    input logic is_scored,
    input logic round_done,

    output logic match_end,     // 1 = match ended
    output logic match_result   // 1 = match won by player, 0 = match lost 
);

//inports

import game_pkg::*;

//local variables

logic match_end_nxt ;
logic match_result_nxt ;
logic [2:0] score_player, score_enemy, score_player_nxt, score_enemy_nxt ;

//logic

always_ff @(posedge clk) begin
    if(rst) begin
        match_end <= '0 ;
        match_result <= '0 ;

        score_player <= '0 ;
        score_enemy <= '0 ;
    end
    else begin
        match_end <= match_end_nxt ;
        match_result <= match_result_nxt ;

        score_player <= score_player_nxt ;
        score_enemy <= score_enemy_nxt ;
    end
end

always_comb begin
    if(game_state == KEEPER) begin

        if(round_done) begin    //logic assigned to counting the score
            if(is_scored) begin
                score_player_nxt = score_player ;
                score_enemy_nxt = score_enemy + 1 ;
            end
            else begin
                score_player_nxt = score_player + 1 ;
                score_enemy_nxt = score_enemy;
            end
        end
        else begin
            score_player_nxt = score_player ;
            score_enemy_nxt = score_enemy ;
        end

        if(score_player == 5) begin     //logic assigned to end the match upon reaching the final score
            match_end_nxt = 1'b1 ;  
            match_result_nxt = 1'b1;
        end
        else if(score_enemy == 5) begin
            match_end_nxt = 1'b1 ;
            match_result_nxt = 1'b0;
        end
        else begin
            match_end_nxt = 1'b0 ;
            match_result_nxt = 1'b0;
        end
    end
    else begin
        score_player_nxt = 3'b0 ;
        score_enemy_nxt = 3'b0 ;
        match_end_nxt = 1'b0 ;
        match_result_nxt = 1'b0 ;
    end
end


endmodule