`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yoshizaki Eichi Lance
// 
// Create Date: 10/14/2024 03:18:41 PM
// Design Name: 
// Module Name: keypress
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


module keypress #(
    parameter makecode = 24'b0,
    parameter breakcode = 24'b0
    )(
    input [23:0] keycode,
    input oflag,
    output reg key_status=0
    );

always @ (negedge oflag) begin
    if (makecode[15:8]==8'hE0) begin
        if (keycode==breakcode) begin
            key_status <= 0;
        end
        else if (keycode[15:0]==makecode[15:0]) begin
            key_status <= 1;
        end
    end
    else begin
        if (keycode[15:0]==breakcode[15:0] && keycode[23:16]!=8'hE0) begin
            key_status <= 0;
        end
        else if (keycode[7:0]==makecode[7:0] && keycode[15:8]!=8'hE0 && keycode[15:8]!=8'hF0) begin
            key_status <= 1;
        end
    end
end

endmodule
