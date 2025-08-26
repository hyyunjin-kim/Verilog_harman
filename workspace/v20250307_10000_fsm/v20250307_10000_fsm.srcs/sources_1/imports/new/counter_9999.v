`timescale 1ns / 1ps

module top_counter_9999 (
    input clk,
    input reset,
    //input [1:0] switch,
    input btn_run_stop,
    input btn_clear,
    output [7:0] seg,
    output [3:0] seg_comm
);
    wire [13:0] count_value;
    wire w_slow_clk;
    wire w_run_stop, w_clear;
    wire w_tick_100hz;
    wire o_btn_run_stop;
    wire o_btn_run_clear;
    wire w_tick_msec;
 //   assign w_run_stop = clk & switch[0];
 //   assign w_clear = reset | switch[1];

    tick_100Hz tick(.clk(clk),.reset(reset),.run_stop(w_run_stop),.o_tick_100Hz(w_tick_100hz));
//    counter_9999 cnt99(.clk(w_slow_clk), .reset(w_clear), .clear(w_clear), .count_stop(w_run_stop), .count(count_value));
    counter_tick ct100(.clk(clk), .reset(reset), .clear(w_clear), .tick(w_tick_100hz), .counter(count_value),.o_tick(w_tick_msec));
   // counter_tick #(.TICK_COUNT = ) ct60(.clk(clk), .reset(reset), .clear(w_clear), .tick(w_tick_100hz), .counter(count_value),.o_tick());
    fnd_controller fc1(.clk(clk), .reset(reset), . bcd(count_value), .seg(seg), .seg_comm(seg_comm));
//    clk_divider_slow cds1(.clk(clk), .reset(reset), .slow_clk(w_slow_clk));
    control_unit cu1(.clk(clk), .reset(reset),.i_run_stop(o_btn_run_stop),.i_clear(o_btn_run_clear),
                     .o_run_stop(w_run_stop), .o_clear(w_clear));
    btn_debounce bd_runstop(.clk(clk), .reset(reset), .i_btn(btn_run_stop), .o_btn(o_btn_run_stop));
    btn_debounce bd_clear(.clk(clk), .reset(reset), .i_btn(btn_clear), .o_btn(o_btn_run_clear));
endmodule


/*module counter_9999(
    input clk,
    input reset,
    input clear,
    input count_stop,
    output reg [13:0] count
    );
    reg clk_out_reg;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            count <= 0;
        end
        
        else if(clear) begin
            count <=0;
        end

        else if(count_stop) begin
            count <= count;
        end

        else begin
            if (count == 9999) begin
                count <= 0;
        //        clk_out_reg <= ~clk_out_reg;
            end
            else begin
                count <= count + 1;
            end
        end
    end

   // assign count = clk_out_reg;
endmodule
*/

// module clk_divider_slow (
//     input clk, reset,
//     output reg slow_clk
// );
//     reg [23:0] counter;  // 클럭을 나누기 위한 카운터 (24비트: 약 1Hz 생성 가능)

//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             counter <= 0;
//             slow_clk <= 0;
//         end else begin
//             if (counter == 5_000_000) begin // 100MHz / 5M = 10Hz (0.1초마다 1번)
//                 counter <= 0;
//                 slow_clk <= ~slow_clk;  // 토글하여 반주기 사용
//             end else begin
//                 counter <= counter + 1;
//             end
//         end
//     end
// endmodule


module tick_100Hz ( ///////////////////////////////////////////////////////////////////////
    input clk, reset,
    input run_stop,
    output o_tick_100Hz
);
  //  reg [23:0] counter;  // 클럭을 나누기 위한 카운터 (24비트: 약 1Hz 생성 가능)
    reg [$clog2(1_000_000-1):0] r_counter;
    reg r_tick_100hz;

    assign o_tick_100Hz = r_tick_100hz;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick_100hz <= 0;
        end else begin
            if (run_stop == 1'b1) begin // 100MHz / 5M = 10Hz (0.1초마다 1번)
                if( r_counter == (1_000_000 - 1)) begin
                r_counter <= 0;
                r_tick_100hz <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick_100hz <= 1'b0; // 100M = 1 tick
                end
            end
        end
    end
endmodule

// 100진 1msec 만들기 == 기본 100Mhz -> 한 주기시간 : 10ns , 1msec=1ms=1,000,000ns -> 필요한 클럭 주기 수: 100_000
module counter_tick  #(parameter TICK_COUNT = 100_000) (
    input clk, reset,
    input tick,
    input clear,
    output [$clog2(TICK_COUNT)-1:0] counter,
    output o_tick
);
    //     state         next
    reg [$clog2(TICK_COUNT)-1:0] counter_reg, counter_next;  
    reg r_tick;

    assign counter = counter_reg;
    assign o_tick = r_tick;
    // state
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    // next
    always @(*) begin
        counter_next = counter_reg;
        r_tick = 1'b0;
        if(clear == 1'b1) begin
            counter_next =0;
        end
        else if (tick == 1'b1) begin // tick count
            if(counter_reg == TICK_COUNT-1) begin
                counter_next = 0;
                r_tick = 1'b1;
            end 
            else begin
                counter_next = counter_reg + 1;
                r_tick = 1'b0;
            end
        end
    end
    
endmodule

// module clk_divider_100Hz (
//     input clk, reset,
//     input run_stop,
//     output reg o_tick_100Hz
// );

//     parameter CLK_100Hz = 1_000_000;
//     parameter STOP = 1'b0, RUN = 1'b1;
//     reg state, next;

//     reg [$clog2(CLK_100Hz-1):0] r_count;
//     reg r_clk_100hz;

//     // reg 출력을 위해서
//     assign o_tick_100Hz = r_clk_100hz;

//     // state 저장
//     always @(posedge clk, posedge reset) begin
//         if(reset) begin
//             state <= 0;
//         end else begin
//             state <= next;
//         end
//     end

//     // next combination
//     always @(*) begin
//         next = state;   // latch 제거용용
//         case (state)
//            STOP : begin 
//                 if(run_stop == 1'b1)
//                     next = RUN;
//            end
//            RUN : begin
//                 if(run_stop == 1'b0)begin
//                     next = STOP;
//                 end
//            end
//             default: next = state;
//         endcase
//     end

//     // output combinational logic
//     always @(*) begin
//         r_count = 0;
//         case (state)
//             RUN : begin
//                 if(r_count == (CLK_100Hz-1)) begin
//                     r_count = 0;
//                     r_clk_100hz = 1'b1; // 출력 클럭을 hign
//                 end else begin
//                     r_count = r_count =1;
//                 end
//             end
//             default: 
//         endcase
//     end
// endmodule

module control_unit (
    input clk, reset,
    input i_run_stop,
    input i_clear,
    output reg o_run_stop,
    output reg o_clear
);
    parameter STOP = 3'b000, RUN = 3'b001, CLEAR = 3'b010;

    reg [2:0] state, next;

// state sequential logic
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= STOP;
        end else begin
            state <= next;
        end
    end

// next combinational logic
    always @(*) begin
        next = state;
        case (state)
            STOP : begin
                if (i_run_stop == 1'b1) begin
                    next = RUN; 
                end else if (i_clear == 1'b1) begin
                    next = CLEAR;
                end
            end
            RUN : begin
                if (i_run_stop == 1'b1) begin
                    next = STOP;
                end
            end
            CLEAR : begin
                if(i_clear == 1'b0) begin
                    next = STOP;
                end
            end
            default: next = state;
        endcase
    end
    
// combinationl output logic
    always @(*) begin
        o_run_stop = 1'b0;
        o_clear = 1'b0;
        case (state)
            STOP : begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
            end 
            RUN : begin
                o_run_stop = 1'b1;
                o_clear = 1'b0;
            end
            CLEAR : begin
               // o_run_stop = 1'b1;
                o_clear = 1'b1;
            end
            default: begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
            end
        endcase
    end
endmodule