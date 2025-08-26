`timescale 1ns / 1ps


module tb_dht_11();

    reg clk, rst;
    reg btn_start;
    wire dht_io;

    reg io_oe;
    reg dht_sensor_data;

    DHT_11_sensor dut(
        .clk(clk), .rst(rst), .btn_start(btn_start), .dht_io(dht_io)
    );

    assign dht_io = (io_oe) ? dht_sensor_data : 1'bz;

    always #5 clk = ~clk;

    // initial begin
    //     clk = 0;
    //     rst = 1;
    //     io_oe = 0;
    //     btn_start = 0;

    //     #100;
    //     rst = 0;
    //     #100;
    //     btn_start = 1;
    //     #100;
    //     btn_start = 0;
    //     //18msec 대기
    //     wait (dht_io);
    //     #30000;
    //     // 입력 모드로 변환
    //     io_oe = 1;
    //     dht_sensor_data = 1'b0;
    //     #80000;
    //     dht_sensor_data = 1'b1;
    //     #80000;
    //     #50000;
    //     $stop;
    // end
integer i;

initial begin
        clk = 0;
        rst = 1;
        io_oe = 0;
        btn_start = 0;
        
        #100
        rst = 0;
        #100
        btn_start = 1;
        #100
        btn_start = 0;
        //wait 18msec 
        wait(dht_io);
        #50000;
        //입력 모드
        io_oe = 1;

        //80us data comes in
        dht_sensor_data = 1'b1; //1 // sync_high
        #80000;                 
        dht_sensor_data = 1'b0;     // DATA_sync
        #50000;

        for(i=0;i<9; i=i+1) begin
        dht_sensor_data = 1'b1; //1
        #50000;
        dht_sensor_data = 1'b0;
        #50000;

        dht_sensor_data = 1'b1; ///1
        #50000;
        dht_sensor_data = 1'b0;
        #50000;

        dht_sensor_data = 1'b1; //0
        #25000;
        dht_sensor_data = 1'b0;
        #50000;

        dht_sensor_data = 1'b1; //1
        #50000;
        dht_sensor_data = 1'b0;
        #50000;

        dht_sensor_data = 1'b1; //1
        #50000;
        dht_sensor_data = 1'b0;
        #50000;
        end
        $stop;
    end
endmodule

