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
 logic [25:0] counter;

 typedef enum bit [1:0] {IDLE, BEGIN, COUNTDOWN, RESULT} glove_state; //czemu begin jest czerwone? XD
 glove_state state, state_nxt ;
 g_state game_state_nxt;

 logic [11:0] rgb_nxt;

 logic is_scored_d;
logic [3:0] round_counter_d;
logic [2:0] score_d;
g_mode game_mode_d;

logic [10:0] hcount_d, vcount_d;
logic hblnk_d, vblnk_d, hsync_d, vsync_d;

 //delay

 delay #(
    .CLK_DEL(1),
    .WIDTH(9)
 )
 u_delay_control(
    .clk,
    .rst,
    .din({in_control.is_scored, in_control.round_counter, in_control.score, in_control.game_mode}),
    .dout({is_scored_d, round_counter_d, score_d, game_mode_d})
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
    end 
    else begin
        out.vcount <= vcount_d;
        out.vsync  <= vsync_d;
        out.vblnk  <= vblnk_d;
        out.hcount <= hcount_d;
        out.hsync  <= hsync_d;
        out.hblnk  <= hblnk_d;
        out.rgb    <= rgb_nxt;
    
        out_control.is_scored <= is_scored_d;
        out_control.round_counter <= round_counter_d;
        out_control.score <= score_d;
        out_control.game_mode <= game_mode_d;
        out_control.game_state <= game_state_nxt;  
        
        state <= state_nxt;
    end
 end

 always_comb begin
    case(state)
        IDLE:       begin
                        if(in_control.game_state == KEEPER)
                            state_nxt = BEGIN ;
                        else
                            state_nxt = IDLE ;

                        rgb_nxt = in.rgb ;
                    end

        BEGIN:      begin
                        //rozrusznik countdown
                        counter = '0;
                        state_nxt = COUNTDOWN ;
                        rgb_nxt = in.rgb ;
                    end

        COUNTDOWN:  begin
                        if(in.hcount >= BEGIN_CROSS_X && in.hcount <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && in.vcount >= BEGIN_CROSS_Y && in.vcount <= (BEGIN_CROSS_Y + CROSS_WIDTH) ) 
                            rgb_nxt = 12'hF_0_0;
                        else 
                            rgb_nxt = in.rgb;
                        
                        counter++ ;
                        if(counter == 65019506)
                            state = RESULT ;
                        else
                            state = COUNTDOWN ;
                        
                    end

        RESULT:     begin
                        if(xpos >= BEGIN_CROSS_X && xpos <= (BEGIN_CROSS_X + CROSS_WIDTH)
                        && ypos >= BEGIN_CROSS_Y && ypos <= (BEGIN_CROSS_Y + CROSS_WIDTH) )
                            game_state_nxt = WINNER ;
                        else
                            game_state_nxt = START ;

                        rgb_nxt = in.rgb ;
                    end

        default:    begin
                        rgb_nxt = 12'hF_0_0; //red
                        state_nxt = IDLE ;
                    end
    endcase
 end

 endmodule