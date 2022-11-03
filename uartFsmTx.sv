`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2022 18:15:41
// Design Name: 
// Module Name: uartFsmTx
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
//-----define states-------//
`define idle 3'b000
`define start 3'b001
`define trans 3'b010
`define stop 3'b011
//------------------------//
module uartFsmTx(
    input wire clk,rst,tx_start,
    input wire [7:0]data_in,    //txd = data o/p
    output txd,tx_done
    );
    wire txd;//assign sta
    reg tx_done; 
    reg [2:0]ps,ns;
    reg [7:0]sbuf_reg ,sbuf_next;
    reg [0:2]count_reg , count_next;
    reg tx_reg , tx_next;
    
    wire tick;//need to generate it
    wire [11:0]q;
    baudrate m(.*);
    //Every FSM has 3 blocks: Memory block,nextstate block,o/p block
    //------Memory of FSM-----------//
    always@(posedge clk) begin
        if(rst == 1) begin //----Initiallising idle conditions ---------//
                ps = `idle;
                sbuf_reg = 0;
                count_reg = 0;
                tx_reg = 0;
        end
        else begin //----changing present state to next state----//
                ps = ns;
//                $display("sbuf>reg,next",sbuf_reg,sbuf_next);
                sbuf_reg = sbuf_next;
                count_reg = count_next;
                tx_reg = tx_next;
            end
    end
    //-----End of memory block ------//
    //Next state &o/p blocks of FSM
    always@(*) begin 
        //Next state of FSM
        ns = ps;
        sbuf_next = sbuf_reg;
        count_next = count_reg;
        tx_next = tx_reg;
        //o/p blocks of FSM
        case(ps) 
            `idle: begin
                    $display($time,"------in idle state------");
                    tx_next = 1;
                    tx_done = 0;
                    if(tick && tx_start == 1) begin
                        ns = `start;
                        $display($time,"----idle state to start state----");
                    end
             end
             `start: begin
                tx_next = 0; // start bit
                $display($time,"------in start state------");
                if(tick) begin
                    sbuf_next = data_in;
                    count_next = 0;
                    ns = `trans;
                    $display($time,"---- start to trans state----,sbuf_reg = %b",sbuf_reg);
                end
              end
              `trans: begin
                    tx_next = sbuf_reg[0];
                    $display($time,"------in trans state------ %b",tx_next,sbuf_reg);
                    if(tick) begin
                        sbuf_next = sbuf_reg>>1;
                        $display(sbuf_reg,"sbuf>>1",sbuf_next);
                        if(count_reg == 7) begin
                            ns = `stop;
                            $display($time,"------trans to stop state------");
                        end
                        else
                            $display("count_reg = %d and txd = %d,sbuf_next = %b",count_reg,txd,sbuf_next);
                            count_reg = count_reg +1;
                    end
              end
              `stop: begin
              $display($time,"------in stop state------");
                tx_next = 1;
                if(tick) begin
                    tx_done = 1;
                    ns = `idle;
                    $stop;
                end
              end
              default: ns= `idle;
         endcase
    end
    assign txd = tx_reg;
    
endmodule
