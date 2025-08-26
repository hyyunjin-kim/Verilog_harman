`timescale 1ns / 1ps

module tb_sensor_uart();

    reg clk, rst, echo, btn_start, rx;
    wire [7:0] fnd_font;
    wire [3:0] fnd_comm;
    wire trigger, tx;

    Top_uart_ultrasonic dut(
    .clk(clk),
    .rst(rst),
    .echo(echo),
    .btn_start(btn_start),
    .trigger(trigger),
    .rx(rx),
    .tx(tx),
    .fnd_font(fnd_font),
    .fnd_comm(fnd_comm)
);
    integer i = 0;
    always begin
        #5 clk = ~clk; 
    end
    
    initial begin
        clk = 0;
        rst = 1;
        echo = 0;
        btn_start = 0;
        i = 0; 
        #10;
        rst = 0;
        #10000
        /*
        btn_start = 1;
        #10;
        btn_start = 0;
        */

        for(i = 0; i < 6; i = i +1) begin
        rx = 0;
         #104160; 
         send_bit("U"); 
         rx = 1; 
         #104160;

        #11000;
        echo = 1;
      #725000; //640u  12.5cm
        echo = 0;
        #110000;
        end
    #100; $stop;
    end
    task send_bit(input [7:0] data);
        integer i;
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
            #104160;
            end
    endtask

endmodule