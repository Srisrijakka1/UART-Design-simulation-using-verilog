`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2022 19:49:17
// Design Name: 
// Module Name: uart_rx
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
//----block states------//
`define idle 3'b000
`define start 3'b001
`define trans 3'b010
`define stop 3'b011
//--------------------//
module uart_rx(
    input clk,rst,rxd,
    output reg rxd_done,tick,
    output wire [7:0]data_out
    );
    reg [2:0]ps,ns; //procedural assignment so reg  
    reg [7:0]sbuf_reg,sbuf_next;
    reg [3:0]count_reg,count_next;
    
    //to generate tick
    wire tick;
    wire [11:0]q;
    baudrate m(.*);
     
    //FSM = Memory + next state & o/p block
    //Memory block
    always@(posedge clk) begin
        if(rst) begin //initilise all
            ps = `idle;
            sbuf_reg = 0;
            count_reg = 0;
        end
        else begin
            ps = ns;
            sbuf_reg = sbuf_next;
            count_reg = count_next;
        end
    end
    //next statw block & o/p block of FSM
    always@(*) begin
        //next state declaration
        ns =  ps;
        sbuf_next = sbuf_reg;
        count_next = count_reg;
        //states declaration for o/p block
     end
     always@(posedge tick) begin
        case(ps)
            `idle: begin
                $display($time,"---in idle state----");//to watch the o/p in tcl console use display to print
//                data_out = 0; //nothing data will be sent as o/p now
                rxd_done = 0; //receiving action is not done till now 
                //since for asynchronous data formate = 0(start bit) + data + 1(stopbit)
                if(rxd == 1) begin 
                    //1 is a stop bit so rxd_done is finished
                end
                else if(rxd == 0) begin
                    //0 is start bit so state changes to start state
                    ns = `start;
                    $display($time,"---state changes from idle to start state----");//to display state change
                    
                end
            end
            `start: begin 
                $display($time,"---in start state----");//to watch the o/p in tcl console use display to print
                if(tick) begin
                    count_next = 0;
                    ns = `trans;
                    sbuf_next = {rxd,sbuf_reg[7:1]};  // to save 1st bit
                    $display($time,"---state changes from start to trans state----");//to display state change
                end
            end
            `trans: begin 
                    $display($time,"---in Trans state----",sbuf_next," ",rxd);//to watch the o/p in tcl console use display to print                if(tick) begin
                    sbuf_next = {rxd,sbuf_reg[7:1]}; // to save other 7bits
                    $display("sbuf_next>>%b",sbuf_next);
                    count_next = count_reg +1;
                if(count_reg == 6) begin
                    ns = `stop;
                    $display($time,"---state changes from trans to stop state----");
                end 
//                else begin
//                    count_next = count_reg +1;
//                end
            end
            `stop: begin
                $display($time,"---in stop state----");
                if(tick) begin
                    rxd_done = 1;
                    ns =`idle;
                    $display($time,"---state changes from stop to idle state----");
//                    $stop;
                end
            end 
            default: begin
                $display("Default case");
                ns = `idle;
            end
        endcase    
    end
    assign data_out = sbuf_reg;
    initial begin
        $display("%h",data_out);
    end
endmodule
