`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 21:36:08
// Design Name: 
// Module Name: loading_screen
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


module loading_screen (input basys_clock, output [7:0] JC);
wire slow_clock_6p25mhz;
wire slow_clock_25mhz;
flexible_clock unit_1 (basys_clock, 7, slow_clock_6p25mhz);
flexible_clock unit_3 (basys_clock, 1, slow_clock_25mhz);
wire [12:0] pix_index;
wire fb, sending_pix, sample_pix;
wire [12:0]x;
wire [12:0]y;

reg [12:0]x_var = 0;
reg [12:0]y_var = 0;
reg [15:0] oled_colour = 16'b00000_111111_00000; //red blue green respectively

assign x = pix_index % 96;  // for 96x64 display
assign y = pix_index / 96;

Oled_Display my_oled_unit(.clk(slow_clock_6p25mhz), .reset(0), .frame_begin(fb), .sending_pixels(sending_pix),
  .sample_pixel(sample_pix), .pixel_index(pix_index), .pixel_data(oled_colour), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
  .pmoden(JC[7]));

always @ (posedge slow_clock_25mhz) begin
   if (
        // Letter E
        (x>=1 && x<=5 && (y==7 || y==13 || y==18)) || (y>=7 && y<=18 && x==1) ||
        
        // Letter N
        (x==7 && y>=7 && y<=17) || (x==8 && y>=9 && y<=10) || 
        (x==9 && y>=10 && y<=11) || (x==10 && y>=11 && y<=12) || 
        (x==11 && y>=12 && y<=13) || (x==12 && y>=13 && y<=14) || 
        (x==13 && y>=14 && y<=15) || (x==14 && y>=7 && y<=17) ||
        
        // Letter T
        (x>=16 && x<=21 && y==7) || (x==18 && y>=8 && y<=17) ||
        
        // Letter E
        (y>=7 && y<=18 && x==23) || (x>=24 && x<=27 && (y==7 || y==13 || y==18)) ||
        
        // Letter R
        (x==29 && y>=7 && y<=18) || (x>=30 && x<=33 && y==7) || 
        (x==33 && y>=8 && y<=12) || (x>=30 && x<=32 && y==12) ||
        (x>=30 && x<=31 && y==13) || (x>=31 && x<=32 && y==14) || (x>=32 && x<=33 && y==15) || (x>=33 && x<=34 && y==16) || (x>=34 && x<=35 && y==17) || (x==35 && y==18) ||
        
        // Letter N
        (x==41 && y>=7 && y<=17) || (x==42 && y>=9 && y<=10) || (x==43 && y>=10 && y<=11) || (x==44 && y>=11 && y<=12) || (x==45 && y>=12 && y<=13) || (x==46 && y>=13 && y<=14) || (x==47 && y>=14 && y<=15) || 
        (x==41 && y>=7 && y<=17) || (x==42 && y>=9 && y<=10) || (x==43 && y>=10 && y<=11) || (x==44 && y>=11 && y<=12) || (x==45 && y>=12 && y<=13) || (x==46 && y>=13 && y<=14) || (x==47 && y>=14 && y<=15) || 
        (x==48 && y>=7 && y<=17) ||
        
        // Letter A
        (x==51 && y >= 12 && y <= 18) || (y==12 && x >= 51 && x <= 60) || (x==60 && y >= 12 && y <= 18) ||
        (x==52 && y >= 8 && y <= 11) || (x==59 && y >= 8 && y <= 11) || (x==53 && y >= 7 && y <= 8) || (x==58 && y >= 7 && y <= 8) || (y==7 && x >= 54 && x <= 57) ||
        
        // Letter M 
        (y>=7 && y<=18 && x==62) || (x>=63 && x<=64 && y==7) || (x>=64 && x<=65 && y==8) || (x>=65 && x<=66 && y==9) || (x>=66 && x<=67 && y==10) || (x>=67 && x<=68 && y==11) || 
        (x>=68 && x<=70 && y==12) || (x==69 && y==13) || (x>=70 && x<=71 && y==11) || (x>=71 && x<=71 && y==10) || 
        (x>=72 && x<=73 && y==9) || (x>=73 && x<=74 && y==8) || (x>=74 && x<=75 && y==7) || 
        (y>=7 && y<=18 && x==76) ||
        
        // Letter E
        (x>=78 && x<=82 && (y==7 || y==13 || y==18)) || 
        (y>=7 && y<=18 && x==78) || 
        
        // Number 1
        (y>=7 && y<=18 && x==89) ) begin
        oled_colour <= 16'b11111_111111_11111;  // White
    end else begin
        oled_colour <= 16'b0;  // Black
    end
end
endmodule 
 