/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module that is responsible for controlling the direction of the ball.
 */

 module ball_control(
    input wire clk, rst,
    //input  wire [11:0] x_shooter, // this data is sent from second player //commented for testing purposes
    //input  wire [11:0] y_shooter, // this data is sent from second player

    output logic [11:0] shot_xpos,
    output logic [11:0] shot_ypos,
    input g_state game_state,

    vga_if.in in,   
    vga_if.out out
);

import game_pkg::*;

// Local variables

logic [11:0] shot_xpos_nxt, shot_ypos_nxt;
logic [31:0] random_x, random_y, random_x_nxt, random_y_nxt;

always_ff @(posedge clk) begin : data_passed_through
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;

        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= '0;
        out_control.game_mode <= MULTI;
        out_control.game_state <= START;

        shot_xpos <= '0;
        shot_ypos <= '0;
        random_x <= '0;
        random_y <= '0;
    end 
    else begin
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= in.rgb;
    
        out_control.is_scored <= in_control.is_scored;
        out_control.round_counter <= in_control.round_counter;
        out_control.score <= in_control.score;
        out_control.game_mode <= in_control.game_mode;
        out_control.game_state <= in_control.game_state;    
        
        shot_xpos <= shot_xpos_nxt;
        shot_xpos <= shot_ypos_nxt;
        random_x <= random_x_nxt;
        random_y <= random_y_nxt;
    end
 end

always_comb begin : shot_direction_controller
    case(in_control.game_mode)
        SOLO: begin
            if((in_control.is_scored == 1) || (in_control.game_state != KEEPER)) begin // it's not very optimal I know
                /*random_x_nxt = $urandom_range(989, 35); // $urandom_range gives 32 bit number so i have to to this
                random_y_nxt = $urandom_range(644, 115);*/ //temporary for tests
                if(random_x > 35 && random_x < 989)
                    random_x_nxt = random_x + 250 ;
                else
                    random_x_nxt = 40 ;

                if(random_y > 115 && random_y < 644)
                    random_y_nxt = random_y + 138 ;
                else
                    random_y_nxt = 130 ;
            end
            else begin
                random_x_nxt = random_x;
                random_y_nxt = random_y;
            end

            shot_xpos_nxt = random_x[11:0];
            shot_ypos_nxt = random_y[11:0];
        end
        MULTI: begin
            //shot_xpos_nxt = x_shooter; //commented for testing purposes
            //shot_ypos_nxt = y_shooter;
            random_x_nxt = '0 ;
            random_x_nxt = '0 ;
        end
        default: begin
            shot_xpos_nxt = '0;
            shot_ypos_nxt = '0;  
            random_x_nxt = '0 ;
            random_x_nxt = '0 ;  
        end
    endcase
 end


endmodule