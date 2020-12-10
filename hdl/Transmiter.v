`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2019 10:30:11 PM
// Design Name: 
// Module Name: Transmiter
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


module Transmiter ( input CLK, RST, txStart,
                     input [7 : 0]TXData,
                     output txOut, reg CTS);
   
    //FSM for gereating CTS
    localparam waiting = 0, transmiting = 1;
    reg STATE;
    reg [3 : 0]TxCounter;
    
    always@(posedge CLK or posedge RST )begin
    if(RST) begin
        STATE     <= waiting;
        TxCounter <= 0;
        CTS       <= 1;
    end 
    else begin
        case(STATE)
            waiting     :begin
                if(txStart)begin
                    STATE     <= transmiting;
                    TxCounter <= 0;
                    CTS       <= 0;
                end
                else begin
                    STATE     <= waiting;
                    TxCounter <= 0;
                    CTS       <= 1;
                end
            end
            transmiting :begin
            // may need to change to TxCounter > 6 to fix timing error
                if(TxCounter > 7)begin 
                    STATE     <= waiting;
                    TxCounter <= 0;
                    CTS       <= 1;
                end
                else begin
                    STATE     <= transmiting;
                    TxCounter <= TxCounter + 1;
                    CTS       <= 0;
                end
            end
            default     :begin end 
        endcase
    end
    end
    //End FSM for gereating CTS
     
    //Transmit Unit
    localparam startBit = 1'b0,
               stopBit  = 1'b1;     

    reg signed [9:0]ShftReg; 
    always@(posedge CLK or posedge RST ) 
	begin
	    if(RST) begin
            ShftReg <= 10'b1111111111;
        end
		else if(txStart && CTS)ShftReg <= {stopBit,TXData,startBit};
		else ShftReg <= ShftReg >>> 1;
	end
    assign txOut = ShftReg[0];
    //End Transmit Unit
    
endmodule
