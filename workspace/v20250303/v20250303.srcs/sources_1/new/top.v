`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/03 20:30:36
// Design Name: 
// Module Name: top
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


module top (
    input [7:0] a,b,
    input clk_100MHz,
    output [3:0] seg_comm,
    output [7:0] seg
   // output [3:0] led
);
    wire [7:0] w_sum;
    wire w_cout;

    FA_8bit FA8 (.a(a), .b(b), .cin(1'b0), .sum(w_sum), .cout(w_cout));
    fnd_controller fc(.sum(w_sum), .cout(w_cout), .clk_100MHz(clk_100MHz), .seg_comm(seg_comm), .seg(seg));
    
endmodule

