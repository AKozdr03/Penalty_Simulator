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
    input wire tx_full,
    input wire [2:0] op_code_data,
    

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
 typedef enum bit [1:0] {WAIT, READY, SEND} uart_machine;
 uart_machine uart_state, uart_state_nxt ;
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
 logic update_tick, update_tick_nxt;
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
        update_tick <= '0;
        uart_state <= WAIT ;
    end
    else begin
        data_to_transmit <= data_to_transmit_nxt;
        pos_update <= pos_update_nxt;
        uart_state <= uart_state_nxt ;
        update_tick <= update_tick_nxt;
    end
end

always_comb begin // it is stable for 1s so can be transmitted in 4 ticks I believe
    if(!tx_full && uart_state == READY)
        uart_state_nxt = SEND ;
    else if(tx_full && uart_state == WAIT)
        uart_state_nxt = READY ;
    else 
        uart_state_nxt = uart_state ;

    if((tx_full == 0) && (op_code_data == 3'b000)) begin 
        update_tick_nxt = 1'b1;
    end
    else begin
        update_tick_nxt = 1'b0;
    end
    
    if(update_tick) begin
        update_tick_nxt = 1'b0;
    end
    else begin
        update_tick_nxt = update_tick;
    end

    if(uart_state == SEND) begin
        if(pos_update == 2'b00) begin
            data_to_transmit_nxt = {shot_xpos[4:0], 3'b011};
            if(update_tick == 1'b1) begin
                pos_update_nxt = 2'b01;
            end
            else begin
                pos_update_nxt = 2'b00;
            end
        end
        else if(pos_update == 2'b01)  begin
            data_to_transmit_nxt = {shot_xpos[9:5], 3'b100};
            if(update_tick == 1'b1) begin
                pos_update_nxt = 2'b10;
            end
            else begin
                pos_update_nxt = 2'b01;
            end
        end
        else if(pos_update == 2'b10)  begin
            data_to_transmit_nxt = {shot_ypos[9:5], 3'b101};
            if(update_tick == 1'b1) begin
                pos_update_nxt = 2'b11;
            end
            else begin
                pos_update_nxt = 2'b10;
            end
        end
        else if(pos_update == 2'b11) begin
            data_to_transmit_nxt = {shot_ypos[9:5], 3'b110};
            if(update_tick == 1'b1) begin
                pos_update_nxt = 2'b00;
            end
            else begin
                pos_update_nxt = 2'b11;
            end    
        end
        else begin
            data_to_transmit_nxt = data_to_transmit;
            pos_update_nxt = pos_update;
        end
        uart_state_nxt = WAIT ;
    end
    else begin
        if(!tx_full && uart_state == READY)
            uart_state_nxt = SEND ;
        else if(tx_full && uart_state == WAIT)
            uart_state_nxt = READY ;
        else 
            uart_state_nxt = uart_state ;
            
        data_to_transmit_nxt = data_to_transmit;
        pos_update_nxt = pos_update;
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
                                end_gk_nxt = 1'b0;
                                round_done_nxt = 1'b0 ;
                            end

                RESULT:     begin //calculating result
                                if(xpos >= shot_xpos && xpos <= (shot_xpos + CROSS_WIDTH)
                                && ypos >= shot_ypos && ypos <= (shot_ypos + CROSS_WIDTH) ) begin
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