/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Uart decode module
 */

 module uart_decoder(
    input wire clk,
    input wire rst,
    input wire [7:0] read_data,
    input wire rx_empty,
    input g_state game_state,

    output logic rd_uart,
    output logic connect_corrected,
    output logic enemy_shooter,
    output logic game_starts,
    output logic [9:0] keeper_pos,
    output logic [9:0] x_shooter,
    output logic [9:0] y_shooter,
    output logic [2:0]  opponent_score,
    output logic enemy_input,
    output logic enemy_is_scored,
    output logic back_to_start
);

import game_pkg::*;

// Local variables
logic connect_corrected_nxt, enemy_shooter_nxt,game_starts_nxt, rd_uart_nxt, enemy_input_nxt, enemy_is_scored_nxt, back_to_start_nxt;
logic [9:0] keeper_pos_nxt, x_shooter_nxt, y_shooter_nxt;
logic [4:0] keeper_pos_ow, keeper_pos_ow_nxt,  x_shooter_ow, y_shooter_ow, x_shooter_ow_nxt,  x_shooter_ow_2, x_shooter_ow_2_nxt, y_shooter_ow_nxt;
logic [2:0]  opponent_score_nxt;

//Logic

always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        connect_corrected <= '0;
        keeper_pos <= '0;
        x_shooter <= '0;
        y_shooter <= '0;
        opponent_score <= '0;
        keeper_pos_ow <= '0;
        x_shooter_ow <= '0;
        y_shooter_ow <= '0;
        enemy_shooter <= '0;
        game_starts <= '0;
        rd_uart <= '0;
        x_shooter_ow_2 <= '0;
        enemy_input <= '0 ;
        enemy_is_scored <= '0 ;
        back_to_start <= '0;
    end
    else begin
        connect_corrected <= connect_corrected_nxt;
        keeper_pos <= keeper_pos_nxt;   
        x_shooter <= x_shooter_nxt;
        y_shooter <= y_shooter_nxt;
        opponent_score <= opponent_score_nxt;     
        keeper_pos_ow <= keeper_pos_ow_nxt;
        x_shooter_ow <= x_shooter_ow_nxt;
        x_shooter_ow_2 <= x_shooter_ow_2_nxt;
        y_shooter_ow <= y_shooter_ow_nxt;
        enemy_shooter <= enemy_shooter_nxt;
        game_starts <= game_starts_nxt;
        rd_uart <= rd_uart_nxt;
        enemy_input <= enemy_input_nxt ;
        enemy_is_scored <= enemy_is_scored_nxt ;
        back_to_start <= back_to_start_nxt;
    end
end

