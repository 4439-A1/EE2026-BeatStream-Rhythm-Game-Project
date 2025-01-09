`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 17:26:17
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input PS2Clk, PS2Data,
    input btnU, btnD, btnC, btnL, btnR,
    input [15:0] sw,
    output reg [15:0] led=0,
    output reg [7:0] JC,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed, vgaBlue, vgaGreen, output Hsync, Vsync,
    output reg JA0,JA2
);

// key_presses
wire q_status, w_status, e_status, r_status, t_status, y_status, u_status, i_status, o_status, p_status, a_status, s_status, d_status, f_status, g_status, h_status,
    j_status, k_status, l_status, z_status, x_status, c_status, v_status, b_status, n_status, m_status, enter_status, up_status, down_status, left_status, right_status, lshift_status, space_status;
key_status all_keys (.clk(clk), .PS2Clk(PS2Clk), .PS2Data(PS2Data), .q_status(q_status), .w_status(w_status), .e_status(e_status), .r_status(r_status), .t_status(t_status),
    .y_status(y_status), .u_status(u_status), .i_status(i_status), .o_status(o_status), .p_status(p_status), .a_status(a_status), .s_status(s_status), .d_status(d_status),
    .f_status(f_status), .g_status(g_status), .h_status(h_status), .j_status(j_status), .k_status(k_status), .l_status(l_status), .z_status(z_status), .x_status(x_status),
    .c_status(c_status), .v_status(v_status), .b_status(b_status), .n_status(n_status), .m_status(m_status), .enter_status(enter_status),
    .up_arrow_status(up_status), .down_arrow_status(down_status), .left_arrow_status(left_status), .right_arrow_status(right_status), .lshift_status(lshift_status), .space_status(space_status));
wire [25:0] abc; assign abc = {z_status, y_status, x_status, w_status, v_status, u_status, t_status, s_status, r_status, q_status, p_status, o_status,
n_status, m_status, l_status, k_status, j_status, i_status, h_status, g_status, f_status, e_status, d_status, c_status, b_status, a_status};

// program instantaneous key presses
wire up_short, down_short, left_short, right_short;
short_press b1 (clk, left_status, left_short);
short_press b2 (clk, up_status, up_short);
short_press b3 (clk, down_status, down_short);
short_press b4 (clk, right_status, right_short);
// notes map integration

wire clk_20Hz; wire [13:0] play_counter1, play_counter2; reg start_play1=0, start_play2=0;
//clock_divider clk_20 (clk, 2_499_999, clk_20Hz);
clock_divider clk_20 (clk, 2_499_999, clk_20Hz);
wire ticker; wire ticker2;
reg reset_map_1 = 0, reset_map_2 = 0;
wire pause;
play_timer play_time1 (.playing(reset_map_1), .clk_20Hz(clk_20Hz), .counter(play_counter1), .pause(pause), .ticker(ticker));
play_timer play_time2 (.playing(reset_map_2), .clk_20Hz(clk_20Hz), .counter(play_counter2), .pause(pause), .ticker(ticker2));

// remember to change value of N with length of m1_data
parameter N_1_1 = 31, N_1_2 = 0, N_1 = 31;
reg [15:0] m1_data [0:N_1-1]; wire [16*N_1_1-1:0] m1_1_data_flattened; // wire [16*N_1_2-1:0] m1_2_data_flattened;
initial begin
m1_data[0] = {14'd68, 2'b00};
m1_data[1] = {14'd83, 2'b01};
m1_data[2] = {14'd98, 2'b10};
m1_data[3] = {14'd113, 2'b11};
m1_data[4] = {14'd128, 2'b00};
m1_data[5] = {14'd143, 2'b10};
m1_data[6] = {14'd158, 2'b11};
m1_data[7] = {14'd173, 2'b00};
m1_data[8] = {14'd188, 2'b10};
m1_data[9] = {14'd203, 2'b00};
m1_data[10] = {14'd218, 2'b11};
m1_data[11] = {14'd233, 2'b01};
m1_data[12] = {14'd248, 2'b11};
m1_data[13] = {14'd293, 2'b00};
m1_data[14] = {14'd308, 2'b01};
m1_data[15] = {14'd323, 2'b00};
m1_data[16] = {14'd338, 2'b00};
m1_data[17] = {14'd353, 2'b11};
m1_data[18] = {14'd368, 2'b00};
m1_data[19] = {14'd383, 2'b10};
m1_data[20] = {14'd398, 2'b11};
m1_data[21] = {14'd428, 2'b00};
m1_data[22] = {14'd443, 2'b01};
m1_data[23] = {14'd458, 2'b00};
m1_data[24] = {14'd473, 2'b00};
m1_data[25] = {14'd488, 2'b11};
m1_data[26] = {14'd503, 2'b00};
m1_data[27] = {14'd518, 2'b01};
m1_data[28] = {14'd533, 2'b00};
m1_data[29] = {14'd548, 2'b00};
m1_data[30] = {14'd563, 2'b00};
//m1_data[31] = {14'd578, 2'b00};
//m1_data[32] = {14'd593, 2'b00};
//m1_data[33] = {14'd608, 2'b01};
//m1_data[34] = {14'd623, 2'b00};
//m1_data[35] = {14'd638, 2'b01};
//m1_data[36] = {14'd653, 2'b11};
//m1_data[37] = {14'd668, 2'b01};
//m1_data[38] = {14'd683, 2'b00};
//m1_data[39] = {14'd698, 2'b01};
//m1_data[40] = {14'd728, 2'b00};
//m1_data[41] = {14'd758, 2'b00};
//m1_data[42] = {14'd788, 2'b00};
//m1_data[43] = {14'd818, 2'b00};
//m1_data[44] = {14'd863, 2'b11};
//m1_data[45] = {14'd878, 2'b01};
//m1_data[46] = {14'd893, 2'b01};
//m1_data[47] = {14'd923, 2'b00};
//m1_data[48] = {14'd938, 2'b10};
//m1_data[49] = {14'd953, 2'b11};
//m1_data[50] = {14'd968, 2'b00};
//m1_data[51] = {14'd998, 2'b10};
//m1_data[52] = {14'd1013, 2'b11};
//m1_data[53] = {14'd1028, 2'b01};
//m1_data[54] = {14'd1043, 2'b00};
//m1_data[55] = {14'd1073, 2'b11};
//m1_data[56] = {14'd1103, 2'b01};
//m1_data[57] = {14'd1133, 2'b01};
//m1_data[58] = {14'd1148, 2'b10};
//m1_data[59] = {14'd1163, 2'b01};
//m1_data[60] = {14'd1178, 2'b11};
//m1_data[61] = {14'd1208, 2'b01};
end

parameter N_2_1 = 31, N_2_2 = 0, N_2_3 = 0, N_2 = 31;
reg [15:0] m2_data [0:N_2-1];
wire [16*N_2_1-1:0] m2_1_data_flattened; //wire [16*N_2_2-1:0] m2_2_data_flattened; wire [16*N_2_3-1:0] m2_3_data_flattened;
initial begin
//m2_data[0] = {14'd23, 2'b00};
//m2_data[1] = {14'd28, 2'b01};
//m2_data[2] = {14'd33, 2'b10};
//m2_data[3] = {14'd38, 2'b11};
//m2_data[4] = {14'd43, 2'b00};
//m2_data[5] = {14'd48, 2'b10};
//m2_data[6] = {14'd53, 2'b11};
//m2_data[7] = {14'd58, 2'b00};
//m2_data[8] = {14'd63, 2'b10};
//m2_data[9] = {14'd68, 2'b00};
//m2_data[10] = {14'd73, 2'b11};
//m2_data[11] = {14'd78, 2'b01};
//m2_data[12] = {14'd83, 2'b11};
//m2_data[13] = {14'd98, 2'b00};
//m2_data[14] = {14'd103, 2'b01};
//m2_data[15] = {14'd108, 2'b00};
//m2_data[16] = {14'd113, 2'b00};
//m2_data[17] = {14'd118, 2'b11};
//m2_data[18] = {14'd123, 2'b00};
//m2_data[19] = {14'd128, 2'b10};
//m2_data[20] = {14'd133, 2'b11};
//m2_data[21] = {14'd143, 2'b00};
//m2_data[22] = {14'd148, 2'b01};
//m2_data[23] = {14'd153, 2'b00};
//m2_data[24] = {14'd158, 2'b00};
//m2_data[25] = {14'd163, 2'b11};
//m2_data[26] = {14'd168, 2'b00};
//m2_data[27] = {14'd173, 2'b01};
//m2_data[28] = {14'd178, 2'b00};
//m2_data[29] = {14'd183, 2'b00};
//m2_data[30] = {14'd188, 2'b00};

//m2_data[31] = {14'd192, 2'b00};
//m2_data[32] = {14'd197, 2'b00};
//m2_data[33] = {14'd202, 2'b01};
//m2_data[34] = {14'd207, 2'b00};
//m2_data[35] = {14'd212, 2'b01};
//m2_data[36] = {14'd217, 2'b11};
//m2_data[37] = {14'd222, 2'b01};
//m2_data[38] = {14'd227, 2'b00};
//m2_data[39] = {14'd232, 2'b01};
//m2_data[40] = {14'd242, 2'b00};
//m2_data[41] = {14'd252, 2'b00};
//m2_data[42] = {14'd262, 2'b00};
//m2_data[43] = {14'd272, 2'b00};
//m2_data[44] = {14'd287, 2'b11};
//m2_data[45] = {14'd292, 2'b01};
//m2_data[46] = {14'd297, 2'b01};
//m2_data[47] = {14'd307, 2'b00};
//m2_data[48] = {14'd312, 2'b10};
//m2_data[49] = {14'd317, 2'b11};
//m2_data[50] = {14'd322, 2'b00};
//m2_data[51] = {14'd332, 2'b10};
//m2_data[52] = {14'd337, 2'b11};
//m2_data[53] = {14'd342, 2'b01};
//m2_data[54] = {14'd347, 2'b00};
//m2_data[55] = {14'd357, 2'b11};
//m2_data[56] = {14'd367, 2'b01};
//m2_data[57] = {14'd377, 2'b01};
//m2_data[58] = {14'd382, 2'b10};
//m2_data[59] = {14'd387, 2'b01};
//m2_data[60] = {14'd392, 2'b11};
//m2_data[61] = {14'd402, 2'b01};
//m2_data[62] = {14'd417, 2'b00};
//m2_data[63] = {14'd422, 2'b00};
//m2_data[64] = {14'd427, 2'b10};
//m2_data[65] = {14'd432, 2'b00};
//m2_data[66] = {14'd437, 2'b11};
//m2_data[67] = {14'd442, 2'b01};
//m2_data[68] = {14'd447, 2'b11};
//m2_data[69] = {14'd452, 2'b00};
//m2_data[70] = {14'd457, 2'b01};
//m2_data[71] = {14'd462, 2'b00};
//m2_data[72] = {14'd467, 2'b00};
//m2_data[73] = {14'd472, 2'b11};
//m2_data[74] = {14'd477, 2'b00};
//m2_data[75] = {14'd482, 2'b10};
//m2_data[76] = {14'd487, 2'b11};

m2_data[0] = {14'd29, 2'b00};
m2_data[1] = {14'd44, 2'b01};
m2_data[2] = {14'd59, 2'b10};
m2_data[3] = {14'd74, 2'b11};
m2_data[4] = {14'd89, 2'b00};
m2_data[5] = {14'd104, 2'b10};
m2_data[6] = {14'd119, 2'b11};
m2_data[7] = {14'd134, 2'b00};
m2_data[8] = {14'd149, 2'b10};
m2_data[9] = {14'd164, 2'b00};
m2_data[10] = {14'd179, 2'b11};
m2_data[11] = {14'd194, 2'b01};
m2_data[12] = {14'd209, 2'b11};
m2_data[13] = {14'd254, 2'b00};
m2_data[14] = {14'd269, 2'b01};
m2_data[15] = {14'd284, 2'b00};
m2_data[16] = {14'd299, 2'b00};
m2_data[17] = {14'd314, 2'b11};
m2_data[18] = {14'd329, 2'b00};
m2_data[19] = {14'd344, 2'b10};
m2_data[20] = {14'd359, 2'b11};
m2_data[21] = {14'd389, 2'b00};
m2_data[22] = {14'd404, 2'b01};
m2_data[23] = {14'd419, 2'b00};
m2_data[24] = {14'd434, 2'b00};
m2_data[25] = {14'd449, 2'b11};
m2_data[26] = {14'd464, 2'b00};
m2_data[27] = {14'd479, 2'b01};
m2_data[28] = {14'd494, 2'b00};
m2_data[29] = {14'd509, 2'b00};
m2_data[30] = {14'd524, 2'b00};
end

genvar i_1;
generate
    for (i_1 = 0; i_1 < N_1; i_1 = i_1 + 1) begin
        if (i_1 < N_1_1) begin
            assign m1_1_data_flattened[16 * (i_1 + 1) - 1 : 16 * i_1] = m1_data[i_1];
        end
//        else if (i_1 < N_1_1 + N_1_2) begin
//            assign m1_2_data_flattened[16 * (i_1 - N_1_1 + 1) - 1 : 16 * (i_1 - N_1_1)] = m1_data[i_1];
//        end
    end
endgenerate

genvar i_2;
generate
    for (i_2 = 0; i_2 < N_2; i_2 = i_2 + 1) begin
        if (i_2 < N_2_1) begin
            assign m2_1_data_flattened[16 * (i_2 + 1) - 1 : 16 * i_2] = m2_data[i_2];
        end
//        else if (i_2 < N_2_1 + N_2_2) begin
//            assign m2_2_data_flattened[16 * (i_2 - N_2_1 + 1) - 1 : 16 * (i_2 - N_2_1)] = m2_data[i_2];
//        end
//        else if (i_2 < N_2_1 + N_2_2 + N_2_3) begin
//            assign m2_3_data_flattened[16 * (i_2 - N_2_1 - N_2_2 + 1) - 1 : 16 * (i_2 - N_2_1 - N_2_2)] = m2_data[i_2];
//        end
    end
endgenerate

wire [3:0] perfect, good, bad, miss; wire p, g, b, m;

wire [3:0] perfect1_1, good1_1, bad1_1, miss1_1; wire p1_1, g1_1, b1_1, m1_1;
wire [3:0] perfect1_2, good1_2, bad1_2, miss1_2; wire p1_2, g1_2, b1_2, m1_2;
//wire done_processing, done_parsing;
wire [N_1 - 1:0] missed_notes_1; wire endscreen1;
note_grader # (N_1_1) grader_1_1 (.clk(clk), .end_time(m1_data[N_1-1][15:2]+20), .btnU(up_short), .btnD(down_short), .btnL(left_short), .btnR(right_short), .play_counter(play_counter1), .playing(reset_map_1), .m_data_flattened(m1_1_data_flattened), .perfect(perfect1_1), .good(good1_1), .bad(bad1_1), .miss(miss1_1), .p(p1_1), .g(g1_1), .b(b1_1), .m(m1_1), .missed_notes(missed_notes_1[N_1_1-1:0]), .endscreen(endscreen1));
//note_grader # (N_1_2) grader_1_2 (.clk(clk), .btnU(up_short), .btnD(down_short), .btnL(left_short), .btnR(right_short), .play_counter(play_counter1), .playing(reset_map_1), .m_data_flattened(m1_2_data_flattened), .perfect(perfect1_2), .good(good1_2), .bad(bad1_2), .miss(miss1_2), .p(p1_2), .g(g1_2), .b(b1_2), .m(m1_2), .missed_notes(missed_notes_1[N_1_2+N_1_1-1:N_1_1]));

wire [3:0] perfect2_1, good2_1, bad2_1, miss2_1; wire p2_1, g2_1, b2_1, m2_1;
wire [3:0] perfect2_2, good2_2, bad2_2, miss2_2; wire p2_2, g2_2, b2_2, m2_2;
wire [3:0] perfect2_3, good2_3, bad2_3, miss2_3; wire p2_3, g2_3, b2_3, m2_3;
//wire done_processing, done_parsing;
wire [N_2-1:0] missed_notes_2; wire endscreen2;
note_grader # (N_2_1) grader_2_1 (.clk(clk), .end_time(m2_data[N_2-1][15:2]+20), .btnU(up_short), .btnD(down_short), .btnL(left_short), .btnR(right_short), .play_counter(play_counter2), .playing(reset_map_2), .m_data_flattened(m2_1_data_flattened), .perfect(perfect2_1), .good(good2_1), .bad(bad2_1), .miss(miss2_1), .p(p2_1), .g(g2_1), .b(b2_1), .m(m2_1), .missed_notes(missed_notes_2[N_2_1-1:0]), .endscreen(endscreen2));
//note_grader # (N_2_2) grader_2_2 (.clk(clk), .btnU(up_short), .btnD(down_short), .btnL(left_short), .btnR(right_short), .play_counter(play_counter2), .playing(start_play2), .m_data_flattened(m2_2_data_flattened), .perfect(perfect2_2), .good(good2_2), .bad(bad2_2), .miss(miss2_2), .p(p2_2), .g(g2_2), .b(b2_2), .m(m2_2), .missed_notes(missed_notes_2[N_2_2+N_2_1-1:N_2_1]));
//note_grader # (N_2_3) grader_2_3 (.clk(clk), .btnU(up_short), .btnD(down_short), .btnL(left_short), .btnR(right_short), .play_counter(play_counter2), .playing(start_play2), .m_data_flattened(m2_3_data_flattened), .perfect(perfect2_3), .good(good2_3), .bad(bad2_3), .miss(miss2_3), .p(p2_3), .g(g2_3), .b(b2_3), .m(m2_3), .missed_notes(missed_notes_2[N_2_3+N_2_2+N_2_1-1:N_2_2+N_2_1]));
wire endscreen;
assign endscreen = endscreen1 + endscreen2;
assign perfect = perfect1_1 + perfect2_1; //+ perfect2_2 + perfect2_3;
assign good = good1_1 + good2_1; // + good2_2 + good2_3;
assign bad = bad1_1 + bad2_1; //+ bad2_2 + bad2_3;
assign miss = miss1_1 + miss2_1; // + miss2_2 + miss2_3;
assign p = |perfect;
assign g = |good;
assign b = |bad;
assign m = |miss;

wire p_long, g_long, b_long, m_long;
elongate l1 (clk, p, p_long); elongate l2 (clk, g, g_long); elongate l3 (clk, b, b_long); elongate l4 (clk, m, m_long);


// display note timeings
always @ (posedge clk) begin
    led[0] <= m;
    led[1] <= b;
    led[2] <= g;
    led[3] <= p;
//    led[7] <= done_parsing;
//    led[8] <= done_processing;
//    led[9] <= ticker2;
//    led[10] <= start_play2;
end


//different game screens
wire [7:0] JC_startup, JC_game1, JC_game2, JC_menu, JC_bar, JC_difficulty, JC_end, JC_pause, JC_load, JC_letter; reg start_point = 0;
startup_screen init (.basys_clock(clk), .btnc(btnC), .btnr(btnR), .btnd(btnD), .btnu(btnU), .btnl(btnL), .JC(JC_startup));
//map1 firstmap (.CLOCK(clk), .reset(0), .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnC(reset_map_1), .perfect(p_long), .good(g_long), .bad(b_long), .miss(m_long), .JC(JC_game1), .missedflag(missed_notes_1));
map2 secondmap (.CLOCK(clk), .reset(reset_map_2), .pause(pause), .perfect(p_long), .good(g_long), .bad(b_long), .miss(m_long), .JC(JC_game2), .missedflag(missed_notes_2));
survival_bar bar1 (.basys_clock(clk), .btnc(m), .JC(JC_bar));
menu_screen menu (.CLOCK(clk), .btnC(btnC), .btnD(btnD), .JC(JC_menu));
difficulty_menu difmenu (.CLOCK(clk), .JC(JC_difficulty));
Point_system_display points (.basys_clock(clk), .btnu(start_point), .btnd(p), .btnl(b), .btnr(g), .an(an), .seg(seg));
end_screen endingscreen (.basys_clock(clk), .JC(JC_end));
pause pausescreen (.CLOCK(clk), .JC(JC_pause));
map1 firstmap (.CLOCK(clk), .reset(reset_map_1), .pause(pause), .perfect(p_long), .good(g_long), .bad(b_long), .miss(m_long), .missedflag(missed_notes_1), .JC(JC_game1));
loading_screen load (.basys_clock(clk), .JC(JC_load));
display_letters_to_screen let(.basys_clock(clk), .abc(abc), .JC(JC_letter));  

// Switch between screens
wire [31:0] screen_sel;
screen_selector sel_1 (.clk(clk), .enter(enter_status), .space(space_status), .abc(abc), .up(up_status), .down(down_status), .left(left_status), .right(right_status), .lshift(lshift_status), .screen_sel(screen_sel), .pause(pause), .endscreen(endscreen));

reg reset_pulse=0;
reg reset1_prev=0;
reg rcount = 0;
always @ (posedge clk) begin
    
    if (reset1_prev && !reset_map_1) begin
        reset_pulse <= 1;
        rcount <= 0;
    end
    else if (reset_pulse && rcount < 10000000) begin
        rcount <= rcount + 1;
    end
    else if (rcount == 10000000) begin
        reset_pulse <= 0;
    end
    reset1_prev <= reset_map_1;
end
//elongate l5 (clk, reset_map_1, reset_pulse);

// play music
wire JA0_1, JA2_1, JA0_2, JA2_2;
music_play play1 (.clk(clk), .play(reset_map_1), .reset(reset_map_1), .pause(pause), .audio_out(JA0_1), .amp_enable(JA2_1));
music_play # (16666) play2 (.clk(clk), .play(reset_map_2), .reset(reset_map_2), .pause(pause), .audio_out(JA0_2), .amp_enable(JA2_2));
always @ (posedge clk) begin
    if (reset_map_1) begin
        JA0 <= JA0_1;
        JA2 <= JA2_1;
    end
    else if (reset_map_2) begin
        JA0 <= JA0_2;
        JA2 <= JA2_2;
    end
    else begin
        JA0 <= 0;
        JA2 <= 0;
    end
end
//reg [31:0] refresh = 0;
always @ (posedge clk) begin
    case(screen_sel)
        0: begin // menu screen
            JC <= JC_menu;
            reset_map_1 <= 0;
            reset_map_2 <= 0;
            start_point <= 0;
        end
        1: begin
            JC <= JC_difficulty;
            reset_map_1 <= 0;
            reset_map_2 <= 0;
            start_point <= 0;
        end
        2: begin // startup screen
            JC <= JC_startup;
            reset_map_1 <= 0;
            reset_map_2 <= 0;
            start_point <= 0;
        end
        3: begin // map 1 screen
            JC <= JC_game1;
            reset_map_1 <= 1;
            reset_map_2 <= 0;
            start_point <= 1;
        end
        4: begin // map 2 screen
            JC <= JC_game2;
            reset_map_1 <= 0;
            reset_map_2 <= 1;
            start_point <= 1;
        end
        5: begin // end screen
            JC <= JC_end;
            reset_map_1 <= 0;
            reset_map_2 <= 0;
            start_point <= 0;
        end
        6: begin // pause screen 1
            JC <= JC_pause;
        end
        7: begin // pause screen 2
            JC <= JC_pause;
        end
        8: begin // loading screen
            JC <= JC_load;
        end
        9: begin
            JC <= JC_letter;
        end
        
    endcase
end

endmodule
