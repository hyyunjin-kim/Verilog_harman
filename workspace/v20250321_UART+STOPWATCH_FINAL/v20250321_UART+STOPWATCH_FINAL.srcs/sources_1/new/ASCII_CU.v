`timescale 1ns / 1ps

module ASCII_CU(
    input clk, rst,
    input [7:0] rx_data,
    input sw_mode,
  //  input rx_rd,
  //  output reg btn_left, btn_right, btn_down,
    output reg btn_run, btn_clear, btn_sec, btn_min, btn_hour,
    input w_rx_empty
    );


    parameter STOP = 2'b000, SEC = 2'b001, MIN = 2'b010, HOUR=2'b011, RUN=3'b100, CLEAR=3'b101;

    reg [2:0] state, next;
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
        if(w_rx_empty) begin     
            empty_data_next = rx_data;
        end else begin
            empty_data_next = 8'hxx;
        end

         if(sw_mode == 1'b1) begin
            case (state)
                STOP : begin
                    if(empty_data_reg == 8'h53 || empty_data_reg == 8'h73) begin
                        next = SEC;
                    end 
                    else if (empty_data_reg == 8'h4D || empty_data_reg == 8'h6D) begin
                        next = MIN;
                    end 
                    else if (empty_data_reg == 8'h48 || empty_data_reg == 8'h68) begin
                        next = HOUR;
                    end
                end
                SEC : begin
                    next = STOP;                   
                end
                MIN : begin                   
                    next = STOP;             
                end
                HOUR : begin                
                    next = STOP;             
                end
            endcase
            end else begin
            if(sw_mode == 1'b0) begin
                case(state)
                    STOP : begin
                        if(empty_data_reg == 8'h52 || empty_data_reg == 8'h72) begin
                            next = RUN;
                        end 
                        else if (empty_data_reg == 8'h43 || empty_data_reg == 8'h63)  begin
                            next = CLEAR;
                        end
                    end
                    RUN : begin
                        if(empty_data_reg == 8'h52 || empty_data_reg == 8'h72) begin
                            next = STOP;
                        end
                    end
                    CLEAR : begin
                        next = STOP;
                    end
                endcase
            end
        end
    end

//     //output
//     always @(*) begin
//         btn_left=0; btn_right=0; btn_down=0;
//         case (state)
//             STOP : begin
//                 btn_left = 1'b0;
//                 btn_down = 1'b0;
//                 btn_right= 1'b0;
//             end 
//             SEC : begin
//                 btn_left = 1'b1;
//                 btn_down = 1'b0;
//                 btn_right= 1'b0;
//             end
//             MIN : begin
//                 btn_left = 1'b0;
//                 btn_down = 1'b1;
//                 btn_right= 1'b0;
//             end
//             HOUR : begin
//                 btn_left = 1'b0;
//                 btn_down = 1'b0;
//                 btn_right= 1'b1;
//             end
//             RUN : begin
//                 btn_left = 1'b1;
//                 btn_right= 1'b0;
//             end
//             CLEAR : begin
//                 btn_left = 1'b0;
//                 btn_right= 1'b1;
//             end
//         endcase
//     end 
// endmodule



    //output
    always @(*) begin
        btn_run=0; btn_clear=0; btn_sec=0; btn_min=0; btn_hour=0;

        case (state)
            STOP : begin
                btn_run=0;
                btn_clear=0;
                btn_sec=0;
                btn_min=0;
                btn_hour=0;
            end 
            SEC : begin
                btn_run=0;
                btn_clear=0;
                btn_sec=1;
                btn_min=0;
                btn_hour=0;
            end
            MIN : begin
                btn_run=0;
                btn_clear=0;
                btn_sec=0;
                btn_min=1;
                btn_hour=0;
            end
            HOUR : begin
                btn_run=0;
                btn_clear=0;
                btn_sec=0;
                btn_min=0;
                btn_hour=1;
            end
            RUN : begin
                btn_run=1;
                btn_clear=0;
                btn_sec=0;
                btn_min=0;
                btn_hour=0;
            end
            CLEAR : begin
                btn_run=0;
                btn_clear=1;
                btn_sec=0;
                btn_min=0;
                btn_hour=0;
            end
        endcase
    end 
endmodule