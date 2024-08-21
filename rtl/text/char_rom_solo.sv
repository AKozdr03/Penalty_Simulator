`timescale 1ns / 1ps
/**
 * MTM UEC2
 * Author: Andrzej Kozdrowski, Aron Lampart
 *
 * Description:
 * ROM with saved solo mode text.
 *
 */

module char_rom_solo
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
            12'h000: data = "F"; 
            12'h001: data = "O"; 
            12'h002: data = "R"; 
            12'h003: data = " "; 
            12'h004: data = "S"; 
            12'h005: data = "I"; 
            12'h006: data = "N"; 
            12'h007: data = "G"; 
            12'h008: data = "L"; 
            12'h009: data = "E"; 
            12'h00a: data = "P"; 
            12'h00b: data = "L"; 
            12'h00c: data = "A"; 
            12'h00d: data = "Y"; 
            12'h00e: data = "E"; 
            12'h00f: data = "R"; 
            12'h010: data = " "; 
            12'h011: data = "T"; 
            12'h012: data = "O"; 
            12'h013: data = "G"; 
            12'h014: data = "G"; 
            12'h015: data = "L"; 
            12'h016: data = "E"; 
            12'h017: data = " "; 
            12'h018: data = "S"; 
            12'h019: data = "W";
            12'h01a: data = "1"; 
            default: data = 7'h20; 
        endcase
    end
endmodule
