`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 22:47:48
// Design Name: 
// Module Name: note_grader
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


module note_grader # (
    parameter N = 2
    )
    (
    input clk,
    input btnU, btnR, btnD, btnL,
    input [31:0] play_counter,
    input [13:0] end_time,
    input playing,
    input [16*N-1:0] m_data_flattened,
    output reg [3:0] perfect=0, good=0, bad=0, miss=0,
    output p, g, b, m, 
    output reg [N-1:0] missed_notes=0,
    output reg endscreen=0
    );
    
    wire clk_1kHz;
    clock_divider div1 (clk, 49999, clk_1kHz);
    
    wire [31:0]  len_00, len_01, len_10, len_11;
    wire done_parsing;
    
    decomposer # (N) decomposer_1 (clk, m_data_flattened, len_00, len_01, len_10, len_11, done_parsing);
    
    wire [15:0] m_data [0:N-1];
    reg [13:0] m_data_00 [0:N-1];
    reg [13:0] m_data_01 [0:N-1];
    reg [13:0] m_data_10 [0:N-1];
    reg [13:0] m_data_11 [0:N-1];
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign m_data[i] = m_data_flattened[16*(i+1)-1:16*i];
        end
    endgenerate
    
    reg [31:0] count_00 = 0;
    reg [31:0] count_01 = 0;
    reg [31:0] count_10 = 0;
    reg [31:0] count_11 = 0;
    
    reg [31:0] j = 0;
    reg done_processing = 0;
    always @ (posedge clk) begin
        if (j < N) begin
            case (m_data[j][1:0]) // Check 2 LSBs for lane info
                2'b00: begin
                    m_data_00[count_00] <= m_data[j][15:2];
                    count_00 <= count_00 + 1;
                end
                2'b01: begin
                    m_data_01[count_01] <= m_data[j][15:2];
                    count_01 <= count_01 + 1;
                end
                2'b10: begin
                    m_data_10[count_10] <= m_data[j][15:2];
                    count_10 <= count_10 + 1;
                end
                2'b11: begin
                    m_data_11[count_11] <= m_data[j][15:2];
                    count_11 <= count_11 + 1;
                end
            endcase
            j <= j+1;
        end
        else begin
            done_processing <= 1;
        end
    end
    
    
    reg [31:0] iter_00=0, iter_01=0, iter_10=0, iter_11=0;
    
    reg [31:0] k=0;
    always @ (posedge clk_1kHz) begin
    if (play_counter > end_time) begin
        endscreen <= 1;
        k <= 0;
        iter_00 <= 0;
        iter_01 <= 0;
        iter_10 <= 0;
        iter_11 <= 0;
        perfect <= 0;
        good <= 0;
        bad <= 0;
        miss <= 0;
    end
    else if (~playing) begin
        missed_notes <= 0;
        k <= 0;
        iter_00 <= 0;
        iter_01 <= 0;
        iter_10 <= 0;
        iter_11 <= 0;
        endscreen <= 0;
        perfect <= 0;
        good <= 0;
        bad <= 0;
        miss <= 0;
    end
    else if (done_parsing && done_processing) begin // && playing
        if (perfect != 0 || good != 0 || bad != 0 || miss != 0) begin    
            perfect <= 0;
            good <= 0;
            bad <= 0;
            miss <= 0;
        end
        else begin
            // grading the leftmost lane
            if (iter_00 < len_00) begin
                if (play_counter > m_data_00[iter_00]+4) begin //if (play_counter > m_data_00[iter_00]+4) begin
                    miss[3] <= 1;
                    iter_00 <= iter_00 + 1;
                    missed_notes[k] <= 1;
                    k <= k + 1;
                end
                else if (btnL && (play_counter == 4 + m_data_00[iter_00] || m_data_00[iter_00] == 4 + play_counter) ) begin
                    bad[3] <= 1;
                    iter_00 <= iter_00 + 1;
                    k <= k + 1;
                end
                else if (btnL && (play_counter<=3+m_data_00[iter_00] && play_counter>=2+m_data_00[iter_00] || m_data_00[iter_00]<=3+play_counter && m_data_00[iter_00]>=2+play_counter)) begin
                    good[3] <= 1;
                    iter_00 <= iter_00 + 1;
                    k <= k + 1;
                end
                else if (btnL && (play_counter<=1+m_data_00[iter_00] && m_data_00[iter_00]<=1+play_counter)) begin
                    perfect[3] <= 1;
                    iter_00 <= iter_00 + 1;
                    k <= k + 1;
                end
            end
            // grading the left-center lane
            if (iter_01 < len_01) begin
                if (play_counter > 4 + m_data_01[iter_01]) begin
                    miss[2] <= 1;
                    iter_01 <= iter_01 + 1;
                    missed_notes[k] <= 1;
                    k <= k + 1;
                end
                else if (btnU && (play_counter == 4 + m_data_01[iter_01] || m_data_01[iter_01] == 4 + play_counter) ) begin
                    bad[2] <= 1;
                    iter_01 <= iter_01 + 1;
                    k <= k + 1;
                end
                else if (btnU && (play_counter<=3+m_data_01[iter_01] && play_counter>=2+m_data_01[iter_01] || m_data_01[iter_01]<=3+play_counter && m_data_01[iter_01]>=2+play_counter)) begin
                    good[2] <= 1;
                    iter_01 <= iter_01 + 1;
                    k <= k + 1;
                end
                else if (btnU && (play_counter<=1+m_data_01[iter_01] && m_data_01[iter_01]<=1+play_counter)) begin
                    perfect[2] <= 1;
                    iter_01 <= iter_01 + 1;
                    k <= k + 1;
                end
            end
            
            // grading the right-center lane
            if (iter_10 < len_10) begin
                if (play_counter > 4 + m_data_10[iter_10]) begin
                    miss[1] <= 1;
                    iter_10 <= iter_10 + 1;
                    missed_notes[k] <= 1;
                    k <= k + 1;
                end
                else if (btnD && (play_counter == 4 + m_data_10[iter_10] || m_data_10[iter_10] == 4 + play_counter) ) begin
                    bad[1] <= 1;
                    iter_10 <= iter_10 + 1;
                    k <= k + 1;
                end
                else if (btnD && (play_counter<=3+m_data_10[iter_10] && play_counter>=2+m_data_10[iter_10] || m_data_10[iter_10]<=3+play_counter && m_data_10[iter_10]>=2+play_counter)) begin
                    good[1] <= 1;
                    iter_10 <= iter_10 + 1;
                    k <= k + 1;
                end
                else if (btnD && (play_counter<=1+m_data_10[iter_10] && m_data_10[iter_10]<=1+play_counter)) begin
                    perfect[1] <= 1;
                    iter_10 <= iter_10 + 1;
                    k <= k + 1;
                end
            end
            // grading the rightmost lane
            if (iter_11 < len_11) begin
                if (play_counter > 4 + m_data_11[iter_11]) begin
                    miss[0] <= 1;
                    iter_11 <= iter_11 + 1;
                    missed_notes[k] <= 1;
                    k <= k + 1;
                end
                else if (btnR && (play_counter == 4 + m_data_11[iter_11] || m_data_11[iter_11] == 4 + play_counter) ) begin
                    bad[0] <= 1;
                    iter_11 <= iter_11 + 1;
                    k <= k + 1;
                end
                else if (btnR && (play_counter<=3+m_data_11[iter_11] && play_counter>=2+m_data_11[iter_11] || m_data_11[iter_11]<=3+play_counter && m_data_11[iter_11]>=2+play_counter)) begin
                    good[0] <= 1;
                    iter_11 <= iter_11 + 1;
                    k <= k + 1;
                end
                else if (btnL && (play_counter<=1+m_data_00[iter_00] && m_data_00[iter_00]<=1+play_counter)) begin
                    perfect[0] <= 1;
                    iter_11 <= iter_11 + 1;
                    k <= k + 1;
                end
            end
        end
    
    end
    end
    
    assign p = |perfect;
    assign g = |good;
    assign b = |bad;
    assign m = |miss;
    

    
endmodule
