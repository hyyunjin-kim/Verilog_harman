`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/07 16:07:08
// Design Name: 
// Module Name: tb_stopwatch
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


module tb_stopwatch();
    reg clk, reset, w_clear, w_tick_100hz;
    wire [$clog2(10000)-1:0] count_value;
    wire w_tick_msec;

    counter_tick dut(.clk(clk), .reset(reset), .clear(w_clear),
                     .tick(w_tick_100hz), .counter(count_value),.o_tick(w_tick_msec));

    always #5 clk = ~clk;
    integer i;
    initial begin
        clk=0; reset=1; w_clear=0; w_tick_100hz=0;
        #10 reset = 0;

        for (i =0 ;i<250 ;i=i+1 ) begin
            #10 w_tick_100hz = 1'b1;
            #10 w_tick_100hz = 1'b0;
        end
        #10 $stop;
    end
endmodule
