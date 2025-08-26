`timescale 1ns / 1ps



module top_fifo_uart(
    input clk, rst,
    input rx,
    output [7:0] w_rx_rdata,
    output tx,
    // output rx_rd,
    output w_rx_empty
    );

    wire [7:0] w_tx_rdata, w_rx_data;  // wire인지 reg인지 판단 필요
    wire w_tx_empty, w_tx_done;
    // wire w_rx_empty;
 
    // assign tx_rd = ~w_tx_done & ~w_tx_empty;
    // assign rx_rd = ~w_rx_empty;

    fifo fifo_tx (
     .clk(clk),
     .rst(rst),
    // write
     .wdata(w_rx_rdata),
     .wr(~w_rx_empty),
     .full(w_tx_full),
    // read
     .rd(~w_tx_done), // w_tx_done 대신 TX FIFO가 비어 있지 않을 때 읽기
     .rdata(w_tx_rdata),
     .empty(w_tx_empty)
    );

    fifo fifo_rx (
     .clk(clk),
     .rst(rst),
    // write
     .wdata(w_rx_data),
     .wr(w_rx_done),
     .full(),   // full 핀 연결
    // read
     .rd(~w_tx_full),
     .rdata(w_rx_rdata),
     .empty(w_rx_empty)
    );

    uart U_uart (
    .clk(clk),
    .reset(rst),
    .btn_start(~w_tx_empty),
    .tx_data_in(w_tx_rdata),
    .tx(tx),
    .tx_done(w_tx_done),
    .rx(rx),
    .rx_done(w_rx_done),
    .rx_data(w_rx_data)
    );
endmodule
