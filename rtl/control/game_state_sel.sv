/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Next state controller.
 */

module game_state_sel(
    input wire clk, rst,
    input wire left_clicked,
    input wire right_clicked,
    input wire solo_enable,
    input wire connect_corrected,
    input wire enemy_shooter,
    input logic match_end,
    input logic match_result,
    input logic game_starts,
    input logic is_shooted,

    output g_state game_state,
    output g_mode game_mode
);

import game_pkg::*;

// Local variables
g_state game_state_nxt;
g_mode game_mode_nxt;

//logic
always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        game_state <= START;
        game_mode <= MULTI;
    end
    else begin
        game_state <= game_state_nxt ;
        game_mode <= game_mode_nxt ;
    end
end

always_comb begin : next_game_mode_controller
    if(game_state == START) begin 
        if(solo_enable) begin // this is protection for inquisitive people :) to not switch game mode during the game
            game_mode_nxt = SOLO;
        end
        else begin
            game_mode_nxt = MULTI;
        end
    end
    else begin
        game_mode_nxt = game_mode;  
    end
end

always_comb begin : next_game_state_controller
    case(game_mode)
        SOLO: begin
            case(game_state)
                START: begin
                    if(left_clicked) begin
                        game_state_nxt = KEEPER;
                    end
                    else begin
                        game_state_nxt = START;
                    end
                end
                KEEPER: begin
                    if(match_end) begin
                        if(match_result)
                            game_state_nxt = WINNER ;
                        else
                            game_state_nxt = LOSER ;
                    end
                    else
                        game_state_nxt = KEEPER ;
                    
                end
                SHOOTER: begin // there is no possiblility this state in solo mode, but it have to be there
                    game_state_nxt = START; 
                end
                WINNER: begin
                    if(right_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = WINNER;
                    end
                end
                LOSER: begin
                    if(right_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = LOSER;
                    end
                end
                default: begin
                    game_state_nxt = START;
                end
            endcase
        end
        MULTI: begin
            if(connect_corrected) begin
                case(game_state)
                    START: begin
                    if(enemy_shooter && game_starts)
                        game_state_nxt = SHOOTER;
                    else if (game_starts)
                        game_state_nxt = KEEPER;
                    else
                        game_state_nxt = START;
                    end
                    KEEPER: begin
                        if(match_end) begin
                            if(match_result)
                                game_state_nxt = WINNER ;
                            else
                                game_state_nxt = LOSER ;
                        end
                        else if (is_shooted)
                            game_state_nxt = SHOOTER ;
                        else   
                            game_state_nxt = KEEPER ;                                              
                    end
                    SHOOTER: begin
                        if(match_end) begin
                            if(match_result)
                                game_state_nxt = WINNER ;
                            else
                                game_state_nxt = LOSER ;
                        end
                        else if (is_shooted)
                            game_state_nxt = KEEPER ;
                        else   
                            game_state_nxt = SHOOTER ; 
                    end
                    WINNER: begin
                        if(right_clicked) begin
                            game_state_nxt = START;
                        end
                        else begin
                            game_state_nxt = WINNER;
                        end
                    end
                    LOSER: begin
                        if(right_clicked) begin
                            game_state_nxt = START;
                        end
                        else begin
                            game_state_nxt = LOSER;
                        end
                    end
                    default: begin
                        game_state_nxt = START;
                    end
                endcase
            end
            else
                game_state_nxt = START;
        end
    endcase
    
end

endmodule