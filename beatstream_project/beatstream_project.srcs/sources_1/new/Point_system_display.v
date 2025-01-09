`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 19:24:42
// Design Name: 
// Module Name: Point_system_display
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

// btnD = perfect, btnR = good, btnL = bad

module Point_system_display(input basys_clock,input btnu, input btnd, input btnl,
 input btnr, output reg [3:0] an, output reg [6:0] seg);

    wire slow_clock_1khz;
    flexible_clock unit_0 (basys_clock, 50000, slow_clock_1khz);
   
reg [14:0] total_points = 0; // Total points (up to 9999)
reg [14:0] temp = 0;
        reg [3:0] digit; // Current digit to display
        reg [1:0] count = 0; // Counter for anode selection
   reg btnu_stable, btnd_stable, btnl_stable, btnr_stable;
           reg btnu_prev, btnd_prev, btnl_prev, btnr_prev;  
        always @(posedge  slow_clock_1khz ) begin
btnu_stable <= (btnu && !btnu_prev) ? 1 : 0;
                btnd_stable <= (btnd && !btnd_prev) ? 1 : 0;
                btnl_stable <= (btnl && !btnl_prev) ? 1 : 0;
                btnr_stable <= (btnr && !btnr_prev) ? 1 : 0;
                
                btnu_prev <= btnu;
                btnd_prev <= btnd;
                btnl_prev <= btnl;
                btnr_prev <= btnr;
        
                // Increment total points based on stable button presses
                if (btnu_stable) begin
                     total_points <= 0;
                end
//                else if (~btnu && btnu_prev) begin
//                    total_points <= 0;
//                end
                else if (btnd_stable) begin 
                total_points <= (total_points + 5 > 9999) ? 9999 : total_points + 5; // Perfect
                end 
                else if (btnr_stable)begin 
                total_points <= (total_points + 3 > 9999) ? 9999 : total_points + 3; // Good
                end 
                else if (btnl_stable) begin 
                 total_points <= (total_points + 1 > 9999) ? 9999 : total_points + 1; // Bad
                 end 
                
                

            count <= count + 1;
    
            // Control anodes and segments based on the count
            temp = total_points;
            case (count)
                2'b00: begin
                    an <= 4'b1110; // Activate first anode
                    digit <= temp % 10; // Extract last digit
                end
                2'b01: begin
                    an <= 4'b1101; // Activate second anode
                    digit <= (temp / 10) % 10; // Extract 2nd last digit
                end
                2'b10: begin
                    an <= 4'b1011; // Activate third anode
                    digit <= (temp / 100) % 10; // Extract 3rd last digit
                end
                2'b11: begin
                    an <= 4'b0111; // Activate fourth anode
                    digit <= (temp / 1000) % 10; // Extract 1st digit
                end
            endcase
            
            // Update segment based on the current digit
            case (digit)
                4'd0: seg <= 7'b1000000; // 0
                4'd1: seg <= 7'b1111001; // 1
                4'd2: seg <= 7'b0100100; // 2
                4'd3: seg <= 7'b0110000; // 3
                4'd4: seg <= 7'b0011001; // 4
                4'd5: seg <= 7'b0010010; // 5
                4'd6: seg <= 7'b0000010; // 6
                4'd7: seg <= 7'b1111000; // 7
                4'd8: seg <= 7'b0000000; // 8
                4'd9: seg <= 7'b0010000; // 9
                default: seg <= 7'b1111111; // Off
            endcase
        end
    endmodule
