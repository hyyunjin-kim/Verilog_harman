`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/10 11:47:32
// Design Name: 
// Module Name: top_stopwatch
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


module top_stopwatch(
    input clk, reset, btn_run, btn_clear,
    output [3:0] fnd_comm,
    output [7:0] fnd_font
    );
    wire w_run, w_clear;
    wire [6:0]msec, sec, min, hour;

    stopwacth_dp U_stopwatch_dp1(
    .clk(clk), .reset(reset), .run(w_run), .clear(w_clear), .msec(msec), .sec(sec), .min(min), .hour(hour)
    );

    stopwatch_cu U_stopwatch_cu1(
    .clk(clk), .reset(reset), .i_btn_run(btn_run), .i_btn_clear(btn_clear), .o_run(w_run), .o_clear(w_clear)
    );

    fnd_controller U_fnd_ctrl1(
        .clk(clk), .reset(reset), .msec(msec), .sec(sec), .min(min), .hour(hour), .fnd_font(fnd_font), .fnd_comm(fnd_comm)
    );
endmodule
