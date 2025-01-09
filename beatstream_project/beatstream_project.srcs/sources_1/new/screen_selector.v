`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 06:26:18 AM
// Design Name: 
// Module Name: screen_selector
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


module screen_selector(
//    input key_s,
    input clk,
    input endscreen,
    input enter,
    input space,
    input [25:0] abc,
    input lshift,
    input up, down, left, right,
    output reg [31:0] screen_sel=0,
    output reg pause=0
    );

reg upprev=0, downprev=0, enterprev=0;
wire p;
assign p = abc[15];

reg p_prev = 0;
always @ (posedge clk) begin
    case(screen_sel)
        0: begin // menu screen
            if (~upprev && up) begin
                screen_sel <= 1;
            end
            if (~downprev && down) begin // g and lshift -> startup
                screen_sel <= 2;
            end
        end
        1: begin //difficulty selection
            if (~upprev && up) begin
                screen_sel <= 3;
            end
            if (~downprev && down) begin
                screen_sel <= 4;
            end
            else if (lshift && space) begin
                screen_sel <= 0;
            end
        end
        2: begin // startup screen
            if (space && lshift) begin
                screen_sel <= 0;
            end
            if (enter) begin
                screen_sel <= 8;
            end
        end
        3: begin // game 1 screen
            if (space && lshift) begin
                screen_sel <= 0;
            end
            if (endscreen) begin
                screen_sel <= 5;
            end
            if (p && ~p_prev) begin
                screen_sel <= 6;
                pause <= 1;
            end
        end
        4: begin // game 2 screen
            if (space && lshift) begin
                screen_sel <= 0;
            end
            if (p && ~p_prev) begin
                screen_sel <= 7;
                pause <= 1;
            end
            if (endscreen) begin
                screen_sel <= 5;
            end
        end
        5: begin // end screen
            if (lshift && space) begin
                screen_sel <= 0;
            end
        end
        6: begin // pause screen 1
            if (p && ~p_prev || right) begin
                pause <= 0;
                screen_sel <= 3;
            end
            else if (left) begin
                pause <= 0;
                screen_sel <= 0;
            end
            else if (enter) begin
                pause <= 0;
                screen_sel <= 1;
            end
            else if (lshift && space) begin
                pause <= 0;
                screen_sel <= 0;
            end
        end
        7: begin // pause screen 2
            if (p && ~p_prev || right) begin
                pause <= 0;
                screen_sel <= 4;
            end
            else if (left) begin
                pause <= 0;
                screen_sel <= 0;
            end
            else if (enter) begin
                pause <= 0;
                screen_sel <= 1;
            end
            else if (lshift && space) begin
                pause <= 0;
                screen_sel <= 0;
            end
        end
        8: begin // loading screen
            if (lshift && space) begin
                screen_sel <= 0;
            end
            if (enter && ~enterprev) begin
                screen_sel <= 9;
            end
        end
        9: begin
            if (lshift && space) begin
                screen_sel <= 0;
            end
        end
        
    endcase
    downprev <= down;
    upprev <= up;
    p_prev <= p;
end
  
//always @ (posedge clk) begin
//    case(screen_sel)
//        0: begin
//            if (sw[0]) begin
//                screen_sel <= 1;
//            end
//            if (sw[1]) begin
//                screen_sel <= 2;
//            end
//        end
//        1: begin
//            if (sw[2]) begin
//                screen_sel <= 0;
//            end
//        end
//        2: begin
//            if (sw[2]) begin
//                screen_sel <= 0;
//            end
//        end
//    endcase
//end
    
endmodule
