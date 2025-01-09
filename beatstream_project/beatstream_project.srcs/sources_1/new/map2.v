module map2(
    input CLOCK,
	input reset,
	input pause,
	input perfect, good, bad, miss,
	input [30:0] missedflag,
	output[7: 0] JC
);

wire slow_clock_6p25mhz;
wire slow_clock_20hz;
wire slow_clock_25mhz;
wire slow_clock_1ms;
wire fb;
wire sending_pix;
wire sample_pix;
wire[12: 0] pix_index;
wire[12: 0] x;
wire[12: 0] y;

reg[4: 0] state = 5 'b00000;
reg moving = 1;

reg[15: 0] oled_colour;

clock_divider unit_1(CLOCK, 7, slow_clock_6p25mhz);
clock_divider unit_2(CLOCK, 2_499_999, slow_clock_20hz);
clock_divider unit_3(CLOCK, 1, slow_clock_25mhz);
clock_divider unit_4(CLOCK, 49999, slow_clock_1ms);

// variables for displaying grade 
reg [7:0] current_char;   
reg [2:0] current_row, current_col; 
wire pixel_on;           
char char_inst (
    .char(current_char), 
    .row(current_row), 
    .col(current_col), 
    .pixel(pixel_on)
);

Oled_Display my_oled_unit(	.clk(slow_clock_6p25mhz),
	.reset(0),
	.frame_begin(fb),
	.sending_pixels(sending_pix),
	.sample_pixel(sample_pix),
	.pixel_index(pix_index),
	.pixel_data(oled_colour),
	.cs(JC[0]),
	.sdin(JC[1]),
	.sclk(JC[3]),
	.d_cn(JC[4]),
	.resn(JC[5]),
	.vccen(JC[6]),
	.pmoden(JC[7]));

assign x = pix_index % 96;
assign y = pix_index / 96;
reg[15: 0] timer = 0;	// timer counter
integer i;	// i for for loop
integer m;
reg [92:0] moving_arrow = 0;    // Can now handle up to 79 arrows
reg [6:0] y_var [0:92];         // Array for y-positions of up to 79 arrows (7-bit for y values 0-63)
reg y_missing [0:92];         // Array for y-positions of up to 79 arrows (7-bit for y values 0-63)
wire [78:0] missed;

// map missedflags to missed
assign missed[0] = missedflag[0];
assign missed[1] = missedflag[1];
assign missed[2] = missedflag[2];
assign missed[3] = missedflag[3];
assign missed[4] = missedflag[4];
assign missed[5] = missedflag[5];
assign missed[6] = missedflag[6];
assign missed[7] = missedflag[7];
assign missed[8] = missedflag[8];
assign missed[9] = missedflag[9];
assign missed[10] = missedflag[10];
assign missed[11] = missedflag[11];
assign missed[12] = missedflag[12];
assign missed[15] = missedflag[13];
assign missed[16] = missedflag[14];
assign missed[17] = missedflag[15];
assign missed[18] = missedflag[16];
assign missed[19] = missedflag[17];
assign missed[20] = missedflag[18];
assign missed[21] = missedflag[19];
assign missed[22] = missedflag[20];
assign missed[24] = missedflag[21];
assign missed[25] = missedflag[22];
assign missed[26] = missedflag[23];
assign missed[27] = missedflag[24];
assign missed[28] = missedflag[25];
assign missed[29] = missedflag[26];
assign missed[30] = missedflag[27];
assign missed[31] = missedflag[28];
assign missed[32] = missedflag[29];
assign missed[33] = missedflag[30];
//assign missed[34] = missedflag[31];
//assign missed[35] = missedflag[32];
//assign missed[36] = missedflag[33];
//assign missed[37] = missedflag[34];
//assign missed[38] = missedflag[35];
//assign missed[39] = missedflag[36];
//assign missed[40] = missedflag[37];
//assign missed[41] = missedflag[38];
//assign missed[42] = missedflag[39];
//assign missed[44] = missedflag[40];
//assign missed[46] = missedflag[41];
//assign missed[48] = missedflag[42];
//assign missed[50] = missedflag[43];
//assign missed[53] = missedflag[44];
//assign missed[54] = missedflag[45];
//assign missed[55] = missedflag[46];
//assign missed[57] = missedflag[47];
//assign missed[58] = missedflag[48];
//assign missed[59] = missedflag[49];
//assign missed[60] = missedflag[50];
//assign missed[62] = missedflag[51];
//assign missed[63] = missedflag[52];
//assign missed[64] = missedflag[53];
//assign missed[65] = missedflag[54];
//assign missed[67] = missedflag[55];
//assign missed[69] = missedflag[56];
//assign missed[71] = missedflag[57];
//assign missed[72] = missedflag[58];
//assign missed[73] = missedflag[59];
//assign missed[74] = missedflag[60];
//assign missed[76] = missedflag[61];
//assign missed[79] = missedflag[62];

integer j;	// Declare the loop counter
integer k;

// health bar
 reg [31:0] health_level = 32'd100;  // Initialize health level to maximum (100%)
reg btnc_prev = 0;             // Regisr to store previous button state
wire [31:0] bar_width;           // Register for bar width
reg set = 1;
reg reset_health = 0;

//reg miss_prev = 0;
//reg pcount = 0;
//always @ (posedge CLOCK) begin
//    if (miss && !miss_prev) begin
//        btnC <= 1;
//    end
//    else if (btnC) begin
//        if (pcount < 10000000) begin
//            pcount <= pcount + 1;
//        end
//        else begin
//            btnC <= 0;
//            pcount <= 0;
//        end
//    end
//    miss_prev <= miss;
//end

// Timer-controlled arrow activation loop (up to 79 arrows)
always @(posedge slow_clock_20hz) begin
    if (!reset) begin
        timer <= 0;
        moving_arrow <= 0;
        for (k = 0; k < 79; k = k + 1) begin
            y_var[k] <= 0;
        end
    end
    else if (pause) begin
        // nothing should change
        timer <= timer;
    end
    else begin
        timer <= timer + 1;  // Counter for every 20Hz
    
        for (i = 0; i < 34; i = i + 1) begin
            if (timer >= (10 + i * 15)) begin  // Arrows start after 3 counts
                moving_arrow[i] <= 1;
            end
        end
    
        for (j = 0; j < 34; j = j + 1) begin
            if (moving_arrow[j]) begin
                if (y_var[j] < 63-5) begin  // Increment y_var until it reaches 63
                    y_var[j] <= y_var[j] + 3;  // Move arrow down
                end
                else begin
                    moving_arrow[j] <= 0;  // Stop moving the arrow after it reaches 63
                end
            end
             
            if(!moving_arrow[j] && missed[j] && y_var[j] == 63-5)  begin
                if (y_missing[j] < 10) begin  // Increment y_var until it reaches 63
                    y_missing[j] <= y_missing[j] + 3;  // Move arrow down
                end
            end
        end
    end

end

always @(posedge slow_clock_20hz) begin

   if (!reset) begin
        health_level <= 100;
   end
   else if (set && !btnc_prev && miss && health_level >= 10) begin
                     health_level <= health_level - 10; // Decrease health by 10 until it reaches 10 
     end
     btnc_prev <=  miss;
//                                       if(reset_health) begin
//                                       health_level <= 100;
                                      
//                                       end
end

assign bar_width = (health_level * 21) / 100; 
// assigning color to arrow
always @(posedge slow_clock_6p25mhz) begin

case (state)
0: begin

     if(y >= 13 && y <= 18 && x >= 0 && x <= bar_width) begin 
                oled_colour <= (health_level < 20) ? 16'b11111_000000_00000 :         // Red if below 20%
                                   (health_level < 50) ? 16'b11111_111111_00000 :         // Orange if below 50%
                                                       16'b00000_111111_00000; // Green otherwise
                                                       set<=1;
end


    // code for display grades
    else if (perfect) begin //PERFECT
        if (y >= 20 && y < 28) begin 
            case ((x - 16) / 8)
                0: current_char <= 8'h50; 
                1: current_char <= 8'h45; 
                2: current_char <= 8'h52; 
                3: current_char <= 8'h46; 
                4: current_char <= 8'h45; 
                5: current_char <= 8'h43; 
                6: current_char <= 8'h54; 
                default: current_char <= 8'h20; 
            endcase
        end else begin
            current_char <= 8'h20; 
        end
    end else if (good) begin // GOOD
        if (y >= 20 && y < 28) begin 
            case ((x - 32) / 8)
                0: current_char <= 8'h47; 
                1: current_char <= 8'h4F; 
                2: current_char <= 8'h4F; 
                3: current_char <= 8'h44;
                default: current_char <= 8'h20; 
            endcase
        end else begin
            current_char <= 8'h20; 
        end
    end else if (bad) begin // BAD
        if (y >= 20 && y < 28) begin
            case ((x - 32) / 8)
                0: current_char <= 8'h42; 
                1: current_char <= 8'h41; 
                2: current_char <= 8'h44; 
                default: current_char <= 8'h20; 
            endcase
        end else begin
            current_char <= 8'h20; 
        end
    end else if (miss) begin // MISS
        if (y >= 20 && y < 28) begin 
            case ((x - 32) / 8)
                0: current_char <= 8'h4D; 
                1: current_char <= 8'h49; 
                2: current_char <= 8'h53; 
                3: current_char <= 8'h53; 
                default: current_char <= 8'h20; 
            endcase
        end else begin
            current_char <= 8'h20; 
        end
    end else begin
        current_char <= 8'h20; 
    end
    
    current_row <= y % 8;
    current_col <= x % 8;
    
    if (pixel_on) begin
        if (perfect && y >= 20 && y < 28)
            oled_colour <= 16'b00000_111111_11111; // Yellow
        else if (good && y >= 20 && y < 28)
            oled_colour <= 16'b00000_111111_00000; // Green 
        else if (bad && y >= 20 && y < 28)
            oled_colour <= 16'b00000_000000_11111; // Blue
        else if (miss && y >= 20 && y < 28)
            oled_colour <= 16'b11111_000000_00000; // Red
        else
            oled_colour <= 16'b00000_000000_00000; 
    end

