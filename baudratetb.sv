`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2022 15:14:04
// Design Name: 
// Module Name: baudratetb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
