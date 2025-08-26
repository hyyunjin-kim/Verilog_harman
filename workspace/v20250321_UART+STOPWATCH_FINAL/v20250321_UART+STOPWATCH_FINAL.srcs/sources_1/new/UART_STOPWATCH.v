`timescale 1ns / 1ps

module UART_STOPWATCH(
    input clk,
    input rst,
    input [2:0]sw_mode,
    input btn_left, btn_right, btn_down,
    input rx,
    output tx,
    output [3:0] fnd_comm,
    output [7:0] fnd_font,
    output [4:0] led
    );

    //wire w_btn_left, w_btn_down, w_btn_right;
    wire [7:0] w1_rx_rdata;
    wire w_rx_empty;

    top_fifo_uart U_TFU (
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .w_rx_rdata(w1_rx_rdata),
        .tx(tx),
       // .rx_rd(rx_rd),
        .w_rx_empty(w_rx_empty)
    );

    top_stopwatch U_TST (
        .clk(clk), 
        .reset(rst),
        .btn_left(btn_left), 
        .btn_right(btn_right), 
        .btn_down(btn_down),
        .sw_mode(sw_mode),  //sw[1]은 stopwatch, clock 구별용 // sw[0]는 msec, hour 구별용
        .fnd_comm(fnd_comm),
        .fnd_font(fnd_font),
        .led(led),
        .rx_data(w1_rx_rdata),
     //   .rx_rd(rx_rd),
        .w_rx_empty(~w_rx_empty)
    );

endmodule