else if (pause) begin
        // draw a white rectangle overlay for pause screen 
            if((x == 34 && y >= 20 && y <= 24) || (x >= 35 && x <= 36 && (y == 22 || y == 20)) 
           || (x == 37 && y == 21) || (x >= 40 && x <= 41 && (y == 20 || y == 22)) || 
           ((x == 39 || x == 42) && y >= 21 && y <= 24) || ((x == 44 || x == 47) && y >= 20 && y <= 23) 
           || (x >= 45 && x <= 46 && y == 24) || (x >= 50 && x <= 52 && y == 20) || (x == 49 && y == 21) ||
           (x >= 50 && x <= 51 && y == 22) || (x == 52 && y == 23) || (x >= 49 && x <= 51 && y == 24) ||
           (x >= 54 && x <= 57 && (y == 20 || y == 24)) || (x == 54 && y >= 21 && y <= 23) || (x >= 55 && x <= 56 && y == 22)
           || (x >= 59 && x <= 61 && (y == 20 || y == 24)) || ((x == 59 || x == 62) && y >= 21 && y <= 23) ||
           (x >= 6 && x <= 7 && y == 37) || (x == 5 && y >= 38 && y <= 40) || (x == 8 && y >= 38 && y <= 39) ||
           (x == 7 && y == 40) || (x == 6 && y == 41) || (x == 8 && y == 41) || ((x == 10 || x == 13) && y >= 37 && y <= 40)
           || (x >= 11 && x <= 12 && y == 41) || (x >= 15 && x <= 17 && (y == 37 || y == 41)) || (x == 16 && y >= 38 && y <= 40)
           || (x >= 19 && x <= 23 && y == 37) || (x == 21 && y >= 38 && y <= 41) || (x == 35 && y >= 37 && y <= 41) ||
           (x >= 36 && x <= 37 && (y == 37 || y == 39)) || (x == 38 && y == 38) || (x == 37 && y == 40) || (x == 38 && y == 41) ||
           (x == 40 && y >= 37 && y <= 41) || (x >= 41 && x <= 43 && (y == 37 || y == 41)) || (x >= 41 && x <= 42 && y == 39) ||
           (x >= 45 && x <= 49 && y == 37) || (x == 47 && y >= 38 && y <= 41) || (x == 51 && y >= 37 && y <= 41) || 
           (x >= 52 && x <= 53 && (y == 39 || y == 37)) || (x == 54  && y == 38) || (x == 54 && y == 40) || (x == 54 &&
           y == 41) || ((x == 56 || x == 60) && y >= 37 && y <= 38) || (x >= 57 && x <= 59 && y == 39) || (x == 58 && y >= 40
           && y <= 41) || (x == 70 && y >= 38 && y <= 40) || (x >= 71 && x <= 72 && (y == 37 || y == 41)) || (x == 73 && y == 38)
           || (x == 73 && y == 40) || (x >= 76 && x <= 77 && (y == 37 || y == 41)) || ((x == 75 || x == 78) && y >= 38 && y <= 40) 
           || ((x == 80 || x == 83) && y >= 37 && y <= 41) || (x == 81 && y == 38) || (x == 82 && y == 39) || (x >= 85 && x <= 89 
           && y == 37) || (x == 87 && y >= 38 && y <= 41)) begin                           
                 oled_colour <= 16'h000;
                  end
 
                     else if((x == 38 && y == 29) || (x == 57 && y == 29) || (x >= 38 && x <= 42 && y == 32) || (x >= 53 && x <= 57 && y == 32) || (x >= 42 && x <= 53 && y == 33)) begin
                      oled_colour <= 16'hF800;
                      end
           
             else if((x >= 3 && x <= 25 && (y == 35 || y == 43)) || 
                      ((x == 3 || x == 25) && y >= 36 && y <= 42) || (x >= 33 && x <= 62 && (y == 35 || y == 43)) ||
                      ((x == 33 || x == 62) && y >= 36 && y <= 42) || (x >= 68 && x <= 91 && (y == 35 || y == 43)) 
                      || (( x == 91 || x == 68) && y >= 36 && y <= 42)) begin
                         oled_colour <= 16'h78EF;
                          end               
                                     
                                       
                  else if (x >= 2 && x <= 92 && y >= 18 && y <= 25) begin
                      oled_colour <= 16'h001F;  // white color
                  end
                  else if(x >= 2 && x <= 92 && y >= 26 && y <= 43) begin
                  oled_colour <= 16'hFFFF;
                  end
                                          
                                                     
        else begin
          oled_colour <= 16'h0;  // black color
           end
        end
        
      
 else if (y_var[0] < 63- 5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[0] - 9- 5 && y < y_var[0] + 8 - 9- 5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_var[0] - 9- 5 && y <= 9 + y_var[0] - 9- 5) ||
                    (x == 25 && y >= 1 + y_var[0] - 9- 5 && y <= 8 + y_var[0] - 9- 5) ||
                    (x == 24 && y >= 2 + y_var[0] - 9- 5 && y <= 7 + y_var[0] - 9- 5) ||
                    (x == 23 && y >= 3 + y_var[0] - 9- 5 && y <= 6 + y_var[0] - 9- 5) ||
                    (x == 22 && y >= 4 + y_var[0] - 9- 5 && y <= 5 + y_var[0] - 9- 5))) begin
                oled_colour <= 16 'h9000;    // red left arrow 
                
                  end else if(missed[0] && (y_var[0] == 63- 5) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[0]- 5 && y < 63 + 8 - 9 + y_missing[0]- 5) ||
                      (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[0]- 5 && y <= 9 + 63 - 9 + y_missing[0]- 5) ||
                      (x == 25 && y >= 1 + 63 - 9 + y_missing[0]- 5 && y <= 8 + 63 - 9 + y_missing[0]- 5) ||
                      (x == 24 && y >= 2 + 63 - 9 + y_missing[0]- 5 && y <= 7 + 63 - 9 + y_missing[0]- 5) ||
                      (x == 23 && y >= 3 + 63 - 9 + y_missing[0]- 5 && y <= 6 + 63 - 9 + y_missing[0]- 5) ||
                      (x == 22 && y >= 4 + 63 - 9 + y_missing[0]- 5 && y <= 5 + 63 - 9 + y_missing[0]- 5))) begin
                      oled_colour <= 16 'h9000;
                      end
                
                else if (y_var[1] < 63- 5 && ((x >= 39 && x <= 44 && y >= 6 + y_var[1] - 9- 5 && y <= 9 + y_var[1] - 9- 5) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_var[1] - 9- 5 && y <= 5 + y_var[1] - 9- 5) ||
                    (x >= 38 && x <= 45 && y == 3 + y_var[1] - 9- 5) ||
                    (x >= 39 && x <= 44 && y == 2 + y_var[1] - 9- 5) ||
                    (x >= 40 && x <= 43 && y == 1 + y_var[1] - 9- 5) ||
                    (x >= 41 && x <= 42 && y == 0 + y_var[1] - 9- 5))) begin
                oled_colour = 16 'h0010;    // blue up arrow
                end
                
                else if(missed[1] && (y_var[1] == 63- 5) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[1] - 9 + 63- 5  && y <= 9 + y_missing[1] - 9 + 63- 5 ) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_missing[1] - 9 + 63- 5 && y <= 5 + y_missing[1] - 9 + 63- 5 ) ||
                    (x >= 38 && x <= 45 && y == 3 + y_missing[1] - 9 + 63- 5 ) ||
                    (x >= 39 && x <= 44 && y == 2 + y_missing[1] - 9 + 63- 5 ) ||
                    (x >= 40 && x <= 43 && y == 1 + y_missing[1] - 9 + 63- 5 ) ||
                    (x >= 41 && x <= 42 && y == 0 + y_missing[1] - 9 + 63- 5 ))) begin
                      oled_colour <= 16 'h0010;
                      end
                
                
                else if (y_var[2] < 63- 5 && ((x >= 54 && x <= 59 && y >= 0 + y_var[2] - 9- 5 && y <= 3 + y_var[2] - 9- 5) ||
                    (x >= 52 && x <= 61 && y >= 4 + y_var[2] - 9- 5 && y <= 5 + y_var[2] - 9- 5) ||
                    (x >= 53 && x <= 60 && y == 6 + y_var[2] - 9- 5) ||
                    (x >= 54 && x <= 59 && y == 7 + y_var[2] - 9- 5) ||
                    (x >= 55 && x <= 58 && y == 8 + y_var[2] - 9- 5) ||
                    (x >= 56 && x <= 57 && y == 9 + y_var[2] - 9- 5))) begin
                oled_colour = 16 'h801F;    // purple down arrow
                end
                
                
                else if(missed[2] && (y_var[2] == 63- 5) && ((x >= 54 && x <= 59 && y >= 0 + y_missing[2] - 9 + 63- 5 && y <= 3 + y_missing[2] - 9 + 63- 5) ||
                    (x >= 52 && x <= 61 && y >= 4 + y_missing[2] - 9 + 63- 5 && y <= 5 + y_missing[2] - 9 + 63- 5) ||
                    (x >= 53 && x <= 60 && y == 6 + y_missing[2] - 9 + 63- 5) ||
                    (x >= 54 && x <= 59 && y == 7 + y_missing[2] - 9 + 63- 5) ||
                    (x >= 55 && x <= 58 && y == 8 + y_missing[2] - 9 + 63- 5) ||
                    (x >= 56 && x <= 57 && y == 9 + y_missing[2] - 9 + 63- 5))) begin
                      oled_colour <= 16 'h801F;
                      end
                      
                
                else if (y_var[3] < 63- 5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[3] - 9- 5 && y <= 7 + y_var[3] - 9- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[3] - 9- 5 && y <= 9 + y_var[3] - 9- 5) ||
                         (x == 73 && y >= 1 + y_var[3] - 9- 5 && y <= 8 + y_var[3] - 9- 5) ||
                         (x == 74 && y >= 2 + y_var[3] - 9- 5 && y <= 7 + y_var[3] - 9- 5) ||
                         (x == 75 && y >= 3 + y_var[3] - 9- 5 && y <= 6 + y_var[3] - 9- 5) ||
                         (x == 76 && y >= 4 + y_var[3] - 9- 5 && y <= 5 + y_var[3] - 9- 5))) begin
                    oled_colour = 16'h0400;  // green right arrow
                end
                
                else if (missed[3] && (y_var[3] == 63- 5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[3] - 9 + 63- 5 && y <= 7 + y_missing[3] - 9 + 63- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[3] - 9 + 63 && y <= 9 + y_missing[3] - 9 + 63- 5) ||
                         (x == 73 && y >= 1 + y_missing[3] - 9- 5 + 63 && y <= 8 + y_missing[3] - 9 + 63- 5) ||
                         (x == 74 && y >= 2 + y_missing[3] - 9- 5 + 63 && y <= 7 + y_missing[3] - 9 + 63- 5) ||
                         (x == 75 && y >= 3 + y_missing[3] - 9- 5 + 63 && y <= 6 + y_missing[3] - 9 + 63- 5) ||
                         (x == 76 && y >= 4 + y_missing[3] - 9- 5 + 63 && y <= 5 + y_missing[3] - 9 + 63- 5))) begin
                    oled_colour <= 16'h0400;  // color for missed case
                end
                
                else if (y_var[4] < 63- 5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[4] - 9- 5 && y < y_var[4] + 8 - 9- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[4] - 9-5 && y <= 9 + y_var[4] - 9- 5) ||
                         (x == 25 && y >= 1 + y_var[4] - 9- 5 && y <= 8 + y_var[4] - 9- 5) ||
                         (x == 24 && y >= 2 + y_var[4] - 9- 5 && y <= 7 + y_var[4] - 9- 5) ||
                         (x == 23 && y >= 3 + y_var[4] - 9- 5 && y <= 6 + y_var[4] - 9- 5) ||
                         (x == 22 && y >= 4 + y_var[4] - 9- 5 && y <= 5 + y_var[4] - 9- 5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                else if (missed[4] && (y_var[4] == 63- 5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[4] - 9 + 63- 5 && y < y_missing[4] + 8 - 9 + 63- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[4] - 9 + 63- 5 && y <= 9 + y_missing[4] - 9 + 63- 5) ||
                         (x == 25 && y >= 1 + y_missing[4] - 9 + 63- 5 && y <= 8 + y_missing[4] - 9 + 63- 5) ||
                         (x == 24 && y >= 2 + y_missing[4] - 9 + 63- 5 && y <= 7 + y_missing[4] - 9 + 63- 5) ||
                         (x == 23 && y >= 3 + y_missing[4] - 9 + 63- 5 && y <= 6 + y_missing[4] - 9 + 63- 5) ||
                         (x == 22 && y >= 4 + y_missing[4] - 9 + 63- 5 && y <= 5 + y_missing[4] - 9 + 63- 5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[5] < 63- 5 && ((x >= 54 && x <= 59 && y >= 0 + y_var[5] - 9- 5 && y <= 3 + y_var[5] - 9- 5) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_var[5] - 9- 5 && y <= 5 + y_var[5] - 9- 5) ||
                         (x >= 53 && x <= 60 && y == 6 + y_var[5] - 9- 5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_var[5] - 9- 5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_var[5] - 9- 5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_var[5] - 9- 5))) begin
                    oled_colour <= 16'h801F;  // purple down arrow
                end
                
                
                else if (missed[5] && (y_var[5] == 63- 5) && ((x >= 54 && x <= 59 && y >= 0 + y_missing[5] - 9 + 63- 5 && y <= 3 + y_missing[5] - 9 + 63- 5) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_missing[5] - 9 + 63- 5 && y <= 5 + y_missing[5] - 9 + 63- 5) ||
                         (x >= 53 && x <= 60 && y == 6 + y_missing[5] - 9 + 63- 5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_missing[5] - 9 + 63- 5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_missing[5] - 9 + 63- 5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_missing[5] - 9 + 63- 5))) begin
                    oled_colour <= 16'h801F;  // purple down arrow for missed case
                end
                
                
                else if (y_var[6] < 63- 5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[6] - 9- 5 && y <= 7 + y_var[6] - 9- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[6] - 9- 5 && y <= 9 + y_var[6] - 9- 5) ||
                         (x == 73 && y >= 1 + y_var[6] - 9- 5 && y <= 8 + y_var[6] - 9- 5) ||
                         (x == 74 && y >= 2 + y_var[6] - 9- 5 && y <= 7 + y_var[6] - 9- 5) ||
                         (x == 75 && y >= 3 + y_var[6] - 9- 5 && y <= 6 + y_var[6] - 9- 5) ||
                         (x == 76 && y >= 4 + y_var[6] - 9- 5 && y <= 5 + y_var[6] - 9- 5))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[6] && (y_var[6] == 63- 5) && ((x >= 67 && x <= 70- 5 && y >= 2 + y_missing[6] - 9 + 63- 5 && y <= 7 + y_missing[6] - 9 + 63- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[6] - 9 + 63- 5 && y <= 9 + y_missing[6] - 9 + 63- 5) ||
                         (x == 73 && y >= 1 + y_missing[6] - 9 + 63- 5 && y <= 8 + y_missing[6] - 9 + 63- 5) ||
                         (x == 74 && y >= 2 + y_missing[6] - 9 + 63- 5 && y <= 7 + y_missing[6] - 9 + 63- 5) ||
                         (x == 75 && y >= 3 + y_missing[6] - 9 + 63- 5 && y <= 6 + y_missing[6] - 9 + 63- 5) ||
                         (x == 76 && y >= 4 + y_missing[6] - 9 + 63- 5 && y <= 5 + y_missing[6] - 9 + 63- 5))) begin
                    oled_colour <= 16'h0400;  // color for missed case
                end
                
                
                else if (y_var[7] < 63- 5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[7] - 9- 5 && y < y_var[7] + 8 - 9- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[7] - 9- 5 && y <= 9 + y_var[7] - 9) ||
                         (x == 25 && y >= 1 + y_var[7] - 9- 5 && y <= 8 + y_var[7] - 9- 5) ||
                         (x == 24 && y >= 2 + y_var[7] - 9- 5 && y <= 7 + y_var[7] - 9- 5) ||
                         (x == 23 && y >= 3 + y_var[7] - 9- 5 && y <= 6 + y_var[7] - 9- 5) ||
                         (x == 22 && y >= 4 + y_var[7] - 9- 5 && y <= 5 + y_var[7] - 9- 5))) begin
                    oled_colour <= 16'h9000;  // red arrow
                end
                
                else if (missed[7] && (y_var[7] == 63- 5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[7] - 9 + 63- 5 && y < y_missing[7] + 8 - 9 + 63- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[7] - 9 + 63- 5 && y <= 9 + y_missing[7] - 9 + 63- 5) ||
                         (x == 25 && y >= 1 + y_missing[7] - 9 + 63- 5 && y <= 8 + y_missing[7] - 9 + 63- 5) ||
                         (x == 24 && y >= 2 + y_missing[7] - 9 + 63- 5 && y <= 7 + y_missing[7] - 9 + 63- 5) ||
                         (x == 23 && y >= 3 + y_missing[7] - 9 + 63- 5 && y <= 6 + y_missing[7] - 9 + 63- 5) ||
                         (x == 22 && y >= 4 + y_missing[7] - 9 + 63- 5 && y <= 5 + y_missing[7] - 9 + 63- 5))) begin
                    oled_colour <= 16'h9000;  // red arrow for missed case
                end
                
                
                else if (y_var[8] < 63- 5 && ((x >= 54 && x <= 59 && y >= 0 + y_var[8] - 9- 5 && y <= 3 + y_var[8] - 9- 5) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_var[8] - 9- 5 && y <= 5 + y_var[8] - 9- 5) ||
                         (x >= 53 && x <= 60 && y == 6 + y_var[8] - 9- 5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_var[8] - 9- 5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_var[8] - 9- 5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_var[8] - 9- 5))) begin
                    oled_colour <= 16'h801F;  // purple down arrow
                end
                
                else if (missed[8] && (y_var[8] == 63- 5) && ((x >= 54 && x <= 59 && y >= 0 + y_missing[8] - 9 + 63- 5 && y <= 3 + y_missing[8] - 9 + 63- 5) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_missing[8] - 9 + 63- 5 && y <= 5 + y_missing[8] - 9 + 63- 5) ||
                         (x >= 53 && x <= 60 && y == 6 + y_missing[8] - 9 + 63- 5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_missing[8] - 9 + 63- 5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_missing[8] - 9 + 63- 5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_missing[8] - 9 + 63- 5))) begin
                    oled_colour <= 16'h801F;  // purple down arrow for missed case
                end
                
                else if (y_var[9] < 63- 5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[9] - 9- 5 && y < y_var[9] + 8 - 9- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[9] - 9- 5 && y <= 9 + y_var[9] - 9- 5) ||
                         (x == 25 && y >= 1 + y_var[9] - 9- 5 && y <= 8 + y_var[9] - 9- 5) ||
                         (x == 24 && y >= 2 + y_var[9] - 9- 5 && y <= 7 + y_var[9] - 9- 5) ||
                         (x == 23 && y >= 3 + y_var[9] - 9- 5 && y <= 6 + y_var[9] - 9- 5) ||
                         (x == 22 && y >= 4 + y_var[9] - 9- 5 && y <= 5 + y_var[9] - 9- 5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                
                else if (missed[9] && (y_var[9] == 63- 5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[9] - 9 + 63- 5 && y < y_missing[9] + 8 - 9 + 63- 5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[9] - 9 + 63- 5 && y <= 9 + y_missing[9] - 9 + 63- 5) ||
                         (x == 25 && y >= 1 + y_missing[9] - 9 + 63- 5 && y <= 8 + y_missing[9] - 9 + 63- 5) ||
                         (x == 24 && y >= 2 + y_missing[9] - 9 + 63- 5 && y <= 7 + y_missing[9] - 9 + 63- 5) ||
                         (x == 23 && y >= 3 + y_missing[9] - 9 + 63- 5 && y <= 6 + y_missing[9] - 9 + 63- 5) ||
                         (x == 22 && y >= 4 + y_missing[9] - 9 + 63- 5 && y <= 5 + y_missing[9] - 9 + 63- 5))) begin
                    oled_colour <= 16'h9000;  // red left arrow for missed case
                end
                
                else if (y_var[10] < 63- 5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[10] - 9- 5 && y <= 7 + y_var[10] - 9- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[10] - 9- 5 && y <= 9 + y_var[10] - 9- 5) ||
                         (x == 73 && y >= 1 + y_var[10] - 9- 5 && y <= 8 + y_var[10] - 9- 5- 5) ||
                         (x == 74 && y >= 2 + y_var[10] - 9- 5 && y <= 7 + y_var[10] - 9- 5) ||
                         (x == 75 && y >= 3 + y_var[10] - 9- 5 && y <= 6 + y_var[10] - 9- 5) ||
                         (x == 76 && y >= 4 + y_var[10] - 9- 5 && y <= 5 + y_var[10] - 9))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[10] && (y_var[10] == 63- 5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[10] - 9 + 63- 5 && y <= 7 + y_missing[10] - 9 + 63- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[10] - 9 + 63- 5 && y <= 9 + y_missing[10] - 9 + 63- 5) ||
                         (x == 73 && y >= 1 + y_missing[10] - 9 + 63- 5 && y <= 8 + y_missing[10] - 9 + 63- 5) ||
                         (x == 74 && y >= 2 + y_missing[10] - 9 + 63- 5 && y <= 7 + y_missing[10] - 9 + 63- 5) ||
                         (x == 75 && y >= 3 + y_missing[10] - 9 + 63- 5 && y <= 6 + y_missing[10] - 9 + 63- 5) ||
                         (x == 76 && y >= 4 + y_missing[10] - 9 + 63- 5 && y <= 5 + y_missing[10] - 9 + 63- 5))) begin
                    oled_colour <= 16'h0400;  // green right arrow for missed case
                end
                
                else if (y_var[11] < 63- 5 && ((x >= 39 && x <= 44 && y >= 6 + y_var[11] - 9- 5 && y <= 9 + y_var[11] - 9- 5) ||
                         (x >= 37 && x <= 46 && y >= 4 + y_var[11] - 9- 5 && y <= 5 + y_var[11] - 9- 5) ||
                         (x >= 38 && x <= 45 && y == 3 + y_var[11] - 9- 5) ||
                         (x >= 39 && x <= 44 && y == 2 + y_var[11] - 9- 5) ||
                         (x >= 40 && x <= 43 && y == 1 + y_var[11] - 9- 5) ||
                         (x >= 41 && x <= 42 && y == 0 + y_var[11] - 9- 5))) begin
                    oled_colour <= 16'h0010;  // blue up arrow
                end
                
                
                else if (missed[11] && (y_var[11] == 63- 5) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[11] - 9 + 63- 5 && y <= 9 + y_missing[11] - 9 + 63- 5) ||
                         (x >= 37 && x <= 46 && y >= 4 + y_missing[11] - 9 + 63- 5 && y <= 5 + y_missing[11] - 9 + 63- 5) ||
                         (x >= 38 && x <= 45 && y == 3 + y_missing[11] - 9 + 63- 5) ||
                         (x >= 39 && x <= 44 && y == 2 + y_missing[11] - 9 + 63- 5) ||
                         (x >= 40 && x <= 43 && y == 1 + y_missing[11] - 9 + 63- 5) ||
                         (x >= 41 && x <= 42 && y == 0 + y_missing[11] - 9 + 63- 5))) begin
                    oled_colour <= 16'h0010;  // blue up arrow for missed case
                end
                
                
                else if (y_var[12] < 63- 5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[12] - 9- 5 && y <= 7 + y_var[12] - 9- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[12] - 9- 5 && y <= 9 + y_var[12] - 9- 5) ||
                         (x == 73 && y >= 1 + y_var[12] - 9- 5 && y <= 8 + y_var[12] - 9- 5) ||
                         (x == 74 && y >= 2 + y_var[12] - 9- 5 && y <= 7 + y_var[12] - 9- 5) ||
                         (x == 75 && y >= 3 + y_var[12] - 9- 5 && y <= 6 + y_var[12] - 9- 5) ||
                         (x == 76 && y >= 4 + y_var[12] - 9- 5 && y <= 5 + y_var[12] - 9- 5))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[12] && (y_var[12] == 63- 5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[12] - 9 + 63- 5 && y <= 7 + y_missing[12] - 9 + 63- 5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[12] - 9 + 63- 5 && y <= 9 + y_missing[12] - 9 + 63- 5) ||
                         (x == 73 && y >= 1 + y_missing[12] - 9 + 63- 5 && y <= 8 + y_missing[12] - 9 + 63- 5) ||
                         (x == 74 && y >= 2 + y_missing[12] - 9 + 63- 5 && y <= 7 + y_missing[12] - 9 + 63- 5) ||
                         (x == 75 && y >= 3 + y_missing[12] - 9 + 63- 5 && y <= 6 + y_missing[12] - 9 + 63- 5) ||
                         (x == 76 && y >= 4 + y_missing[12] - 9 + 63- 5 && y <= 5 + y_missing[12] - 9 + 63- 5))) begin
                    oled_colour <= 16'h0400;  // green right arrow for missed case
                end
                
                else if (y_var[15] < 63 - 5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[15] - 9-5 && y < y_var[15] + 8 - 9-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[15] - 9 -5&& y <= 9 + y_var[15] - 9-5) ||
                         (x == 25 && y >= 1 + y_var[15] - 9-5 && y <= 8 + y_var[15] - 9-5) ||
                         (x == 24 && y >= 2 + y_var[15] - 9-5 && y <= 7 + y_var[15] - 9-5) ||
                         (x == 23 && y >= 3 + y_var[15] - 9-5 && y <= 6 + y_var[15] - 9-5) ||
                         (x == 22 && y >= 4 + y_var[15] - 9-5 && y <= 5 + y_var[15] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red arrow
                end
                
                else if (missed[15] && (y_var[15] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[15] - 9-5 + 63 && y < y_missing[15] + 8-5 - 9 + 63) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[15] - 9-5 + 63 && y <= 9 + y_missing[15] -5- 9 + 63) ||
                         (x == 25 && y >= 1 + y_missing[15] - 9 + 63-5 && y <= 8 + y_missing[15] - 9 + 63-5) ||
                         (x == 24 && y >= 2 + y_missing[15] - 9 + 63-5 && y <= 7 + y_missing[15] - 9 + 63-5) ||
                         (x == 23 && y >= 3 + y_missing[15] - 9 + 63-5 && y <= 6 + y_missing[15] - 9 + 63-5) ||
                         (x == 22 && y >= 4 + y_missing[15] - 9 + 63-5 && y <= 5 + y_missing[15] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                
                else if (y_var[16] < 63-5 && ((x >= 39 && x <= 44 && y >= 6 + y_var[16] - 9-5 && y <= 9 + y_var[16] - 9-5) ||
                         (x >= 37 && x <= 46 && y >= 4 + y_var[16] - 9 -5 && y <= 5 + y_var[16] - 9-5) ||
                         (x >= 38 && x <= 45 && y == 3 + y_var[16] - 9-5) ||
                         (x >= 39 && x <= 44 && y == 2 + y_var[16] - 9-5) ||
                         (x >= 40 && x <= 43 && y == 1 + y_var[16] - 9-5) ||
                         (x >= 41 && x <= 42 && y == 0 + y_var[16] - 9-5))) begin
                    oled_colour <= 16'h0010;  // blue up arrow
                end
                
                else if (missed[16] && (y_var[16] == 63-5) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[16] - 9 + 63-5 && y <= 9 + y_missing[16] - 9 + 63-5) ||
                         (x >= 37 && x <= 46 && y >= 4 + y_missing[16] - 9 + 63-5 && y <= 5 + y_missing[16] - 9 + 63-5) ||
                         (x >= 38 && x <= 45 && y == 3 + y_missing[16] - 9 + 63-5) ||
                         (x >= 39 && x <= 44 && y == 2 + y_missing[16] - 9 + 63-5) ||
                         (x >= 40 && x <= 43 && y == 1 + y_missing[16] - 9 + 63-5) ||
                         (x >= 41 && x <= 42 && y == 0 + y_missing[16] - 9 + 63-5))) begin
                    oled_colour <= 16'h0010;  // color for missed case
                end
                
                else if (y_var[17] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[17] - 9-5 && y < y_var[17] + 8 - 9-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[17] - 9-5 && y <= 9 + y_var[17] - 9-5) ||
                         (x == 25 && y >= 1 + y_var[17] - 9-5 && y <= 8 + y_var[17] - 9-5) ||
                         (x == 24 && y >= 2 + y_var[17] - 9-5 && y <= 7 + y_var[17] - 9-5) ||
                         (x == 23 && y >= 3 + y_var[17] - 9-5 && y <= 6 + y_var[17] - 9-5) ||
                         (x == 22 && y >= 4 + y_var[17] - 9-5 && y <= 5 + y_var[17] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red arrow
                end
                
                else if (missed[17] && (y_var[17] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[17] -5- 9 + 63 && y < y_missing[17]-5 + 8 - 9 + 63) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[17]-5 - 9 + 63 && y <= 9 -5+ y_missing[17] - 9 + 63) ||
                         (x == 25 && y >= 1 -5+ y_missing[17] - 9 + 63 && y <= 8 + y_missing[17] -5- 9 + 63) ||
                         (x == 24 && y >= 2 -5+ y_missing[17] - 9 + 63 && y <= 7 + y_missing[17] -5- 9 + 63) ||
                         (x == 23 && y >= 3 -5+ y_missing[17] - 9 + 63 && y <= 6 + y_missing[17] -5- 9 + 63) ||
                         (x == 22 && y >= 4 -5+ y_missing[17] - 9 + 63 && y <= 5 + y_missing[17] -5- 9 + 63))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[18] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[18] - 9-5 && y < y_var[18]-5 + 8 - 9) ||
                         (x >= 26 && x <= 27 && y >= 0 -5+ y_var[18] - 9 && y <= 9-5 + y_var[18] - 9) ||
                         (x == 25 && y >= 1 + y_var[18] - 9 -5 && y <= 8 + y_var[18]-5 - 9) ||
                         (x == 24 && y >= 2 + y_var[18] - 9-5 && y <= 7 + y_var[18]-5 - 9) ||
                         (x == 23 && y >= 3 + y_var[18] - 9-5 && y <= 6 + y_var[18]-5 - 9) ||
                         (x == 22 && y >= 4 + y_var[18] - 9-5 && y <= 5 + y_var[18]-5 - 9))) begin
                    oled_colour <= 16'h9000;  // red arrow
                end
                
                else if (missed[18] && (y_var[18] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[18] - 9 + 63-5 && y < y_missing[18] + 8 - 9 + 63-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[18] - 9 + 63-5 && y <= 9 + y_missing[18] - 9 + 63-5) ||
                         (x == 25 && y >= 1 + y_missing[18] - 9 + 63-5 && y <= 8 + y_missing[18] - 9 + 63-5) ||
                         (x == 24 && y >= 2 + y_missing[18] - 9 + 63-5 && y <= 7 + y_missing[18] - 9 + 63-5) ||
                         (x == 23 && y >= 3 + y_missing[18] - 9 + 63-5 && y <= 6 + y_missing[18] - 9 + 63-5) ||
                         (x == 22 && y >= 4 + y_missing[18] - 9 + 63-5 && y <= 5 + y_missing[18] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[19] < 63-5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[19] - 9-5 && y <= 7 + y_var[19] - 9-5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[19]-5 - 9 && y <= 9 + y_var[19]-5 - 9) ||
                         (x == 73 && y >= 1 + y_var[19] - 9-5 && y <= 8 + y_var[19] - 9-5) ||
                         (x == 74 && y >= 2 + y_var[19] - 9-5 && y <= 7 + y_var[19] - 9-5) ||
                         (x == 75 && y >= 3 + y_var[19] - 9 -5 && y <= 6 + y_var[19] - 9-5) ||
                         (x == 76 && y >= 4 + y_var[19] - 9 -5 && y <= 5 + y_var[19] - 9-5))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[19] && (y_var[19] == 63-5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[19] - 9 + 63-5 && y <= 7 + y_missing[19] - 9-5 + 63) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[19] - 9 + 63-5 && y <= 9 + y_missing[19]-5 - 9 + 63) ||
                         (x == 73 && y >= 1 + y_missing[19] - 9 + 63-5 && y <= 8 + y_missing[19] - 9 + 63-5) ||
                         (x == 74 && y >= 2 + y_missing[19] - 9 + 63-5 && y <= 7 + y_missing[19] - 9 + 63-5) ||
                         (x == 75 && y >= 3 + y_missing[19] - 9 + 63-5 && y <= 6 + y_missing[19] - 9 + 63-5) ||
                         (x == 76 && y >= 4 + y_missing[19] - 9 + 63-5 && y <= 5 + y_missing[19] - 9 + 63-5))) begin
                    oled_colour <= 16'h0400;  // color for missed case
                end
                
                else if (y_var[20] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 -5+ y_var[20] - 9 && y < y_var[20] -5 + 8 - 9) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[20] - 9-5 && y <= 9 + y_var[20] - 9-5) ||
                         (x == 25 && y >= 1 + y_var[20] - 9 -5 && y <= 8 + y_var[20] - 9-5) ||
                         (x == 24 && y >= 2 + y_var[20] - 9-5 && y <= 7 + y_var[20] - 9-5) ||
                         (x == 23 && y >= 3 + y_var[20] - 9-5 && y <= 6 + y_var[20] - 9-5) ||
                         (x == 22 && y >= 4 + y_var[20] - 9-5 && y <= 5 + y_var[20] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                else if (missed[20] && (y_var[20] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[20] - 9 + 63-5 && y < y_missing[20] + 8 - 9 + 63-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[20] - 9 + 63-5 && y <= 9 + y_missing[20] - 9 + 63-5) ||
                         (x == 25 && y >= 1 + y_missing[20] - 9 + 63-5 && y <= 8 + y_missing[20] - 9 + 63-5) ||
                         (x == 24 && y >= 2 + y_missing[20] - 9 + 63-5 && y <= 7 + y_missing[20] - 9 + 63-5) ||
                         (x == 23 && y >= 3 + y_missing[20] - 9 + 63-5 && y <= 6 + y_missing[20] - 9 + 63-5) ||
                         (x == 22 && y >= 4 + y_missing[20] - 9 + 63-5 && y <= 5 + y_missing[20] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[21] < 63-5 && ((x >= 54 && x <= 59 && y >= 0 + y_var[21] - 9-5 && y <= 3 + y_var[21] - 9-5) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_var[21] - 9-5 && y <= 5 + y_var[21] - 9-5) ||
                         (x >= 53 && x <= 60 && y == 6 + y_var[21] - 9-5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_var[21] - 9-5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_var[21] - 9-5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_var[21] - 9-5))) begin
                    oled_colour <= 16'h801F;  // purple down arrow
                end
                
                else if (missed[21] && (y_var[21] == 63-5) && ((x >= 54 && x <= 59 && y >= 0 + y_missing[21]-5 - 9 + 63 && y <= 3 + y_missing[21]-5 - 9 + 63) ||
                         (x >= 52 && x <= 61 && y >= 4 + y_missing[21] - 9 + 63-5 && y <= 5 + y_missing[21]-5 - 9 + 63) ||
                         (x >= 53 && x <= 60 && y == 6 + y_missing[21] - 9 + 63-5) ||
                         (x >= 54 && x <= 59 && y == 7 + y_missing[21] - 9 + 63-5) ||
                         (x >= 55 && x <= 58 && y == 8 + y_missing[21] - 9 + 63-5) ||
                         (x >= 56 && x <= 57 && y == 9 + y_missing[21] - 9 + 63-5))) begin
                    oled_colour <= 16'h801F;  // color for missed case
                end
                
                else if (y_var[22] < 63-5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[22] - 9-5 && y <= 7 + y_var[22] - 9-5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_var[22] - 9-5 && y <= 9 + y_var[22] - 9-5) ||
                         (x == 73 && y >= 1 + y_var[22] - 9-5 && y <= 8 + y_var[22] - 9-5) ||
                         (x == 74 && y >= 2 + y_var[22] - 9-5 && y <= 7 + y_var[22] - 9-5) ||
                         (x == 75 && y >= 3 + y_var[22] - 9-5 && y <= 6 + y_var[22] - 9-5) ||
                         (x == 76 && y >= 4 + y_var[22] - 9-5 && y <= 5 + y_var[22] - 9-5))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[22] && (y_var[22] == 63-5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[22] - 9 + 63-5 && y <= 7 + y_missing[22] - 9 + 63-5) ||
                         (x >= 71 && x <= 72 && y >= 0 + y_missing[22] - 9 + 63-5 && y <= 9 + y_missing[22] - 9 + 63-5) ||
                         (x == 73 && y >= 1 + y_missing[22] - 9 + 63-5 && y <= 8 + y_missing[22] - 9 + 63-5) ||
                         (x == 74 && y >= 2 + y_missing[22] - 9 + 63-5 && y <= 7 + y_missing[22] - 9 + 63-5) ||
                         (x == 75 && y >= 3 + y_missing[22] - 9 + 63-5 && y <= 6 + y_missing[22] - 9 + 63-5) ||
                         (x == 76 && y >= 4 + y_missing[22] - 9 + 63-5 && y <= 5 + y_missing[22] - 9 + 63-5))) begin
                    oled_colour <= 16'h0400;  // color for missed case
                end
                
                else if (y_var[24] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[24] - 9-5 && y < y_var[24] + 8 - 9-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_var[24] - 9-5 && y <= 9 + y_var[24] - 9-5) ||
                         (x == 25 && y >= 1 + y_var[24] - 9 -5 && y <= 8 + y_var[24] - 9-5) ||
                         (x == 24 && y >= 2 + y_var[24] - 9-5 && y <= 7 + y_var[24] - 9-5) ||
                         (x == 23 && y >= 3 + y_var[24] - 9 -5 && y <= 6 + y_var[24] - 9-5) ||
                         (x == 22 && y >= 4 + y_var[24] - 9-5 && y <= 5 + y_var[24] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                else if (missed[24] && (y_var[24] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[24] - 9 + 63-5 && y < y_missing[24] + 8 - 9 + 63-5) ||
                         (x >= 26 && x <= 27 && y >= 0 + y_missing[24] - 9 + 63-5 && y <= 9 + y_missing[24] - 9 + 63-5) ||
                         (x == 25 && y >= 1 + y_missing[24] - 9 + 63-5 && y <= 8 + y_missing[24] - 9 + 63-5) ||
                         (x == 24 && y >= 2 + y_missing[24] - 9 + 63-5 && y <= 7 + y_missing[24] - 9 + 63-5) ||
                         (x == 23 && y >= 3 + y_missing[24] - 9 + 63-5 && y <= 6 + y_missing[24] - 9 + 63-5) ||
                         (x == 22 && y >= 4 + y_missing[24] - 9 + 63-5 && y <= 5 + y_missing[24] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[25] < 63-5 && ((x >= 39 && x <= 44 && y >= 6 + y_var[25] - 9-5 && y <= 9 + y_var[25] - 9-5) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_var[25] - 9-5 && y <= 5 + y_var[25] - 9-5) ||
                    (x >= 38 && x <= 45 && y == 3 + y_var[25] - 9-5) ||
                    (x >= 39 && x <= 44 && y == 2 + y_var[25] - 9-5) ||
                    (x >= 40 && x <= 43 && y == 1 + y_var[25] - 9-5) ||
                    (x >= 41 && x <= 42 && y == 0 + y_var[25] - 9-5))) begin
                    oled_colour <= 16'h0010;  // blue up arrow
                end
                
                else if (missed[25] && (y_var[25] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[25] - 9 + 63-5 && y <= 9 + y_missing[25] - 9 + 63-5) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_missing[25] - 9 + 63-5 && y <= 5 + y_missing[25] - 9 + 63-5) ||
                    (x >= 38 && x <= 45 && y == 3 + y_missing[25] - 9 + 63-5) ||
                    (x >= 39 && x <= 44 && y == 2 + y_missing[25] - 9 + 63-5) ||
                    (x >= 40 && x <= 43 && y == 1 + y_missing[25] - 9 + 63-5) ||
                    (x >= 41 && x <= 42 && y == 0 + y_missing[25] - 9 + 63-5))) begin
                    oled_colour <= 16'h0010;  // color for missed case
                end
                
                else if (y_var[26] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[26] - 9-5 && y < y_var[26] + 8 - 9-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_var[26] - 9-5 && y <= 9 + y_var[26] - 9-5) ||
                    (x == 25 && y >= 1 + y_var[26] - 9-5 && y <= 8 + y_var[26] - 9-5) ||
                    (x == 24 && y >= 2 + y_var[26] - 9-5 && y <= 7 + y_var[26] - 9-5) ||
                    (x == 23 && y >= 3 + y_var[26] - 9-5 && y <= 6 + y_var[26] - 9-5) ||
                    (x == 22 && y >= 4 + y_var[26] - 9-5 && y <= 5 + y_var[26] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                else if (missed[26] && (y_var[26] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[26] - 9 + 63-5 && y < y_missing[26] + 8 - 9 + 63-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_missing[26] - 9 + 63-5 && y <= 9 + y_missing[26] - 9 + 63-5) ||
                    (x == 25 && y >= 1 + y_missing[26] - 9 + 63-5 && y <= 8 + y_missing[26] - 9 + 63-5) ||
                    (x == 24 && y >= 2 + y_missing[26] - 9 + 63-5 && y <= 7 + y_missing[26] - 9 + 63-5) ||
                    (x == 23 && y >= 3 + y_missing[26] - 9 + 63-5 && y <= 6 + y_missing[26] - 9 + 63-5) ||
                    (x == 22 && y >= 4 + y_missing[26] - 9 + 63-5 && y <= 5 + y_missing[26] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[27] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[27] - 9-5 && y < y_var[27] + 8 - 9-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_var[27] - 9-5 && y <= 9 + y_var[27] - 9-5) ||
                    (x == 25 && y >= 1 + y_var[27] - 9-5 && y <= 8 + y_var[27] - 9-5) ||
                    (x == 24 && y >= 2 + y_var[27] - 9-5 && y <= 7 + y_var[27] - 9-5) ||
                    (x == 23 && y >= 3 + y_var[27] - 9-5 && y <= 6 + y_var[27] - 9-5) ||
                    (x == 22 && y >= 4 + y_var[27] - 9-5 && y <= 5 + y_var[27] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red left arrow
                end
                
                else if (missed[27] && (y_var[27] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[27] - 9 + 63-5 && y < y_missing[27] + 8 - 9 + 63-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_missing[27] - 9 + 63-5 && y <= 9 + y_missing[27] - 9 + 63-5) ||
                    (x == 25 && y >= 1 + y_missing[27] - 9 + 63-5 && y <= 8 + y_missing[27] - 9 + 63-5) ||
                    (x == 24 && y >= 2 + y_missing[27] - 9 + 63-5 && y <= 7 + y_missing[27] - 9 + 63-5) ||
                    (x == 23 && y >= 3 + y_missing[27] - 9 + 63-5 && y <= 6 + y_missing[27] - 9 + 63-5) ||
                    (x == 22 && y >= 4 + y_missing[27] - 9 + 63-5 && y <= 5 + y_missing[27] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                else if (y_var[28] < 63-5 && ((x >= 67 && x <= 70 && y >= 2 + y_var[28] - 9-5 && y <= 7 + y_var[28] - 9-5) ||
                    (x >= 71 && x <= 72 && y >= 0 + y_var[28] - 9-5 && y <= 9 + y_var[28] - 9-5) ||
                    (x == 73 && y >= 1 + y_var[28] - 9-5 && y <= 8 + y_var[28] - 9-5) ||
                    (x == 74 && y >= 2 + y_var[28] - 9-5 && y <= 7 + y_var[28] - 9-5) ||
                    (x == 75 && y >= 3 + y_var[28] - 9-5 && y <= 6 + y_var[28] - 9-5) ||
                    (x == 76 && y >= 4 + y_var[28] - 9-5 && y <= 5 + y_var[28] - 9-5))) begin
                    oled_colour <= 16'h0400;  // green right arrow
                end
                
                else if (missed[28] && (y_var[28] == 63-5) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[28] - 9 + 63-5 && y <= 7 + y_missing[28] - 9 + 63-5) ||
                    (x >= 71 && x <= 72 && y >= 0 + y_missing[28] - 9 + 63-5 && y <= 9 + y_missing[28] - 9 + 63-5) ||
                    (x == 73 && y >= 1 + y_missing[28] - 9 + 63-5 && y <= 8 + y_missing[28] - 9 + 63-5) ||
                    (x == 74 && y >= 2 + y_missing[28] - 9 + 63-5 && y <= 7 + y_missing[28] - 9 + 63-5) ||
                    (x == 75 && y >= 3 + y_missing[28] - 9 + 63-5 && y <= 6 + y_missing[28] - 9 + 63-5) ||
                    (x == 76 && y >= 4 + y_missing[28] - 9 + 63-5 && y <= 5 + y_missing[28] - 9 + 63-5))) begin
                    oled_colour <= 16'h0400;  // color for missed case
                end
                
                else if (y_var[29] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[29] - 9-5 && y < y_var[29] + 8 - 9-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_var[29] - 9-5 && y <= 9 + y_var[29] - 9-5) ||
                    (x == 25 && y >= 1 + y_var[29] - 9-5 && y <= 8 + y_var[29] - 9-5) ||
                    (x == 24 && y >= 2 + y_var[29] - 9-5 && y <= 7 + y_var[29] - 9-5) ||
                    (x == 23 && y >= 3 + y_var[29] - 9-5 && y <= 6 + y_var[29] - 9-5) ||
                    (x == 22 && y >= 4 + y_var[29] - 9-5 && y <= 5 + y_var[29] - 9-5))) begin
                    oled_colour <= 16'h9000;  // red left arrow 
                end
                
                else if (missed[29] && (y_var[29] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[29] - 9 + 63-5 && y < y_missing[29] + 8 - 9 + 63-5) ||
                    (x >= 26 && x <= 27 && y >= 0 + y_missing[29] - 9 + 63-5 && y <= 9 + y_missing[29] - 9 + 63-5) ||
                    (x == 25 && y >= 1 + y_missing[29] - 9 + 63-5 && y <= 8 + y_missing[29] - 9 + 63-5) ||
                    (x == 24 && y >= 2 + y_missing[29] - 9 + 63-5 && y <= 7 + y_missing[29] - 9 + 63-5) ||
                    (x == 23 && y >= 3 + y_missing[29] - 9 + 63-5 && y <= 6 + y_missing[29] - 9 + 63-5) ||
                    (x == 22 && y >= 4 + y_missing[29] - 9 + 63-5 && y <= 5 + y_missing[29] - 9 + 63-5))) begin
                    oled_colour <= 16'h9000;  // color for missed case
                end
                
                
                else if (y_var[30] < 63-5 && ((x >= 39 && x <= 44 && y >= 6 + y_var[30] - 9-5 && y <= 9 + y_var[30] - 9-5) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_var[30] - 9-5 && y <= 5 + y_var[30] - 9-5) ||
                    (x >= 38 && x <= 45 && y == 3 + y_var[30] - 9-5) ||
                    (x >= 39 && x <= 44 && y == 2 + y_var[30] - 9-5) ||
                    (x >= 40 && x <= 43 && y == 1 + y_var[30] - 9-5) ||
                    (x >= 41 && x <= 42 && y == 0 + y_var[30] - 9-5))) begin
                    oled_colour <= 16'h0010;  // blue up arrow
                end
                
                else if (missed[30] && (y_var[30] == 63-5) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[30] - 9 + 63-5 && y <= 9 + y_missing[30] - 9 + 63-5) ||
                    (x >= 37 && x <= 46 && y >= 4 + y_missing[30] - 9 + 63-5 && y <= 5 + y_missing[30] - 9 + 63-5) ||
                    (x >= 38 && x <= 45 && y == 3 + y_missing[30] - 9 + 63-5) ||
                    (x >= 39 && x <= 44 && y == 2 + y_missing[30] - 9 + 63-5) ||
                    (x >= 40 && x <= 43 && y == 1 + y_missing[30] - 9 + 63-5) ||
                    (x >= 41 && x <= 42 && y == 0 + y_missing[30] - 9 + 63-5))) begin
                    oled_colour <= 16'h0010;  // color for missed case
                end
        
        
        else if (y_var[31] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[31] - 9-5 && y < y_var[31] + 8 - 9-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_var[31] - 9-5 && y <= 9 + y_var[31] - 9-5) ||
            (x == 25 && y >= 1 + y_var[31] - 9-5 && y <= 8 + y_var[31] - 9-5) ||
            (x == 24 && y >= 2 + y_var[31] - 9-5 && y <= 7 + y_var[31] - 9-5) ||
            (x == 23 && y >= 3 + y_var[31] - 9-5 && y <= 6 + y_var[31] - 9-5) ||
            (x == 22 && y >= 4 + y_var[31] - 9-5 && y <= 5 + y_var[31] - 9-5))) begin
            oled_colour <= 16'h9000;  // red left arrow
        end
        
        else if (missed[31] && (y_var[31] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[31] - 9 + 63-5 && y < y_missing[31] + 8 - 9 + 63-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_missing[31] - 9 + 63 && y <= 9 + y_missing[31] - 9 + 63) ||
            (x == 25 && y >= 1 + y_missing[31] - 9 + 63-5 && y <= 8 + y_missing[31] - 9 + 63-5) ||
            (x == 24 && y >= 2 + y_missing[31] - 9 + 63-5 && y <= 7 + y_missing[31] - 9 + 63-5) ||
            (x == 23 && y >= 3 + y_missing[31] - 9 + 63-5 && y <= 6 + y_missing[31] - 9 + 63-5) ||
            (x == 22 && y >= 4 + y_missing[31] - 9 + 63-5 && y <= 5 + y_missing[31] - 9 + 63-5))) begin
            oled_colour <= 16'h9000;  // color for missed case
        end
        
        else if (y_var[32] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[32] - 9-5 && y < y_var[32] + 8 - 9-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_var[32] - 9-5 && y <= 9 + y_var[32] - 9-5) ||
            (x == 25 && y >= 1 + y_var[32] - 9-5 && y <= 8 + y_var[32] - 9-5) ||
            (x == 24 && y >= 2 + y_var[32] - 9-5 && y <= 7 + y_var[32] - 9-5) ||
            (x == 23 && y >= 3 + y_var[32] - 9-5 && y <= 6 + y_var[32] - 9-5) ||
            (x == 22 && y >= 4 + y_var[32] - 9-5 && y <= 5 + y_var[32] - 9-5))) begin
            oled_colour <= 16'h9000;  // red left arrow
        end
        
        else if (missed[32] && (y_var[32] == 6-53) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[32] - 9 + 63-5 && y < y_missing[32] + 8 - 9 + 63-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_missing[32] - 9 + 63 && y <= 9 + y_missing[32] - 9 + 63-5) ||
            (x == 25 && y >= 1 + y_missing[32] - 9 + 63-5 && y <= 8 + y_missing[32] - 9 + 63-5) ||
            (x == 24 && y >= 2 + y_missing[32] - 9 + 63-5 && y <= 7 + y_missing[32] - 9 + 63-5) ||
            (x == 23 && y >= 3 + y_missing[32] - 9 + 63-5 && y <= 6 + y_missing[32] - 9 + 63-5) ||
            (x == 22 && y >= 4 + y_missing[32] - 9 + 63-5 && y <= 5 + y_missing[32] - 9 + 63-5))) begin
            oled_colour <= 16'h9000;  // color for missed case
        end
        
        else if (y_var[33] < 63-5 && ((x >= 28 && x <= 31 && y >= 2 + y_var[33] - 9-5 && y < y_var[33] + 8 - 9-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_var[33] - 9-5 && y <= 9 + y_var[33] - 9-5) ||
            (x == 25 && y >= 1 + y_var[33] - 9-5 && y <= 8 + y_var[33] - 9-5) ||
            (x == 24 && y >= 2 + y_var[33] - 9-5 && y <= 7 + y_var[33] - 9-5) ||
            (x == 23 && y >= 3 + y_var[33] - 9-5 && y <= 6 + y_var[33] - 9-5) ||
            (x == 22 && y >= 4 + y_var[33] - 9-5 && y <= 5 + y_var[33] - 9-5))) begin
            oled_colour <= 16'h9000;  // red left arrow
        end
        
        else if (missed[33] && (y_var[33] == 63-5) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[33] - 9 + 63-5 && y < y_missing[33] + 8 - 9 + 63-5) ||
            (x >= 26 && x <= 27 && y >= 0 + y_missing[33] - 9 + 63-5 && y <= 9 + y_missing[33] - 9 + 63-5) ||
            (x == 25 && y >= 1 + y_missing[33] - 9 + 63-5 && y <= 8 + y_missing[33] - 9 + 63-5) ||
            (x == 24 && y >= 2 + y_missing[33] - 9 + 63-5 && y <= 7 + y_missing[33] - 9 + 63-5) ||
            (x == 23 && y >= 3 + y_missing[33] - 9 + 63-5 && y <= 6 + y_missing[33] - 9 + 63-5) ||
            (x == 22 && y >= 4 + y_missing[33] - 9 + 63-5 && y <= 5 + y_missing[33] - 9 + 63-5))) begin
            oled_colour <= 16'h9000;  // color for missed case
        end


