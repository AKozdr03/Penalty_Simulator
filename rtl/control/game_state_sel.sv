/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Next state controller.
 */

module game_state_sel(
    input wire clk, rst,
    input wire left_clicked, is_scored,
    input wire solo_enable,
    input logic [2:0] score // it maybe in interface? or in pkg
    
);

import game_pkg::*;

// Local variables
logic [2:0] round_counter, round_counter_nxt; // this also can be in pkg or interface?

always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        game_state <= START;
        game_mode <= MULTI;
        round_counter <= '0;
    end
    else begin
        game_state <= game_state_nxt;
        game_mode <= game_mode_nxt;
        round_counter <= round_counter_nxt;
    end
end

always_comb begin : next_game_mode_controller
    if(solo_enable) begin 
        if(game_state == START) begin // this is protection for inquisitive people :) to not switch game mode during the game
            game_mode_nxt = SOLO;
        end
        else begin
            case(game_mode)
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
    case(game_mode)
        SOLO: begin
            case(game_state)
                START: begin
                    round_counter_nxt = '0;
                    if(left_clicked) begin
                        game_state_nxt = KEEPER;
                    end
                    else begin
                        game_state_nxt = START;
                    end
                end
                KEEPER: begin
                    if(is_scored) begin // is_scored, round_counter, score is information from another module that you can go to another state
                        if(round_counter == 3'd4) begin
                            round_counter_nxt = '0;
                            if(score >= 2'd3) begin // score will be reseted in score module
                                game_state_nxt = WINNER;
                            end
                            else begin 
                                game_state_nxt = LOOSER;
                            end
                        end
                        else begin
                            round_counter_nxt = round_counter;
                            game_state_nxt = KEEPER;                           
                        end
                    end
                    else begin
                        round_counter_nxt = round_counter;
                        game_state_nxt = KEEPER;
                    end
                end
                SHOOTER: begin // there is no possiblility this state in solo mode, but it have to be there
                    round_counter_nxt = '0;
                    game_state_nxt = START; 
                end
                WINNER: begin
                    round_counter_nxt = '0;
                    if(left_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = WINNER;
                    end
                end
                LOOSER: begin
                    round_counter_nxt = '0;
                    if(left_clicked) begin
                        game_state_nxt = START;
                    end
                    else begin
                        game_state_nxt = LOOSER;
                    end
                end
                default: begin
                    round_counter_nxt = '0;
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