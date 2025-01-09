`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 09:27:28 AM
// Design Name: 
// Module Name: decomposer
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


module decomposer # (parameter N = 2)(
    input clk,
    input [16*N-1:0] m_data_flattened,
    output reg [31:0] len_00=0, len_01=0, len_10=0, len_11=0,
    output reg done_parsing=0
    );
    
    wire [16:0] m_data [0:N-1];
        
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign m_data[i] = m_data_flattened[16*(i+1)-1:16*i];
        end
    endgenerate
    
    reg [31:0] j = 0;
    always @ (posedge clk) begin
        if (j < N) begin
            case (m_data[j][1:0])
                2'b00: len_00 <= len_00 + 1;
                2'b01: len_01 <= len_01 + 1;
                2'b10: len_10 <= len_10 + 1;
                2'b11: len_11 <= len_11 + 1;
            endcase
            j <= j + 1;
        end
        else begin
            done_parsing <= 1;
        end
    end
endmodule
