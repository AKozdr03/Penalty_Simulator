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
    input wire solo_enable,

    control_if.in in_control,
    control_if.out out_control
);

import game_pkg::*;

// Local variables
g_state game_state_nxt;
g_mode game_mode_nxt;

always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= '0;
        out_control.game_mode <= MULTI;
        out_control.game_state <= START;
    end
    else begin
        out_control.is_scored <= in_control.is_scored;
        out_control.round_counter <= in_control.round_counter;
        out_control.score <= in_control.score;
        out_control.game_mode <= game_mode_nxt;
        out_control.game_state <= game_state_nxt;
    end
end

always_comb begin : next_game_mode_controller
    if(solo_enable) begin 
        if(in_control.game_state == START) begin // this is protection for inquisitive people :) to not switch game mode during the game
            game_mode_nxt = SOLO;
        end
        else begin
            case(in_control.game_state)
                SOLO: game_mode_nxt = SOLO;
                MULTI: game_mode_nxt = MULTI;
                default: game_mode_nxt = MULTI;
            endcase
        end
    end
    else begin
        game_mode_nxt = MULTI;  
    end
end

always_comb begin : next_game_state_controller
    case(in_control.game_mode)
        SOLO: begin
            case(in_control.game_state)
                START: begin
                    if(left_clicked) begin
                        game_state_nxt = KEEPER;
                    end
                    else begin
                        game_state_nxt = START;
                    end
                end
                KEEPER: begin
                    if(in_control.is_scored) begin // is_scored, round_counter, score is information from another module that you can go to another state
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
                    end
                    else begin
                        game_state_nxt = KEEPER;
                    end
                end
                SHOOTER: begin // there is no possiblility this state in solo mode, but it have to be there
                    game_state_nxt = START; 
                end
                WINNER: begin
                    if(left_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = WINNER;
                    end
                end
                LOOSER: begin
                    if(left_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = LOOSER;
                    end
                end
                default: begin
                    game_state_nxt = START;
                end
            endcase

        end
        MULTI: begin
        // there will be next state controller for multi later :)
        end
    endcase

end

endmodule