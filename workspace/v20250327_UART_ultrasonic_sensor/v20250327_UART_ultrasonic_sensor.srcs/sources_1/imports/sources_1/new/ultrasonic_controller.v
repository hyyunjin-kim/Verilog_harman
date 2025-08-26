`timescale 1ns / 1ps



module ultrasonic_controller(
    input clk, rst,
    input btn_start,
    input echo,
    output [7:0] fnd_font,
    output [3:0] fnd_comm,
    output trigger,
    output [3:0] state_led,
    output led
    );

    wire w_btn;
    wire w_start_trigger;
    wire [8:0] w_distance;

    assign led = echo;

    btn_debounce U_btn_debounce (
        .clk(clk), .reset(rst), .i_btn(btn_start), .o_btn(w_btn)
    );
    Start_trigger_10u U_ST_TRIG(
        .clk(clk) , .rst(rst), .btn_start(w_btn), .trigger_tick(trigger)
    );
    ultrasonic_cu U_ultra_cu(
        .clk(clk), .rst(rst), .trigger(trigger), .echo(echo), .distance(w_distance), .state_led(state_led)
    );
    fnd_controller U_FC(
        .clk(clk), .reset(rst), .distance(w_distance), .fnd_font(fnd_font), .fnd_comm(fnd_comm)
    );
endmodule

module Start_trigger_10u (  // 10us 짜리 길이이 tick 생성
    input clk, rst,
    input btn_start,
    output trigger_tick
);
    parameter FCOUNT = 1000;   // clk = 100_000_000 

    reg [$clog2(FCOUNT)-1:0] count_reg, count_next;
    reg trig_reg, trig_next;
    // reg btn_start_next;

    assign trigger_tick = trig_reg;  // 최종 출력.

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            count_reg <= 0;
            trig_reg <= 0;
            // btn_start <= 0;
        end else begin
            count_reg <= count_next;
            trig_reg <= trig_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        trig_next = trig_reg;
        // btn_start_next = btn_start;

        if (btn_start) begin
            trig_next = 1'b1;
            count_next = 1'b0;
        end else if(trig_reg) begin 
            if (count_reg < FCOUNT - 1) begin
                trig_next = 1'b1;
                count_next = count_reg + 1;
            end else begin
                trig_next = 1'b0;
            end
        end
    end
endmodule

module ultrasonic_cu (
    input clk, rst,
    input trigger,
    input echo,
    output [8:0] distance,
    output reg [3:0] state_led
);
    parameter IDLE = 2'b00, TRIG = 2'b01, WAIT_ECHO = 2'b10, MEASURE = 2'b11;

    reg [1:0] state, next;
    reg [21:0] cnt_next, cnt_reg;           // 2,328,000 echo 감지 시간 //10ns로 400m를 구하기 위한 뭐시기
    reg [8:0] distance_next, distance_reg;  // 400cm 표시 위해 9비트

     // state register
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            state <= IDLE;
            distance_reg <=0;
            cnt_reg <= 0;
        end else begin
            state <= next;
            cnt_reg <= cnt_next;
            distance_reg <= distance_next;
        end
    end

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            state_led <= 4'b0000;
        end else begin
            case (state)
                IDLE:       state_led <= 4'b0001;
                TRIG:       state_led <= 4'b0010;
                WAIT_ECHO:  state_led <= 4'b0100;
                MEASURE:    state_led <= 4'b1000;
                default:    state_led <= 4'b0000;
            endcase
        end
    end

    assign distance = distance_reg;        //cnt_reg/1000/58;

    // next
    always @(*) begin
        next = state;
        cnt_next = cnt_reg;
        distance_next = distance_reg;
        case (state)
            IDLE : begin
                cnt_next = 0;
                if(trigger == 1) begin
                    next = TRIG;
                end
            end
            TRIG : begin
                if(trigger == 0) begin
                    next = WAIT_ECHO;
                end 
            end
            WAIT_ECHO : begin
                if(echo == 1) begin
                    next = MEASURE;
                end
            end
            MEASURE : begin
                distance_next = 0;
                if(echo == 1'b1) begin
                    cnt_next = cnt_reg + 1;
                end
                else begin
                    if(distance_reg > 400) begin
                        distance_next = 400;
                    end else begin
                    distance_next = cnt_reg/5800;  // 난 1us가 아니라 10ns로 측정했기에 58이 아닌 5800
                    end
                    next = IDLE;
                end
            end
        endcase
    end
endmodule

// distance 값이 안뜨는 문제 => distance reg , distance next를 만들어주었다.
// echo는 반짝이지만 값이 안뜰때때