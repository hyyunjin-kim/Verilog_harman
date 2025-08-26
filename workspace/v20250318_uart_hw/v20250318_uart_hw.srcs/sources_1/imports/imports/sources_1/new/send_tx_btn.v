`timescale 1ns / 1ps

module send_tx_btn(
    input clk,
    input reset,
    input btn_start,
    output tx
    );

    parameter IDLE = 0, START = 1, SEND = 2;
    reg [1:0] state, next;    // send char fsm state

    wire w_start, w_tx_done;
    wire [7:0] w_tx_data_in;
    reg [7:0] send_tx_data_reg, send_tx_data_next; 
    reg send_reg, send_next;  // start trigger 출력
    reg [3:0]send_count_reg, send_count_next;  // send data count

    button_debounce u_button_debounce(
    .clk(clk),
    .reset(reset),
    .i_btn(btn_start),
    .o_btn(w_start)
    );

    uart uart(
    .clk(clk),
    .reset(reset),
    .btn_start(send_reg),
    .tx_data_in(send_tx_data_reg),
    .tx(tx),
    .tx_done(w_tx_done)
    );

    // send tx ascii to PC



    always@(posedge clk, posedge reset)
        begin
            if(reset) begin 
                send_tx_data_reg <= 8'h30; //데이터이기 때문에 "0"으로
                state <= IDLE;
                send_next <= 1'b0;
                send_count_reg <= 4'b0;
            end
            else begin
                send_tx_data_reg <= send_tx_data_next;
                state <= next;
                send_count_reg <= send_count_next;
                send_reg <= send_next;
            end
        end
    integer i=0;
    always@(*)
        begin
            send_tx_data_next = send_tx_data_reg;
            next = state;
            send_next = 1'b0;   // for 1 tick
            send_count_next = send_count_reg;
            case (state)
               IDLE : begin
                    send_next = 1'b0;
                    send_count_next = 0;
                    if(w_start == 1'b1) begin
                        next = START;
                        send_next = 1'b1;
                    end
                end
               START : begin
                    send_next = 1'b0;
                    if (w_tx_done == 1'b1) begin
                        next = SEND;
                    end
                end
               SEND :  begin
                    if (w_tx_done == 1'b0) begin
                        send_next = 1'b1;   // send 1 tick
                        send_count_next = send_count_reg + 1;
                        if(send_count_reg == 15) begin
                             next = IDLE;
                        end else begin
                            next = START;
                        end
                        // w_tx_done이 low로 떨어진 다음에 1번만 증가 시키기 위함.
                        if (send_tx_data_reg == "z") begin
                            send_tx_data_next = "0";
                        end else begin
                            send_tx_data_next = send_tx_data_reg + 1;
                        end 
                    end
                end
            endcase

            end
endmodule