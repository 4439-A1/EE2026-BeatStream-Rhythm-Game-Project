`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module startup_screen (input basys_clock, input btnc, input btnr, input btnd, input btnl, input btnu, output [7:0] JC);
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
reg [15:0] oled_colour = 16'b00000_000000_00000; //red blue green respectively
reg [3:0] current_state = 0; // 00 = nothing, 01 = btnc, 10 = btnd, 11 = btnr
reg moving  = 0;




assign x = pix_index % 96;  // for 96x64 display
assign y = pix_index / 96;


Oled_Display my_oled_unit(.clk(slow_clock_6p25mhz), .reset(0), .frame_begin(fb), .sending_pixels(sending_pix),
  .sample_pixel(sample_pix), .pixel_index(pix_index), .pixel_data(oled_colour), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
  .pmoden(JC[7]));
  
 
  always @ (posedge slow_clock_25mhz) begin
      if (btnc) begin 
      moving <= 1;
      current_state <= 4'b0001; // Set state for button C
      end
      else if (btnd) begin 
      moving <= 1;
      current_state <= 4'b0010; // Set state for button D
      end
      else if (btnr) begin 
      moving <= 1;
      current_state <= 4'b0011; // Set state for button R
      end
        end
  
  
 always @ (posedge slow_clock_25mhz) begin
 if (moving) begin 

 case (current_state)
  4'b0001: begin // btnc pressed
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
    
    
 4'b0010: begin // btnd pressed
        
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
        
        // Number 2
        ((y==7||y==12||y==18) && x>=88 && x<=93) ||(y>=7&&y<=12&&x==93) || (y>=12&&y<=18&&x==88) ) begin
        oled_colour <= 16'b11111_111111_11111;  // White
    end else begin
        oled_colour <= 16'b0;  // Black
    end
end


 4'b0011: begin // btnr pressed
            
    //diamond
   if ((x>=67 && x<=69 && (y==4 || y==14)) || (x>=66 && x<=70 && (y==5 || y==13)) || (x>=65 && x<=71 && (y==6 || y==12)) || (x>=64 && x<=72 && (y==7 || y==11)) || (x>=63 && x<=73 && (y==8 || y==10)) || (x>=62 && x<=74 && y==9)) begin
    oled_colour <= 16'b00000_000000_11111;  // Blue
    end else begin 
     oled_colour <= 16'b0000000000000000; // black
    end
    
    //tree
    if((x>=37 && x<=43 && y==5) || (x>=36 && x<=44 && y==6) || (x>=35 && x<=45 && y==7) || (x>=34 && x<=46 && y==8) || (x>=33 && x<=47 && y==9) || (x>=32 && x<=48 && y==10) || (x>=31 && x<=49 && y==11)) begin
    oled_colour <= 16'b00000_111111_00000; //green
    end
    else if (x>=38 && x<=42 && y>=12 && y<=15) begin
    oled_colour <= 16'b11111_111111_11111;  // White
    end
    
    //heart
    if((x>=8 && x<=10 && y==5)||(x>=7 && x<=11 && y==6)||(x>=6 && x<=18 && (y==6||y==7||y==8||y==9||y==10))||(x>=7&&x<=17&&y==11)||(x>=8 && x<=16 && y==12)||(x>=9 && x<=15 && y==13)||(x>=10 && x<=14 && y==14)||(x>=11 && x<=13 && y==15)||(x==16 && y==16)||(x>=14 && x<=16 && y==5)||(x>=13 && x<=17 && y==6)) begin
    oled_colour <= 16'b1111100000000000; //red
    end
    
    //speech box
    if((x>=40 && x<=60&&y>=43&&y<=51)||(x>=41&&x<=60&&y==52)||(x>=42&&x<=44&&y==53) ||(x>=43&&x<=44&&y==54)||(x==44&&y==55)) begin
    oled_colour <= 16'b1111111100000000; // yellow 
    end
    
    //door
    if((x>=74 && x<=85&&(y==42||y==59))||(y>=42&&y<=59&&(x==74||x==85))) begin
    oled_colour <= 16'b11111_101100_00000; // orange
    end 
    else if (y>=50 && y<=51 && x==76) begin
    oled_colour <= 16'b10100_011000_00100; // brown
   end
   
   //face 
   if((x>=3 &&x<=21 && ((y>=41&&y<=47)||(y>=49&&y<=52)||(y>=54&&y<=60)))||(((x>=3&&x<=8)||(x>=11&&x<=13)||(x>=16&&x<=21))&&y==48)||(((x>=3&&x<=9)||(x>=15&&x<=21))&&y==53)) begin
   oled_colour <= 16'b11111_000000_11111; // purple
   end 
   else if((((x>=9&&x<=10)||(x>=14&&x<=15))&&y==48)||(x>=10&&x<=14&&y==53)) begin 
   oled_colour <= 16'b00000_000000_11111;  // Blue
   end 
       end 
   
   default: begin // No button pressed
   oled_colour <= 16'b0; // Black
           end
       endcase

 
   end
   end 
endmodule
