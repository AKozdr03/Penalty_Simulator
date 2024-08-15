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

    output logic rd_uart,
    output logic connect_corrected,
    output logic enemy_shooter,
    output logic game_starts,
    output logic [9:0] keeper_pos,
    output logic [9:0] x_shooter,
    output logic [9:0] y_shooter,
    output logic [2:0]  opponent_score,
    output logic enemy_input,
    output logic enemy_is_scored
);

// Local variables
logic connect_corrected_nxt, enemy_shooter_nxt,game_starts_nxt, rd_uart_nxt, enemy_input_nxt, enemy_is_scored_nxt;
logic [9:0] keeper_pos_nxt, x_shooter_nxt, y_shooter_nxt;
logic [4:0] keeper_pos_ow, keeper_pos_ow_nxt,  x_shooter_ow, y_shooter_ow, x_shooter_ow_nxt,  x_shooter_ow_2, x_shooter_ow_2_nxt, y_shooter_ow_nxt;
logic [2:0]  opponent_score_nxt;
//logic [3:0] tick_transmit_c, tick_transmit_c_nxt;

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
        //tick_transmit_c <= '0;
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
       // tick_transmit_c <= tick_transmit_c_nxt;
    end
end

/*
 * OPCODES
 * 
 * 000 - synchronization data  (number which ensure us that communication is corrected [0] which start state have opponent [4] and if game starts [3]) [connect_corrected]
 * 001 - gloves position part 1 (required to draw keeper on second screen) [keeper_pos[4:0]]
 * 010 - gloves position part 2 (required to draw keeper on second screen) [keeper_pos[9:5]]  - there is keeper_pos updated
 * 011 - shot x position 1 part [x_shooter[4:0]]
 * 100 - shot x position 2 part [x_shooter[9:5]] 
 * 101 - shot y position 1 part [y_shooter[4:0]]
 * 110 - shot y position 2 part [y_shooter[9:5]] - there is x_shooter and y_shooter updated
 * 111 - data from score_control: [7]-multipurpose output, [6]-is_scored, [5:3]-score_player
*/

 always_comb begin : uart_decoding_module
    if(rx_empty == 1'b0) begin
        case(read_data[2:0])
            3'b000: begin
                if(read_data[7:3] == 5'b11001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b1;
                    game_starts_nxt = 1'b1;
                end
                else if(read_data[7:3] == 5'b01001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b1;
                end
                else if(read_data[7:3] == 5'b00001) begin
                    connect_corrected_nxt = 1'b1;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b0;
                end                      
                else begin
                    connect_corrected_nxt = 1'b0;
                    enemy_shooter_nxt = 1'b0;
                    game_starts_nxt = 1'b0;
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
                keeper_pos_ow_nxt[4:0] = read_data[7:3]; // ow is required because keeper_pos and shot pos can be updated when all position is read 
                keeper_pos_nxt = keeper_pos;
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
            end
            3'b010: begin
                keeper_pos_nxt = {read_data[7:3] , keeper_pos_ow};
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
            end
            3'b011: begin
                x_shooter_ow_nxt = read_data[7:3]; 
                keeper_pos_nxt = keeper_pos;
                keeper_pos_ow_nxt = keeper_pos_ow;
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                y_shooter_ow_nxt = y_shooter_ow;
                opponent_score_nxt = opponent_score;
                connect_corrected_nxt = connect_corrected;
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
            end
            3'b100: begin
                x_shooter_ow_2_nxt = read_data[7:3];
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
            end
            3'b101: begin
                y_shooter_ow_nxt = read_data[7:3]; 
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
            end
            3'b110: begin
                y_shooter_nxt = {read_data[7:3] , y_shooter_ow}; //update y
                x_shooter_ow_nxt = x_shooter_ow; 
                x_shooter_nxt = {x_shooter_ow_2, x_shooter_ow}; //update x
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
            end
            3'b111: begin
                opponent_score_nxt = read_data[5:3];
                enemy_is_scored_nxt = read_data[6];
                enemy_input_nxt = read_data[7];
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
            end
            default: begin
                opponent_score_nxt = opponent_score;
                x_shooter_nxt = x_shooter;
                y_shooter_nxt = y_shooter;
                x_shooter_ow_nxt = x_shooter_ow;
                y_shooter_ow_nxt = y_shooter_ow;
                keeper_pos_ow_nxt = keeper_pos_ow;
                keeper_pos_nxt = keeper_pos;
                connect_corrected_nxt = 1'b0; // because it is sign that something in connection is broken
                enemy_input_nxt = enemy_input ;
                enemy_is_scored_nxt = enemy_is_scored ;
                enemy_shooter_nxt = enemy_shooter;
                game_starts_nxt = game_starts;
                x_shooter_ow_2_nxt = x_shooter_ow_2;
            end
        endcase
        if(rd_uart == 1'b0) begin
            rd_uart_nxt = 1'b1;
        end
        else begin
            rd_uart_nxt = 1'b0;
        end
        
        //tick_transmit_c_nxt = 0;
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
        /*if(tick_transmit_c < 15) begin // prevention against overflow
            tick_transmit_c_nxt = tick_transmit_c + 1;
        end
        else begin
            tick_transmit_c_nxt = 4'b1110;
        end*/
    end
    /*if(tick_transmit_c >= 4'd10) begin // this is because if uart send nothing it is sign that connection is not corrected
        connect_corrected_nxt = 1'b0;
    end
    else begin
        connect_corrected_nxt = connect_corrected;
    end*/
end

endmodule