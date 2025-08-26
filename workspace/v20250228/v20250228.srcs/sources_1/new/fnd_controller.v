`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 14:32:33
// Design Name: 
// Module Name: fnd_controller
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


module fnd_controller(
    input [3:0] bcd,
    output [7:0] seg,
    output reg [3:0] seg_comm,
    input [1:0] BIN
    );
    //assign seg_comm = 4'b0000; // segment 0의 자리 on, seg는 anode type
    bcdtoseg U_bcdtoseg(
        .bcd(bcd),   // [3:0] sum 값
        .seg(seg)
    );

    always @(BIN) begin
        case (BIN)
           2'b00 : seg_comm = 4'b1110;
           2'b01 : seg_comm = 4'b1101;
           2'b10 : seg_comm = 4'b1011;
           2'b11 : seg_comm = 4'b0111;
            default: seg_comm = 4'b0000;
        endcase
    end
endmodule


module bcdtoseg (
    input [3:0] bcd,
    output reg [7:0] seg
);

    always @(bcd) begin
        case (bcd)
            4'h0 : seg= 8'hC0;
            4'h1 : seg= 8'hF9;
            4'h2 : seg= 8'hA4;
            4'h3 : seg= 8'hB0;
            4'h4 : seg= 8'h99;
            4'h5 : seg= 8'h92;
            4'h6 : seg= 8'h82;
            4'h7 : seg= 8'hF8;
            4'h8 : seg= 8'h80;
            4'h9 : seg= 8'h90;
            4'hA : seg= 8'h88;
            4'hB : seg= 8'h83;
            4'hC : seg= 8'hC6;
            4'hD : seg= 8'hA1;
            4'hE : seg= 8'h86;
            4'hF : seg= 8'h8E;
            default: seg =8'hff;
        endcase        
    end
    
endmodule