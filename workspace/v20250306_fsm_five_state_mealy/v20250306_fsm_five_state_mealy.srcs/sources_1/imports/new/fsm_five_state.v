`timescale 1ns / 1ps

module fsm_five_state_mealy(
    input clk,
    input reset,
    input [2:0] sw,
    output reg [2:0] led
);

    parameter IDLE = 3'b000, st01 = 3'b001, st02 = 3'b010, st03 = 3'b100, st04 = 3'b111; 
    reg [2:0] state, next;
    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next;
        end
    end

    // Next state and output logic (Mealy Model)
    always @(*) begin
        // Default assignments
        next = state; // Keeps the state stable unless conditions below apply
        led = 3'b000; // Default LED state

        case (state)
            IDLE: begin 
                if (sw == 3'b001) begin
                    next = st01;
                    led = 3'b001; // Output depends on input
                end else if (sw == 3'b010) begin
                    next = st02;
                    led = 3'b010;
                end
            end
            st01: begin
                if (sw == 3'b010) begin
                    next = st02;
                    led = 3'b010;
                end else begin
                    led = 3'b001;
                end
            end
            st02: begin
                if (sw == 3'b100) begin
                    next = st03;
                    led = 3'b100;
                end else begin
                    led = 3'b010;
                end
            end
            st03: begin
                if (sw == 3'b111) begin
                    next = st04;
                    led = 3'b111;
                end else if (sw == 3'b001) begin
                    next = st01;
                    led = 3'b001;
                end else if (sw == 3'b000) begin
                    next = IDLE;
                    led = 3'b000;
                end else begin
                    led = 3'b100;
                end
            end
            st04: begin
                if (sw == 3'b100) begin
                    next = st03;
                    led = 3'b100;
                end else begin
                    led = 3'b111;
                end
            end
            default: begin
                next = IDLE;
                led = 3'b000;
            end
        endcase
    end
endmodule
