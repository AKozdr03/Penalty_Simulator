/**
 * 2024  AGH University of Science and Technology
 * MTM UEC2
 * Aron Lampart, Andrzej Kozdrowski
 *
 * Description:
 * The uart top module.
 */

 module top_uart(
    input wire clk,
    input wire rst,
    input wire tx_full,
    input wire [7:0] data_mouse_control,
    input wire [7:0] data_game_state_sel,
    input wire [7:0] data_gloves_control,
    input wire [7:0] data_score_control,
    
    output logic wr_uart,
    output logic [7:0] w_data
 );

 //local variables
logic [7:0] w_data_nxt;
logic [1:0] module_counter, module_counter_nxt;
logic wr_uart_nxt;

 //logic

 always_ff @(posedge clk) begin
    if(rst) begin
        w_data <= '0;
        module_counter <= '0;
        wr_uart <= '0;
    end
    else begin
        w_data <= w_data_nxt;
        module_counter <= module_counter_nxt;
        wr_uart <= wr_uart_nxt;
    end
 end

 /*
 * CODES FOR MODULES
 * 00 - game_state_sel
 * 01 - gloves_control
 * 10 - score_control
 * 11 - mouse_control
 */

 always_comb begin
    if(tx_full == 1'b0) begin
        case(module_counter)
            2'b00: begin
                w_data_nxt = data_game_state_sel;
            end
            2'b01: begin
                w_data_nxt = data_gloves_control;
            end
            2'b10: begin
                w_data_nxt = data_score_control;
            end
            2'b11: begin
                w_data_nxt = data_mouse_control;
            end
        endcase
        
        module_counter_nxt = module_counter + 1;

        if(wr_uart) begin
            wr_uart_nxt = 1'b0;
        end
        else begin
            wr_uart_nxt = 1'b1;
        end
    end
    else begin
        wr_uart_nxt = 1'b0;
        w_data_nxt = w_data;
        module_counter_nxt = module_counter;
    end

 end
 endmodule