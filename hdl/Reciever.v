`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2019 10:30:11 PM
// Design Name: 
// Module Name: Reciever
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


module Reciever #(parameter OSR = 16)( input CLK, RST, RX, 
                  output reg rcvFalg,
                  output reg [7 : 0]rxOut);
                  
    // FSM
    localparam 
        idle       = 2'b00,
        checkStart = 2'b01,
        recieve    = 2'b10,
        checkStop  = 2'b11;
    
    reg [1 : 0]STATE;
    reg [$clog2(OSR) : 0]overSampleCount; // change 3 to log2(osr);
    reg [3 : 0]rxCount;
    reg ldData,ld;//,ERROR;
    
    always@(posedge CLK or posedge RST ) begin
        if(RST)begin
            STATE <= idle;
            overSampleCount <= 0;
            rxCount <= 0;
            ld <= 0;
            rcvFalg <= 0;
            ldData  <= 0;
//            ERROR <= 0;
        end
        else begin
            case(STATE)
            idle:begin
                if(RX == 0)begin
                    rcvFalg <= 0;
                    STATE <= checkStart;
                    overSampleCount <= 0;
                end
                else begin
                    rcvFalg <= 0;
                    STATE <= idle;
                    overSampleCount <= 0;
                end            
            end
            checkStart:begin
                if(overSampleCount >= (OSR/2)-1) begin
                    STATE <= (RX)? idle : recieve;
                    overSampleCount <= 0;
                    rxCount <= 0;
                end
                else begin 
                    STATE <= checkStart;
                    overSampleCount <= overSampleCount + 1;
                end
            end
            recieve:begin
                if(rxCount > 7)begin
                    STATE <= checkStop;
                    ld <= 0;
                    overSampleCount <= 1;
                    rxCount <= 0;
                end else
                if(overSampleCount >= OSR-1) begin
                    ldData <= RX;
                    ld <= 1;
                    rxCount <= rxCount + 1;
                    overSampleCount <= 0;
                    STATE <= recieve;
                end
                else begin
                    ld <= 0;
                    STATE <= recieve;
                    overSampleCount <= overSampleCount + 1;
                end    
            end
            checkStop:begin
                if(overSampleCount >= (OSR)-1) begin
  //                  ERROR <= (countLow >= (OSR/2))? 1 : 0;
                    STATE <= idle;
                    overSampleCount <= 0;
                    rxCount <= 0;
                    rcvFalg <= 1;
                end
                else begin 
                    STATE <= checkStop;
                    overSampleCount <= overSampleCount + 1;
                end     
            end
            default:begin end
            endcase
        end
    end
  
    
    //out buffer
    always@(posedge CLK)begin
        if(ld) begin
            rxOut[rxCount - 1] = ldData;
        end
    end
    
endmodule
