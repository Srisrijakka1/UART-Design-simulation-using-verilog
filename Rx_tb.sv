`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2022 23:07:25
// Design Name: 
// Module Name: Rx_tb
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


module Rx_tb();
    reg clk,rst,rxd;
    wire rxd_done,tick;
    wire [7:0]data_out;
    
    //module instantation
    uart_rx m(.*);
    
    //Driver stimulus
    initial begin
        clk = 0;
        #11 rst = 1;
        #22 rst = 0;
        #25 rxd = 0; 
       // to start process
       rdata(0); // start bit
       $display("---Start BIT--");
       rdata(1);
       $display("---rdata1 -----%b",data_out);
       rdata(0);
       $display("---rdata2 -----");
       rdata(1);
       $display("---rdata3 -----");
       rdata(0);
       $display("---rdata4 -----");
       rdata(1);
       $display("---rdata5 -----");
       rdata(0);
       $display("---rdata6 -----");
       rdata(1);
       $display("---rdata7 -----");
       rdata(0);
       $display("---rdata8 -----");
//       rdata(1);
       $display("--STOP BIT--");
       $display("in tb = %h",data_out);
       $stop;
    end
    
    always #10 clk = ~clk;
    
    task rdata;
        input inp;
        begin
            @(posedge tick) begin
                rxd = inp;
                $display("---supply data--");
            end
        end
    endtask
endmodule
