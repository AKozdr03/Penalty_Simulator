/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Gloves controller.
 */

 module gloves_control(
    input wire clk,
    input wire rst,
    input logic [11:0] xpos,
    input logic [11:0] ypos,
    input g_state game_state,
    input g_mode game_mode,
    input logic [9:0] shot_xpos,
    input logic [9:0] shot_ypos,
    input logic enemy_input, //msb of uart with 111 opcode, informs that enemy has ended the round
    

    output logic is_scored,
    output logic round_done,
    output logic end_gk,

    vga_if.in in,   
    vga_if.out out
 );

 import game_pkg::*;

 //params

 localparam CROSS_WIDTH = 100 ;
//variables

 //For 65MHz - 1tick = 15.38ns
 //for 1s - 65 019 506 ticks
 
 logic [25:0] counter, counter_nxt;

 typedef enum bit [2:0] {IDLE, ENGAGE, COUNTDOWN, RESULT, GOAL, MISS, TERMINATE} glove_state;
 glove_state state, state_nxt ;

 logic [11:0] rgb_nxt;
 logic is_scored_nxt;
 logic round_done_nxt;
 logic end_gk_nxt ;
 
 logic [10:0] hcount_d, vcount_d;
 logic hblnk_d, vblnk_d, hsync_d, vsync_d;

 
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
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;

        is_scored <= '0 ;
        round_done <= '0;

        state <= IDLE;
        counter <= '0;
        end_gk <= '0;
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
        round_done <= round_done_nxt;
        
        state <= state_nxt;
        counter <= counter_nxt ;
        end_gk <= end_gk_nxt;
    end
 end

 

 always_comb begin
    case(game_mode)
        SOLO: begin
            case(state)
                IDLE:       begin
                                if(game_state == KEEPER)
                                    state_nxt = ENGAGE ;
                                else
                                    state_nxt = IDLE ;

                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                            end

                ENGAGE:      begin
                                if(game_state == KEEPER) begin
                                    if(counter == 65019506) begin
                                        state_nxt = COUNTDOWN ;
                                        counter_nxt = '0 ;
                                    end
                                    else begin
                                        state_nxt = ENGAGE ;
                                        counter_nxt = counter + 1 ;
                                    end
                                end
                                else begin
                                    state_nxt = IDLE ;
                                    counter_nxt = '0 ;
                                end
                                rgb_nxt = in.rgb ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                            end

                COUNTDOWN:  begin
                                if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'h0_0_F;
                                else 
                                    rgb_nxt = in.rgb;
                                
                                if(counter == 65019506) begin
                                    state_nxt = RESULT ;
                                    counter_nxt = '0;
                                end
                                else begin
                                    state_nxt = COUNTDOWN ;
                                    counter_nxt = counter + 1 ;
                                end

                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                            end

                RESULT:     begin
                                if(xpos >= shot_xpos && xpos <= (shot_xpos + CROSS_WIDTH)
                                && ypos >= shot_ypos && ypos <= (shot_ypos + CROSS_WIDTH) ) begin
                                    state_nxt = MISS ;
                                end
                                else begin
                                    state_nxt = GOAL ; 
                                end                     
                                rgb_nxt = in.rgb ;
                                round_done_nxt = 1'b0 ;
                                is_scored_nxt = 1'b0 ;
                                counter_nxt = '0 ;
                                end_gk_nxt = 1'b0;

                            end
                GOAL:       begin
                                if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'hF_0_0;
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
                                end_gk_nxt = 1'b0;
                            end
                
                MISS:       begin
                                if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'h0_F_0;
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
                                end_gk_nxt = 1'b0;
                            end
                TERMINATE:  begin
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                counter_nxt = '0 ;
                                state_nxt = IDLE ;
                                rgb_nxt = in.rgb;
                                end_gk_nxt = 1'b1;
                            end

                default:    begin
                                rgb_nxt = 12'h0_0_F; //blue = error control
                                state_nxt = IDLE ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                            end
            endcase
        end
        MULTI: begin
            case(state)
                IDLE:       begin
                                if(game_state == KEEPER)
                                    state_nxt = ENGAGE ;
                                else
                                    state_nxt = IDLE ;

                                rgb_nxt = in.rgb ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                                round_done_nxt = 1'b0 ;
                            end

                ENGAGE:      begin //waiting for shot to be made
                                if(game_state == KEEPER) begin
                                    if(enemy_input) begin
                                        state_nxt = COUNTDOWN ;
                                    end
                                    else begin
                                        state_nxt = ENGAGE ;
                                    end
                                end
                                else begin
                                    state_nxt = IDLE ;
                                end
                                rgb_nxt = in.rgb ;
                                is_scored_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                                counter_nxt = '0 ;
                                round_done_nxt = 1'b0 ;
                            end

                COUNTDOWN:  begin //time to react
                                // if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                // && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                //     rgb_nxt = 12'h0_0_F;
                                // else 
                                //     rgb_nxt = in.rgb;

                                if(in.hcount >= 200 && in.hcount <= (200 + CROSS_WIDTH)
                                && in.vcount >= 300 && in.vcount <= (300 + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'h0_0_F;
                                else 
                                    rgb_nxt = in.rgb;
                                
                                if(counter == 65019506) begin
                                    state_nxt = RESULT ;
                                    counter_nxt = '0;
                                end
                                else begin
                                    state_nxt = COUNTDOWN ;
                                    counter_nxt = counter + 1 ;
                                end

                                is_scored_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                                round_done_nxt = 1'b0 ;
                            end

                RESULT:     begin //calculating result
                                // if(xpos >= shot_xpos && xpos <= (shot_xpos + CROSS_WIDTH)
                                // && ypos >= shot_ypos && ypos <= (shot_ypos + CROSS_WIDTH) ) begin
                                //     state_nxt = MISS ;
                                // end
                                // else begin
                                //     state_nxt = GOAL ; 
                                // end   
                                if(xpos >= 200 && xpos <= (200 + CROSS_WIDTH)
                                && ypos >= 300 && ypos <= (300 + CROSS_WIDTH) ) begin
                                    state_nxt = MISS ;
                                end
                                else begin
                                    state_nxt = GOAL ; 
                                end                   
                                rgb_nxt = in.rgb ;
                                is_scored_nxt = 1'b0 ;
                                counter_nxt = '0 ;
                                end_gk_nxt = 1'b0;
                                round_done_nxt = 1'b0 ;

                            end
                GOAL:       begin
                                if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'hF_0_0;
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

                                is_scored_nxt = 1'b1;
                                round_done_nxt = 1'b1 ;
                                end_gk_nxt = 1'b0;
                                
                            end
                
                MISS:       begin
                                if(in.hcount >= shot_xpos && in.hcount <= (shot_xpos + CROSS_WIDTH)
                                && in.vcount >= shot_ypos && in.vcount <= (shot_ypos + CROSS_WIDTH) ) 
                                    rgb_nxt = 12'h0_F_0;
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

                                is_scored_nxt = 1'b0;
                                round_done_nxt = 1'b1 ;
                                end_gk_nxt = 1'b0;
                            end
                TERMINATE:  begin
                                if(counter == 13003901) begin
                                    state_nxt = IDLE ;
                                    counter_nxt = '0;
                                    end_gk_nxt = 1'b1;
                                end
                                else begin
                                    state_nxt = TERMINATE ;
                                    counter_nxt = counter + 1 ;
                                    end_gk_nxt = 1'b0 ;
                                end
                                is_scored_nxt = 1'b0 ;
                                round_done_nxt = 1'b0 ;
                                rgb_nxt = in.rgb;
                            end

                default:    begin
                                rgb_nxt = 12'h0_0_F; //blue = error control
                                state_nxt = IDLE ;
                                counter_nxt = '0 ;
                                is_scored_nxt = 1'b0 ;
                                end_gk_nxt = 1'b0;
                                round_done_nxt = 1'b0 ;
                            end
            endcase
        end
    endcase
 end

 endmodule