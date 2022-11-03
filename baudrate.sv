`timescale 1ns / 1ps
module baudrate(
    input wire clk,rst,
    output reg [11:0]q,
    output reg tick
    );
    always@(posedge clk) begin
//        $display("ss time = %d,clk = %d,q = %d,rst = %d,tick = %d",$time,clk,q,rst,tick);
        if(rst) begin
            q = 0;
        end
        else begin
            q = (q==2604) ? 0 : q+1;
            if(q==2604) 
                $display("q reached 2604");
        end
    end
    always@(*) begin
        if(q==2604) 
            $display("tick pulse generates");
        tick = (q==2604) ? 1 : 0 ;
    end 
endmodule
