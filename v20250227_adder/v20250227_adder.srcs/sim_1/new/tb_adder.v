`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/27 15:21:15
// Design Name: 
// Module Name: tb_adder
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


module tb_adder;
    

    reg [3:0] a, b; 
    reg cin;         
    wire [3:0] s;     
    wire c_out;  
    
    FA_4bit FA_4bit_1(.a(a), .b(b), .cin(cin), .s(s), .c_out(c_out));
    
    initial
        begin
        #10  a=4'b0001; b=4'b0000; cin=0;
        #10  a=4'b0000; b=4'b0010; cin=0;
        #10  a=4'b0101; b=4'b1000; cin=0;
        #10  a=4'b0110; b=4'b0111; cin=0;
        
        #10  a=4'b1100; b=4'b0111; cin=0;
        #10  a=4'b0000; b=4'b0110; cin=0;
        #10  a=4'b0010; b=4'b0000; cin=0;
        #10  a=4'b1000; b=4'b1100; cin=0;
 
        end
endmodule
