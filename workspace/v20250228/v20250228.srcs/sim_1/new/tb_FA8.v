`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/01 17:18:20
// Design Name: 
// Module Name: tb_FA8
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


module tb_FA8;

    reg [7:0] a,b;
    wire [7:0] sum;
    wire cout;
    // uut, dut 많이 사용
    FA_8bit uut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    integer i,j;
    initial begin
        a = 8'b0; b=8'b0;
        // i++ 베릴로그는 증감연산자가 없다.
        #10;
        for ( i=0 ;i<256 ; i = i+1) begin
            a = i;
            for ( j=0 ; j<256; j = j+1) begin
                b = j;
                #10;
            end
            #10;
        end
        #10;
        $stop;
    end
endmodule
