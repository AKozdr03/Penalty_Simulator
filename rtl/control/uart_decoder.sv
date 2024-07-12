/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Uart decode module
 */

 module uart_decoder(
    input wire clk,
    input wire rst,
    output logic connect_corrected,
    output logic [11:0] keeper_pos
);

always_ff @(posedge clk) begin
    if(rst) begin
        connect_corrected <= 1'b0;
        keeper_pos <= 12'b0;
    end
    else begin
        connect_corrected <= 1'b0;
        keeper_pos <= 12'b0; // t.b.c.   
    end
end

  
endmodule