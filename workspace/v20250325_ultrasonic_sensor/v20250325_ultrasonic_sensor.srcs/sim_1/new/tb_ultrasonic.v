`timescale 1ns / 1ps



module tb_ultrasonic();

    reg clk, rst, btn_start, echo;
    wire [7:0] fnd_font;
    wire [3:0] fnd_comm;
    wire trigger;
    wire [3:0] state_led;

    ultrasonic_controller U_uc(
        .clk(clk), .rst(rst), .btn_start(btn_start), .echo(echo),
        .fnd_font(fnd_font), .fnd_comm(fnd_comm), .trigger(trigger),
        .state_led(state_led)
    );

    always #5 clk=~clk;

    initial begin
        clk = 0;
        rst = 1;
        btn_start = 0;
        echo = 0;

        #10 rst = 0;

        #10 btn_start = 1;

        #10000000 btn_start = 0;

        // Echo rising edge 기다렸다가 HIGH 유지 (거리 = 약 401cm)
       // trigger 끝나고 WAIT_ECHO 상태로 진입
        #3000 echo = 1;       // echo 1 시작 → 측정 시작

        // Echo HIGH 유지 (2,328,000 클럭 = 23.28ms)
        #1500000 echo = 0;  // 측정 끝 → 거리 계산

        // 결과 확인
        #100000;

        $finish;
    end

endmodule