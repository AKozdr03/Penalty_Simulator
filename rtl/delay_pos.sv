/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Delay mouse to display
 */


 module delay_pos(
    input wire clk,
    input wire rst,
    input logic [11:0] xpos_in,
    input logic [11:0] ypos_in,  
    output logic [11:0] xpos_out,
    output logic [11:0] ypos_out  
 );

 always_ff @(posedge clk) begin
    if(rst) begin
    xpos_out <= '0;
    ypos_out <= '0;
    end
    else begin
    xpos_out <= xpos_in;
    ypos_out <= ypos_in;
    end
 end




 endmodule