//else if (y_var[34] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[34] - 9 && y < y_var[34] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[34] - 9 && y <= 9 + y_var[34] - 9) ||
//    (x == 25 && y >= 1 + y_var[34] - 9 && y <= 8 + y_var[34] - 9) ||
//    (x == 24 && y >= 2 + y_var[34] - 9 && y <= 7 + y_var[34] - 9) ||
//    (x == 23 && y >= 3 + y_var[34] - 9 && y <= 6 + y_var[34] - 9) ||
//    (x == 22 && y >= 4 + y_var[34] - 9 && y <= 5 + y_var[34] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[34] && (y_var[34] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[34] - 9 + 63 && y < y_missing[34] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[34] - 9 + 63 && y <= 9 + y_missing[34] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[34] - 9 + 63 && y <= 8 + y_missing[34] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[34] - 9 + 63 && y <= 7 + y_missing[34] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[34] - 9 + 63 && y <= 6 + y_missing[34] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[34] - 9 + 63 && y <= 5 + y_missing[34] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end

//else if (y_var[35] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[35] - 9 && y < y_var[35] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[35] - 9 && y <= 9 + y_var[35] - 9) ||
//    (x == 25 && y >= 1 + y_var[35] - 9 && y <= 8 + y_var[35] - 9) ||
//    (x == 24 && y >= 2 + y_var[35] - 9 && y <= 7 + y_var[35] - 9) ||
//    (x == 23 && y >= 3 + y_var[35] - 9 && y <= 6 + y_var[35] - 9) ||
//    (x == 22 && y >= 4 + y_var[35] - 9 && y <= 5 + y_var[35] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[35] && (y_var[35] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[35] - 9 + 63 && y < y_missing[35] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[35] - 9 + 63 && y <= 9 + y_missing[35] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[35] - 9 + 63 && y <= 8 + y_missing[35] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[35] - 9 + 63 && y <= 7 + y_missing[35] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[35] - 9 + 63 && y <= 6 + y_missing[35] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[35] - 9 + 63 && y <= 5 + y_missing[35] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end

