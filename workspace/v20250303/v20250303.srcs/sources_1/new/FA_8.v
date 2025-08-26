`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/03 20:27:20
// Design Name: 
// Module Name: FA_8
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


module FA_8bit (
    input [7:0] a,b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire carry;

    FA_4bit FA4_1(.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(sum[3:0]), .cout(carry));
    FA_4bit FA4_2(.a(a[7:4]), .b(b[7:4]), .cin(carry), .sum(sum[7:4]), .cout(cout));
endmodule


module FA_4bit (
    input [3:0] a,
    input [3:0]b,  //4bit vector형
    input cin,  // 주석했던거 주의!!
    output [3:0] sum,
    output cout
);
    wire c1, c2, c3;

    full_adder fa1(
        .a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .c(c1)
    );
    full_adder fa2(
        .a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .c(c2)
    );
    full_adder fa3(
        .a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .c(c3)
    );
    full_adder fa4(
        .a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .c(cout)
    );
endmodule

module full_adder (
    input a, b, cin,
    output sum, c
);
    wire sum1, c1, c2;
    half_adder ha1(
        .a(a), .b(b), .sum(sum1), .c(c1)
    );
    half_adder ha2(
        .a(cin), .b(sum1), .sum(sum) , .c(c2)
    );

    or(c, c1,c2);
endmodule

module half_adder (
    input a, 
    input b,
    output sum,
    output c
);

    //assign sum = a ^ b;
    //assign c = a & b;

    // 게이트 프리미티브
    xor (sum, a, b);
    and (c, a, b);
endmodule