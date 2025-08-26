`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/06 17:05:38
// Design Name: 
// Module Name: mealy_machine
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


module mealy_machine(
    input clk, reset,
    input in,
    output reg out
    );

    reg [2:0]  next_state, cur_state;
    parameter start=3'b000, rd0_once=3'b001, rd1_once=3'b010, rd0_twice=3'b011, rd1_twice=3'b100;

    always @(posedge clk, posedge reset) begin
        if(reset)
            cur_state <=start;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        case (cur_state)
            start : if(in == 0) begin
                        next_state = rd0_once;
                        out = 0;
                    end
                    else if(in == 1) begin
                        next_state = rd1_once;
                        out = 0;
                    end
            rd0_once : if (in == 0) begin
                        next_state = rd0_twice;
                        out = 1;
                    end
                    else if(in == 1) begin
                        next_state = rd1_once;
                        out = 0;
                    end 
            rd0_twice : if (in == 0) begin
                        next_state = rd0_twice;
                        out = 1;
                    end
                    else if (in == 1) begin
                        next_state = rd1_once;
                        out = 0;
                    end 
            rd1_once : if (in == 0) begin
                        next_state = rd0_once;
                        out = 0;
                    end
                    else if (in == 1) begin
                        next_state = rd1_twice;
                        out = 1;
                    end 
            rd1_twice : if (in == 0) begin
                        next_state = rd0_once;
                        out = 0;
                    end
                    else if (in == 1) begin
                        next_state = rd1_twice;
                        out = 1;
                    end 
            default: begin
                next_state = cur_state;
                out = 0;
            end
        endcase
        
    end
endmodule
