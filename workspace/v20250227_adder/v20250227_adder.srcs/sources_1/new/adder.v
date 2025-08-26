`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/27 15:10:14
// Design Name: 
// Module Name: adder
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

// 1bit FA
module full_adder(
    input a, b, cin,
    output s,c
    );
    wire s1, c1, c2;
    
   half_adder half_adder1(.a(a), .b(b), .s(s1), .c(c1));
   half_adder half_adder2(.a(cin), .b(s1), .s(s), .c(c2));
   assign c = c1 | c2;
endmodule
   
module half_adder(
    input a, b,
    output s, c
    );
    
    // half adder code
    assign s = a ^ b;
    assign c = a & b;
endmodule
