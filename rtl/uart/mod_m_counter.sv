// Listing 4.11
module mod_m_counter
   #(
    parameter N=4, // number of bits in counter
              M=10 // mod-M
   )
   (
    input wire clk, reset,
    output logic max_tick,
    output logic [N-1:0] q
   );

   //signal declaration
   reg [N-1:0] r_reg;
   wire [N-1:0] r_next;

   // body
   // register
   always_ff @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;

   // next-state logic
   assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;
   // output logic
   assign q = r_reg;
   assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule