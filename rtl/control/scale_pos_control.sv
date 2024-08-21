/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Scaling shot position controller.
 */

 module scale_pos_control(
    input wire clk, rst,
    input wire [9:0] shot_xpos, shot_ypos,

    output logic [9:0] scaled_shot_xpos, scaled_shot_ypos
 );

 // local variables
 logic [9:0] scaled_shot_xpos_nxt, scaled_shot_ypos_nxt;

 //logic
 always_ff @(posedge clk) begin : data_passed_through
    if(rst) begin
        scaled_shot_xpos <= '0;
        scaled_shot_ypos <= '0;
    end
    else begin
        scaled_shot_xpos <= scaled_shot_xpos_nxt;
        scaled_shot_ypos <= scaled_shot_ypos_nxt;
    end
 end

 always_comb begin : scaling_position_controller
    // scaling shot_x_pos
    if((shot_xpos >= 155) && (shot_xpos < 255)) begin
        scaled_shot_xpos_nxt = shot_xpos - 120;  
    end
    else if((shot_xpos >= 255) && (shot_xpos < 355)) begin
        scaled_shot_xpos_nxt = shot_xpos - 100;
    end
    
    else if((shot_xpos >= 669) && (shot_xpos < 769)) begin
        scaled_shot_xpos_nxt = shot_xpos;
    end
    else if((shot_xpos >= 769) && (shot_xpos < 869)) begin
        scaled_shot_xpos_nxt = shot_xpos + 20 ;
    end   

    else if((shot_xpos <= 155)) begin
        scaled_shot_xpos_nxt = '0;     
    end
    else if((shot_xpos >= 869)) begin
        scaled_shot_xpos_nxt = 10'd1000;    
    end
    else begin
        scaled_shot_xpos_nxt = shot_xpos - 50;
    end

    // scaling shot_y_pos

    if((shot_ypos > 195) && (shot_ypos <= 300)) begin
        scaled_shot_ypos_nxt = shot_ypos - 85;  
    end
    else if((shot_ypos >= 450) && (shot_ypos < 510)) begin
        scaled_shot_ypos_nxt = shot_ypos + 40;
    end
    else if((shot_ypos >= 510) && (shot_ypos < 550)) begin
        scaled_shot_ypos_nxt = 550;
    end

    else if(shot_ypos >= 550) begin
        scaled_shot_ypos_nxt = 10'd738;
    end
    else if(shot_ypos <= 195) begin
        scaled_shot_ypos_nxt = 10'd0;
    end
    else begin
        scaled_shot_ypos_nxt = shot_ypos;
    end
 end

 endmodule