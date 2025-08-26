`timescale 1ns / 1ps

module tb_fifo_uart();

    reg clk;
    reg rst;
    wire [7:0] w_tx_rdata, w_rx_data;
    wire [7:0] w_rx_rdata;
    wire w_tx_empty, w_tx_done;
    wire w_rx_empty, w_tx_full; // w_rx_full 추가
    wire tx; 
    reg  rx;

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

    always #1 clk = ~clk;  // 10ns 주기 클럭 (100MHz)
    integer i;

     initial begin
        clk = 0;
        rst = 1;
        rx = 1;

        #20 
        rst = 0;
        #2
        rx = 0; #10417; send_bit(8'h68); rx = 1; #31248; // 'h'
        #2
        rx = 0; #10417; send_bit(8'b01100101); rx = 1; #31248; // 'e'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h6F); rx = 1; #31248; // 'o'

        #500;

        rx = 0; #10417; send_bit(8'h77); rx = 1; #31248; // 'w'
        #2
        rx = 0; #10417; send_bit(8'h6F); rx = 1; #31248; // 'o'
        #2
        rx = 0; #10417; send_bit(8'h72); rx = 1; #31248; // 'r'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h64); rx = 1; #31248; // 'd'

        #10000;
        $finish;
    end

    task send_bit(input [7:0] data);
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #20834;
        end
    endtask

endmodule
