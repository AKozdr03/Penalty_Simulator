/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Module responsible for shooter actions.
 */

 //imports

 import game_pkg::*;
 import draw_pkg::*;

 //module

 module shoot_control(
    input logic clk,
    input logic rst,
    input g_state game_state,
    input g_mode game_mode,
    input logic [11:0] xpos,
    input logic [11:0] ypos,
    input logic [9:0] keeper_pos,
    input wire left_clicked,

    input logic enemy_input, //msb of uart with 111 opcode, informs that enemy has ended the round
    input logic enemy_is_scored, //is_scored from uart

    output logic is_scored,
    output logic round_done,
    output logic end_sh,
    output logic shot_taken,


    vga_if.in in,   
    vga_if.out out
 );

 //params
 
 localparam GK_POS_X = 400 ;
 localparam GK_BOTTOM = 250 ;
 localparam [9:0] GK_WIDTH = 200 ;
 localparam [9:0] GK_HALF_WIDTH = 100 ;
 localparam GK_TOP = 550 ;
 //variables

 typedef enum bit [2:0] {IDLE, ENGAGE, COUNTDOWN, RESULT, GOAL, MISS, TERMINATE} shoot_state;
 shoot_state state, state_nxt ;

 logic [25:0] counter, counter_nxt;

 logic [11:0] rgb_nxt;
 logic is_scored_nxt;
 logic round_done_nxt;
 logic end_sh_nxt;
 logic shot_taken_nxt;
 
 logic [10:0] hcount_d, vcount_d;
 logic hblnk_d, vblnk_d, hsync_d, vsync_d;
 
 logic [9:0] gk_left_edge, gk_left_edge_nxt, gk_right_edge, gk_right_edge_nxt ;

 //delay

 delay #(
    .CLK_DEL(1),
    .WIDTH(26)
 )
 u_delay_vga(
    .clk,
    .rst,
    .din({in.hblnk, in.hcount, in.hsync, in.vblnk, in.vcount, in.vsync}),
    .dout({hblnk_d,hcount_d,hsync_d, vblnk_d, vcount_d, vsync_d})
 );

 //logic

 always_ff @(posedge clk) begin
    if(rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;

        is_scored <= '0 ;
        round_done <= '0 ;
        state <= IDLE;
        counter <= '0 ;
        end_sh <= '0 ;
        shot_taken <= '0 ;
        gk_left_edge <= '0 ;
        gk_right_edge <= '0 ;
    end
    else begin
        out.vcount <= vcount_d;
        out.vsync  <= vsync_d;
        out.vblnk  <= vblnk_d;
        out.hcount <= hcount_d;
        out.hsync  <= hsync_d;
        out.hblnk  <= hblnk_d;
        out.rgb    <= rgb_nxt;

        is_scored <= is_scored_nxt ;
        round_done <= round_done_nxt ;
        state <= state_nxt;
        counter <= counter_nxt ;
        end_sh <= end_sh_nxt ;
        shot_taken <= shot_taken_nxt ;
        gk_left_edge <= gk_left_edge_nxt ;
        gk_right_edge <= gk_right_edge_nxt ;
    end
 end

 always_comb begin
    case(game_mode)
        SOLO: begin
            case(state)
                IDLE:       begin
                                if(game_state == SHOOTER)
                                    state_nxt = ENGAGE ;
                                else
                                    state_nxt = IDLE ;

                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end
                ENGAGE:     begin //this is a safety measure for the delay of state machine
                                if(game_state == SHOOTER) begin
                                    state_nxt = COUNTDOWN ;
                                end
                                else begin
                                    state_nxt = IDLE ;
                                end
                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end

                COUNTDOWN:  begin 
                                if(in.hcount >= GK_POS_X && in.hcount <= (GK_POS_X + GK_WIDTH)     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_0_F;
                                else 
                                    rgb_nxt = in.rgb;
                                    
                            if(left_clicked) begin
                                    state_nxt = RESULT ;
                                end
                                else begin
                                    state_nxt = COUNTDOWN ;
                                end

                                is_scored_nxt = 1'b0 ;
                                counter_nxt = '0;
                                round_done_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end

                RESULT:     begin
                                if(in.hcount >= GK_POS_X && in.hcount <= (GK_POS_X + GK_WIDTH)     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_0_F;
                                else 
                                    rgb_nxt = in.rgb;

                                if((xpos >= SH_POST_INNER_EDGE && xpos <= (SCREEN_WIDTH - SH_POST_INNER_EDGE)
                                    && ypos >= SH_CROSSBAR_BOTTOM_EDGE && ypos <= SH_POST_BOTTOM_EDGE )
                                && !(xpos >= GK_POS_X && xpos <= (GK_POS_X + GK_WIDTH)     
                                    && ypos >= GK_BOTTOM && ypos <= GK_TOP )) begin
                                    state_nxt = GOAL ;
                                end
                                else begin
                                    state_nxt = MISS ; 
                                end

                                round_done_nxt = 1'b0 ;
                                is_scored_nxt = 1'b0 ;
                                counter_nxt = '0 ;
                                end_sh_nxt = 1'b0;

                            end
                GOAL:       begin
                                if(in.hcount >= GK_POS_X && in.hcount <= (GK_POS_X + GK_WIDTH)     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_F_0;
                                else 
                                    rgb_nxt = in.rgb;

                                if(counter == 13003901) begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = '0;
                                    round_done_nxt = 1'b1 ;
                                end
                                else begin
                                    state_nxt = GOAL ;
                                    counter_nxt = counter + 1 ;
                                    round_done_nxt = 1'b0 ;
                                end

                                is_scored_nxt = 1'b1;
                                end_sh_nxt = 1'b0 ;
                            end
                
                MISS:       begin
                                if(in.hcount >= GK_POS_X && in.hcount <= (GK_POS_X + GK_WIDTH)     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'hF_0_0;
                                else 
                                    rgb_nxt = in.rgb;

                                if(counter == 13003901) begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = '0;
                                    round_done_nxt = 1'b1 ;
                                end
                                else begin
                                    state_nxt = MISS ;
                                    counter_nxt = counter + 1 ;
                                    round_done_nxt = 1'b0 ;
                                end

                                is_scored_nxt = 1'b0;
                                end_sh_nxt = 1'b0 ;
                            end
                TERMINATE:  begin
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                counter_nxt = '0 ;
                                state_nxt = IDLE ;
                                rgb_nxt = in.rgb;
                                end_sh_nxt = 1'b1 ;
                            end

                default:    begin
                                rgb_nxt = 12'h0_0_F; //blue = error control
                                state_nxt = IDLE ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0;
                            end
            endcase
            //leftovers from multi 
            shot_taken_nxt = 1'b0 ;
            gk_left_edge_nxt = 0 ;
            gk_right_edge_nxt = 0;
        end
        MULTI: begin
            case(state)
                IDLE:       begin 
                                if(game_state == SHOOTER)
                                    state_nxt = ENGAGE ;
                                else
                                    state_nxt = IDLE ;

                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                shot_taken_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end
                ENGAGE:     begin //this is a safety measure for the delay of state machine
                                if(game_state == SHOOTER) begin
                                    state_nxt = COUNTDOWN ;
                                end
                                else begin
                                    state_nxt = IDLE ;
                                end
                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                shot_taken_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end

                COUNTDOWN:  begin //actually just waiting for the shot to be made
                                if(in.hcount >= gk_left_edge && in.hcount <= gk_right_edge     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_0_F;
                                 else 
                                    rgb_nxt = in.rgb;
                                    
                                if(left_clicked) begin
                                    state_nxt = RESULT ;
                                end
                                else begin
                                    state_nxt = COUNTDOWN ;
                                end
                                shot_taken_nxt = 1'b0 ;
                                counter_nxt = '0;
                                end_sh_nxt = 1'b0 ;
                            end

                RESULT:     begin //waiting for info from enemy basys if the shot was saved or not
                                if(in.hcount >= gk_left_edge && in.hcount <= gk_right_edge     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_0_F;
                                 else 
                                    rgb_nxt = in.rgb;

                                if(enemy_input) begin
                                    if(counter == 10) begin
                                        if(enemy_is_scored) begin
                                            state_nxt = GOAL ;
                                        end
                                        else begin
                                            state_nxt = MISS ;
                                        end
                                        counter_nxt = 0 ;
                                    end
                                    else begin
                                        state_nxt = RESULT ;
                                        counter_nxt = counter + 1 ;
                                    end
                                end
                                else begin
                                    state_nxt = RESULT ;
                                    counter_nxt = 0 ;
                                end

                                shot_taken_nxt = 1'b1 ;
                                end_sh_nxt = 1'b0 ;

                            end
                GOAL:       begin //goal scored
                                if(in.hcount >= gk_left_edge && in.hcount <= gk_right_edge     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'h0_F_0;
                                else 
                                    rgb_nxt = in.rgb;

                                if(counter == 13003901) begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = '0;
                                end
                                else begin
                                    state_nxt = GOAL ;
                                    counter_nxt = counter + 1 ;
                                end
                                shot_taken_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end
                
                MISS:       begin //shot saved
                                if(in.hcount >= gk_left_edge && in.hcount <= gk_right_edge     //keeper test drawing
                                && in.vcount >= GK_BOTTOM && in.vcount <= GK_TOP ) 
                                    rgb_nxt = 12'hF_0_0;
                                else 
                                    rgb_nxt = in.rgb;

                                if(counter == 13003901) begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = '0;
                                end
                                else begin
                                    state_nxt = MISS ;
                                    counter_nxt = counter + 1 ;
                                end
                                shot_taken_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end
                TERMINATE:  begin 
                                if(counter == 13003901) begin
                                    state_nxt = IDLE ;
                                    counter_nxt = '0;
                                    end_sh_nxt = 1'b1 ;
                                end
                                else begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = counter + 1 ;
                                    end_sh_nxt = 1'b0 ;
                                end
                                rgb_nxt = in.rgb;
                                shot_taken_nxt = 1'b0 ;
                            end

                default:    begin
                                rgb_nxt = 12'h0_0_F; //blue = error control
                                state_nxt = IDLE ;
                                counter_nxt = '0 ;
                                shot_taken_nxt = 1'b0 ;
                                end_sh_nxt = 1'b0 ;
                            end
            endcase
            //leftovers from solo
            is_scored_nxt = 1'b0 ;
            round_done_nxt = 1'b0 ;

            //calculations
            if(keeper_pos < 255) begin
                gk_left_edge_nxt = 255 - GK_HALF_WIDTH;
                gk_right_edge_nxt = 255 + GK_HALF_WIDTH ;
            end
            else if(keeper_pos > 769) begin
                gk_left_edge_nxt = 769 - GK_HALF_WIDTH ;
                gk_right_edge_nxt = 769 + GK_HALF_WIDTH ;
            end
            else begin
                gk_left_edge_nxt = keeper_pos - GK_HALF_WIDTH ;
                gk_right_edge_nxt = keeper_pos + GK_HALF_WIDTH ;
            end

        end
    endcase
 end

 endmodule