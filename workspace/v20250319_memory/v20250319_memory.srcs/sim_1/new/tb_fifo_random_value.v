`timescale 1ns / 1ps

module tb_fifo_random_value();

    reg clk;
    reg rst;
    // write
    reg [7:0] wdata;
    reg wr;
    wire full;
    // read
    reg rd;
    wire [7:0] rdata;
    wire empty;

    fifo U_fifo (
     .clk(clk),
     .rst(rst),
    // write
     .wdata(wdata),
     .wr(wr),
     .full(full),
    // read
     .rd(rd),
     .rdata(rdata),
     .empty(empty)
    );

    always #5 clk = ~clk;
    integer i;

    reg rand_rd;    // integer는 범위 설정을 안하면 항상 32bit로 들어간다.
    reg rand_wr;
    integer write_count;
    integer read_count;
    reg [7:0]compare_data[2**4-1 : 0];  //16byte

    initial begin
        clk = 0;
        rst =1;
        wdata =0;
        wr =0;
        rd =0;
        #10 ;
        rst =0;
        #10;
        
        // 쓰기 , full test
        wr =1;
        for(i=0; i<17; i=i+1) begin
            wdata = i;
            #10;
        end

        // 읽기 , empty test
        wr = 0;
        rd = 1;
        for(i=0; i<17; i=i+1) begin
            #10;
        end
        wr = 0;
        rd = 0;
        #10;

        // 동시 읽고 쓰기
        wr = 1;
        rd = 1;
        for(i=0; i<17; i=i+1) begin
            wdata = i*2+1;
            #10;
        end

        wr = 0;
        #10;  
        rd = 0;
        #20;    // empty 만들고 delay
        write_count = 0;
        read_count = 0;

        for(i=0; i<50; i=i+1) begin
            @(negedge clk);            // 쓰기 wdata를 negedge에서 시작하기 위함.
            rand_wr = $random%2;       // wr 랜덤으로 1,0 만들기
            if(~full&rand_wr) begin    // full 아니면서 wr이 1일때만 새로운 wdata 생성.
                wdata = $random%256;   // 256 = 1byte? = 8bit 아 보내는 데이터가 8bit이다. // random값 생성
                compare_data[write_count%16] = wdata;  // read data와 비교하기 위함
                write_count = write_count + 1;
                wr = 1;
            end else begin
                wr = 0;
            end
            
            rand_rd = $random%2;      // rd random으로 생성 0,1
            if (~empty&rand_rd) begin // read test
                rd = 1;
                #2;
                if(rdata == compare_data[read_count%16]) begin
                    $display("pass");
                end else begin
                    $display("fail : rdata = %h, compare_data=%h", rdata, compare_data[read_count%16]);
                end
                read_count = read_count + 1;
            end else begin
                rd = 0;
            end
        end
    end
endmodule