//else if (y_var[36] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[36] - 9 && y <= 9 + y_var[36] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[36] - 9 && y <= 5 + y_var[36] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[36] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[36] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[36] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[36] - 9))) begin
//    oled_colour <= 16'h0010;  // blue up arrow
//end

//else if (missed[36] && (y_var[36] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[36] - 9 + 63 && y <= 9 + y_missing[36] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[36] - 9 + 63 && y <= 5 + y_missing[36] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[36] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[36] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[36] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[36] - 9 + 63))) begin
//    oled_colour <= 16'h0010;  // color for missed case
//end


//else if (y_var[37] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[37] - 9 && y < y_var[37] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[37] - 9 && y <= 9 + y_var[37] - 9) ||
//    (x == 25 && y >= 1 + y_var[37] - 9 && y <= 8 + y_var[37] - 9) ||
//    (x == 24 && y >= 2 + y_var[37] - 9 && y <= 7 + y_var[37] - 9) ||
//    (x == 23 && y >= 3 + y_var[37] - 9 && y <= 6 + y_var[37] - 9) ||
//    (x == 22 && y >= 4 + y_var[37] - 9 && y <= 5 + y_var[37] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[37] && (y_var[37] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[37] - 9 + 63 && y < y_missing[37] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[37] - 9 + 63 && y <= 9 + y_missing[37] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[37] - 9 + 63 && y <= 8 + y_missing[37] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[37] - 9 + 63 && y <= 7 + y_missing[37] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[37] - 9 + 63 && y <= 6 + y_missing[37] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[37] - 9 + 63 && y <= 5 + y_missing[37] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end

