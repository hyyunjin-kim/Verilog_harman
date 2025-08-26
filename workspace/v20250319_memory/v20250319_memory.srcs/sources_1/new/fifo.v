`timescale 1ns / 1ps



module fifo(
    input clk,
    input rst,
    // write
    input [7:0] wdata,
    input wr,
    output full,
    // read
    input rd,
    output [7:0] rdata,
    output empty
    );
    
    wire [3:0] waddr, raddr;

    // module instance
        register_file U_reg(
            .clk(clk),
            .waddr(waddr),
            .wdata(wdata),
            .wr({~full&wr}),
            .raddr(raddr),
            .rdata(rdata)
        );

        fifo_control_unit U_FCT(
            .clk(clk),
            .rst(rst),
            //write
            .wr(wr),
            .waddr(waddr),
            .full(full),
            //read
            .rd(rd),
            .raddr(raddr),
            .empty(empty)
        );
    endmodule

    // data path
    module register_file (
        input clk,
        // write
        input [3:0] waddr,
        input [7:0] wdata,
        input wr,
        // read
        input [3:0] raddr,
        output [7:0] rdata
    );

        reg [7:0] mem [0:15] ; // 4bit address

        // write
        always @(posedge clk) begin
            if(wr == 1) begin
                mem[waddr] = wdata;
            end
        end

        // read
        assign rdata = mem[raddr];
    endmodule

    module fifo_control_unit (
        input clk,
        input rst,
        //write
        input wr,
        output [3:0] waddr,
        output full,
        //read
        input rd,
        output [3:0] raddr,
        output empty
    );

        // 1bit 상태 output
        reg full_reg, full_next, empty_reg, empty_next;
        // W,R address 관리
        reg [3:0]wptr_reg, wptr_next, rptr_reg, rptr_next;

        assign waddr = wptr_reg;
        assign raddr = rptr_reg;
        assign full = full_reg;
        assign empty = empty_reg;

        // state
        always @(posedge clk, posedge rst) begin
            if(rst) begin
                full_reg <= 0;
                empty_reg <= 1;  // empty는 초기값 1
                wptr_reg <= 0;
                rptr_reg <= 0;
            end else begin
                full_reg <= full_next;
                empty_reg <= empty_next;
                wptr_reg <= wptr_next;
                rptr_reg <= rptr_next;
            end
        end

        // next
        always @(*) begin
            full_next = full_reg;
            empty_next = empty_reg;
            wptr_next = wptr_reg;
            rptr_next = rptr_reg;
            case ({wr, rd})   // state // 외부에서 입력으로 변경됨.
               2'b01 : begin
                    if(empty_reg == 0) begin
                        rptr_next = rptr_reg + 1;
                        full_next = 1'b0;
                        if(wptr_reg == rptr_next) begin
                            empty_next = 1'b1;
                        end
                    end 
                end
               2'b10 : begin
                    if (full_reg == 1'b0) begin
                         wptr_next = wptr_reg + 1;
                         empty_next = 1'b0;
                         if(wptr_next == rptr_reg) begin
                            full_next = 1'b1;
                         end
                    end
                end
                // 둘 다 1일 때는 pop(read)이 더 크리티컬하다
               2'b11 : begin
                    if (empty_reg == 1'b1) begin
                        wptr_next = wptr_reg + 1;
                        empty_next = 1'b0;
                    end else if (full_reg == 1'b1) begin
                        rptr_next = rptr_reg + 1;
                        full_next = 1'b0;
                    end else begin
                        wptr_next = wptr_reg + 1;
                        rptr_next = rptr_reg + 1;
                    end
               end
            endcase
        end
        
    endmodule