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
    input logic is_scored,
    input logic round_done,
    control_if.out out_control
);

import game_pkg::*;

// Local variables
g_state game_state, game_state_nxt;
g_mode game_mode, game_mode_nxt;

logic [2:0] score_nxt;

//logic
always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= '0;
        out_control.game_mode <= MULTI;
        out_control.game_state <= START;

        game_mode <= MULTI;
        game_state <= START ;
    end
    else begin
        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= score_nxt;
        out_control.game_mode <= game_mode_nxt;
        out_control.game_state <= game_state_nxt;

        game_mode <= game_mode_nxt ;
        game_state <= game_state_nxt ;
    end
end

always_comb begin : next_game_mode_controller
    if(solo_enable) begin 
        if(game_state == START) begin // this is protection for inquisitive people :) to not switch game mode during the game
            game_mode_nxt = SOLO;
        end
        else begin
            game_mode_nxt = game_mode;
        end
    end
    else begin
        game_mode_nxt = MULTI;  
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
                    score_nxt = 0 ;
                end
                KEEPER: begin
                    /*if(in_control.is_scored) begin // is_scored, round_counter, score is information from another module that you can go to another state
                        if(in_control.round_counter == 4'd4) begin
                            if(in_control.score >= 3'd3) begin // score and round_counter are reseted in score module
                                game_state_nxt = WINNER;
                            end
                            else begin 
                                game_state_nxt = LOOSER;
                            end
                        end
                        else begin
                            game_state_nxt = KEEPER;                           
                        end 
                        
                    end*///commented for test purpose
                    if(round_done) begin
                        if(is_scored)
                            game_state_nxt = LOOSER ;
                        else
                            game_state_nxt = WINNER ;
                    end
                    else
                        game_state_nxt = KEEPER ;
                    
                    score_nxt = '0; //
                    
                end
                SHOOTER: begin // there is no possiblility this state in solo mode, but it have to be there
                    game_state_nxt = START; 
                    score_nxt = '0;
                end
                WINNER: begin
                    if(right_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = WINNER;
                    end
                    score_nxt = '0; //
                end
                LOOSER: begin
                    if(right_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = LOOSER;
                    end
                    score_nxt = '0; //
                end
                default: begin
                    game_state_nxt = START;
                    score_nxt = '0;
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
           score_nxt = '0; //
        end
    endcase
    
end

endmodule