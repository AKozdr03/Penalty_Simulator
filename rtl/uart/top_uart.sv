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
    input wire [7:0] data_shoot_control,
    input wire [7:0] data_score_control,
    
    output logic wr_uart,
    output logic [7:0] w_data
 );

 //local variables
logic [7:0] w_data_nxt;
logic [1:0] module_counter, module_counter_nxt;
logic wr_uart_nxt;
logic tx_tick, tx_tick_nxt;

 //logic

 always_ff @(posedge clk) begin
    if(rst) begin
        w_data <= '0;
        module_counter <= '0;
        wr_uart <= '0;
        tx_tick <= 1'b1;
    end
    else begin
        w_data <= w_data_nxt;
        module_counter <= module_counter_nxt;
        wr_uart <= wr_uart_nxt;
        tx_tick <= tx_tick_nxt;
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
                w_data_nxt = data_game_state_sel; //000
            end
            2'b01: begin
                w_data_nxt = data_shoot_control; //011, 100, 101, 110 
            end
            2'b10: begin
                w_data_nxt = data_score_control; //111
            end
            2'b11: begin
                w_data_nxt = data_mouse_control; //001, 010
            end
            default: begin
                w_data_nxt = data_game_state_sel;
            end
        endcase

        if(tx_tick) begin
            module_counter_nxt = module_counter + 1;
            tx_tick_nxt = 1'b0;
        end
        else begin
            module_counter_nxt = module_counter;
            tx_tick_nxt = 1'b0;
        end
        
        if(wr_uart) begin
            wr_uart_nxt = 1'b0;
        end
        else begin
            wr_uart_nxt = 1'b1;
        end
    end
    else begin
        wr_uart_nxt = 1'b0;
        tx_tick_nxt = 1'b1;
        w_data_nxt = w_data;
        module_counter_nxt = module_counter;
    end

 end
 endmodule