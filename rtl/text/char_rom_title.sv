`timescale 1ns / 1ps
/**
 * MTM UEC2
 * Author: Andrzej Kozdrowski, Aron Lampart
 *
 * Description:
 * ROM with saved title text.
 *
 */

module char_rom_title
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
            12'h000: data = "P"; 
            12'h001: data = "E"; 
            12'h002: data = "N"; 
            12'h003: data = "A"; 
            12'h004: data = "L"; 
            12'h005: data = "T"; 
            12'h006: data = "Y"; 
            12'h007: data = " "; 
            12'h008: data = "S"; 
            12'h009: data = "I"; 
            12'h00a: data = "M"; 
            12'h00b: data = "U"; 
            12'h00c: data = "L"; 
            12'h00d: data = "A"; 
            12'h00e: data = "T"; 
            12'h00f: data = "O"; 
            12'h010: data = "R"; 
            default: data = 7'h20; 
        endcase
    end
endmodule
