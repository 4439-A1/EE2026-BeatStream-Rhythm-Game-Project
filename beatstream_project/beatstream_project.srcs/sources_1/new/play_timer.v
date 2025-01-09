`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 22:21:36
// Design Name: 
// Module Name: play_timer
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


module play_timer(
    input playing,
    input clk_20Hz,
    output reg [13:0] counter=0,
    output reg ticker=0
    ,input pause
    );
    
    always @ (posedge clk_20Hz) begin
        
        if (pause) begin
            counter <= counter;
            ticker <= ticker;
        end else
        if (playing) begin
            counter <= counter + 1;
            ticker <= ~ticker;
        end
        else begin
            counter <= 0;
        end
    end
    
endmodule
