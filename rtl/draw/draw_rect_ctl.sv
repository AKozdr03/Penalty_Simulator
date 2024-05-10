/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Andrzej Kozdrowski
 *
 * Description:
 * Control rectalgle drawing (falling rectangle).
 */

module draw_rect_ctl(
    input logic clk,
    input logic rst,
    input logic mouse_left,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,

    output logic [11:0] xpos,
    output logic [11:0] ypos
);
import vga_pkg ::*;


logic [11:0] x_fall;
logic [11:0] y_fall;
logic [17:0] time_inc;
logic [17:0] value;
logic mouse_prev;
logic mouse_press;


typedef enum {STAY, FALLING, FELT} state_t;

state_t rect_state;

always_ff @(posedge clk) begin
    if(rst) begin
        xpos <= '0;
        ypos <= '0;
        time_inc <= '0;
        value <= 18'd200000;
    end
    else begin
    if (rect_state == FALLING) begin
        if(time_inc == value) begin
            value <= value - 18'd250;
            time_inc <= 0;
            xpos <= x_fall;
            ypos <= y_fall;

        end
        else begin
            time_inc <= time_inc + 1;
        end
    end
    else begin
        value <= 18'd200000;
        time_inc <= 0;
        xpos <= x_fall;
        ypos <= y_fall;
    end
end
    mouse_prev <= mouse_left;

end

always_comb begin
    mouse_press = ~mouse_prev & mouse_left;
    case(rect_state)
        STAY : begin
            if ((mouse_press == 1) && (ypos != (VER_PIXELS - RECT_WIDTH))) begin
                rect_state = FALLING;
            end
            else begin
                rect_state = STAY;
            end
            x_fall = mouse_xpos;
            y_fall = mouse_ypos;
        end
        FALLING : begin
            if(ypos == (VER_PIXELS - RECT_WIDTH)) begin
                rect_state = FELT;
            end
            else begin
                rect_state = FALLING;
            end
            x_fall = xpos;
            y_fall = ypos + 1;
        end
        FELT : begin
            if (mouse_press == 1) begin
                rect_state = STAY;
            end
            else begin
                rect_state = FELT;
            end
            x_fall = xpos;
            y_fall = ypos;
        end
        default : begin
            x_fall = mouse_xpos;
            y_fall = mouse_ypos;
        end

    endcase

end

endmodule