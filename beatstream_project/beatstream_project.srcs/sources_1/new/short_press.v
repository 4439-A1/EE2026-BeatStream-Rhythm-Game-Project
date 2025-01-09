`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 08:07:27 PM
// Design Name: 
// Module Name: short_press
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


module short_press(
    input clk,
    input signal,
    output pulses
    );
    
    reg [31:0] count=0;
    reg counting = 0;
    reg signal_prev = 0;
    always @ (posedge clk) begin
        if (signal && ~signal_prev) begin
            counting <= 1;
            count <= 0;
        end
        else if (counting && count < 5000000) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
            counting <= 0;
        end
        signal_prev <= signal;
    end
    
    
    assign pulses = counting;
    
endmodule
