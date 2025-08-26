`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/05 16:22:18
// Design Name: 
// Module Name: fsm_five_state
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fsm_five_state( 
    input clk, reset,
    input [2:0] sw,
    output reg [2:0] led
);
    parameter [2:0] IDLE = 3'b000, st1 = 3'b001, st2 = 3'b010, st3 = 3'b100, st4 = 3'b111;
    //상태관리, next, 출력
    reg [2:0] state, next;
    always @(posedge clk, posedge reset) begin
       if (reset) begin
            state <= IDLE;
       end 
       else begin
            state <= next;
       end
    end

    always @(*) begin
        case (state)
            IDLE : if (sw == 3'b001) begin
                        next = st1;
                    end
                    else if (sw == 3'b010) begin
                        next = st2;
                    end  
            st1 : if (sw == 3'b010) begin
                        next = st2;
                    end
            st2 : if (sw == 3'b100) begin
                        next = st3;
                    end
            st3 : if (sw == 3'b111) begin
                        next = st4;
                    end
                    else if (sw == 3'b001) begin
                        next = st1;
                    end
                    else if (sw == 3'b000) begin
                        next = IDLE;
                    end
            st4 : if (sw == 3'b100) begin
                        next = st3;
                    end
            default: next = state;
        endcase
    end

    always @(*) begin
        case (next)
            IDLE: led=3'b000;
            st1 : led=3'b001;
            st2 : led=3'b010;
            st3 : led=3'b100;
            st4 : led=3'b111;     
            default: led=3'b111;
        endcase
    end
endmodule