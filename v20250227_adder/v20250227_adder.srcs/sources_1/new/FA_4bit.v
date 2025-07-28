`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/27 17:06:19
// Design Name: 
// Module Name: FA_4bit
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


module FA_4bit (
    input [3:0] a,
    b,
    input cin,
    output [3:0] s,
    output c_out
);
    wire c1, c2, c3;


    full_adder FA1 (
        .a  (a[0]),
        .b  (b[0]),
        .cin(cin),
        .s  (s[0]),
        .c  (c1)
    );
    full_adder FA2 (
        .a  (a[1]),
        .b  (b[1]),
        .cin(c1),
        .s  (s[1]),
        .c  (c2)
    );
    full_adder FA3 (
        .a  (a[2]),
        .b  (b[2]),
        .cin(c2),
        .s  (s[2]),
        .c  (c3)
    );
    full_adder FA4 (
        .a  (a[3]),
        .b  (b[3]),
        .cin(c3),
        .s  (s[3]),
        .c  (c_out)
    );
endmodule
