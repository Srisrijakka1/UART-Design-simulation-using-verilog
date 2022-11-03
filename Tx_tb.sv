`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2022 16:39:38
// Design Name: 
// Module Name: Tx_tb
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


module Tx_tb();
//    reg
    logic clk,rst,tx_start;
//    reg
    logic [7:0]data_in;    //txd = data o/p
//    wire
    logic txd,tx_done;
    //instantation
    uartFsmTx m(.*);
    //Driver stimulus
    initial begin
        clk = 0;
        rst = 1; //if part
        #10 rst = 0;//else
        #40 tx_start = 1;
        data_in = 8'haa;//1010_1010
        
        #1000000 $finish;
    end
    
    always #9 clk = ~clk;//togling clk every 10 ns//t = 20ns> f=50MHz
endmodule
