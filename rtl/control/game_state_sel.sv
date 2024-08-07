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
    input wire solo_enable,// connect_corrected,
    input logic match_end,
    input logic match_result,
    input logic end_gk,
    input logic end_sh,

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
                    else if(end_gk)
                        game_state_nxt = SHOOTER ;
                    else
                        game_state_nxt = KEEPER ;
                    
                end
                SHOOTER: begin //added in limited version for initial testing
                    if(match_end) begin
                        if(match_result)
                            game_state_nxt = WINNER ;
                        else
                            game_state_nxt = LOSER ;
                    end
                    else if(end_sh)
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
        MULTI: begin
            // case(in_control.game_state) 
            //     START: begin
            //         if(left_clicked && connect_corrected) begin
            //             game_state_nxt = KEEPER;
            //         end
            //         else begin
            //             game_state_nxt = START;
            //         end
            //     end

            // endcase
            /*
            if (connect_corrected) begin
                game_state_nxt = START;
            end
            else begin
            game_state_nxt = START;
            end
            */
           game_state_nxt = START ;
        end
    endcase
    
end

endmodule