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
    input logic [11:0] shot_xpos,
    input logic [11:0] shot_ypos,

    vga_if.in in,   
    vga_if.out out,
    control_if.in in_control,
    control_if.out out_control
 );

 import game_pkg::*;
 //import draw_pkg::*;

 //params

 localparam BEGIN_CROSS_X = 200 ;
 localparam BEGIN_CROSS_Y = 200 ;
 localparam CROSS_WIDTH = 100 ;

//variables

 //For 65MHz - 1tick = 15.38ns
 //for 1s - 65 019 506 ticks
 logic [25:0] counter, counter_nxt;

 typedef enum bit [2:0] {IDLE, ENGAGE, COUNTDOWN, RESULT, GOAL, MISS} glove_state;
 glove_state state, state_nxt ;

 logic [11:0] rgb_nxt;
 logic is_scored_nxt;
 logic [3:0] round_counter_nxt;

 logic [2:0] score_d;
 g_mode game_mode_d;
 g_state game_state_d;
 
 logic [10:0] hcount_d, vcount_d;
 logic hblnk_d, vblnk_d, hsync_d, vsync_d;

 //delay

 delay #(
    .CLK_DEL(1),
    .WIDTH(7)
 )
 u_delay_control(
    .clk,
    .rst,
    .din({in_control.score, in_control.game_mode, in_control.game_state}),
    .dout({score_d, game_mode_d, game_state_d})
 );

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

        out_control.is_scored <= '0;
        out_control.round_counter <= '0;
        out_control.score <= '0;
        out_control.game_mode <= MULTI;
        out_control.game_state <= START;

        state <= IDLE;
        counter <= '0;
    end 
    else begin
        out.vcount <= vcount_d;
        out.vsync  <= vsync_d;
        out.vblnk  <= vblnk_d;
        out.hcount <= hcount_d;
        out.hsync  <= hsync_d;
        out.hblnk  <= hblnk_d;
        out.rgb    <= rgb_nxt;
    
        out_control.is_scored <= is_scored_nxt;
        out_control.round_counter <= round_counter_nxt;
        out_control.score <= score_d;
        out_control.game_mode <= game_mode_d;
        out_control.game_state <= game_state_d;  
        
        state <= state_nxt;
        counter <= counter_nxt ;
    end
 end

 always_comb begin
    case(state)
        IDLE:       begin
                        if(in_control.game_state == KEEPER)
                            state_nxt = ENGAGE ;
                        else
                            state_nxt = IDLE ;

                        rgb_nxt = in.rgb ;
                        counter_nxt = counter ;
                        is_scored_nxt = 1'b0 ;
                        round_counter_nxt = in_control.round_counter ;
                    end

        ENGAGE:      begin
                        counter_nxt = '0;
                        state_nxt = COUNTDOWN ;
                        rgb_nxt = in.rgb ;
                        is_scored_nxt = 1'b0 ;
                        round_counter_nxt = in_control.round_counter ;
                    end

        COUNTDOWN:  begin
                        if(in.hcount >= BEGIN_CROSS_X && in.hcount <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && in.vcount >= BEGIN_CROSS_Y && in.vcount <= (BEGIN_CROSS_Y + CROSS_WIDTH) ) 
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
                        round_counter_nxt = in_control.round_counter ;
                    end

        RESULT:     begin
                        if(xpos >= BEGIN_CROSS_X && xpos <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && ypos >= BEGIN_CROSS_Y && ypos <= (BEGIN_CROSS_Y + CROSS_WIDTH) ) begin
                            state_nxt = MISS ;
                            is_scored_nxt = 1'b0;
                        end
                        else begin
                            state_nxt = GOAL ;
                            is_scored_nxt = 1'b1;    
                        end                     
                        rgb_nxt = in.rgb ;
                        round_counter_nxt = in_control.round_counter + 1 ;
                        counter_nxt = '0 ;

                    end
        GOAL:       begin
                        if(in.hcount >= BEGIN_CROSS_X && in.hcount <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && in.vcount >= BEGIN_CROSS_Y && in.vcount <= (BEGIN_CROSS_Y + CROSS_WIDTH) ) 
                            rgb_nxt = 12'hF_0_0;
                        else 
                            rgb_nxt = in.rgb;
                        if(counter == 65019506) begin
                            state_nxt = IDLE ;
                            counter_nxt = '0;
                        end
                        else begin
                            state_nxt = GOAL ;
                            counter_nxt = counter + 1 ;
                        end

                        is_scored_nxt = 1'b1;
                        round_counter_nxt = in_control.round_counter ;

                    end
        
        MISS:       begin
                        if(in.hcount >= BEGIN_CROSS_X && in.hcount <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && in.vcount >= BEGIN_CROSS_Y && in.vcount <= (BEGIN_CROSS_Y + CROSS_WIDTH) ) 
                            rgb_nxt = 12'h0_F_0;
                        else 
                            rgb_nxt = in.rgb;
                        if(counter == 65019506) begin
                            state_nxt = IDLE ;
                            counter_nxt = '0;
                        end
                        else begin
                            state_nxt = GOAL ;
                            counter_nxt = counter + 1 ;
                        end

                        is_scored_nxt = 1'b0;
                        round_counter_nxt = in_control.round_counter ;
                    end

        default:    begin
                        rgb_nxt = 12'h0_0_F; //blue = error control
                        state_nxt = IDLE ;
                        counter_nxt = '0 ;
                        is_scored_nxt = 1'b0 ;
                        round_counter_nxt = in_control.round_counter ;
                    end
    endcase
 end

 endmodule