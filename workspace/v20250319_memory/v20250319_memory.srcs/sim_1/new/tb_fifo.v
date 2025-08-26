`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 16:38:06
// Design Name: 
// Module Name: tb_fifo
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


module tb_fifo();

    reg clk;
    reg rst;
    // write
    reg [7:0] wdata;
    reg wr;
    wire full;
    // read
    reg rd;
    wire [7:0] rdata;
    wire empty;

    fifo U_fifo (
     .clk(clk),
     .rst(rst),
    // write
     .wdata(wdata),
     .wr(wr),
     .full(full),
    // read
     .rd(rd),
     .rdata(rdata),
     .empty(empty)
    );


    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst =1;
        wdata =0;
        wr =0;
        rd =0;
        #10 ;
        rst =0;
        #10;
        wr = 1;
        wdata =8'haa;  
        #10;
        wdata =8'h55;
        #10;
        wr =0;
        rd=1;
        #20;
        $stop;
    end
endmodule
