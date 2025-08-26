`timescale 1ns / 1ps

module TOP_DHT11(
    input clk,
    input reset,
    input btn_left,
    input [2:0]sw_mode, 
    input [15:0] DHT11_decimal_data,
    output [15:0] data_out,
    output [4:0] led,
    output wr_tx,
    output [7:0] wdata_tx,
    inout dht_io
    );

    DHT11_CU U_DHT11_CU(
        .clk(clk),
        .reset(reset),
        .btn_start(btn_left),
        .sw_mode(sw_mode[2:1]),
        .data_out(data_out),
        .led(led),
        .dht_done(w_dht_done),
        .dht_io(dht_io)
    );

    DHT11_dp U_DHT11_dp(
        .clk(clk),
        .reset(reset),
        .dht_done(w_dht_done),
        .sw_mode(sw_mode[0]),
        .DHT11_decimal_data(DHT11_decimal_data),
        .wr_tx(wr_tx),
        .data_sensor_tx(wdata_tx)
    );

endmodule
