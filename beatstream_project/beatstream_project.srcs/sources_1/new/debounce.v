`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 15:50:51
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,       
    input button,     
    output reg button_out 
);

    reg [1:0] state = 0;  
    reg [7:0] counter = 0;

   
    parameter IDLE = 0, DEBOUNCE = 1, WAIT_RELEASE = 2;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (button == 1) begin
                    button_out <= 1;      
                    state <= DEBOUNCE;    
                    counter <= 0;        
                end else begin
                    button_out <= 0;    
                end
            end
            DEBOUNCE: begin
                button_out <= 0;         
                counter <= counter + 1;   
                if (counter >= 50) begin 
                    state <= WAIT_RELEASE; 
                end
            end
            WAIT_RELEASE: begin
                if (button == 0) begin
                    state <= IDLE;       
                end
            end
        endcase
    end
endmodule
