`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2019 10:14:07 PM
// Design Name: 
// Module Name: boadRateGen
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


module boadRateGen#(parameter SYSCLK = 10000000, BAUD = 115200, OSR = 16)
                  (input  CLK, RST,
                   output reg Rx_CLK,Tx_CLK);

    localparam clkPerBd = SYSCLK/(BAUD),
               rxCLKprd = clkPerBd/OSR;
    
    //reg [$clog2(rxCLKprd) : 0]countRX;
    reg [$clog2(clkPerBd) : 0]countTX;
    reg [8 : 0]countRX;
    //reg [8 : 0]countTX;
    always@(posedge CLK or posedge RST)begin
        if(RST) begin 
        Rx_CLK <= 0;
        Tx_CLK <= 0;
        countRX <= 0;
        countTX <= 0;
        end
        else if(countRX > ((rxCLKprd/2) -1)) begin 
            if(countTX > ((clkPerBd/2) -1)) begin 
                Tx_CLK <= ~Tx_CLK;
                countTX <= 0;
            end else begin
                countTX <= countTX+1;
            end
            Rx_CLK <= ~Rx_CLK;
            countRX <= 0;
        end else begin
            if(countTX > ((clkPerBd/2) -1)) begin 
                Tx_CLK <= ~Tx_CLK;
                countTX <= 0;
            end else begin
                countTX <= countTX+1;
            end
            countRX <= countRX+1;
        end
    end

    


endmodule
