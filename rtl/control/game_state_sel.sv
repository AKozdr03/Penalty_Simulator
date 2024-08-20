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
    input logic end_gk,
    input logic end_sh,
    input logic back_to_start,

    output logic [7:0] data_to_transmit, //synchronization data
    output g_state game_state,
    output g_mode game_mode
);

import game_pkg::*;

// Local variables
g_state game_state_nxt;
g_mode game_mode_nxt;

logic [7:0] data_to_transmit_nxt;
logic [20:0] counter_c, counter_c_nxt ;

//logic
always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        game_state <= START;
        game_mode <= MULTI;
        counter_c <= '0 ;
    end
    else begin
        game_state <= game_state_nxt ;
        game_mode <= game_mode_nxt ;
        counter_c <= counter_c_nxt ;
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
    if(left_clicked)
        data_to_transmit_nxt = 8'b11001000;
    else if(right_clicked)
        data_to_transmit_nxt = 8'b00101000;
    else if(game_starts)
        data_to_transmit_nxt = 8'b01001000;
    else
        data_to_transmit_nxt = 8'b00001000;
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
            //leftovers from multi
            counter_c_nxt = '0 ;
        end
        MULTI: begin
            if(connect_corrected) begin
                case(game_state)
                    START: begin
                    if(counter_c == 1_000_000) begin
                        if(enemy_shooter && game_starts) begin
                            game_state_nxt = SHOOTER;
                        end
                        else if (game_starts) begin
                            game_state_nxt = KEEPER;
                        end
                        else begin
                            game_state_nxt = START;
                        end
                        counter_c_nxt = counter_c ;
                    end
                    else begin
                        game_state_nxt = START;
                        counter_c_nxt = counter_c + 1 ;
                    end

                    end
                    KEEPER: begin
                        if(match_end) begin
                            if(match_result) begin
                                game_state_nxt = WINNER ;
                            end
                            else begin
                                game_state_nxt = LOSER ;
                            end
                        end
                        else if (end_gk) begin
                            game_state_nxt = SHOOTER ;
                        end
                        else begin
                            game_state_nxt = KEEPER ; 
                        end
                        counter_c_nxt = '0 ;
                    end
                    SHOOTER: begin
                        if(match_end) begin
                            if(match_result) begin
                                game_state_nxt = WINNER ;
                            end
                            else begin
                                game_state_nxt = LOSER ;
                            end
                        end
                        else if (end_sh) begin
                            game_state_nxt = KEEPER ;
                        end
                        else begin
                            game_state_nxt = SHOOTER ; 
                        end
                        counter_c_nxt = '0 ;
                    end
                    WINNER: begin
                        if(right_clicked || (back_to_start == 1'b1)) begin
                            game_state_nxt = START;
                        end
                        else begin
                            game_state_nxt = WINNER;
                        end
                        counter_c_nxt = '0 ;
                    end
                    LOSER: begin
                        if(right_clicked || (back_to_start == 1'b1)) begin
                            game_state_nxt = START;
                        end
                        else begin
                            game_state_nxt = LOSER;
                        end
                        counter_c_nxt = '0 ;
                    end
                    default: begin
                        game_state_nxt = START;
                        counter_c_nxt = '0 ;
                    end
                endcase
            end
            else begin
                game_state_nxt = START;
                counter_c_nxt = '0 ;
            end
        end
        default: begin
            game_state_nxt = START;
            counter_c_nxt = '0 ;
        end
    endcase
    
end

endmodule