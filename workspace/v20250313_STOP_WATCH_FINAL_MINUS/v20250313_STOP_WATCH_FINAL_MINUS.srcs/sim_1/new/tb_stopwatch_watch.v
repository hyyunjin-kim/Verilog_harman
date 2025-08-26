`timescale 1ns / 1ps



module tb_stopwatch_watch();

    reg clk, reset, btn_left, btn_right, btn_down;
    reg [2:0] sw_mode;
    wire [3:0] fnd_comm;
    wire [7:0] fnd_font;
    wire [4:0] led;

    top_stopwatch dut(
    .clk(clk),
    .reset(reset),
    .sw_mode(sw_mode),
    .btn_left(btn_left),
    .btn_right(btn_right),
    .btn_down(btn_down),
    .fnd_comm(fnd_comm),
    .fnd_font(fnd_font),
    .led(led)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 0;
        btn_left = 1'b0;
        btn_down = 1'b0;
        btn_right = 1'b0;

        #10;
        reset = 1;
        
        #10;
        reset= 0;
        sw_mode = 3'b011;

    #100000000;
        btn_down = 1'b1;
    #100000000;
        btn_down = 1'b0;
    #100000000;
        btn_down = 1'b1;
    #100000000;
        btn_down = 1'b0;
    #100000000;
        btn_right = 1'b1;
    #100000000;
        btn_right = 1'b0;
    #100000000;
        btn_right = 1'b1;
    #100000000;
        btn_right = 1'b0;


        #10;
        sw_mode = 3'b111;
        #100000000;
        btn_down = 1'b1;
    #100000000;
        btn_left = 1'b0;
    #100000000;
        btn_down = 1'b1;
    #100000000;
        btn_down = 1'b0;
    #100000000;
        btn_right = 1'b1;
    #100000000;
        btn_right = 1'b0;
    #100000000;
        btn_right = 1'b1;
    #100000000;
        btn_right = 1'b0;
 
    end 
endmodule