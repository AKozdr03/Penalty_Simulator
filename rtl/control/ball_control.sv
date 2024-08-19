/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module that is responsible for controlling the direction of the ball.
 */

 //imports

 import game_pkg::*;

 //module

 module ball_control(
    input wire clk, rst,
    input g_state game_state,
    input g_mode game_mode,
    input logic round_done,
    input  wire [9:0] x_shooter, // this data is sent from second player 
    input  wire [9:0] y_shooter, // this data is sent from second player

    output logic [9:0] shot_xpos,
    output logic [9:0] shot_ypos
);

// Local variables

logic [9:0] shot_xpos_nxt, shot_ypos_nxt;
logic [9:0] random_x, random_y, random_x_nxt, random_y_nxt;
logic [9:0] random_counter_x, random_counter_x_nxt;
logic [9:0] random_counter_y, random_counter_y_nxt;

always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin

        shot_xpos <= '0;
        shot_ypos <= '0;
        random_x <= '0;
        random_y <= '0;
        random_counter_x <= '0;
        random_counter_y <= '0;
    end 
    else begin
        
        shot_xpos <= shot_xpos_nxt;
        shot_ypos <= shot_ypos_nxt;
        random_x <= random_x_nxt;
        random_y <= random_y_nxt;
        random_counter_x <= random_counter_x_nxt;
        random_counter_y <= random_counter_y_nxt;
    end
 end

 always_comb begin : shot_direction_controller
    case(game_mode)
        SOLO: begin
            if(round_done == 1 || game_state == START) begin
                if(random_counter_x < 36)
                    random_x_nxt = 36 ;
                else if(random_counter_x > 888)
                    random_x_nxt = 888 ;
                else
                    random_x_nxt = random_counter_x ;

                if(random_counter_y < 116)
                    random_y_nxt = 116 ;
                else if(random_counter_y > 549)
                    random_y_nxt = 549 ;
                else
                    random_y_nxt = random_counter_y ;          
            end
            else begin
                random_x_nxt = random_x;
                random_y_nxt = random_y;
            end

            shot_xpos_nxt = random_x;
            shot_ypos_nxt = random_y;
            
            //clock counter working

            random_counter_x_nxt = random_counter_x + 21;
            random_counter_y_nxt = random_counter_y + 17;
        end
        MULTI: begin 
            shot_xpos_nxt = x_shooter;
            shot_ypos_nxt = y_shooter;
            random_x_nxt = '0;
            random_y_nxt = '0;
            random_counter_x_nxt = '0;
            random_counter_y_nxt = '0;
        end
        default: begin
            shot_xpos_nxt = '0;
            shot_ypos_nxt = '0;
            random_x_nxt = '0;
            random_y_nxt = '0;
            random_counter_x_nxt = '0;
            random_counter_y_nxt = '0;          
        end

    endcase
 end

endmodule