//else if (y_var[38] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[38] - 9 && y <= 9 + y_var[38] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[38] - 9 && y <= 5 + y_var[38] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[38] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[38] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[38] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[38] - 9))) begin
//    oled_colour <= 16'h0010;  // blue up arrow
//end

//else if (missed[38] && (y_var[38] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[38] - 9 + 63 && y <= 9 + y_missing[38] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[38] - 9 + 63 && y <= 5 + y_missing[38] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[38] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[38] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[38] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[38] - 9 + 63))) begin
//    oled_colour <= 16'h0010;  // color for missed case
//end


//else if (y_var[39] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[39] - 9 && y <= 7 + y_var[39] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[39] - 9 && y <= 9 + y_var[39] - 9) ||
//    (x == 73 && y >= 1 + y_var[39] - 9 && y <= 8 + y_var[39] - 9) ||
//    (x == 74 && y >= 2 + y_var[39] - 9 && y <= 7 + y_var[39] - 9) ||
//    (x == 75 && y >= 3 + y_var[39] - 9 && y <= 6 + y_var[39] - 9) ||
//    (x == 76 && y >= 4 + y_var[39] - 9 && y <= 5 + y_var[39] - 9))) begin
//    oled_colour <= 16'h0400;  // green right arrow
//end

//else if (missed[39] && (y_var[39] == 63) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[39] - 9 + 63 && y <= y_missing[39] + 8 - 9 + 63) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_missing[39] - 9 + 63 && y <= 9 + y_missing[39] - 9 + 63) ||
//    (x == 73 && y >= 1 + y_missing[39] - 9 + 63 && y <= 8 + y_missing[39] - 9 + 63) ||
//    (x == 74 && y >= 2 + y_missing[39] - 9 + 63 && y <= 7 + y_missing[39] - 9 + 63) ||
//    (x == 75 && y >= 3 + y_missing[39] - 9 + 63 && y <= 6 + y_missing[39] - 9 + 63) ||
//    (x == 76 && y >= 4 + y_missing[39] - 9 + 63 && y <= 5 + y_missing[39] - 9 + 63))) begin
//    oled_colour <= 16'h0400;  // color for missed case
//end

