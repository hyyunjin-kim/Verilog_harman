`timescale 1ns / 1ps

module tb_uart_tx();
    // reg clk, reset, btn_start;
    // wire tx;

    // send_tx_btn dut(
    // .clk(clk),
    // .reset(reset),
    // .btn_start(btn_start),
    // .tx(tx)
    // );

    reg clk, reset;
    reg rx;
    wire w_tick, w_rx_done;
    wire [7:0] rx_data;

    uart_rx dut(
    .clk(clk),
    .reset(reset),
    .tick(w_tick),
    .rx(rx),
    .rx_done(w_rx_done),
    .rx_data(rx_data)
);
    Baud_Tick_Gen uut(
    .clk(clk),
    .reset(reset),
    .baud_tick(w_tick)
    );


    always #5 clk = ~clk;

    initial begin
    //     clk = 0;
    //     reset = 1;
    //     btn_start = 1'b0;

    //     #10;
    //     reset = 0;
    //   #100000; 
    //    btn_start = 1'b1;
    //   #100000; 
    //    btn_start = 1'b0;
    //   #2000000; 
    //    btn_start = 1'b1;
    //   #100000; 
    //    btn_start = 1'b0;

    clk = 0;
    reset = 1;
    rx = 1;
    #10;
    reset = 0;
    #100;
    rx = 0;  // start
    #104160;  // 1/9600 => 9600bit. 단위는 ns
    rx = 1;  // data 0
    #104160;  // 1/9600 => 9600bit. 단위는 ns
    rx = 0;  // data 1
    #104160
    rx = 0;  // data 2
    #104160;  // 1/9600 => 9600bit. 단위는 ns
    rx = 0;  // data 3
    #104160
    rx = 1;  // data 4
    #104160;  // 1/9600 => 9600bit. 단위는 ns
    rx = 1;  // data 5
    #104160
    rx = 0;  // data 6
    #104160;  // 1/9600 => 9600bit. 단위는 ns
    rx = 1;  // data 7

    #10000;
    $stop;

    end
endmodule