`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 23:25:07
// Design Name: 
// Module Name: end_screen
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


module end_screen(input basys_clock,output [7:0] JC);
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
  
always @(posedge slow_clock_25mhz) begin 
if((x>=12&&x<=24&&y==23)||((x==12||x==24)&&y>=24&&y<=33)||(x==13&&y==34)||(x==14&&y==35)||
(x==15&&y==36)||(x==16&&y==37)||(x==23&&y==34)||(x==22&&y==35)||(x==21&&y==36)||(x==20&&y==37)||
(x>=17&&x<=19&&y==38)||((x==17||x==19)&&y>=38&&y<=49)||(y==49&&x>=15&&x<=16)||(x>=20&&x<=21&&y==49)||
(x==14&&y==50)||(x==22&&y==50)||(y==51&&x>=13&&x<=23)) begin //trophy outline 
oled_colour <= 16'b11111_111111_11111; // white 
end 

else if((x>=13&&x<=22&&y>=24&&y<=25)||(y>=26&&y<=32&&x==13)||(x>=16&&x<=23&&y>=26&&y<=32)||
(x>=13&&x<=22&&y==33)||(x>=14&&x<=21&&y==34)||(x>=15&&x<=20&&y==35)||(x>=16&&x<=19&&y==36)||
(x>=17&&x<=18&&y==37)||(x==18&&y>=39&&y<=49)||(x>=15&&x<=21&&y==50)) begin //interior
oled_colour <= 16'b11111_111111_00000; // Light yellow
end 

else if ((x==23&&y>=24&&y<=33)||(x==22&&y==34)||(x==21&&y==35)||(x==20&&y==36)||(x==19&&y==37)) begin 
oled_colour <= 16'b10101_101010_00000; // Dark yellow
end 

else if(x>=14&&x<=15&&y>=26&&y<=32) begin //interior shade
oled_colour <= 16'b11111_111111_11111; // white 
end 

else if((x>=25&&x<=28&&y==26)||(x==28&&y>=26&&y<=30)||(x==27&&x<=28&y==30)||(x>=25&&x<=27&&y==31)
||(y==26&&x>=8&&x<=11)||(x==8&&y>=26&&y<=30)||(x>=8&&x<=9&&y==30)||
(y==31&&x>=9&&x<=11)) begin //outline of trophy handle
oled_colour <= 16'b11111_111111_11111; // white 
end 

else if((x>=9&&x<=11&&y>=27&&y<=29)||(x>=10&&x<=11&&y==30)||(x>=25&&x<=27&&y>=27&&y<=29)||
(y==30&&y>=25&&y<=26)) begin  //handle interior 
oled_colour <= 16'b11111_111111_00000; // Light yellow
end 

else if((x>=8&&x<=90&&(y==2||y==13))||(y>=2&&y<=13&&(x==8||x==90))) begin //for the enter name part 
oled_colour <= 16'b11111_111111_11111; // white outline 
//name 
//icon 
end 

else if(((y==26||y==30||y==28)&&x>=50&&x<=52)||(x==53&&(y==27||y==29))||(y>=26&&y<=30&&x==50)) begin 
oled_colour <= 16'b11111_111111_11111; // B
end 
else if((y>=26&&y<=30&&x==55)||(x>=55&&x<=58&&(y==26||y==28||y==30))) begin
oled_colour <= 16'b11111_111111_11111; // E
end else if((x>=60&&x<=64&&y==26)||(y>=26&&y<=30&&x==62)) begin 
oled_colour <= 16'b11111_111111_11111; // T
end else if((x>=66&&x<=70&&y==26)||(y>=26&&y<=30&&x==68)) begin 
oled_colour <= 16'b11111_111111_11111; // T
end else if((y>=26&&y<=30&&x==72)||(x>=72&&x<=75&&(y==26||y==28||y==30))) begin
oled_colour <= 16'b11111_111111_11111; // E
end else if((x==77&&y>=26&&y<=30)||((y==26||y==28)&&x>=77&&x<=79)||(x==80&&y==27)||
(x==79&&y==29)||(x==80&&y==30))begin 
oled_colour <= 16'b11111_111111_11111; // R
end else if ((x==50&&y>=32&&y<=36)||(x>=50&&x<=53&&y==36)) begin 
oled_colour <= 16'b11111_111111_11111; // L
end else if ((y>=32&&y<=35&&(x==55||x==58))||(x>=56&&x<=57&&y==36))begin 
oled_colour <= 16'b11111_111111_11111; // U
end else if((x>=61&&x<=62&&(y==32||y==36))||(y>=33&&y<=35&&x==60)||(x==63&&y==33)||(x==63&&y==35)) begin
oled_colour <= 16'b11111_111111_11111; // C
end else if((x==65&&y>=32&&y<=36)||(x==66&&y==34)||(x==67&&y==33)||(x==68&&y==32)||(x==67&&y==35)||
(x==68&&y==36))begin 
oled_colour <= 16'b11111_111111_11111; // K
end 

else begin 
oled_colour <= 16'b00000_000000_00000; // Black
end 




end 
endmodule
