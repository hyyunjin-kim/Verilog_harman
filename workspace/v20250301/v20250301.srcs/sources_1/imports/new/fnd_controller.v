`timescale 1ns / 1ps


module fnd_controller (
    input  [7:0] sum,
    input cout,
    input clk_100MHz,
    output reg [3:0] seg_comm,
    output reg [7:0] seg
    
    //input [1:0] BIN
);
    //assign seg_comm = 4'b0000;  // segment 0의 자리 on, seg는 anode type

    reg [1:0] digit_select;
    reg [19:0] digit_timer;

    always @(posedge clk_100MHz) begin
        if(digit_timer == 1_000_000) begin
            digit_timer <= 0;
            digit_select <= digit_select + 1;
        end
        else
            digit_timer <= digit_timer + 1; 
    end

    always @(digit_select) begin
        case (digit_select)
            2'b00:   seg_comm = 4'b1110;
            2'b01:   seg_comm = 4'b1101;
            2'b10:   seg_comm = 4'b1011;
            2'b11:   seg_comm = 4'b0111;
            default: seg_comm = 4'b0000;
        endcase
    end

    always @(posedge clk_100MHz) begin
        case (digit_select)
            2'b00 : begin
                case (sum[3:0])
                    4'h0: seg = 8'hC0;
                    4'h1: seg = 8'hF9;
                    4'h2: seg = 8'hA4;
                    4'h3: seg = 8'hB0;
                    4'h4: seg = 8'h99;
                    4'h5: seg = 8'h92;
                    4'h6: seg = 8'h82;
                    4'h7: seg = 8'hF8;
                    4'h8: seg = 8'h80;
                    4'h9: seg = 8'h90;
                    4'hA: seg = 8'h88;
                    4'hB: seg = 8'h83;
                    4'hC: seg = 8'hC6;
                    4'hD: seg = 8'hA1;
                    4'hE: seg = 8'h86;
                    4'hF: seg = 8'h8E;
                    default: seg = 8'hff;
                endcase
            end

            2'b01 : begin
                case (sum[7:4])
                    4'h0: seg = 8'hC0;
                    4'h1: seg = 8'hF9;
                    4'h2: seg = 8'hA4;
                    4'h3: seg = 8'hB0;
                    4'h4: seg = 8'h99;
                    4'h5: seg = 8'h92;
                    4'h6: seg = 8'h82;
                    4'h7: seg = 8'hF8;
                    4'h8: seg = 8'h80;
                    4'h9: seg = 8'h90;
                    4'hA: seg = 8'h88;
                    4'hB: seg = 8'h83;
                    4'hC: seg = 8'hC6;
                    4'hD: seg = 8'hA1;
                    4'hE: seg = 8'h86;
                    4'hF: seg = 8'h8E;
                    default: seg = 8'hff;
                endcase
            end

            2'b10 : begin
                case (cout)
                    1'h0: seg = 8'hC0;
                    1'h1: seg = 8'hF9;
                    default: seg = 8'hff;
                endcase
            end

            2'b11 : begin
                case (1'b0)
                    1'h0: seg = 8'hC0;
                    default: seg = 8'hff;
                endcase
            end
        endcase
    end

endmodule