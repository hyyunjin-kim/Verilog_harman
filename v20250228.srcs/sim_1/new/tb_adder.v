`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 12:31:10
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

    reg [3:0] a,b;
    wire [3:0] sum;
    wire cout;
    // uut, dut 많이 사용
    FA_4bit uut (
        .a(a), .b(b), .sum(sum), .cout(cout)
    );

    integer i;
    initial begin
        a = 4'b0; b=4'b0;
        // i++ 베릴로그는 증감연산자가 없다.
        #10;
        for ( i=0 ;i<16 ; i = i+1) begin
            a = i;
            #10;
        end
        #10;
        $stop;
    end
endmodule
