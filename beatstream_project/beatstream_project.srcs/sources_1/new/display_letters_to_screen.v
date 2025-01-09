`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 18:32:21
// Design Name: 
// Module Name: display_letters_to_screen
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


module display_letters_to_screen(


    input basys_clock,
    input [25:0] abc,
    output  [7:0] JC
    );  
    
    wire slow_clock_6p25mhz;
    flexible_clock unit_1 (basys_clock, 7, slow_clock_6p25mhz);
    wire [12:0] pix_index;
    wire fb, sending_pix, sample_pix;
    wire [159:0] display_mapping;
    reg [15:0] oled_colour = 16'b00000_000000_00000; //red blue green respectively
    reg [15:0] colour; 
    
    
    Oled_Display my_oled_unit(.clk(slow_clock_6p25mhz), .reset(0), .frame_begin(fb), .sending_pixels(sending_pix),
      .sample_pixel(sample_pix), .pixel_index(pix_index), .pixel_data(oled_colour), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
      .pmoden(JC[7]));
wire q_status, w_status, e_status, r_status, t_status, y_status, u_status, i_status, o_status, p_status, a_status, s_status, d_status, f_status, g_status, h_status,
          j_status, k_status, l_status, z_status, x_status, c_status, v_status, b_status, n_status, m_status;

assign a_status=abc[0];
assign b_status=abc[1];
assign c_status=abc[2];
assign d_status=abc[3];
assign e_status=abc[4];
assign f_status=abc[5];
assign g_status=abc[6];
assign h_status=abc[7];
assign i_status=abc[8];
assign j_status=abc[9];
assign k_status=abc[10];
assign l_status=abc[11];
assign m_status=abc[12];
assign n_status=abc[13];
assign o_status=abc[14];
assign p_status=abc[15];
assign q_status=abc[16];
assign r_status=abc[17];
assign s_status=abc[18];
assign t_status=abc[19];
assign u_status=abc[20];
assign v_status=abc[21];
assign w_status=abc[22];
assign x_status=abc[23];
assign y_status=abc[24];
assign z_status=abc[25];


wire[7:0]a = 8'h1C;
    wire[7:0]b = 8'h32;
    wire[7:0]c = 8'h21;
    wire[7:0]d = 8'h23;
    wire[7:0]e = 8'h24;
    wire[7:0]f = 8'h2B;
    wire[7:0]g = 8'h34;
    wire[7:0]h = 8'h33;
    wire[7:0]i = 8'h43;
    wire[7:0]j = 8'h3B;
    wire[7:0]k = 8'h42;
    wire[7:0]l = 8'h4B;
    wire[7:0]m = 8'h3A;
    wire[7:0]n = 8'h31;
    wire[7:0]o = 8'h44;
    wire[7:0]p = 8'h4D;
    wire[7:0]q = 8'h15;
    wire[7:0]r = 8'h2D;
    wire[7:0]s = 8'h1B;
    wire[7:0]t = 8'h2C;
    wire[7:0]u = 8'h3C;
    wire[7:0]v = 8'h2A;
    wire[7:0]w = 8'h1D;
    wire[7:0]letter_x = 8'h22;
    wire[7:0]letter_y = 8'h35;
    wire[7:0]z = 8'h1A;
    wire[7:0]space = 8'h29;
    wire[7:0]underline = 8'h1;
    wire[7:0]separator = 8'h2;
    wire[7:0]null = 8'd0;

    


    //shiftx = 90
    //shifty = 54

    wire[6:0] x_pos;
    wire[5:0] y_pos;
    assign x_pos = (pix_index%96);
    assign y_pos = (pix_index/96);

    //each character shiftX += 6
    //each line shiftY += 9
    

    //colours
    parameter [15:0] WHITE = 16'b1111111111111111;
    parameter [15:0] BLACK = 16'd0;
    parameter [15:0] RED = 16'b1111100000000000;
    parameter [15:0] GREEN = 16'b0000011111100000;
    
    
    
     wire char_pos_1;
       wire char_pos_2;
       wire char_pos_3;
       wire char_pos_4;
       wire char_pos_5;
       wire char_pos_6;
       wire char_pos_7;
       wire char_pos_8;
       wire char_pos_9;
       wire char_pos_10;
       wire char_pos_11;
       wire char_pos_12;
       wire char_pos_13;
       wire char_pos_14;
       wire char_pos_15;
       wire char_pos_16;
       wire char_pos_17;
       wire char_pos_18;
       wire char_pos_19;
       wire char_pos_20;
       wire separator_pos;

// top half
    assign char_pos_1 =  (x_pos >= 9 && x_pos <= 15) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_2 =  (x_pos >= 17 && x_pos <= 23) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_3 =  (x_pos >= 25 && x_pos <= 31) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_4 =  (x_pos >= 33 && x_pos <= 39) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_5 =  (x_pos >= 41 && x_pos <= 47) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_6 =  (x_pos >= 49 && x_pos <= 55) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_7 =  (x_pos >= 57 && x_pos <= 63) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_8 =  (x_pos >= 65 && x_pos <= 71) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_9 =  (x_pos >= 73 && x_pos <= 79) && (y_pos >= 15 && y_pos <= 23);
    assign char_pos_10 =  (x_pos >= 81 && x_pos <= 87) && (y_pos >= 15 && y_pos <= 23);
    // bottom half
    assign char_pos_11 =  (x_pos >= 9 && x_pos <= 15) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_12 =  (x_pos >= 17 && x_pos <= 23) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_13 =  (x_pos >= 25 && x_pos <= 31) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_14 =  (x_pos >= 33 && x_pos <= 39) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_15 =  (x_pos >= 41 && x_pos <= 47) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_16 =  (x_pos >= 49 && x_pos <= 55) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_17 =  (x_pos >= 57 && x_pos <= 63) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_18 =  (x_pos >= 65 && x_pos <= 71) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_19 =  (x_pos >= 73 && x_pos <= 79) && (y_pos >= 41 && y_pos <= 49);
    assign char_pos_20 =  (x_pos >= 81 && x_pos <= 87) && (y_pos >= 41 && y_pos <= 49);
    assign separator_pos = (x_pos >= 0 && x_pos <= 96) && (y_pos >= 32 && y_pos <= 33);
   
    // top half
       wire[7:0]display_pos1;
       wire[7:0]display_pos2;
       wire[7:0]display_pos3;
       wire[7:0]display_pos4;
       wire[7:0]display_pos5;
       wire[7:0]display_pos6;
       wire[7:0]display_pos7;
       wire[7:0]display_pos8;
       wire[7:0]display_pos9;
       wire[7:0]display_pos10;
       // bottom half
       wire[7:0]display_pos11;
       wire[7:0]display_pos12;
       wire[7:0]display_pos13;
       wire[7:0]display_pos14;
       wire[7:0]display_pos15;
       wire[7:0]display_pos16;
       wire[7:0]display_pos17;
       wire[7:0]display_pos18;
       wire[7:0]display_pos19;
       wire[7:0]display_pos20;
       
  function [15:0]display_A (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5))))begin
                 display_A = colour;
              end
              else begin
                 display_A = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_B (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4))))begin
                 display_B = colour;
              end
              else begin
                 display_B = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_C (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_C = colour;
              end
              else begin
                 display_C = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_D (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4))))begin
                 display_D = colour;
              end
              else begin
                 display_D = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_E (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_E = colour;
              end
              else begin
                 display_E = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_F (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2))))begin
                 display_F = colour;
              end
              else begin
                 display_F = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_G (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_G = colour;
              end
              else begin
                 display_G = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_H (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5))))begin
                 display_H = colour;
              end
              else begin
                 display_H = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_I (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4))))begin
                 display_I = colour;
              end
              else begin
                 display_I = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_J (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_J = colour;
              end
              else begin
                 display_J = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_K (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5))))begin
                 display_K = colour;
              end
              else begin
                 display_K = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_L (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_L = colour;
              end
              else begin
                 display_L = BLACK;
              end
           end
        endfunction
     
     
         function [15:0]display_M (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 3)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 4) || ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6))))begin
                 display_M = colour;
              end
              else begin
                 display_M = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_N (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 3)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 6))))begin
                 display_N = colour;
              end
              else begin
                 display_N = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_O (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_O = colour;
              end
              else begin
                 display_O = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_P (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2))))begin
                 display_P = colour;
              end
              else begin
                 display_P = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_Q (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_Q = colour;
              end
              else begin
                 display_Q = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_R (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5))))begin
                 display_R = colour;
              end
              else begin
                 display_R = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_S (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 1 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_S = colour;
              end
              else begin
                 display_S = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_T (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 1 && (x - x_top_left) < 3))))begin
                 display_T = colour;
              end
              else begin
                 display_T = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_U (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_U = colour;
              end
              else begin
                 display_U = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_V (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 1 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 2 && (x - x_top_left) < 3))))begin
                 display_V = colour;
              end
              else begin
                 display_V = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_W (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 4)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 1)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 4)|| ((x - x_top_left) >= 5 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 1 && (x - x_top_left) < 6)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 2 && (x - x_top_left) < 3)|| ((x - x_top_left) >= 4 && (x - x_top_left) < 5))))begin
                 display_W = colour;
              end
              else begin
                 display_W = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_X (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 1 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5))))begin
                 display_X = colour;
              end
              else begin
                 display_X = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_Y (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 1 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 2 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 2 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 2 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 2 && (x - x_top_left) < 4))))begin
                 display_Y = colour;
              end
              else begin
                 display_Y = BLACK;
              end
           end
        endfunction
     
        function [15:0]display_Z (input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
             if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 2) && (((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 3) && (((x - x_top_left) >= 1 && (x - x_top_left) < 4)))|| 
        (((y - y_top_left) == 4) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 5) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)))|| 
        (((y - y_top_left) == 6) && (((x - x_top_left) >= 0 && (x - x_top_left) < 2)|| ((x - x_top_left) >= 3 && (x - x_top_left) < 5)))|| 
        (((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 5))))begin
                 display_Z = colour;
              end
              else begin
                 display_Z = BLACK;
              end
           end
        endfunction
     
        function [15:0] display_underline(input [6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0] colour);
           begin
              if ((((y - y_top_left) == 7) && (((x - x_top_left) >= 0 && (x - x_top_left) < 6))) ||
              (((y - y_top_left) == 8) && (((x - x_top_left) >= 0 && (x - x_top_left) < 6))))
                 display_underline = colour;
              else
                 display_underline = BLACK;
           end
        endfunction
     
        function [15:0] display_separator(input [6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0] colour);
           begin
              if ((((y - y_top_left) == 0) && (((x - x_top_left) >= 0 && (x - x_top_left) < 96))) || 
              (((y - y_top_left) == 1) && (((x - x_top_left) >= 0 && (x - x_top_left) < 96))))
                 display_separator = colour;
              else
                 display_separator = BLACK;
           end
        endfunction
     
        function [15:0]display_character(input[7:0] char, input[6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0]colour);
           begin
              case(char)
                 a:display_character = display_A(x_top_left,y_top_left,x,y,colour);
                 b:display_character = display_B(x_top_left,y_top_left,x,y,colour);
                 c:display_character = display_C(x_top_left,y_top_left,x,y,colour);
                 d:display_character = display_D(x_top_left,y_top_left,x,y,colour);
                 e:display_character = display_E(x_top_left,y_top_left,x,y,colour);
                 f:display_character = display_F(x_top_left,y_top_left,x,y,colour);
                 g:display_character = display_G(x_top_left,y_top_left,x,y,colour);
                 h:display_character = display_H(x_top_left,y_top_left,x,y,colour);
                 i:display_character = display_I(x_top_left,y_top_left,x,y,colour);
                 j:display_character = display_J(x_top_left,y_top_left,x,y,colour);
                 k:display_character = display_K(x_top_left,y_top_left,x,y,colour);
                 l:display_character = display_L(x_top_left,y_top_left,x,y,colour);
                 m:display_character = display_M(x_top_left,y_top_left,x,y,colour);
                 n:display_character = display_N(x_top_left,y_top_left,x,y,colour);
                 o:display_character = display_O(x_top_left,y_top_left,x,y,colour);
                 p:display_character = display_P(x_top_left,y_top_left,x,y,colour);
                 q:display_character = display_Q(x_top_left,y_top_left,x,y,colour);
                 r:display_character = display_R(x_top_left,y_top_left,x,y,colour);
                 s:display_character = display_S(x_top_left,y_top_left,x,y,colour);
                 t:display_character = display_T(x_top_left,y_top_left,x,y,colour);
                 u:display_character = display_U(x_top_left,y_top_left,x,y,colour);
                 v:display_character = display_V(x_top_left,y_top_left,x,y,colour);
                 w:display_character = display_W(x_top_left,y_top_left,x,y,colour);
                 letter_x:display_character = display_X(x_top_left,y_top_left,x,y,colour);
                 letter_y:display_character = display_Y(x_top_left,y_top_left,x,y,colour);
                 z:display_character = display_Z(x_top_left,y_top_left,x,y,colour);
                 underline:display_character = display_underline(x_top_left,y_top_left,x,y,colour);
                 separator:display_character = display_separator(x_top_left,y_top_left,x,y,colour);
                 null:display_character = BLACK;
                 space:display_character = BLACK;
                 endcase
             end
         endfunction
     
     
     // display_underline(input [6:0] x_top_left, input[5:0] y_top_left, input[6:0] x, input[5:0] y, input[15:0] colour);
         always@(posedge slow_clock_6p25mhz) begin
             if(char_pos_1)begin
               oled_colour <= display_character(display_pos1,9,15,x_pos,y_pos,WHITE);
              end
              else if (char_pos_2) begin
                 oled_colour <= display_character(display_pos2,17,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_3)begin
                oled_colour <= display_character(display_pos3,25,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_4)begin
                oled_colour <= display_character(display_pos4,33,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_5)begin
                 oled_colour <= display_character(display_pos5,41,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_6)begin
                 oled_colour <= display_character(display_pos6,49,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_7)begin
                oled_colour <= display_character(display_pos7,57,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_8)begin
                oled_colour <= display_character(display_pos8,65,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_9)begin
                 oled_colour <= display_character(display_pos9,73,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_10)begin
                oled_colour <= display_character(display_pos10,81,15,x_pos,y_pos,WHITE);
              end
              else if(char_pos_11)begin
                oled_colour <= display_character(display_pos11,9,41,x_pos,y_pos,colour);
              end
              else if(char_pos_12)begin
                oled_colour <= display_character(display_pos12,17,41,x_pos,y_pos,colour);
              end
              else if(char_pos_13)begin
                oled_colour <= display_character(display_pos13,25,41,x_pos,y_pos,colour);
              end
              else if(char_pos_14)begin
               oled_colour <= display_character(display_pos14,33,41,x_pos,y_pos,colour);
              end
              else if(char_pos_15)begin
                oled_colour <= display_character(display_pos15,41,41,x_pos,y_pos,colour);
              end
              else if(char_pos_16)begin
                oled_colour <= display_character(display_pos16,49,41,x_pos,y_pos,colour);
              end
              else if(char_pos_17)begin
                oled_colour <= display_character(display_pos17,57,41,x_pos,y_pos,colour);
              end
              else if(char_pos_18)begin
                 oled_colour <= display_character(display_pos18,65,41,x_pos,y_pos,colour);
              end
              else if(char_pos_19)begin
                 oled_colour <= display_character(display_pos19,73,41,x_pos,y_pos,colour);
              end
              else if(char_pos_20)begin
                 oled_colour <= display_character(display_pos20,81,41,x_pos,y_pos,colour);
              end
              else if (separator_pos)begin
                oled_colour <= display_separator(0, 32, x_pos, y_pos, RED);
              end
              else begin
                oled_colour <= BLACK;
              end
        end
     
     endmodule
