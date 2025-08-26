`timescale 1ns / 1ps

module top_uart(
        input clk,
        input reset,
        input btn_start,
        input [7:0] tx_data_in,
        output tx,
        output tx_done
    );

    wire w_baud_tick;

    Baud_Tick_Gen u_Baud_Tick_Gen(
    .clk(clk),
    .reset(reset),
    .baud_tick(w_baud_tick)
);
    Uart_TX u_Uart_Tx(
    .clk(clk),
    .reset(reset),
    .data(tx_data_in),  //ASCII 값 하나 넣음
    .tick(w_baud_tick),
    .start_trigger(btn_start),
    .o_tx(tx),
    .o_tx_done(tx_done)
);
endmodule

module Uart_TX(
    input clk,
    input reset,
    input [7:0] data,
    input tick,
    input start_trigger,
    output o_tx,
    output o_tx_done
);
    parameter IDLE = 2'b00, START = 2'b01 , DATA = 2'b10, STOP = 2'b11 ;
            // D0 = 4'h2, D1 = 4'h3, D2 = 4'h4, D3 = 4'h5,  
            //   D4 = 4'h6, D5 = 4'h7, D6 = 4'h8 , D7 = 4'h9, STOP = 4'ha ;
    reg [3:0] state, next;
    reg tx_reg, tx_next;
    reg tx_done_reg, tx_done_next;

    assign o_tx = tx_reg;
    assign o_tx_done = tx_done_reg;
    
    integer i = 0;

    always@(posedge clk, posedge reset)
        begin
            if(reset) begin
                state <= 0;
                tx_reg <= 1'b1; //uart tx line을 초기에 항상 1로 만들기 위함.
                tx_done_reg <= 0;
            end else begin
                state <= next;
                tx_reg <= tx_next;
                tx_done_reg <= tx_done_next;
            end
        end

    always@(*)
        begin
            next = state;
            tx_next = tx_reg;
            tx_done_next = tx_done_reg;
                case(state)
                    IDLE : begin
                        tx_next = 1'b1;
                        if(start_trigger) begin
                            next = START;
                        end
                    end
                    START : begin
                            tx_next = 1'b0;
                            tx_done_next = 1'b1;
                        if(tick == 1'b1) begin 
                            next = DATA;
                        end
                    end
                    DATA: begin
                        if(tick == 1'b1) begin
                            if(i == 7) begin
                                next = STOP;
                                tx_next = data[i];
                                i = 0;
                            end
                            else 
                                tx_next = data[i];
                                i = i + 1;
                        end
                    end
                    STOP : begin
                        if(tick == 1'b1) begin
                            tx_done_next = 1'b0;
                            tx_next = 1'b1;
                            next = IDLE;
                        end
                    end
                endcase
        end

endmodule


/*                    D0 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[0];
                            next = D1;
                        end
                    end
                    D1 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[1];
                            next = D2;
                        end
                    end
                    D2 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[2];
                            next = D3;
                        end
                    end
                    D3 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[3];
                            next = D4;
                        end
                    end
                    D4 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[4];
                            next = D5;
                        end
                    end
                    D5 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[5];
                            next = D6;
                        end
                    end
                    D6 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[6];
                            next = D7;
                        end
                    end
                    D7 : begin
                        if(tick == 1'b1) begin
                            tx_next = data[7];
                            next = STOP;
                        end
                    end */

module Baud_Tick_Gen(
    input clk,
    input reset,
    output baud_tick
);
    parameter BAUD_RATE = 9_600;
    localparam BAUD_COUNT = 100_000_000 / BAUD_RATE; //Hz 계산하기 위해서

    reg [$clog2(BAUD_COUNT)-1 :0] count_reg, count_next;
    reg tick_reg, tick_next;

    assign baud_tick = tick_reg;

    always@(posedge clk, posedge reset)
        begin
            if(reset) begin
                count_reg <= 0;
                tick_reg <= 0;
            end
            else begin
                count_reg <= count_next;
                tick_reg <= tick_next;
            end
        end
    
    always@(*)
        begin
            count_next = count_reg;
            tick_next = tick_reg;
                if(count_reg == BAUD_COUNT-1) begin
                    count_next = 0;
                    tick_next = 1'b1;
                end
                else begin
                    count_next = count_reg + 1;
                    tick_next = 1'b0;
                end
            end
endmodule