/*
 * OPCODES
 * 
 * 000 - synchronization data  (number which ensure us that communication is corrected [3] which start state have opponent [7], if game starts [6], if second basys have to go to start [5]) [connect_corrected] - from game_state_sel
 * 001 - gloves position part 1 (required to draw keeper on second screen) [keeper_pos[4:0]] - from mouse_ctl
 * 010 - gloves position part 2 (required to draw keeper on second screen) [keeper_pos[9:5]]  - there is keeper_pos updated
 * 011 - shot x position 1 part [x_shooter[4:0]] - from shoot_ctl
 * 100 - shot x position 2 part [x_shooter[9:5]]
 * 101 - shot y position 1 part [y_shooter[4:0]]
 * 110 - shot y position 2 part [y_shooter[9:5]] - there is x_shooter and y_shooter updated
 * 111 - data from score_control: [7]-multipurpose input, [6]-is_scored, [5:3]-score_player - from score_ctl
*/

 always_comb begin : uart_decoding_module
    if(rx_empty == 1'b0) begin
        case(read_data[2:0])
            3'b000: begin
                if(read_data[7:3] == 5'b11001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b1;
                    game_starts_nxt = 1'b1;
                    back_to_start_nxt = 1'b0;
                end
                else if(read_data[7:3] == 5'b01001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b1;
                    back_to_start_nxt = 1'b0;
                end
                else if(read_data[7:3] == 5'b00001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b0;
                    back_to_start_nxt = 1'b0;
                end    
                else if(read_data[7:3] == 5'b00101) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b0;    
                    back_to_start_nxt = 1'b1;              
                end
                else begin
                    connect_corrected_nxt = 1'b0;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b0;
                    back_to_start_nxt = 1'b0;
                end
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                keeper_pos_ow_nxt = keeper_pos_ow;
                keeper_pos_nxt = keeper_pos;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                x_shooter_ow_2_nxt = x_shooter_ow_2;

            end
            3'b001: begin
                if(game_state == SHOOTER) begin
                    keeper_pos_ow_nxt[4:0] = read_data[7:3]; // ow is required because keeper_pos and shot pos can be updated when all position is read 
                    keeper_pos_nxt = keeper_pos;
                end
                else begin
                    keeper_pos_ow_nxt[4:0] = keeper_pos_ow;
                    keeper_pos_nxt = keeper_pos;
                end
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
            3'b010: begin
                if(game_state == SHOOTER) begin
                    keeper_pos_nxt = {read_data[7:3] , keeper_pos_ow};
                end
                else begin
                    keeper_pos_nxt = keeper_pos;
                end
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;     
                keeper_pos_ow_nxt = keeper_pos_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
            3'b011: begin
                if(game_state == KEEPER) begin
                    x_shooter_ow_nxt = read_data[7:3]; 
                end
                else begin
                    x_shooter_ow_nxt = x_shooter_ow;
                end
                keeper_pos_nxt = keeper_pos;
                keeper_pos_ow_nxt = keeper_pos_ow;
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
            3'b100: begin
                if(game_state == KEEPER) begin
                    x_shooter_ow_2_nxt = read_data[7:3];
                end
                else begin
                    x_shooter_ow_2_nxt = x_shooter_ow_2;
                end
                x_shooter_nxt = x_shooter;
                x_shooter_ow_nxt = x_shooter_ow; 
                keeper_pos_nxt = keeper_pos;
                keeper_pos_ow_nxt = keeper_pos_ow;
                y_shooter_nxt = y_shooter;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                back_to_start_nxt = back_to_start;
            end
            3'b101: begin
                if(game_state == KEEPER) begin
                    y_shooter_ow_nxt = read_data[7:3]; 
                end
                else begin
                    y_shooter_ow_nxt = y_shooter_ow;
                end
                keeper_pos_nxt = keeper_pos;
                keeper_pos_ow_nxt = keeper_pos_ow;
                x_shooter_nxt = x_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_nxt = y_shooter;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;     
                enemy_shooter_nxt = enemy_shooter;   
                game_starts_nxt = game_starts;  
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
            3'b110: begin
                if(game_state == KEEPER) begin
                    y_shooter_nxt = {read_data[7:3] , y_shooter_ow}; //update y
                    x_shooter_nxt = {x_shooter_ow_2, x_shooter_ow}; //update x
                end
                else begin
                    y_shooter_nxt = y_shooter;
                    x_shooter_nxt = x_shooter;
                end
                x_shooter_ow_nxt = x_shooter_ow; 
                keeper_pos_nxt = keeper_pos;
                keeper_pos_ow_nxt = keeper_pos_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;    
                enemy_shooter_nxt = enemy_shooter;    
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
            3'b111: begin
                if((game_state == KEEPER) || (game_state == SHOOTER)) begin
                    opponent_score_nxt = read_data[5:3];
                    enemy_is_scored_nxt = read_data[6];
                    enemy_input_nxt = read_data[7];
                end
                else begin
                    opponent_score_nxt = opponent_score;
                    enemy_is_scored_nxt = enemy_is_scored;
                    enemy_input_nxt = enemy_input;
                end
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                keeper_pos_ow_nxt = keeper_pos_ow;
                keeper_pos_nxt = keeper_pos;
                connect_corrected_nxt = connect_corrected;     
                enemy_shooter_nxt = enemy_shooter;    
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;   
                back_to_start_nxt = back_to_start; 
            end
            default: begin
                opponent_score_nxt = opponent_score;
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                keeper_pos_ow_nxt = keeper_pos_ow;
                keeper_pos_nxt = keeper_pos;
                connect_corrected_nxt = 1'b0; 
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
                back_to_start_nxt = back_to_start;
            end
        endcase
        if(rd_uart == 1'b0) begin
            rd_uart_nxt = 1'b1;
        end
        else begin
            rd_uart_nxt = 1'b0;
        end
    end
    else begin
        connect_corrected_nxt = connect_corrected;
        keeper_pos_nxt = keeper_pos;   
        x_shooter_nxt = x_shooter;
        y_shooter_nxt = y_shooter;
        opponent_score_nxt = opponent_score;     
        keeper_pos_ow_nxt = keeper_pos_ow;
        x_shooter_ow_nxt = x_shooter_ow;
        y_shooter_ow_nxt = y_shooter_ow;
        enemy_input_nxt = enemy_input ;
        enemy_is_scored_nxt = enemy_is_scored ;
        enemy_shooter_nxt = enemy_shooter;
        game_starts_nxt = game_starts;
        x_shooter_ow_2_nxt = x_shooter_ow_2;
        rd_uart_nxt = 1'b0;
        back_to_start_nxt = back_to_start;
    end

end

endmodule