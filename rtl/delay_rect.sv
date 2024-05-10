/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Delay rect to display
 */


 module delay_rect(
    input  logic clk,
    input  logic rst,

    vga_if.in in,
    
    output logic [10:0] vcount,
    output logic vsync,
    output logic vblnk,
    output logic [10:0] hcount,
    output logic hsync,
    output logic hblnk
 );

 logic [10:0] vcount_d1;
 logic [10:0] hcount_d1;
 logic hsync_d1;
 logic vsync_d1;
 logic vblnk_d1;
 logic hblnk_d1;



 always_ff @(posedge clk) begin 
    if(rst) begin
        vcount <= '0;
        vsync <= '0;
        vblnk <= '0;
        hcount <= '0;
        hsync <= '0;
        hblnk <= '0;

        vcount_d1 <= '0;
        vsync_d1 <= '0;
        vblnk_d1 <= '0;
        hcount_d1 <= '0;
        hsync_d1 <= '0;
        hblnk_d1 <= '0;
    end
    else begin

        vcount_d1 <= in.vcount;
        vsync_d1 <= in.vsync;
        vblnk_d1 <= in.vblnk;
        hcount_d1 <= in.hcount;
        hsync_d1 <= in.hsync;
        hblnk_d1 <= in.hblnk;


        vcount <= vcount_d1;
        vsync <= vsync_d1;
        vblnk <= vblnk_d1;
        hcount <= hcount_d1;
        hsync <= hsync_d1;
        hblnk <= hblnk_d1;
    end
end



 endmodule
