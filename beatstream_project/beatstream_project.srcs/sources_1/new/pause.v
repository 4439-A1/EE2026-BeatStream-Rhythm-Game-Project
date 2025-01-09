module pause (input CLOCK, output [7:0] JC);
    wire clk6p25m, clk_30Hz;
    
    reg [15:0] oled_colour = 16'b00000_000000_00000;
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
     .sample_pixel(sample_pix), .pixel_index(pixel_index), .pixel_data(oled_colour), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
     .pmoden(JC[7]));
 

    always @(posedge clk6p25m) begin

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
        
endmodule