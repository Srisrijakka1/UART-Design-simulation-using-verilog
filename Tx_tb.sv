`timescale 1ns / 1ps
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
