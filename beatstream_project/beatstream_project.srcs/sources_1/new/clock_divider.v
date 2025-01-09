`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2024 14:07:30
// Design Name: 
// Module Name: flexible_clock
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



module clock_divider(input CLOCK, input [31:0] frequency, output reg SLOW_CLOCK = 0);     
    reg [31:0] COUNT = 0;
    always @ (posedge CLOCK) 
    begin
        COUNT <= (COUNT == frequency) ? 0: COUNT + 1;
        SLOW_CLOCK <= ( COUNT == frequency ) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
    
endmodule