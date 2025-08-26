`timescale 1ns / 1ps

// 수정 완료

module ASCII_CU(
    input clk, rst,
    input [7:0] rx_data,
    output reg btn_start,

    input w_rx_empty
    );


    parameter STOP = 1'b0, START = 1'b1;

    reg state, next;
    reg [7:0] empty_data_next, empty_data_reg;

    // state register
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            state <= STOP;
            empty_data_reg <=0 ;
        end else begin
            state <= next;
            empty_data_reg <= empty_data_next;
        end
    end

    // next
    always @(*) begin
        next = state;
        empty_data_next = empty_data_reg;
        if(~w_rx_empty) begin     
            empty_data_next = rx_data;
        end else begin
            empty_data_next = 8'hxx;
        end

        case (state)
            STOP : begin
                if(empty_data_reg == "U" || empty_data_reg == "u") begin
                    next = START;
                end 
            end
            START : begin
                next = STOP;
            end
        endcase
    end

    //output
    always @(*) begin
        btn_start = 0;
        case (state)
            STOP : begin
                btn_start=0;
            end 
            START : begin
                btn_start=1;
            end
        endcase
    end 
endmodule