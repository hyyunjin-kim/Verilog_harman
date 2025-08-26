`timescale 1ns / 1ps

module Top_uart_ultrasonic(
    input clk, rst,
    input btn_start,
    input rx,
    output tx,
    input echo,
    output trigger,
    output [7:0] fnd_font,
    output [3:0] fnd_comm
    );

    wire [7:0] w_uart_start;
    wire w_rx_empty;
    wire w_uart_btn;  // uart에서 나와서 센서에 start로 적용하는 wire
    wire [8:0] w_distance;

    wire [3:0] w_d_hund, w_d_tens, w_d_ones;
    wire [7:0] w_tx_wr_data;
    wire fnd_fifo_wr;
    wire w_tick;

    top_fifo_uart U_T_Fifo_U (
        .clk(clk), .rst(rst), .rx(rx), .wr_data(w_tx_wr_data), .wr(fnd_fifo_wr),
        .rd_data(w_uart_start), .tx(tx), .w_rx_empty(w_rx_empty)
    );
    ASCII_CU U_ASCII_CU (
        .clk(clk), .rst(rst), .rx_data(w_uart_start), .w_rx_empty(w_rx_empty), .btn_start(w_uart_btn)
    );
    ultrasonic_controller U_ultra_Ctrl(
        .clk(clk), .rst(rst), .btn_start(btn_start), .UART_start(w_uart_btn), .echo(echo), 
        .distance(w_distance), .trigger(trigger)
    );
    fnd_controller U_FND_Ctrl(
        .clk(clk), .rst(rst), .distance(w_distance), .fnd_font(fnd_font), .fnd_comm(fnd_comm),
        .w_digit_1(w_d_ones), .w_digit_10(w_d_tens), .w_digit_100(w_d_hund)
    );
    send_fnd_uart_tx U_send_uart(
        .clk(clk), .rst(rst), .start(echo), .hundreds(w_d_hund), 
        .tens(w_d_tens), .ones(w_d_ones), .tx_data(w_tx_wr_data), .tx_wr(fnd_fifo_wr), .tick(w_tick)
    );
    tick_gen_1us U_1us(
        .clk(clk), .reset(rst), .o_clk(w_tick)
    );
endmodule

module tick_gen_1us(
    input clk,
    input reset,
    output o_clk
    );

    parameter FCOUNT = 100; // 1_000_000_000 * 1us
    reg [$clog2(FCOUNT)-1:0] count_reg, count_next;
    reg clk_reg, clk_next;

    assign o_clk = clk_reg;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            count_reg <= 0;
            clk_reg <= 0;
        end else begin
            count_reg <= count_next;
            clk_reg <= clk_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        clk_next = clk_reg;
        if(count_reg == (FCOUNT-1)) begin
            count_next = 1'b0;
            clk_next = 1'b1;
        end else begin
            count_next = count_reg + 1;
            clk_next = 1'b0;
        end
    end

endmodule

module send_fnd_uart_tx (  // 10진수 3자리 수를 ASCII code로 변환환
    input clk,
    input rst,
    input start,                // 시작 트리거 (한 번만 high)
    input [3:0] hundreds,      // 백의 자리
    input [3:0] tens,          // 십의 자리
    input [3:0] ones,          // 일의 자리
    output [7:0] tx_data,       // UART로 보낼 데이터
    output tx_wr,             // UART write 신호 (1클럭)
   // output reg done                 // 전송 완료 신호
    input tick
);

    parameter IDLE = 0, WAIT = 1, START = 2, SEND = 3;
    reg [1:0] state, next;
    reg [9:0] cnt;

    reg [7:0] tx_data_reg, tx_data_next;
    reg tx_wr_reg, tx_wr_next;
    reg [1:0] tick_count_reg, tick_count_next;
    
    assign tx_data = tx_data_reg;
    assign tx_wr = tx_wr_reg;

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx_data_reg <= 0;
            tx_wr_reg <= 0;
            tick_count_reg <= 0;
        end else begin
            state <= next;
            tx_data_reg <= tx_data_next;
            tx_wr_reg <= tx_wr_next;
            tick_count_reg <= tick_count_next;
        end
    end

    always @(*) begin
        next = state;
        tx_data_next = tx_data_reg;
        tx_wr_next = tx_wr_reg;
        tick_count_next = tick_count_reg;
        case (state)
            IDLE: begin
                tx_wr_next = 0;
                tx_data_next = 0;
                tick_count_next = 0;
                tx_wr_next = 0;
                if (start == 1) begin
                    next = WAIT;
                end
            end
            WAIT: begin
                if (start == 0) begin
                    next = START;
                end
            end
            START: begin
                tx_wr_next = 0;
                next = SEND;
            end
            SEND :begin
                    tick_count_next = tick_count_reg + 1;
                    case (tick_count_reg)
                        2'b00: begin
                            tx_data_next = hundreds + 8'h30;
                            tx_wr_next = 1;
                            next = START;
                        end
                        2'b01: begin
                            tx_data_next = tens + 8'h30;
                            tx_wr_next = 1;
                            next = START;
                        end
                        2'b10: begin
                            tx_data_next = ones + 8'h30;
                            tx_wr_next = 1;
                            next = START;
                        end
                        2'b11: begin
                            tx_data_next = 0;
                            tx_wr_next = 0;
                            next = IDLE;
                        end
                    endcase
                    if(tick_count_reg == 3) begin
                        next = IDLE;
                    end
                end
        endcase
    end
endmodule