/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Description:
 * Keeper user rom.
 */

 module goalkeeper_rom
	#(parameter
		ADDR_WIDTH = 20,
		DATA_WIDTH = 12
	)
	(
		input wire clk, // posedge active clock
		input wire [ADDR_WIDTH - 1 : 0 ] addrA,
		output logic [DATA_WIDTH - 1 : 0 ] dout
	);

	(* rom_style = "block" *) // block || distributed

	logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0]; // rom memory

	initial
	$readmemh("../../rtl/data/keeper.dat", rom);

	always_ff @(posedge clk) begin : rom_read_blk
		dout <= rom[addrA];
	end

endmodule