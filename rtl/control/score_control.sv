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
    input logic is_scored_gk, is_scored_sh,
    input logic round_done_gk, round_done_sh,
    input logic enemy_is_scored, enemy_input, // enemy_input - enemy shot_taken or round_done_gk
    input g_mode game_mode,
    input logic shot_taken,
    input logic [2:0] opponent_score,
    input logic end_sh, end_gk,

    output logic match_end,     // 1 = match ended
    output logic match_result,   // 1 = match won by player, 0 = match lost 
    output logic [2:0] score_player,
    output logic [2:0] score_enemy,

    output logic [7:0] data_to_transmit // score data
);

//inports

import game_pkg::*;

//local variables

typedef enum bit [0:0] {WAIT, UPDATE} score_machine;
score_machine score_state, score_state_nxt ;

logic match_end_nxt ;
logic match_result_nxt ;
logic [2:0] score_player_nxt, score_enemy_nxt ;

logic [7:0] data_to_transmit_nxt;

//logic

always_ff @(posedge clk) begin
    if(rst) begin
        match_end <= '0 ;
        match_result <= '0 ;

        score_player <= '0 ;
        score_enemy <= '0 ;

        score_state <= UPDATE ;
    end
    else begin
        match_end <= match_end_nxt ;
        match_result <= match_result_nxt ;

        score_player <= score_player_nxt ;
        score_enemy <= score_enemy_nxt ;

        score_state <= score_state_nxt ;
    end
end

always_ff @(posedge clk) begin : data_transmision
    if(rst) begin
        data_to_transmit <= 8'b00000000;
    end
    else begin
        data_to_transmit <= data_to_transmit_nxt;
    end
end

always_comb begin : data_to_transmit_controller
    case(game_state)
        KEEPER: begin
            data_to_transmit_nxt = {round_done_gk, is_scored_gk, score_player, 3'b111};
        end
        SHOOTER: begin
            data_to_transmit_nxt = {shot_taken, 1'b0, score_player, 3'b111};
        end
        default: begin
            data_to_transmit_nxt = {1'b0, 1'b0, score_player, 3'b111};
        end
    endcase
end

always_comb begin
    case(game_mode)
        SOLO: begin
            if(game_state == KEEPER) begin
                if(round_done_gk) begin    //logic assigned to counting the score
                    if(is_scored_gk) begin
                        score_player_nxt = score_player ;
                        score_enemy_nxt = score_enemy + 1 ;
                    end
                    else begin
                        score_player_nxt = score_player;
                        score_enemy_nxt = score_enemy;
                    end
                end
                else begin
                    score_player_nxt = score_player ;
                    score_enemy_nxt = score_enemy ;
                end
            end

            else if(game_state == SHOOTER) begin
                if(round_done_sh) begin
                    if(is_scored_sh) begin
                        score_player_nxt = score_player + 1 ;
                        score_enemy_nxt = score_enemy ;
                    end
                    else begin
                        score_player_nxt = score_player;
                        score_enemy_nxt = score_enemy;
                    end
                end
                else begin
                    score_player_nxt = score_player ;
                    score_enemy_nxt = score_enemy ;
                end
            end

            else begin
                score_player_nxt = 3'b0 ;
                score_enemy_nxt = 3'b0 ;
                match_end_nxt = 1'b0 ;
                match_result_nxt = 1'b0 ;
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
            //leftovers from multi
            score_state_nxt = UPDATE ;
        end
        MULTI: begin
            case(score_state)
                UPDATE: begin
                    if(game_state == KEEPER) begin
                        if(round_done_gk) begin    //logic assigned to counting the score
                            if(is_scored_gk) begin
                                score_player_nxt = score_player ;
                                score_enemy_nxt = opponent_score + 1;
                            end
                            else begin
                                score_player_nxt = score_player;
                                score_enemy_nxt = opponent_score;
                            end
                            score_state_nxt = WAIT ;
                        end
                        else begin
                            score_player_nxt = score_player ;
                            score_enemy_nxt = opponent_score ;
                            score_state_nxt = UPDATE ;
                        end
                    end

                    else if(game_state == SHOOTER) begin
                        if(enemy_input) begin
                            if(enemy_is_scored) begin // keeper scored
                                score_player_nxt = score_player + 1;
                                score_enemy_nxt = opponent_score ;
                            end
                            else begin
                                score_player_nxt = score_player;
                                score_enemy_nxt = opponent_score;
                            end
                            score_state_nxt = WAIT ;
                        end
                        else begin
                            score_player_nxt = score_player ;
                            score_enemy_nxt = opponent_score ;
                            score_state_nxt = UPDATE ;
                        end
                    end

                    else begin
                        score_player_nxt = 3'b0 ;
                        score_enemy_nxt = 3'b0 ;
                        score_state_nxt = UPDATE ;
                    end
 
                    match_end_nxt = 1'b0 ;
                    match_result_nxt = 1'b0 ;
                end
                WAIT: begin
                    if(score_player == 5) begin     //logic assigned to end the match upon reaching the final score
                        match_end_nxt = 1'b1 ;  
                        match_result_nxt = 1'b1;
                    end
                    else if(opponent_score == 5) begin
                        match_end_nxt = 1'b1 ;
                        match_result_nxt = 1'b0;
                    end
                    else begin
                        match_end_nxt = 1'b0 ;
                        match_result_nxt = 1'b0;
                    end
                    score_player_nxt = score_player ;
                    score_enemy_nxt = opponent_score ;

                    if(end_gk || end_sh) begin
                        score_state_nxt = UPDATE ;
                    end
                    else begin
                        score_state_nxt = WAIT ;
                    end
                end
                default: begin

                end
            endcase
        end
    endcase
end


endmodule