`timescale 1ns / 1ps
/**
 * MTM UEC2
 * Author: Andrzej Kozdrowski, Aron Lampart
 *
 * Description:
 * ROM with saved text.
 */

module char_rom_score
    (
        input  logic        clk,
        input  logic  [11:0] char_xy, //org [7:0] 
        input logic [2:0] score_player,
        input logic [2:0] score_enemy,
        output logic  [6:0] char_code // pixels of the character line
    );

    // signal declaration
    logic [6:0] data;

    // body
    always_ff @(posedge clk)
        char_code <= data ;
    always_comb begin
        case(char_xy)
            12'h000:    begin
                            case(score_player)
                                3'd0: data = "0"; 
                                3'd1: data = "1";
                                3'd2: data = "2";
                                3'd3: data = "3";
                                3'd4: data = "4";
                                3'd5: data = "5";
                                default: data = "X";
                            endcase
                        end
            12'h001:    data = ":"; 
            12'h002:    begin
                            case(score_enemy)
                                3'd0: data = "0"; 
                                3'd1: data = "1";
                                3'd2: data = "2";
                                3'd3: data = "3";
                                3'd4: data = "4";
                                3'd5: data = "5";
                                default: data = "X";
                            endcase
                        end
                        
            default: data = 7'h20; 
        endcase
    end
endmodule
