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
    input logic [9:0] shot_xpos,
    input logic [9:0] shot_ypos,

    output logic is_scored,
    output logic round_done,
    output logic [7:0] data_to_transmit, // shot_pos
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

 logic [7:0] data_to_transmit_nxt;
 logic [1:0] pos_update, pos_update_nxt;
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

 always_ff @(posedge clk) begin : data_transmision
    if(rst) begin
        data_to_transmit <= 8'b00000000;
        pos_update <= '0;
    end
    else begin
        data_to_transmit <= data_to_transmit_nxt;
        pos_update <= pos_update_nxt;
    end
end

always_comb begin // it is stable for 1s so can be transmitted in 4 ticks I believe
    if(pos_update == 2'b00) begin
        data_to_transmit_nxt = {shot_xpos[4:0], 3'b001};
        pos_update_nxt = 2'b01;
    end
    else if(pos_update == 2'b01)  begin
        data_to_transmit_nxt = {shot_xpos[9:5], 3'b010};
        pos_update_nxt = 2'b10;
    end
    else if(pos_update == 2'b10)  begin
        data_to_transmit_nxt = {shot_ypos[9:5], 3'b101};
        pos_update_nxt = 2'b11;
    end
    else if(pos_update == 2'b11) begin
        data_to_transmit_nxt = {shot_ypos[9:5], 3'b110};
        pos_update_nxt = 2'b00;      
    end
    else begin
        data_to_transmit_nxt = data_to_transmit;
        pos_update_nxt = pos_update;
    end

end

 always_comb begin
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

 endmodule