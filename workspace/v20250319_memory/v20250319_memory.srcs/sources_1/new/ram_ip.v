`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 10:51:27
// Design Name: 
// Module Name: ram_ip
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


module ram_ip #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 8)(
    input clk,
    input [ADDR_WIDTH - 1:0] waddr,
    input [DATA_WIDTH - 1:0] wdata,
    input                     wr,
    output [DATA_WIDTH -1 :0] rdata
    );
//    reg [DATA_WIDTH - 1 : 0] rdata_reg;
    reg [DATA_WIDTH - 1 : 0] ram[0 : 2**ADDR_WIDTH - 1];  // 2**4 : 2의 4승
    
    // write
    always @(posedge clk) begin
        if(wr) begin
            ram[waddr] <= wdata;
        end
    end
/*
    assign rdata = rdata_reg;
    // read
    always @(posedge clk) begin
        if(!wr) begin
            rdata_reg <= ram[waddr];
        end
    end
*/


// 조합논리 버전 read
    assign rdata = ram[waddr];
endmodule
