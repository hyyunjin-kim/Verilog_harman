`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/04 15:41:59
// Design Name: 
// Module Name: counter_9999
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
module top_counter_9999 (
    input clk,
    input reset,
    output [7:0] seg,
    output [3:0] seg_comm
);
    wire [13:0] count_value;
    wire w_slow_clk;

    counter_9999 cnt99(.clk(w_slow_clk), .reset(reset), .count(count_value));
    fnd_controller fc1(.clk(clk), .reset(reset), . bcd(count_value), .seg(seg), .seg_comm(seg_comm));
    clk_divider_slow cds1(.clk(clk), .reset(reset), .slow_clk(w_slow_clk));
endmodule


module counter_9999(
    input clk,
    input reset,
    output reg [13:0] count
    );
    reg clk_out_reg;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            count <= 0;
        end
        else begin
            if (count == 9999) begin
                count <= 0;
        //        clk_out_reg <= ~clk_out_reg;
            end
            else begin
                count <= count + 1;
            end
        end
    end

   // assign count = clk_out_reg;
endmodule

module clk_divider_slow (
    input clk, reset,
    output reg slow_clk
);
    reg [23:0] counter;  // 클럭을 나누기 위한 카운터 (24비트: 약 1Hz 생성 가능)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end else begin
            if (counter == 5_000_000) begin // 100MHz / 5M = 10Hz (0.1초마다 1번)
                counter <= 0;
                slow_clk <= ~slow_clk;  // 토글하여 반주기 사용
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
