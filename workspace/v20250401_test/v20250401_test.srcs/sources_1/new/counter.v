`timescale 1ns / 1ps



module top_counter(
    input clk, rst,
    input sw,
    output [7:0] fnd_font,
    output [3:0] fnd_comm
    );
    wire o_clk;
    wire [13:0] w_number;

    time_counter_100m U_time_counter_100m(
        .clk(clk), .rst(rst), .o_clk(o_clk)
    );
    upcounter U_counter(
        .clk(o_clk), .rst(rst), .sw(sw), .number(w_number)
    );
    fnd_ctrl U_fnd_ctrl(
        .clk(clk), .rst(rst), .number(w_number), .fnd_font(fnd_font), .fnd_comm(fnd_comm)
    );
endmodule

module time_counter_100m(
    input clk, rst,
    output reg o_clk
);
    parameter FCOUNT = 10_000_000;

    reg [$clog2(FCOUNT)-1 : 0] count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 0;
            o_clk <= 0;
        end
        else begin
            if(count == FCOUNT -1) begin
                count <= 0;
                o_clk <= 1;
            end else begin
                count <= count + 1;
                o_clk <= 0;
            end
        end
    end
endmodule

module upcounter (
    input clk, rst,
    input sw,
    output [13:0] number
);
    reg [13:0]up_number;
    assign number = up_number;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            up_number <= 0;
        end else begin
            if(sw == 0) begin
                if(up_number == 9999)
                up_number <= 0;
                else 
                up_number <= up_number + 1;
            end
            else if (sw == 1) begin
                if (up_number == 0000) begin
                    up_number <= 9999;
                end
                else begin
                    up_number <= up_number - 1;
                end
            end
        end
    end
endmodule

module fnd_ctrl (
    input clk, rst,
    input [13:0] number,
    output [7:0] fnd_font,
    output [3:0] fnd_comm
);
   // wire [3:0] w_decoder_value;
    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [3:0] w_bcd;
    wire w_fnd_clk;

    clk_divider U_clk_divider(
        .clk(clk), .rst(rst), .fnd_clk(w_fnd_clk)
    );
    decoder U_decoder(
        .clk(w_fnd_clk), .rst(rst), .decoder_value(fnd_comm)
    );
    digit_split U_digit(
        .number(number), .number_1(w_digit_1), .number_10(w_digit_10), .number_100(w_digit_100), .number_1000(w_digit_1000)
    );
    mux_4x1 U_mux_4x1(
        .decoder_value(fnd_comm), .number_1(w_digit_1), .number_10(w_digit_10), .number_100(w_digit_100), .number_1000(w_digit_1000), .bcd(w_bcd)
    );
    bcdtoseg U_bcdtoseg(
        .bcd(w_bcd), .seg(fnd_font)
    );
endmodule

module bcdtoseg(   
    input [3:0] bcd, 
    output reg [7:0] seg
);
    always @(bcd) begin 
        case(bcd) 
            4'h0: seg = 8'hc0; 
            4'h1: seg = 8'hF9;
            4'h2: seg = 8'hA4;
            4'h3: seg = 8'hB0;
            4'h4: seg = 8'h99;
            4'h5: seg = 8'h92;
            4'h6: seg = 8'h82;
            4'h7: seg = 8'hf8;
            4'h8: seg = 8'h80;
            4'h9: seg = 8'h90;
            4'hA: seg = 8'h88;
            4'hB: seg = 8'h83;
            4'hC: seg = 8'hc6;
            4'hD: seg = 8'ha1;
            4'hE: seg = 8'h7f;  // dot display
            4'hF: seg = 8'hff;  // segment off
            default: seg = 8'hff;
        endcase
    end
endmodule


module decoder (
    input clk, rst,
    output reg [3:0] decoder_value
);
    reg [1:0] select;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            select <= 0;
        end else
        select <= select + 1;
    end
    always @(*) begin
        case (select)
           2'b00 : decoder_value = 4'b1110;
           2'b01 : decoder_value = 4'b1101;
           2'b10 : decoder_value = 4'b1011;
           2'b11 : decoder_value = 4'b0111; 
        endcase
    end
endmodule

module mux_4x1 (
    input [3:0] decoder_value,
    input [3:0] number_1, number_10, number_100, number_1000,
    output [3:0] bcd
);  
    reg [3:0] bcd_reg;
    assign bcd = bcd_reg;
    always @(*) begin   
        case(decoder_value) 
            4'b1110 : bcd_reg = number_1;
            4'b1101 : bcd_reg = number_10;
            4'b1011 : bcd_reg = number_100;
            4'b0111 : bcd_reg = number_1000;
        endcase
    end
endmodule

module digit_split (
    input [13:0] number,
    output [3:0] number_1,
    output [3:0] number_10,
    output [3:0] number_100,
    output [3:0] number_1000
);
    assign number_1 = number%10;
    assign number_10 = number/10%10;
    assign number_100 = number/100%10;
    assign number_1000 = number/1000%10;

endmodule

module clk_divider (
    input clk, rst,
    output reg fnd_clk
);
    parameter FCOUNT = 100_000;

    reg [$clog2(FCOUNT)-1 : 0] count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 0;
            fnd_clk <= 0;
        end
        else begin
            if(count == FCOUNT -1) begin
                count <= 0;
                fnd_clk <= 1;
            end else begin
                count <= count + 1;
                fnd_clk <= 0;
            end
        end
    end
endmodule
    
