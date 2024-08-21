`timescale 1ns / 1ps
/**
 * MTM UEC2
 * Author: Andrzej Kozdrowski, Aron Lampart
 *
 * Description:
 * ROM with saved instruction text.
 *
 */

module char_rom_end
    (
        input  logic        clk,
        input  logic  [11:0] char_xy, //org [7:0]   
        output logic  [6:0] char_code // pixels of the character line
    );

    // signal declaration
    logic [6:0] data;

    // body
    always_ff @(posedge clk)
        char_code <= data ;
    always_comb begin
        case(char_xy)
            12'h000: data = "T"; 
            12'h001: data = "O"; 
            12'h002: data = " "; 
            12'h003: data = "B"; 
            12'h004: data = "A"; 
            12'h005: data = "C"; 
            12'h006: data = "K"; 
            12'h007: data = " "; 
            12'h008: data = "T"; 
            12'h009: data = "O"; 
            12'h00a: data = " "; 
            12'h00b: data = "S"; 
            12'h00c: data = "T"; 
            12'h00d: data = "A"; 
            12'h00e: data = "R"; 
            12'h00f: data = "T"; 
            12'h010: data = " "; 
            12'h011: data = "P"; 
            12'h012: data = "R"; 
            12'h013: data = "E"; 
            12'h014: data = "S"; 
            12'h015: data = "S"; 
            12'h016: data = " "; 
            12'h017: data = "M"; 
            12'h018: data = "O"; 
            12'h019: data = "U"; 
            12'h01a: data = "S"; 
            12'h01b: data = "E"; 
            12'h01c: data = "2";           
            default: data = 7'h20; 
        endcase
    end
endmodule
