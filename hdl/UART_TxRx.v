`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2019 07:56:15 PM
// Design Name: 
// Module Name: UART_TxRx
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


module UART_TxRx #(parameter SYSCLK = 10000000, BAUD = 115200, OSR = 16)
                  (input  CLK, RX, RST,txStart,
                   input  [7 : 0]TXData,
                   output txOut,rcvFlag,CTS,
                   output [7 : 0]rxOut);   
                   
    wire Rx_CLK,Tx_CLK;
    boadRateGen #( .BAUD(9600), .OSR(16)) BRG01 (.CLK(CLK), .RST(RST), .Rx_CLK(Rx_CLK),.Tx_CLK(Tx_CLK));

    Reciever #(.OSR(OSR)) RX01 (.CLK(Rx_CLK),.RST(RST), .RX(RX)  , .rcvFalg(rcvFlag), .rxOut(rxOut));
    Transmiter TX01 (.CLK(Tx_CLK),.RST(RST), .CTS(CTS), .txStart(txStart), .TXData(TXData),.txOut(txOut));
    
endmodule
