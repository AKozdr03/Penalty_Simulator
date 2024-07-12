`timescale 1ns / 1ps
/**
 * MTM UEC2
 * Author: Aron Lampart
 *
 * Description:
 * ROM with saved text.
 * Zeberka, boczek, wolowina, cielecina, karkowka, schab, rożne gatunki wędlin, a takze dziczyzna. 
 * Do bigosu mozna dodac tez wiele innych skladnikow!
 */

module char_rom_16x16
    (
        input  logic        clk,
        input  logic  [7:0] char_xy,         
        output logic  [6:0] char_code // pixels of the character line
    );

    // signal declaration
    logic [6:0] data;

    // body
    always_ff @(posedge clk)
        char_code <= data ;
    always_comb begin
        case(char_xy)
            8'h00: data = "Z"; 
            8'h01: data = "e"; 
            8'h02: data = "b"; 
            8'h03: data = "e"; 
            8'h04: data = "r"; 
            8'h05: data = "k"; 
            8'h06: data = "a"; 
            8'h07: data = ","; 
            8'h08: data = "b"; 
            8'h09: data = "o"; 
            8'h0a: data = "c"; 
            8'h0b: data = "z"; 
            8'h0c: data = "e"; 
            8'h0d: data = "k"; 
            8'h0e: data = ""; 
            8'h0f: data = ""; 
            8'h10: data = "w"; 
            8'h11: data = "o"; 
            8'h12: data = "l"; 
            8'h13: data = "o"; 
            8'h14: data = "w"; 
            8'h15: data = "i"; 
            8'h16: data = "n"; 
            8'h17: data = "a"; 
            8'h18: data = ","; 
            8'h19: data = ""; 
            8'h1a: data = ""; 
            8'h1b: data = ""; 
            8'h1c: data = ""; 
            8'h1d: data = ""; 
            8'h1e: data = ""; 
            8'h1f: data = "";
            8'h20: data = "c";  
            8'h21: data = "i";  
            8'h22: data = "e";  
            8'h23: data = "l";  
            8'h24: data = "e";  
            8'h25: data = "c"; 
            8'h26: data = "i";  
            8'h27: data = "n";  
            8'h28: data = "a";  
            8'h29: data = ",";  
            8'h2a: data = ""; 
            8'h2b: data = ""; 
            8'h2c: data = ""; 
            8'h2d: data = ""; 
            8'h2e: data = ""; 
            8'h2f: data = ""; 
            8'h30: data = "k";  
            8'h31: data = "a";  
            8'h32: data = "r";  
            8'h33: data = "k";  
            8'h34: data = "o";  
            8'h35: data = "w";  
            8'h36: data = "k"; 
            8'h37: data = "a";  
            8'h38: data = ",";  
            8'h39: data = "s";  
            8'h3a: data = "c";  
            8'h3b: data = "h";  
            8'h3c: data = "a";  
            8'h3d: data = "b";  
            8'h3e: data = ",";  
            8'h3f: data = ""; 
            8'h40: data = "r";  
            8'h41: data = "o";  
            8'h42: data = "z";  
            8'h43: data = "n";  
            8'h44: data = "e";  
            8'h45: data = ""; 
            8'h46: data = "g";  
            8'h47: data = "a";  
            8'h48: data = "t";  
            8'h49: data = "u";  
            8'h4a: data = "n";  
            8'h4b: data = "k";  
            8'h4c: data = "i";  
            8'h4d: data = ""; 
            8'h4e: data = ""; 
            8'h4f: data = ""; 
            8'h50: data = "w";  
            8'h51: data = "e";  
            8'h52: data = "d";  
            8'h53: data = "l";  
            8'h54: data = "i";  
            8'h55: data = "n";  
            8'h56: data = ""; 
            8'h57: data = "a";  
            8'h58: data = ""; 
            8'h59: data = "t";  
            8'h5a: data = "a";  
            8'h5b: data = "k";  
            8'h5c: data = "z";  
            8'h5d: data = "e";  
            8'h5e: data = ""; 
            8'h5f: data = ""; 
            8'h60: data = "d";  
            8'h61: data = "z";  
            8'h62: data = "i";  
            8'h63: data = "c";  
            8'h64: data = "z";  
            8'h65: data = "y";  
            8'h66: data = "z";  
            8'h67: data = "n";  
            8'h68: data = "a"; 
            8'h69: data = ".";  
            8'h6a: data = ""; 
            8'h6b: data = ""; 
            8'h6c: data = ""; 
            8'h6d: data = ""; 
            8'h6e: data = ""; 
            8'h6f: data = ""; 
            8'h70: data = "D";  
            8'h71: data = "o";  
            8'h72: data = ""; 
            8'h73: data = "b";  
            8'h74: data = "i"; 
            8'h75: data = "g";  
            8'h76: data = "o";  
            8'h77: data = "s";  
            8'h78: data = "u"; 
            8'h79: data = ""; 
            8'h7a: data = "m";  
            8'h7b: data = "o";  
            8'h7c: data = "z";  
            8'h7d: data = "n";  
            8'h7e: data = "a"; 
            8'h7f: data = ""; 
            8'h80: data = "d";  
            8'h81: data = "o";  
            8'h82: data = "d";  
            8'h83: data = "a";  
            8'h84: data = "c"; 
            8'h85: data = "";
            8'h86: data = "t"; 
            8'h87: data = "e"; 
            8'h88: data = "z";
            8'h89: data = ""; 
            8'h8a: data = "w";  
            8'h8b: data = "i";  
            8'h8c: data = "e";  
            8'h8d: data = "l";  
            8'h8e: data = "e"; 
            8'h8f: data = ""; 
            8'h90: data = "i";  
            8'h91: data = "n";  
            8'h92: data = "n";  
            8'h93: data = "y";  
            8'h94: data = "c";  
            8'h95: data = "h";  
            8'h96: data = ""; 
            8'h97: data = ""; 
            8'h98: data = ""; 
            8'h99: data = ""; 
            8'h9a: data = ""; 
            8'h9b: data = ""; 
            8'h9c: data = ""; 
            8'h9d: data = ""; 
            8'h9e: data = ""; 
            8'h9f: data = ""; 
            8'ha0: data = "s";  
            8'ha1: data = "k"; 
            8'ha2: data = "l"; 
            8'ha3: data = "a"; 
            8'ha4: data = "d"; 
            8'ha5: data = "n"; 
            8'ha6: data = "i"; 
            8'ha7: data = "k"; 
            8'ha8: data = "o";
            8'ha9: data = "w"; 
            8'haa: data = "!"; 
            8'hab: data = 7'h20; // 
            8'hac: data = 7'h20; // 
            8'had: data = 7'h20; // 
            8'hae: data = 7'h20; // 
            8'haf: data = 7'h20; // 
            8'hb0: data = 7'h20; // 
            8'hb1: data = 7'h20; // 
            8'hb2: data = 7'h20; // 
            8'hb3: data = 7'h20; // 
            8'hb4: data = 7'h20; // 
            8'hb5: data = 7'h20; // 
            8'hb6: data = 7'h20; // 
            8'hb7: data = 7'h20; // 
            8'hb8: data = 7'h20; // 
            8'hb9: data = 7'h20; // 
            8'hba: data = 7'h20; // 
            8'hbb: data = 7'h20; // 
            8'hbc: data = 7'h20; // 
            8'hbd: data = 7'h20; // 
            8'hbe: data = 7'h20; // 
            8'hbf: data = 7'h20; // 
            8'hc0: data = 7'h20; // 
            8'hc1: data = 7'h20; // 
            8'hc2: data = 7'h20; // 
            8'hc3: data = 7'h20; // 
            8'hc4: data = 7'h20; // 
            8'hc5: data = 7'h20; // 
            8'hc6: data = 7'h20; // 
            8'hc7: data = 7'h20; // 
            8'hc8: data = 7'h20; // 
            8'hc9: data = 7'h20; //
            8'hca: data = 7'h20; // 
            8'hcb: data = 7'h20; // 
            8'hcc: data = 7'h20; // 
            8'hcd: data = 7'h20; // 
            8'hce: data = 7'h20; // 
            8'hcf: data = 7'h20; //
            8'hd0: data = 7'h20; // 
            8'hd1: data = 7'h20; //
            8'hd2: data = 7'h20; // 
            8'hd3: data = 7'h20; // 
            8'hd4: data = 7'h20; // 
            8'hd5: data = 7'h20; // 
            8'hd6: data = 7'h20; // 
            8'hd7: data = 7'h20; // 
            8'hd8: data = 7'h20; // 
            8'hd9: data = 7'h20; // 
            8'hda: data = 7'h20; // 
            8'hdb: data = 7'h20; // 
            8'hdc: data = 7'h20; // 
            8'hdd: data = 7'h20; // 
            8'hde: data = 7'h20; // 
            8'hdf: data = 7'h20; // 
            8'he0: data = 7'h20; // 
            8'he1: data = 7'h20; // 
            8'he2: data = 7'h20; // 
            8'he3: data = 7'h20; // 
            8'he4: data = 7'h20; // 
            8'he5: data = 7'h20; // 
            8'he6: data = 7'h20; // 
            8'he7: data = 7'h20; // 
            8'he8: data = 7'h20; // 
            8'he9: data = 7'h20; // 
            8'hea: data = 7'h20; // 
            8'heb: data = 7'h20; // 
            8'hec: data = 7'h20; // 
            8'hed: data = 7'h20; //
            8'hee: data = 7'h20; //
            8'hef: data = 7'h20; // 
            8'hf0: data = 7'h20; // 
            8'hf1: data = 7'h20; // 
            8'hf2: data = 7'h20; //
            8'hf3: data = 7'h20; // 
            8'hf4: data = 7'h20; // 
            8'hf5: data = 7'h20; // 
            8'hf6: data = 7'h20; //
            8'hf7: data = 7'h20; // 
            8'hf8: data = 7'h20; // 
            8'hf9: data = 7'h20; // 
            8'hfa: data = 7'h20; // 
            8'hfb: data = 7'h20; // 
            8'hfc: data = 7'h20; // 
            8'hfd: data = 7'h20; // 
            8'hfe: data = 7'h20; // 
            8'hff: data = 7'h20; // 
        endcase
    end
endmodule
