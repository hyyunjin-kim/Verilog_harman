`timescale 1ns / 1ps


module fsm_led(
    input clk, reset,
    input [2:0] sw,
    output reg [1:0] led
    );

    parameter [1:0] IDLE = 2'b00, LED01 = 2'b01, LED02 = 2'b10; 

    reg [1:0] state, next;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= IDLE;
        //    next <= 0;
        end else begin
            // 상태관리, next를 현재상태로 바꿔라라
            state <= next;
        end
    end

    // next combinational logic
    always @(*) begin
        next = state;
       case (state)
        IDLE: begin 
            if(sw == 3'b001) begin
                next = LED01;
            end
        end 
        LED01: begin
           if(sw == 3'b011) begin
                next = LED02;
           end 
        end
        LED02: begin
            if(sw == 3'b110)begin
                next = LED01;
            end
            else if(sw == 3'b111) begin //else이면 안된다. 딱 그 조건일때만 이동
                next = IDLE;
            end
            else begin
                next = state;
            end
        end
        default: next = state;
       endcase 
    end

    
    // output combinational logic
    always @(*) begin
        case (next)
            IDLE: begin
                led = 2'b00;
            end 
            LED01: begin
                led = 2'b01;
            end
            LED02: begin
                led = 2'b10;
            end
            default: led = 2'b11;
        endcase
    end

endmodule