//else if (y_var[40] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[40] - 9 && y <= 9 + y_var[40] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[40] - 9 && y <= 5 + y_var[40] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[40] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[40] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[40] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[40] - 9))) begin
//    oled_colour <= 16'h0010;  // blue up arrow
//end

//else if (missed[40] && (y_var[40] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[40] - 9 + 63 && y <= 9 + y_missing[40] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[40] - 9 + 63 && y <= 5 + y_missing[40] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[40] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[40] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[40] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[40] - 9 + 63))) begin
//    oled_colour <= 16'h0010;  // color for missed case
//end

//else if (y_var[41] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[41] - 9 && y < y_var[41] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[41] - 9 && y <= 9 + y_var[41] - 9) ||
//    (x == 25 && y >= 1 + y_var[41] - 9 && y <= 8 + y_var[41] - 9) ||
//    (x == 24 && y >= 2 + y_var[41] - 9 && y <= 7 + y_var[41] - 9) ||
//    (x == 23 && y >= 3 + y_var[41] - 9 && y <= 6 + y_var[41] - 9) ||
//    (x == 22 && y >= 4 + y_var[41] - 9 && y <= 5 + y_var[41] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[41] && (y_var[41] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[41] - 9 + 63 && y < y_missing[41] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[41] - 9 + 63 && y <= 9 + y_missing[41] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[41] - 9 + 63 && y <= 8 + y_missing[41] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[41] - 9 + 63 && y <= 7 + y_missing[41] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[41] - 9 + 63 && y <= 6 + y_missing[41] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[41] - 9 + 63 && y <= 5 + y_missing[41] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end


//else if (y_var[42] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[42] - 9 && y <= 9 + y_var[42] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[42] - 9 && y <= 5 + y_var[42] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[42] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[42] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[42] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[42] - 9))) begin
//    oled_colour <= 16'h0010;  // blue up arrow
//end

//else if (missed[42] && (y_var[42] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[42] - 9 + 63 && y <= 9 + y_missing[42] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[42] - 9 + 63 && y <= 5 + y_missing[42] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[42] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[42] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[42] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[42] - 9 + 63))) begin
//    oled_colour <= 16'h0010;  // color for missed case
//end

//else if (y_var[44] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[44] - 9 && y < y_var[44] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[44] - 9 && y <= 9 + y_var[44] - 9) ||
//    (x == 25 && y >= 1 + y_var[44] - 9 && y <= 8 + y_var[44] - 9) ||
//    (x == 24 && y >= 2 + y_var[44] - 9 && y <= 7 + y_var[44] - 9) ||
//    (x == 23 && y >= 3 + y_var[44] - 9 && y <= 6 + y_var[44] - 9) ||
//    (x == 22 && y >= 4 + y_var[44] - 9 && y <= 5 + y_var[44] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[44] && (y_var[44] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[44] - 9 + 63 && y < y_missing[44] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[44] - 9 + 63 && y <= 9 + y_missing[44] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[44] - 9 + 63 && y <= 8 + y_missing[44] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[44] - 9 + 63 && y <= 7 + y_missing[44] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[44] - 9 + 63 && y <= 6 + y_missing[44] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[44] - 9 + 63 && y <= 5 + y_missing[44] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end

//else if (y_var[46] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[46] - 9 && y < y_var[46] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[46] - 9 && y <= 9 + y_var[46] - 9) ||
//    (x == 25 && y >= 1 + y_var[46] - 9 && y <= 8 + y_var[46] - 9) ||
//    (x == 24 && y >= 2 + y_var[46] - 9 && y <= 7 + y_var[46] - 9) ||
//    (x == 23 && y >= 3 + y_var[46] - 9 && y <= 6 + y_var[46] - 9) ||
//    (x == 22 && y >= 4 + y_var[46] - 9 && y <= 5 + y_var[46] - 9))) begin
//    oled_colour <= 16'h9000;  // red left arrow
//end

//else if (missed[46] && (y_var[46] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[46] - 9 + 63 && y < y_missing[46] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[46] - 9 + 63 && y <= 9 + y_missing[46] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[46] - 9 + 63 && y <= 8 + y_missing[46] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[46] - 9 + 63 && y <= 7 + y_missing[46] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[46] - 9 + 63 && y <= 6 + y_missing[46] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[46] - 9 + 63 && y <= 5 + y_missing[46] - 9 + 63))) begin
//    oled_colour <= 16'h9000;  // color for missed case
//end

//else if (y_var[48] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[48] - 9 && y < y_var[48] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[48] - 9 && y <= 9 + y_var[48] - 9) ||
//    (x == 25 && y >= 1 + y_var[48] - 9 && y <= 8 + y_var[48] - 9) ||
//    (x == 24 && y >= 2 + y_var[48] - 9 && y <= 7 + y_var[48] - 9) ||
//    (x == 23 && y >= 3 + y_var[48] - 9 && y <= 6 + y_var[48] - 9) ||
//    (x == 22 && y >= 4 + y_var[48] - 9 && y <= 5 + y_var[48] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[48] && (y_var[48] == 63) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[48] && y < 63 + 8 - 9 + y_missing[48]) ||
//    (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[48] && y <= 9 + 63 - 9 + y_missing[48]) ||
//    (x == 25 && y >= 1 + 63 - 9 + y_missing[48] && y <= 8 + 63 - 9 + y_missing[48]) ||
//    (x == 24 && y >= 2 + 63 - 9 + y_missing[48] && y <= 7 + 63 - 9 + y_missing[48]) ||
//    (x == 23 && y >= 3 + 63 - 9 + y_missing[48] && y <= 6 + 63 - 9 + y_missing[48]) ||
//    (x == 22 && y >= 4 + 63 - 9 + y_missing[48] && y <= 5 + 63 - 9 + y_missing[48]))) begin
//    oled_colour <= 16'h9000;
//end 
//else if (y_var[50] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[50] - 9 && y < y_var[50] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[50] - 9 && y <= 9 + y_var[50] - 9) ||
//    (x == 25 && y >= 1 + y_var[50] - 9 && y <= 8 + y_var[50] - 9) ||
//    (x == 24 && y >= 2 + y_var[50] - 9 && y <= 7 + y_var[50] - 9) ||
//    (x == 23 && y >= 3 + y_var[50] - 9 && y <= 6 + y_var[50] - 9) ||
//    (x == 22 && y >= 4 + y_var[50] - 9 && y <= 5 + y_var[50] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[50] && (y_var[50] == 63) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[50] && y < 63 + 8 - 9 + y_missing[50]) ||
//    (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[50] && y <= 9 + 63 - 9 + y_missing[50]) ||
//    (x == 25 && y >= 1 + 63 - 9 + y_missing[50] && y <= 8 + 63 - 9 + y_missing[50]) ||
//    (x == 24 && y >= 2 + 63 - 9 + y_missing[50] && y <= 7 + 63 - 9 + y_missing[50]) ||
//    (x == 23 && y >= 3 + 63 - 9 + y_missing[50] && y <= 6 + 63 - 9 + y_missing[50]) ||
//    (x == 22 && y >= 4 + 63 - 9 + y_missing[50] && y <= 5 + 63 - 9 + y_missing[50]))) begin
//    oled_colour <= 16'h9000;
//end 
//else if (y_var[53] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[53] - 9 && y <= 7 + y_var[53] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[53] - 9 && y <= 9 + y_var[53] - 9) ||
//    (x == 73 && y >= 1 + y_var[53] - 9 && y <= 8 + y_var[53] - 9) ||
//    (x == 74 && y >= 2 + y_var[53] - 9 && y <= 7 + y_var[53] - 9) ||
//    (x == 75 && y >= 3 + y_var[53] - 9 && y <= 6 + y_var[53] - 9) ||
//    (x == 76 && y >= 4 + y_var[53] - 9 && y <= 5 + y_var[53] - 9))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end else if (missed[53] && (y_var[53] == 63) && ((x >= 67 && x <= 70 && y >= 2 + 63 - 9 + y_missing[53] && y <= 7 + 63 - 9 + y_missing[53]) ||
//    (x >= 71 && x <= 72 && y >= 0 + 63 - 9 + y_missing[53] && y <= 9 + 63 - 9 + y_missing[53]) ||
//    (x == 73 && y >= 1 + 63 - 9 + y_missing[53] && y <= 8 + 63 - 9 + y_missing[53]) ||
//    (x == 74 && y >= 2 + 63 - 9 + y_missing[53] && y <= 7 + 63 - 9 + y_missing[53]) ||
//    (x == 75 && y >= 3 + 63 - 9 + y_missing[53] && y <= 6 + 63 - 9 + y_missing[53]) ||
//    (x == 76 && y >= 4 + 63 - 9 + y_missing[53] && y <= 5 + 63 - 9 + y_missing[53]))) begin
//    oled_colour <= 16'h0400;

