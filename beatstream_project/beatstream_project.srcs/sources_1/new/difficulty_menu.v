`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 18:55:30
// Design Name: 
// Module Name: difficulty_menu
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


module difficulty_menu (input CLOCK, output [7:0] JC);
wire clk6p25m, clk_30Hz;

reg [15:0] oled_data = 16'b00000_000000_00000;
wire p0; wire sample_pix; wire [12:0] pixel_index; wire sending_pixels;
clock_divider divider_6p25MHz (CLOCK, 7, clk6p25m);
clock_divider divider_30Hz (CLOCK, 1666666, clk_30Hz);


wire [6:0] x;
wire [5:0] y;
reg [12:0] x_var = 0;
reg[4:0]state = 5'b00000;
reg moving = 0;
reg [6:0] speed = 1; 
assign x = pixel_index % 96;
assign y = pixel_index / 96;
reg game_flag = 0;
reg menu_flag = 1;
Oled_Display disp (.clk(clk6p25m), .reset(0), .frame_begin(p0), .sending_pixels(sending_pixels),
 .sample_pixel(sample_pix), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
 .pmoden(JC[7]));
 
 
    always @(posedge CLOCK) begin
if((x >= 30 && x <= 37 && y >= 11 && y <= 12) || (x >= 30 && x <= 31 && y >= 13 && y <= 20) ||
(x >= 32 && x <= 35 && y >= 15 && y <= 16) || (x >= 32 && x <= 37 && y >= 19 && y <= 20) || 
(x >= 42 && x <= 45 && y >= 11 && y <= 12) || (x >= 40 && x <= 41 && y >= 13 && y <= 20) ||
(x >= 46 && x <= 47 && y >= 13 && y <= 20) || (x >= 42 && x <= 45 && y >= 15 && y <= 16) ||
(x >= 52 && x <= 57 && y >= 11 && y <= 12) || (x >= 50 && x <= 51 && y >= 13 && y <= 14) ||
(x >= 52 && x <= 55 && y >= 15 && y <= 16) || (x >= 56 && x <= 57 && y >= 17 && y <= 18) ||
(x >= 50 && x <= 55 && y >= 19 && y <= 20) || (x >= 60 && x <= 61 && y >= 11 && y <= 14) ||
(x >= 62 && x <= 67 && y >= 15 && y <= 16) || (x >= 64 && x <= 65 && y >= 17 && y <= 20) ||
(x >= 68 && x <= 69 && y >= 11 && y <= 14) || (x >= 30 && x <= 31 && y >= 43 && y <= 52) || 
(x >= 32 && x <= 35 && y >= 47 && y <= 48) || (x >= 36 && x <= 37 && y >= 43 && y <= 52) || (x >= 42 && x <= 45 && y >= 43 && y <= 44) ||
(x >= 40 && x <= 41 && y >= 45 && y <= 52) || (x >= 46 && x <= 47 && y >= 45 && y <= 52) || 
(x >= 42 && x <= 45 && y >= 47 && y <= 48) || (x >= 50 && x <= 51 && y >= 43 && y <= 52) ||
(x >= 52 && x <= 55 && y >= 43 && y <= 44) || (x >= 56 && x <= 57 && y >= 45 && y <= 46) ||
(x >= 52 && x <= 55 && y >= 47 && y <= 48) || (x >= 54 && x <= 55 && y >= 49 && y <= 50) ||
(x >= 56 && x <= 57 && y >= 51 && y <= 52) || (x >= 60 && x <= 61 && y >= 43 && y <= 52) ||
(x >= 62 && x <= 65 && y >= 43 && y <= 44) || (x >= 62 && x <= 65 && y >= 51 && y <= 53) ||
(x >= 66 && x <= 67 && y >= 45 && y <= 50)) begin
           oled_data <= 16'b0;
end else if((x >= 12 && x <= 85 && (y == 1 || y == 30)) || ((x == 12 || x == 85) && y >= 2 && y <= 29) ||
(x >= 12 && x <= 85 && ( y == 33 || y == 62)) || ((x == 12 || x == 85) && y >= 34 && y <= 61)) begin
           oled_data <= 16'b01101_100001_10001;  // white
end else if (x >= 15 && x <= 82 && y >= 4 && y <= 27) begin
           oled_data <= 16'h0400; //green
end else if(x >= 15 && x <= 82 && y >= 36 && y <= 59) begin
           oled_data <= 16'h9000; //red
        end else begin
           oled_data <= 16'b0;
        end
  end
           
endmodule