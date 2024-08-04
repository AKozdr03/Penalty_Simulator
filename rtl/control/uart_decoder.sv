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
    output logic connect_corrected,
    output logic is_shooted,
    output logic [9:0] keeper_pos,
    output logic [9:0] x_shooter,
    output logic [9:0] y_shooter,
    output logic [2:0]  opponent_score
);

// Local variables
logic connect_corrected_nxt, is_shooted_nxt;
logic [9:0] keeper_pos_nxt, x_shooter_nxt, y_shooter_nxt;
logic [4:0] keeper_pos_ow, keeper_pos_ow_nxt,  x_shooter_ow, y_shooter_ow, x_shooter_ow_nxt, y_shooter_ow_nxt;
logic [2:0]  opponent_score_nxt;

//Logic

always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        connect_corrected <= 1'b0;
        keeper_pos <= 10'b0;
        x_shooter <= 10'b0;
        y_shooter <= 10'b0;
        opponent_score <= 3'b0;
        keeper_pos_ow <= 5'b0;
        x_shooter_ow <= 5'b0;
        y_shooter_ow <= 5'b0;
        is_shooted = 1'b0;
    end
    else begin
        connect_corrected <= connect_corrected_nxt;
        keeper_pos <= keeper_pos_nxt;   
        x_shooter <= x_shooter_nxt;
        y_shooter <= y_shooter_nxt;
        opponent_score <= opponent_score_nxt;     
        keeper_pos_ow <= keeper_pos_ow_nxt;
        x_shooter_ow <= x_shooter_ow_nxt;
        y_shooter_ow <= y_shooter_ow_nxt;
        is_shooted = is_shooted_nxt;
    end
end

/*
 * OPCODES
 * 
 * 000 - synchronization data  (number which ensure us that communication is corrected) [connect_corrected]
 * 001 - gloves position part 1 (required to draw keeper on second screen) [keeper_pos[4:0]]
 * 010 - gloves position part 2 (required to draw keeper on second screen) [keeper_pos[9:5]]  - there is keeper_pos updated
 * 011 - shot x position 1 part [x_shooter[4:0]]
 * 100 - shot x position 2 part [x_shooter[9:5]] - there is x_shooter updated
 * 101 - shot y position 1 part [y_shooter[4:0]]
 * 110 - shot y position 2 part [y_shooter[9:5]] - there is y_shooter updated
 * 111 - opponent score for display [opponent_score], read_data[6] is information if shoot is ended [is_shooted]
*/

 always_comb begin : uart_decoding_module
    case(read_data[2:0])
        3'b000: begin
            if(read_data[7:3] == 5'b10101) // 5'b10101 is a special number which inform us that connect is corrected
                connect_corrected_nxt = 1'b1;
            else
                connect_corrected_nxt = 1'b0;
            x_shooter_nxt = x_shooter;
            y_shooter_nxt = y_shooter;
            x_shooter_ow_nxt = x_shooter_ow;
            y_shooter_ow_nxt = y_shooter_ow;
            opponent_score_nxt = opponent_score;
            keeper_pos_ow_nxt = keeper_pos_ow;
            keeper_pos_nxt = keeper_pos;
            is_shooted_nxt = is_shooted;

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
            is_shooted_nxt = is_shooted;
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
            is_shooted_nxt = is_shooted;   
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
            is_shooted_nxt = is_shooted;
        end
        3'b100: begin
            x_shooter_nxt = {read_data[7:3] , x_shooter_ow};
            x_shooter_ow_nxt = x_shooter_ow; 
            keeper_pos_nxt = keeper_pos;
            keeper_pos_ow_nxt = keeper_pos_ow;
            y_shooter_nxt = y_shooter;
            y_shooter_ow_nxt = y_shooter_ow;
            opponent_score_nxt = opponent_score;
            connect_corrected_nxt = connect_corrected;
            is_shooted_nxt = is_shooted;
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
            is_shooted_nxt = is_shooted;          
        end
        3'b110: begin
            y_shooter_nxt = {read_data[7:3] , y_shooter_ow};
            x_shooter_ow_nxt = x_shooter_ow; 
            x_shooter_nxt = x_shooter;
            keeper_pos_nxt = keeper_pos;
            keeper_pos_ow_nxt = keeper_pos_ow;
            y_shooter_ow_nxt = y_shooter_ow;
            opponent_score_nxt = opponent_score;
            connect_corrected_nxt = connect_corrected;  
            is_shooted_nxt = is_shooted;         
        end
        3'b111: begin
            opponent_score_nxt = read_data[5:3];
            is_shooted_nxt = read_data[6];
            x_shooter_nxt = x_shooter;
            y_shooter_nxt = y_shooter;
            x_shooter_ow_nxt = x_shooter_ow;
            y_shooter_ow_nxt = y_shooter_ow;
            keeper_pos_ow_nxt = keeper_pos_ow;
            keeper_pos_nxt = keeper_pos;
            connect_corrected_nxt = connect_corrected;             
        end
        default: begin
            opponent_score_nxt = opponent_score;
            x_shooter_nxt = x_shooter;
            y_shooter_nxt = y_shooter;
            x_shooter_ow_nxt = x_shooter_ow;
            y_shooter_ow_nxt = y_shooter_ow;
            keeper_pos_ow_nxt = keeper_pos_ow;
            keeper_pos_nxt = keeper_pos;
            connect_corrected_nxt = connect_corrected; 
            is_shooted_nxt = is_shooted; 
        end
    endcase
end

  
endmodule