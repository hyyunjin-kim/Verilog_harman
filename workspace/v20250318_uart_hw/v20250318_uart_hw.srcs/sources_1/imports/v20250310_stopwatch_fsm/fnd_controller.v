`timescale 1ns / 1ps

module fnd_controller(
    input [7:0] tx_pc,

    output reg [7:0] fnd_font,
    output [3:0] fnd_comm
);
    assign fnd_comm = 4'b1110;


    // always구문은 출력으로 wire가 될 수 없음. 항상 reg type을 가져야 한다. 
    always @(tx_pc) begin // 항상 대상이벤트를 감시
        case(tx_pc) //case문 안에서 assign문 사용안함
            8'h30: fnd_font = 8'hc0; //8비트의 헥사c0값
            8'h31: fnd_font = 8'hF9;
            8'h32: fnd_font = 8'hA4;
            8'h33: fnd_font = 8'hB0;
            8'h34: fnd_font = 8'h99;
            8'h35: fnd_font = 8'h92;
            8'h36: fnd_font = 8'h82;
            8'h37: fnd_font = 8'hf8;
            8'h38: fnd_font = 8'h80;
            8'h39: fnd_font = 8'h90;
            8'h41: fnd_font = 8'h88;
            8'h42: fnd_font = 8'h00;
            8'h43: fnd_font = 8'hc6;
            8'h44: fnd_font = 8'h40;
            8'h45: fnd_font = 8'h86; 
            8'h46: fnd_font = 8'h8E; 
        default: fnd_font = 8'hff;
        endcase
    end

endmodule