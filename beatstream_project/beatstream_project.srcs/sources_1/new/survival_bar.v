`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 17:51:59
// Design Name: 
// Module Name: survival_bar
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 01:06:06
// Design Name: 
// Module Name: survival_bar
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


module survival_bar(input basys_clock, input btnc, output [7:0] JC
//    ,output reg dead
);

    wire slow_clock_6p25mhz;
    wire slow_clock_25mhz;
    flexible_clock unit_1 (basys_clock, 7, slow_clock_6p25mhz);
    flexible_clock unit_4 (basys_clock, 1, slow_clock_25mhz);  // Slower clock for reliable health update

    wire [12:0] pix_index;
    wire fb, sending_pix, sample_pix;
    wire [12:0] x;
    wire [12:0] y;
 
    reg [15:0] oled_colour = 16'b00000_000000_00000;
    reg [6:0] health_level = 100;  // Initialize health level to maximum (100%)
    reg btnc_prev = 0;             // Register to store previous button state
    reg [5:0] bar_width;           // Register for bar width

    assign x = pix_index % 96;
    assign y = pix_index / 96;

    Oled_Display my_oled_unit(
        .clk(slow_clock_6p25mhz), .reset(0), .frame_begin(fb), .sending_pixels(sending_pix),
        .sample_pixel(sample_pix), .pixel_index(pix_index), .pixel_data(oled_colour), 
        .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), 
        .vccen(JC[6]), .pmoden(JC[7])
    );

    always @(posedge slow_clock_25mhz) begin
        oled_colour <= 16'b00000_000000_00000; // Default to black
        
        // Check if btnc is pressed and was not pressed in the previous cycle
        if (btnc && !btnc_prev && health_level > 0) begin
         if (health_level > 10) begin
                    health_level <= health_level - 10; // Decrease health by 10 until it reaches 10
                end else begin
                    health_level <= 0; // Set health to 0 if decrement would bring it below zero
                end
            end
            btnc_prev <= btnc;  // Update previous button state
        // Calculate bar width based on updated health level
        bar_width <= (health_level * 21) / 100; // Scale to max width of 21 pixels

        // Draw the green survival bar based on the calculated bar width
                if (y >= 13 && y <= 18 && x >= 0 && x <= bar_width) begin
                   oled_colour <= (health_level < 20) ? 16'b11111_000000_00000 :         // Red if below 20%
                                      (health_level < 50) ? 16'b11111_111111_00000 :         // Orange if below 50%
                                                          16'b00000_111111_00000;          // Green otherwise
                   end else begin 
                       oled_colour <= 16'b00000_000000_00000; // Black background outside bar
                   end 
               end
               endmodule 