//end
//else if (y_var[54] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[54] - 9 && y <= 9 + y_var[54] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[54] - 9 && y <= 5 + y_var[54] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[54] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[54] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[54] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[54] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[54] && (y_var[54] == 63) && ((x >= 39 && x <= 44 && y >= 6 + 63 - 9 + y_missing[54] && y <= 9 + 63 - 9 + y_missing[54]) ||
//    (x >= 37 && x <= 46 && y >= 4 + 63 - 9 + y_missing[54] && y <= 5 + 63 - 9 + y_missing[54]) ||
//    (x >= 38 && x <= 45 && y == 3 + 63 - 9 + y_missing[54]) ||
//    (x >= 39 && x <= 44 && y == 2 + 63 - 9 + y_missing[54]) ||
//    (x >= 40 && x <= 43 && y == 1 + 63 - 9 + y_missing[54]) ||
//    (x >= 41 && x <= 42 && y == 0 + 63 - 9 + y_missing[54]))) begin
//    oled_colour <= 16'h0010;
//end 


//else if (y_var[55] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[55] - 9 && y <= 9 + y_var[55] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[55] - 9 && y <= 5 + y_var[55] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[55] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[55] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[55] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[55] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[55] && (y_var[55] == 63) && ((x >= 39 && x <= 44 && y >= 6 + 63 - 9 + y_missing[55] && y <= 9 + 63 - 9 + y_missing[55]) ||
//    (x >= 37 && x <= 46 && y >= 4 + 63 - 9 + y_missing[55] && y <= 5 + 63 - 9 + y_missing[55]) ||
//    (x >= 38 && x <= 45 && y == 3 + 63 - 9 + y_missing[55]) ||
//    (x >= 39 && x <= 44 && y == 2 + 63 - 9 + y_missing[55]) ||
//    (x >= 40 && x <= 43 && y == 1 + 63 - 9 + y_missing[55]) ||
//    (x >= 41 && x <= 42 && y == 0 + 63 - 9 + y_missing[55]))) begin
//    oled_colour <= 16'h0010;

//end

//else if (y_var[57] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[57] - 9 && y < y_var[57] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[57] - 9 && y <= 9 + y_var[57] - 9) ||
//    (x == 25 && y >= 1 + y_var[57] - 9 && y <= 8 + y_var[57] - 9) ||
//    (x == 24 && y >= 2 + y_var[57] - 9 && y <= 7 + y_var[57] - 9) ||
//    (x == 23 && y >= 3 + y_var[57] - 9 && y <= 6 + y_var[57] - 9) ||
//    (x == 22 && y >= 4 + y_var[57] - 9 && y <= 5 + y_var[57] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[57] && (y_var[57] == 63) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[57] && y < 63 + 8 - 9 + y_missing[57]) ||
//    (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[57] && y <= 9 + 63 - 9 + y_missing[57]) ||
//    (x == 25 && y >= 1 + 63 - 9 + y_missing[57] && y <= 8 + 63 - 9 + y_missing[57]) ||
//    (x == 24 && y >= 2 + 63 - 9 + y_missing[57] && y <= 7 + 63 - 9 + y_missing[57]) ||
//    (x == 23 && y >= 3 + 63 - 9 + y_missing[57] && y <= 6 + 63 - 9 + y_missing[57]) ||
//    (x == 22 && y >= 4 + 63 - 9 + y_missing[57] && y <= 5 + 63 - 9 + y_missing[57]))) begin
//    oled_colour <= 16'h9000;
//end

//else if (y_var[58] < 63 && ((x >= 54 && x <= 59 && y >= 0 + y_var[58] - 9 && y <= 3 + y_var[58] - 9) ||
//    (x >= 52 && x <= 61 && y >= 4 + y_var[58] - 9 && y <= 5 + y_var[58] - 9) ||
//    (x >= 53 && x <= 60 && y == 6 + y_var[58] - 9) ||
//    (x >= 54 && x <= 59 && y == 7 + y_var[58] - 9) ||
//    (x >= 55 && x <= 58 && y == 8 + y_var[58] - 9) ||
//    (x >= 56 && x <= 57 && y == 9 + y_var[58] - 9))) begin
//    oled_colour <= 16'h801F; // purple down arrow
//end else if (missed[58] && (y_var[58] == 63) && ((x >= 54 && x <= 59 && y >= 0 + 63 - 9 + y_missing[58] && y <= 3 + 63 - 9 + y_missing[58]) ||
//    (x >= 52 && x <= 61 && y >= 4 + 63 - 9 + y_missing[58] && y <= 5 + 63 - 9 + y_missing[58]) ||
//    (x >= 53 && x <= 60 && y == 6 + 63 - 9 + y_missing[58]) ||
//    (x >= 54 && x <= 59 && y == 7 + 63 - 9 + y_missing[58]) ||
//    (x >= 55 && x <= 58 && y == 8 + 63 - 9 + y_missing[58]) ||
//    (x >= 56 && x <= 57 && y == 9 + 63 - 9 + y_missing[58]))) begin
//    oled_colour <= 16'h801F;
//end


//else if (y_var[59] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[59] - 9 && y <= 7 + y_var[59] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[59] - 9 && y <= 9 + y_var[59] - 9) ||
//    (x == 73 && y >= 1 + y_var[59] - 9 && y <= 8 + y_var[59] - 9) ||
//    (x == 74 && y >= 2 + y_var[59] - 9 && y <= 7 + y_var[59] - 9) ||
//    (x == 75 && y >= 3 + y_var[59] - 9 && y <= 6 + y_var[59] - 9) ||
//    (x == 76 && y >= 4 + y_var[59] - 9 && y <= 5 + y_var[59] - 9))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end else if (missed[59] && (y_var[59] == 63) && ((x >= 67 && x <= 70 && y >= 2 + 63 - 9 + y_missing[59] && y <= 7 + 63 - 9 + y_missing[59]) ||
//    (x >= 71 && x <= 72 && y >= 0 + 63 - 9 + y_missing[59] && y <= 9 + 63 - 9 + y_missing[59]) ||
//    (x == 73 && y >= 1 + 63 - 9 + y_missing[59] && y <= 8 + 63 - 9 + y_missing[59]) ||
//    (x == 74 && y >= 2 + 63 - 9 + y_missing[59] && y <= 7 + 63 - 9 + y_missing[59]) ||
//    (x == 75 && y >= 3 + 63 - 9 + y_missing[59] && y <= 6 + 63 - 9 + y_missing[59]) ||
//    (x == 76 && y >= 4 + 63 - 9 + y_missing[59] && y <= 5 + 63 - 9 + y_missing[59]))) begin
//    oled_colour <= 16'h0400;
//end

//else if (y_var[60] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[60] - 9 && y < y_var[60] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[60] - 9 && y <= 9 + y_var[60] - 9) ||
//    (x == 25 && y >= 1 + y_var[60] - 9 && y <= 8 + y_var[60] - 9) ||
//    (x == 24 && y >= 2 + y_var[60] - 9 && y <= 7 + y_var[60] - 9) ||
//    (x == 23 && y >= 3 + y_var[60] - 9 && y <= 6 + y_var[60] - 9) ||
//    (x == 22 && y >= 4 + y_var[60] - 9 && y <= 5 + y_var[60] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[60] && (y_var[60] == 63) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[60] && y < 63 + 8 - 9 + y_missing[60]) ||
//    (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[60] && y <= 9 + 63 - 9 + y_missing[60]) ||
//    (x == 25 && y >= 1 + 63 - 9 + y_missing[60] && y <= 8 + 63 - 9 + y_missing[60]) ||
//    (x == 24 && y >= 2 + 63 - 9 + y_missing[60] && y <= 7 + 63 - 9 + y_missing[60]) ||
//    (x == 23 && y >= 3 + 63 - 9 + y_missing[60] && y <= 6 + 63 - 9 + y_missing[60]) ||
//    (x == 22 && y >= 4 + 63 - 9 + y_missing[60] && y <= 5 + 63 - 9 + y_missing[60]))) begin
//    oled_colour <= 16'h9000;
//end

//else if (y_var[62] < 63 && ((x >= 54 && x <= 59 && y >= 0 + y_var[62] - 9 && y <= 3 + y_var[62] - 9) ||
//    (x >= 52 && x <= 61 && y >= 4 + y_var[62] - 9 && y <= 5 + y_var[62] - 9) ||
//    (x >= 53 && x <= 60 && y == 6 + y_var[62] - 9) ||
//    (x >= 54 && x <= 59 && y == 7 + y_var[62] - 9) ||
//    (x >= 55 && x <= 58 && y == 8 + y_var[62] - 9) ||
//    (x >= 56 && x <= 57 && y == 9 + y_var[62] - 9))) begin
//    oled_colour <= 16'h801F; // purple down arrow
//end else if (missed[62] && (y_var[62] == 63) && ((x >= 54 && x <= 59 && y >= 0 + 63 - 9 + y_missing[62] && y <= 3 + 63 - 9 + y_missing[62]) ||
//    (x >= 52 && x <= 61 && y >= 4 + 63 - 9 + y_missing[62] && y <= 5 + 63 - 9 + y_missing[62]) ||
//    (x >= 53 && x <= 60 && y == 6 + 63 - 9 + y_missing[62]) ||
//    (x >= 54 && x <= 59 && y == 7 + 63 - 9 + y_missing[62]) ||
//    (x >= 55 && x <= 58 && y == 8 + 63 - 9 + y_missing[62]) ||
//    (x >= 56 && x <= 57 && y == 9 + 63 - 9 + y_missing[62]))) begin
//    oled_colour <= 16'h801F;
//end

//else if (y_var[63] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[63] - 9 && y <= 7 + y_var[63] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[63] - 9 && y <= 9 + y_var[63] - 9) ||
//    (x == 73 && y >= 1 + y_var[63] - 9 && y <= 8 + y_var[63] - 9) ||
//    (x == 74 && y >= 2 + y_var[63] - 9 && y <= 7 + y_var[63] - 9) ||
//    (x == 75 && y >= 3 + y_var[63] - 9 && y <= 6 + y_var[63] - 9) ||
//    (x == 76 && y >= 4 + y_var[63] - 9 && y <= 5 + y_var[63] - 9))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end else if (missed[63] && (y_var[63] == 63) && ((x >= 67 && x <= 70 && y >= 2 + 63 - 9 + y_missing[63] && y <= 7 + 63 - 9 + y_missing[63]) ||
//    (x >= 71 && x <= 72 && y >= 0 + 63 - 9 + y_missing[63] && y <= 9 + 63 - 9 + y_missing[63]) ||
//    (x == 73 && y >= 1 + 63 - 9 + y_missing[63] && y <= 8 + 63 - 9 + y_missing[63]) ||
//    (x == 74 && y >= 2 + 63 - 9 + y_missing[63] && y <= 7 + 63 - 9 + y_missing[63]) ||
//    (x == 75 && y >= 3 + 63 - 9 + y_missing[63] && y <= 6 + 63 - 9 + y_missing[63]) ||
//    (x == 76 && y >= 4 + 63 - 9 + y_missing[63] && y <= 5 + 63 - 9 + y_missing[63]))) begin
//    oled_colour <= 16'h0400;
//end 

//else if (y_var[64] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[64] - 9 && y <= 9 + y_var[64] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[64] - 9 && y <= 5 + y_var[64] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[64] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[64] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[64] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[64] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[64] && (y_var[64] == 63) && ((x >= 39 && x <= 44 && y >= 6 + 63 - 9 + y_missing[64] && y <= 9 + 63 - 9 + y_missing[64]) ||
//    (x >= 37 && x <= 46 && y >= 4 + 63 - 9 + y_missing[64] && y <= 5 + 63 - 9 + y_missing[64]) ||
//    (x >= 38 && x <= 45 && y == 3 + 63 - 9 + y_missing[64]) ||
//    (x >= 39 && x <= 44 && y == 2 + 63 - 9 + y_missing[64]) ||
//    (x >= 40 && x <= 43 && y == 1 + 63 - 9 + y_missing[64]) ||
//    (x >= 41 && x <= 42 && y == 0 + 63 - 9 + y_missing[64]))) begin
//    oled_colour <= 16'h0010;
//end 

