`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/10 11:53:53
// Design Name: 
// Module Name: stopwatch_cu
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


module stopwatch_cu(
    input clk, reset,
    input i_btn_run,
    input i_btn_clear,
    output reg o_run, o_clear
    );

    // fsm 구조로 CU를 설계 (CU = control unit)
    parameter STOP = 2'b00, RUN = 2'b01, CLEAR = 2'b10;

    reg [1:0] state, next;

    // state register
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= STOP;
        end else begin
            state <= next;
        end
    end

    // next
    always @(*) begin
        next = state;
        case (state)
            STOP : begin
                if(i_btn_run == 1) begin
                    next = RUN;
                end else if (i_btn_clear == 1) begin
                    next = CLEAR;
                end
            end
            RUN : begin
                if(i_btn_run == 1) begin
                    next = STOP;
                end
            end
            CLEAR : begin
                if (i_btn_clear == 1) begin
                    next = STOP;
                end
            end
        endcase
    end

    //output
    always @(*) begin
        o_run = 0;
        o_clear = 0;
        case (state)
            STOP : begin
                o_run = 1'b0;
                o_clear = 1'b0;
            end 
            RUN : begin
                o_run = 1'b1;
                o_clear = 1'b0;
            end
            CLEAR : begin
                o_clear = 1'b1;
            end
        endcase
    end 
endmodule
