`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 00:25:39
// Design Name: 
// Module Name: single_note
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


module single_note(
    input clk,
    input [31:0] tone_freq,  
    output reg audio_out,
    output amp_enable
);

parameter CLOCK_FREQ = 100000000; 

reg [31:0] counter;
reg [31:0] half_period;

assign amp_enable = 1;

always @(*) begin
    half_period = CLOCK_FREQ / (tone_freq * 2);
end

// Generate square wave tone
always @(posedge clk) begin
    if (counter >= half_period) begin
        counter <= 0;
        audio_out <= ~audio_out;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
