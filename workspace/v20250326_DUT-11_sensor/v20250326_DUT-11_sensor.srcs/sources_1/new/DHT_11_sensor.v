`timescale 1ns / 1ps

module DHT_11_sensor(
    input clk, rst,
    input btn_start,
    output [2:0] led,
    output led_check1,
    inout dht_io,

    input sw_mode,
    output [7:0]fnd_font,
    output [3:0]fnd_comm
    );

    wire [39:0] w_data;
    wire w_tick_1us;
    wire w_btn_start;

    btn_debounce U_BTN (
        .clk(clk), .reset(rst), .i_btn(btn_start), .o_btn(w_btn_start)
    );
    tick_1us_gen  U_tick_1us(
        .clk(clk), .rst(rst), .tick_1us(w_tick_1us)
    );
    DHT_11_controller U_DHT_CU(
        .clk(clk), .rst(rst), .btn_start(w_btn_start), .tick_1us(w_tick_1us),
        .led_m(led), .dht_io(dht_io), .data(w_data)
    );
    fnd_controller U_FND(
        .clk(clk), .reset(rst), .measure_value(w_data), .sw_mode(sw_mode), .fnd_font(fnd_font), .fnd_comm(fnd_comm),
        .led_check1(led_check1)
    );
endmodule


module tick_1us_gen (
    input  clk,
    input  rst,
    output tick_1us
);

    localparam TICK_COUNT = 100;  // 10ms at 100MHz clock
    localparam CNT_WIDTH  = $clog2(TICK_COUNT);

    reg [CNT_WIDTH-1:0] count_reg, count_next;
    reg tick_reg, tick_next;

    assign tick_1us = tick_reg;

    // 시퀀셜 로직: 레지스터 업데이트
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count_reg <= 0;
            tick_reg  <= 0;
        end else begin
            count_reg <= count_next;
            tick_reg  <= tick_next;
        end
    end

    // 조합 로직: 다음 상태 결정
    always @(*) begin
        count_next = count_reg;
        tick_next  = 1'b0;

        if (count_reg == TICK_COUNT - 1) begin
            count_next = 0;
            tick_next  = 1'b1;  
        end else begin
            count_next = count_reg + 1;
        end
    end

endmodule

module DHT_11_controller (
    input clk, rst,
    input btn_start,
    input tick_1us,
    output [2:0] led_m, // state랑 message 출력
    output [39:0] data,
    inout dht_io
);
    parameter IDLE = 3'b000, START = 3'b001, WAIT = 3'b010, SYNC_LOW = 3'b011, SYNC_HIGH = 3'b100,
              DATA_SYNC = 3'b101 , DATA_DC = 3'b110, STOP = 3'b111;

    reg [2:0] state, next;
    reg [$clog2(20000)-1:0] cnt_reg, cnt_next;
    reg io_out_reg, io_out_next;
    reg out_en_reg, out_en_next;
    reg [5:0] data_cnt_reg, data_cnt_next;  // 0~40까지 데이터 수 세주기용
    reg [39:0] data_total_reg, data_total_next;  // 40bit짜리 데이터 주머니

    assign led_m =  state;
    assign dht_io = (out_en_reg) ? io_out_reg : 1'bz;
    assign data = data_total_reg;


    always @(posedge clk, posedge rst) begin
        if(rst) begin
            state <= IDLE;
            cnt_reg <= 0;
            io_out_reg <= 1;
            out_en_reg <= 0;
            data_cnt_reg <= 0;
            data_total_reg <= 0;
        end else begin
            state <= next;
            cnt_reg <= cnt_next;
            io_out_reg <= io_out_next;
            out_en_reg <= out_en_next;
            data_cnt_reg <= data_cnt_next;
            data_total_reg <= data_total_next;
        end
    end

    always @(*) begin
        next = state;
        cnt_next = cnt_reg;
        io_out_next = io_out_reg;
        out_en_next = out_en_reg;
        data_cnt_next = data_cnt_reg;
        data_total_next = data_total_reg;

        case (state)
            IDLE : begin
                io_out_next = 1;
                out_en_next = 1; // 항상 출력모드로 설정
                
                if(btn_start) begin
                    data_total_next = 0;
                    next = START;
                    cnt_next = 0;
                end
            end 
            START : begin
                io_out_next = 0;
                if(tick_1us) begin
                    if (cnt_reg == 18000) begin
                        next = WAIT;
                        cnt_next = 0;
                    end else begin
                        cnt_next = cnt_reg + 1;
                    end
                end
            end
            WAIT : begin
                io_out_next = 1;
                if(tick_1us) begin
                    if (cnt_reg == 30) begin
                        next = SYNC_LOW;
                        cnt_next = 0;
                        out_en_next = 0;
                    end else begin
                    cnt_next = cnt_reg + 1;
                    end
                end
            end
        //     READ : begin
        //         out_en_next = 0;
        //         if(tick_1us) begin
        //             if (cnt_reg == 80) begin
        //                 next = IDLE;
        //                 cnt_next = 0;
        //             end else begin
        //                cnt_next = cnt_reg + 1; 
        //             end
        //         end
        //         if (dht_io == 1'b0) begin  // dht_io가 아웃풋이 아니라 센서로부터 들어오는 인풋이 된다.
        //             led_check_next = 1'b1;  // 값이 이제 30us 후 DHT로 넘어가면서 값이 0으로 떨어져 led 켜지기기
        //         end else begin
        //             led_check_next = 1'b0;
        //         end
        //     end
            SYNC_LOW : begin  // 3
                if(tick_1us) begin
                    if(cnt_reg == 20) begin
                        if(dht_io) begin
                            next = SYNC_HIGH;
                            cnt_next = 0;
                        end 
                    end else begin
                        cnt_next = cnt_reg + 1;
                    end
                end
            end
            SYNC_HIGH : begin  // 4
                if(tick_1us) begin
                    if(dht_io == 0) begin
                        next = DATA_SYNC;
                    end
                end
            end
            DATA_SYNC : begin  // 5
                if(tick_1us) begin
                    if(data_cnt_reg == 40) begin
                        data_cnt_next = 0;
                        next = STOP;
                        cnt_next = 0;
                    end else begin
                        if (dht_io) begin
                            next = DATA_DC;
                            cnt_next = 0;
                        end
                    end
            end
            end
            DATA_DC : begin   // 6
                if(tick_1us) begin
                    if(dht_io) begin
                        cnt_next = cnt_reg + 1;
                    end else begin 
                        if (cnt_reg > 40) begin
                            data_total_next = {data_total_reg[38:0],1'b1};
                        end else begin 
                            data_total_next = {data_total_reg[38:0],1'b0};
                        end
                        data_cnt_next = data_cnt_reg + 1;
                        next = DATA_SYNC;
                        cnt_next = 0;
                    end
                end
            end
            STOP : begin
                if(tick_1us) begin
                    if (cnt_reg == 50) begin
                        cnt_next = 0;
                        next = IDLE;
                    end else begin
                        cnt_next = cnt_reg + 1;
                    end
                end
            end
        endcase
    end
endmodule