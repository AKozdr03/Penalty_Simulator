/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Selectable screen rom.
 */

 module screen_rom
	#(parameter
		ADDR_WIDTH = 20,
		DATA_WIDTH = 12
	)
	(
		input wire clk, // posedge active clock
		input wire [ADDR_WIDTH - 1 : 0 ] addrA,
        input logic [2:0] game_state,

		output logic [DATA_WIDTH - 1 : 0 ] dout
	);

    import game_pkg::*;

	(* rom_style = "block" *) // block || distributed

	logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0]; // rom memory

	initial begin
        case(game_state)
            START: $readmemh("../../rtl/data/start_screen.dat", rom);
            KEEPER: $readmemh("../../rtl/data/goalkeeper_screen.dat", rom);
            SHOOTER: $readmemh("../../rtl/data/shooter_screen.dat", rom);
            WINNER: $readmemh("../../rtl/data/winner_screen.dat", rom);
            LOOSER: $readmemh("../../rtl/data/lose_screen.dat", rom);
            default: $readmemh("../../rtl/data/start_screen.dat", rom);
        endcase
    end
	always_ff @(posedge clk) begin : rom_read_blk
		dout <= rom[addrA];
	end

endmodule