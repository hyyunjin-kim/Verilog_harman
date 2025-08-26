`timescale 1ns / 1ps


module tb_fnd();

    reg clk, reset, run, clear; 
    reg sw_mode; 
    reg [6:0] msec; 
    reg [5:0] sec, min; 
    reg [4:0] hour;
    wire fnd_font, fnd_comm;

    stopwacth_dp dut (
        .clk(clk),
        .reset(reset),
        .run(run),
        .clear(clear),
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour)
    );

    fnd_controller DUT(
        .clk(clk), 
        .reset(reset),
        .msec(msec), 
        .sec(sec), 
        .min(min), 
        .hour(hour),
        .sw_mode(sw_mode),
        .fnd_font(fnd_font),
        .fnd_comm(fnd_comm)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        reset = 1;
        sw_mode = 0; // 초기 모드 설정
        msec = 0;    // 초기 msec 값
        sec = 0;     // 초기 sec 값
        min = 0;     // 초기 min 값
        hour = 0;    // 초기 hour 값
        run=0;
        sw_mode = 0;
        
        #10;
        reset = 0;
        run = 1;
        wait (sec == 2);  // 2초대기
        
    // #20;
    // run = 0;
    end
endmodule