//else if (y_var[65] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[65] - 9 && y < y_var[65] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[65] - 9 && y <= 9 + y_var[65] - 9) ||
//    (x == 25 && y >= 1 + y_var[65] - 9 && y <= 8 + y_var[65] - 9) ||
//    (x == 24 && y >= 2 + y_var[65] - 9 && y <= 7 + y_var[65] - 9) ||
//    (x == 23 && y >= 3 + y_var[65] - 9 && y <= 6 + y_var[65] - 9) ||
//    (x == 22 && y >= 4 + y_var[65] - 9 && y <= 5 + y_var[65] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[65] && (y_var[65] == 63) && ((x >= 28 && x <= 31 && y >= 2 + 63 - 9 + y_missing[65] && y < 63 + 8 - 9 + y_missing[65]) ||
//    (x >= 26 && x <= 27 && y >= 0 + 63 - 9 + y_missing[65] && y <= 9 + 63 - 9 + y_missing[65]) ||
//    (x == 25 && y >= 1 + 63 - 9 + y_missing[65] && y <= 8 + 63 - 9 + y_missing[65]) ||
//    (x == 24 && y >= 2 + 63 - 9 + y_missing[65] && y <= 7 + 63 - 9 + y_missing[65]) ||
//    (x == 23 && y >= 3 + 63 - 9 + y_missing[65] && y <= 6 + 63 - 9 + y_missing[65]) ||
//    (x == 22 && y >= 4 + 63 - 9 + y_missing[65] && y <= 5 + 63 - 9 + y_missing[65]))) begin
//    oled_colour <= 16'h9000;
//end


//else if (y_var[67] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[67] - 9 && y <= 7 + y_var[67] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[67] - 9 && y <= 9 + y_var[67] - 9) ||
//    (x == 73 && y >= 1 + y_var[67] - 9 && y <= 8 + y_var[67] - 9) ||
//    (x == 74 && y >= 2 + y_var[67] - 9 && y <= 7 + y_var[67] - 9) ||
//    (x == 75 && y >= 3 + y_var[67] - 9 && y <= 6 + y_var[67] - 9) ||
//    (x == 76 && y >= 4 + y_var[67] - 9 && y <= 5 + y_var[67] - 9))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end else if (missed[67] && (y_var[67] == 63) && ((x >= 67 && x <= 70 && y >= 2 + 63 - 9 + y_missing[67] && y <= 7 + 63 - 9 + y_missing[67]) ||
//    (x >= 71 && x <= 72 && y >= 0 + 63 - 9 + y_missing[67] && y <= 9 + 63 - 9 + y_missing[67]) ||
//    (x == 73 && y >= 1 + 63 - 9 + y_missing[67] && y <= 8 + 63 - 9 + y_missing[67]) ||
//    (x == 74 && y >= 2 + 63 - 9 + y_missing[67] && y <= 7 + 63 - 9 + y_missing[67]) ||
//    (x == 75 && y >= 3 + 63 - 9 + y_missing[67] && y <= 6 + 63 - 9 + y_missing[67]) ||
//    (x == 76 && y >= 4 + 63 - 9 + y_missing[67] && y <= 5 + 63 - 9 + y_missing[67]))) begin
//    oled_colour <= 16'h0400;
//end

//else if (y_var[69] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[69] - 9 && y <= 9 + y_var[69] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[69] - 9 && y <= 5 + y_var[69] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[69] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[69] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[69] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[69] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[69] && (y_var[69] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[69] - 9 + 63 && y <= 9 + y_missing[69] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[69] - 9 + 63 && y <= 5 + y_missing[69] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[69] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[69] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[69] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[69] - 9 + 63))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end 
//else if (y_var[71] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[71] - 9 && y <= 9 + y_var[71] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[71] - 9 && y <= 5 + y_var[71] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[71] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[71] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[71] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[71] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[71] && (y_var[71] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[71] - 9 + 63 && y <= 9 + y_missing[71] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[71] - 9 + 63 && y <= 5 + y_missing[71] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[71] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[71] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[71] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[71] - 9 + 63))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end 
//else if (y_var[72] < 63 && ((x >= 54 && x <= 59 && y >= 0 + y_var[72] - 9 && y <= 3 + y_var[72] - 9) ||
//    (x >= 52 && x <= 61 && y >= 4 + y_var[72] - 9 && y <= 5 + y_var[72] - 9) ||
//    (x >= 53 && x <= 60 && y == 6 + y_var[72] - 9) ||
//    (x >= 54 && x <= 59 && y == 7 + y_var[72] - 9) ||
//    (x >= 55 && x <= 58 && y == 8 + y_var[72] - 9) ||
//    (x >= 56 && x <= 57 && y == 9 + y_var[72] - 9))) begin
//    oled_colour <= 16'h801F; // purple down arrow
//end else if (missed[72] && (y_var[72] == 63) && ((x >= 54 && x <= 59 && y >= 0 + y_missing[72] - 9 + 63 && y <= 3 + y_missing[72] - 9 + 63) ||
//    (x >= 52 && x <= 61 && y >= 4 + y_missing[72] - 9 + 63 && y <= 5 + y_missing[72] - 9 + 63) ||
//    (x >= 53 && x <= 60 && y == 6 + y_missing[72] - 9 + 63) ||
//    (x >= 54 && x <= 59 && y == 7 + y_missing[72] - 9 + 63) ||
//    (x >= 55 && x <= 58 && y == 8 + y_missing[72] - 9 + 63) ||
//    (x >= 56 && x <= 57 && y == 9 + y_missing[72] - 9 + 63))) begin
//    oled_colour <= 16'h801F; // purple down arrow
//end 
//else if (y_var[73] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[73] - 9 && y <= 9 + y_var[73] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[73] - 9 && y <= 5 + y_var[73] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[73] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[73] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[73] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[73] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[73] && (y_var[73] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[73] - 9 + 63 && y <= 9 + y_missing[73] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[73] - 9 + 63 && y <= 5 + y_missing[73] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[73] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[73] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[73] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[73] - 9 + 63))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end 

//else if (y_var[74] < 63 && ((x >= 67 && x <= 70 && y >= 2 + y_var[74] - 9 && y <= 7 + y_var[74] - 9) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_var[74] - 9 && y <= 9 + y_var[74] - 9) ||
//    (x == 73 && y >= 1 + y_var[74] - 9 && y <= 8 + y_var[74] - 9) ||
//    (x == 74 && y >= 2 + y_var[74] - 9 && y <= 7 + y_var[74] - 9) ||
//    (x == 75 && y >= 3 + y_var[74] - 9 && y <= 6 + y_var[74] - 9) ||
//    (x == 76 && y >= 4 + y_var[74] - 9 && y <= 5 + y_var[74] - 9))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end else if (missed[74] && (y_var[74] == 63) && ((x >= 67 && x <= 70 && y >= 2 + y_missing[74] - 9 + 63 && y <= 7 + y_missing[74] - 9 + 63) ||
//    (x >= 71 && x <= 72 && y >= 0 + y_missing[74] - 9 + 63 && y <= 9 + y_missing[74] - 9 + 63) ||
//    (x == 73 && y >= 1 + y_missing[74] - 9 + 63 && y <= 8 + y_missing[74] - 9 + 63) ||
//    (x == 74 && y >= 2 + y_missing[74] - 9 + 63 && y <= 7 + y_missing[74] - 9 + 63) ||
//    (x == 75 && y >= 3 + y_missing[74] - 9 + 63 && y <= 6 + y_missing[74] - 9 + 63) ||
//    (x == 76 && y >= 4 + y_missing[74] - 9 + 63 && y <= 5 + y_missing[74] - 9 + 63))) begin
//    oled_colour <= 16'h0400; // green right arrow
//end 

//else if (y_var[76] < 63 && ((x >= 39 && x <= 44 && y >= 6 + y_var[76] - 9 && y <= 9 + y_var[76] - 9) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_var[76] - 9 && y <= 5 + y_var[76] - 9) ||
//    (x >= 38 && x <= 45 && y == 3 + y_var[76] - 9) ||
//    (x >= 39 && x <= 44 && y == 2 + y_var[76] - 9) ||
//    (x >= 40 && x <= 43 && y == 1 + y_var[76] - 9) ||
//    (x >= 41 && x <= 42 && y == 0 + y_var[76] - 9))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end else if (missed[76] && (y_var[76] == 63) && ((x >= 39 && x <= 44 && y >= 6 + y_missing[76] - 9 + 63 && y <= 9 + y_missing[76] - 9 + 63) ||
//    (x >= 37 && x <= 46 && y >= 4 + y_missing[76] - 9 + 63 && y <= 5 + y_missing[76] - 9 + 63) ||
//    (x >= 38 && x <= 45 && y == 3 + y_missing[76] - 9 + 63) ||
//    (x >= 39 && x <= 44 && y == 2 + y_missing[76] - 9 + 63) ||
//    (x >= 40 && x <= 43 && y == 1 + y_missing[76] - 9 + 63) ||
//    (x >= 41 && x <= 42 && y == 0 + y_missing[76] - 9 + 63))) begin
//    oled_colour <= 16'h0010; // blue up arrow
//end 

//else if (y_var[79] < 63 && ((x >= 28 && x <= 31 && y >= 2 + y_var[79] - 9 && y < y_var[79] + 8 - 9) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_var[79] - 9 && y <= 9 + y_var[79] - 9) ||
//    (x == 25 && y >= 1 + y_var[79] - 9 && y <= 8 + y_var[79] - 9) ||
//    (x == 24 && y >= 2 + y_var[79] - 9 && y <= 7 + y_var[79] - 9) ||
//    (x == 23 && y >= 3 + y_var[79] - 9 && y <= 6 + y_var[79] - 9) ||
//    (x == 22 && y >= 4 + y_var[79] - 9 && y <= 5 + y_var[79] - 9))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end else if (missed[79] && (y_var[79] == 63) && ((x >= 28 && x <= 31 && y >= 2 + y_missing[79] - 9 + 63 && y < y_missing[79] + 8 - 9 + 63) ||
//    (x >= 26 && x <= 27 && y >= 0 + y_missing[79] - 9 + 63 && y <= 9 + y_missing[79] - 9 + 63) ||
//    (x == 25 && y >= 1 + y_missing[79] - 9 + 63 && y <= 8 + y_missing[79] - 9 + 63) ||
//    (x == 24 && y >= 2 + y_missing[79] - 9 + 63 && y <= 7 + y_missing[79] - 9 + 63) ||
//    (x == 23 && y >= 3 + y_missing[79] - 9 + 63 && y <= 6 + y_missing[79] - 9 + 63) ||
//    (x == 22 && y >= 4 + y_missing[79] - 9 + 63 && y <= 5 + y_missing[79] - 9 + 63))) begin
//    oled_colour <= 16'h9000; // red left arrow
//end 

else if ((x >= 28 && x <= 31 && y >= 56 - 5 && y <= 61 - 5) ||
	(x >= 26 && x <= 27 && y >= 54 - 5 && y <= 63 - 5) ||
	(x == 25 && y >= 55 - 5 && y <= 62 - 5) ||
	(x == 24 && y >= 56 - 5 && y <= 61 - 5) ||
	(x == 23 && y >= 57 - 5 && y <= 60 - 5) ||
	(x == 22 && y >= 58 - 5 && y <= 59 - 5) ||
	(x >= 39 && x <= 44 && y >= 60 - 5 && y <= 63 - 5) ||
	(x >= 37 && x <= 46 && y >= 58 - 5 && y <= 59 - 5) ||
	(x >= 38 && x <= 45 && y == 57 - 5) ||
	(x >= 39 && x <= 44 && y == 56 - 5) ||
	(x >= 40 && x <= 43 && y == 55 - 5) ||
	(x >= 41 && x <= 42 && y == 54 - 5) ||
	(x >= 54 && x <= 59 && y >= 54 - 5 && y <= 57 - 5) ||
	(x >= 52 && x <= 61 && y >= 58 - 5 && y <= 59 - 5) ||
	(x >= 53 && x <= 60 && y == 60 - 5) ||
	(x >= 54 && x <= 59 && y == 61 - 5) ||
	(x >= 55 && x <= 58 && y == 62 - 5) ||
	(x >= 56 && x <= 57 && y == 63 - 5) ||
	(x >= 67 && x <= 70 && y >= 56 - 5 && y <= 61 - 5) ||
	(x >= 71 && x <= 72 && y >= 54 - 5 && y <= 63 - 5) ||
	(x == 73 && y >= 55 - 5 && y <= 62 - 5) ||
	(x == 74 && y >= 56 - 5 && y <= 61 - 5) ||
	(x == 75 && y >= 57 - 5 && y <= 60 - 5) ||
	(x == 76 && y >= 58 - 5 && y <= 59 - 5) ||
	(y >= 0 - 5 && y <= 63 - 5 && x == 34) ||
	(y >= 0 - 5 && y <= 63 - 5 && x == 49) ||
	(y >= 0 - 5 && y <= 63 - 5 && x == 64)) begin
oled_colour <= 16 'b01101_100001_10001; 	//white arrow at the bottom
end

else begin
oled_colour <= 16 'b0;	//black background
end

end

endcase
end

endmodule