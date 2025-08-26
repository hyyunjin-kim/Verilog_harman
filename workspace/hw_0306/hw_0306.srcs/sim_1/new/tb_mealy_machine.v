`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/06 18:18:11
// Design Name: 
// Module Name: tb_mealy_machine
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


module tb_mealy_machine();
    reg clk, reset;
    reg in;
    wire out;

mealy_machine uut(.clk(clk), .reset(reset), .in(in), .out(out));

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    #10
    reset = 0;
    #10
    in=1;
    #10
    in=1;
    #10
    in=0;
    #10
    in=0;
    #10
    in=1;
    #10
    in=0;
    #10
    $stop;
end
endmodule


