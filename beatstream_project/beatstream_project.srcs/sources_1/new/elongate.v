`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 01:52:10 AM
// Design Name: 
// Module Name: elongate
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


module elongate(
    input clk,
    input signal,
    output reg elong_signal=0
    );
    
    // elongate a bit to show led
    reg [31:0] elong_counter=0;
    always @ (posedge clk) begin
        if (elong_counter == 0 && signal && ~elong_signal) begin
            elong_signal <= 1;
        end
        else if (elong_signal) begin
            elong_counter <= elong_counter + 1;
            if (elong_counter == 20000000) begin
                elong_signal <= 0;
            end
        end
        else begin
            elong_counter <= 0;
        end
    end
endmodule
