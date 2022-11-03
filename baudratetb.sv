`timescale 1ns / 1ps

module baudratetb();
    reg rst,clk;
    wire tick;
    wire [11:0]q;
    baudrate m(.*);
    initial begin
        clk = 1;
        rst = 1;
        #10 rst = 0;
        
        #1000000 $finish; 
    end 
    always #10 clk = ~clk;
endmodule
