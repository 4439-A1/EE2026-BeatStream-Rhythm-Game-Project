`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 17:37:01
// Design Name: 
// Module Name: key_status
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


module key_status(
    input clk,
    input PS2Clk, PS2Data,

    output q_status,
    w_status,
    e_status,
    r_status,
    t_status,
    y_status,
    u_status,
    i_status,
    o_status,
    p_status,
    a_status,
    s_status,
    d_status,
    f_status,
    g_status,
    h_status,
    j_status,
    k_status,
    l_status,
    z_status,
    x_status,
    c_status,
    v_status,
    b_status,
    n_status,
    m_status,
    enter_status,
    left_arrow_status,
    up_arrow_status,
    down_arrow_status,
    right_arrow_status,
    lshift_status,
    space_status
    );
    
reg         CLK50MHZ=0;
wire [23:0] keycode;
wire        flag;

always @ (posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
PS2Receiver uut (
    .clk(CLK50MHZ),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
);

// letter keys
keypress # (.makecode(24'h000015), .breakcode(24'h00F015)) key_q (.keycode(keycode), .oflag(flag), .key_status(q_status));
keypress # (.makecode(24'h00001D), .breakcode(24'h00F01D)) key_w (.keycode(keycode), .oflag(flag), .key_status(w_status));
keypress # (.makecode(24'h000024), .breakcode(24'h00F024)) key_e (.keycode(keycode), .oflag(flag), .key_status(e_status));
keypress # (.makecode(24'h00002D), .breakcode(24'h00F02D)) key_r (.keycode(keycode), .oflag(flag), .key_status(r_status));
keypress # (.makecode(24'h00002C), .breakcode(24'h00F02C)) key_t (.keycode(keycode), .oflag(flag), .key_status(t_status));
keypress # (.makecode(24'h000035), .breakcode(24'h00F035)) key_y (.keycode(keycode), .oflag(flag), .key_status(y_status));
keypress # (.makecode(24'h00003C), .breakcode(24'h00F03C)) key_u (.keycode(keycode), .oflag(flag), .key_status(u_status));
keypress # (.makecode(24'h000043), .breakcode(24'h00F043)) key_i (.keycode(keycode), .oflag(flag), .key_status(i_status));
keypress # (.makecode(24'h000044), .breakcode(24'h00F044)) key_o (.keycode(keycode), .oflag(flag), .key_status(o_status));
keypress # (.makecode(24'h00004D), .breakcode(24'h00F04D)) key_p (.keycode(keycode), .oflag(flag), .key_status(p_status));
keypress # (.makecode(24'h00001C), .breakcode(24'h00F01C)) key_a (.keycode(keycode), .oflag(flag), .key_status(a_status));
keypress # (.makecode(24'h00001B), .breakcode(24'h00F01B)) key_s (.keycode(keycode), .oflag(flag), .key_status(s_status));
keypress # (.makecode(24'h000023), .breakcode(24'h00F023)) key_d (.keycode(keycode), .oflag(flag), .key_status(d_status));
keypress # (.makecode(24'h00002B), .breakcode(24'h00F02B)) key_f (.keycode(keycode), .oflag(flag), .key_status(f_status));
keypress # (.makecode(24'h000034), .breakcode(24'h00F034)) key_g (.keycode(keycode), .oflag(flag), .key_status(g_status));
keypress # (.makecode(24'h000033), .breakcode(24'h00F033)) key_h (.keycode(keycode), .oflag(flag), .key_status(h_status));
keypress # (.makecode(24'h00003B), .breakcode(24'h00F03B)) key_j (.keycode(keycode), .oflag(flag), .key_status(j_status));
keypress # (.makecode(24'h000042), .breakcode(24'h00F042)) key_k (.keycode(keycode), .oflag(flag), .key_status(k_status));
keypress # (.makecode(24'h00004B), .breakcode(24'h00F04B)) key_l (.keycode(keycode), .oflag(flag), .key_status(l_status));
keypress # (.makecode(24'h00001A), .breakcode(24'h00F01A)) key_z (.keycode(keycode), .oflag(flag), .key_status(z_status));
keypress # (.makecode(24'h000022), .breakcode(24'h00F022)) key_x (.keycode(keycode), .oflag(flag), .key_status(x_status));
keypress # (.makecode(24'h000021), .breakcode(24'h00F021)) key_c (.keycode(keycode), .oflag(flag), .key_status(c_status));
keypress # (.makecode(24'h00002A), .breakcode(24'h00F02A)) key_v (.keycode(keycode), .oflag(flag), .key_status(v_status));
keypress # (.makecode(24'h000032), .breakcode(24'h00F032)) key_b (.keycode(keycode), .oflag(flag), .key_status(b_status));
keypress # (.makecode(24'h000031), .breakcode(24'h00F031)) key_n (.keycode(keycode), .oflag(flag), .key_status(n_status));
keypress # (.makecode(24'h00003A), .breakcode(24'h00F03A)) key_m (.keycode(keycode), .oflag(flag), .key_status(m_status));

// arrow keys
keypress # (.makecode(24'h000075), .breakcode(24'h00F075)) key_up (.keycode(keycode), .oflag(flag), .key_status(up_arrow_status));
keypress # (.makecode(24'h000072), .breakcode(24'h00F072)) key_down (.keycode(keycode), .oflag(flag), .key_status(down_arrow_status));
keypress # (.makecode(24'h00006B), .breakcode(24'h00F06B)) key_left (.keycode(keycode), .oflag(flag), .key_status(left_arrow_status));
keypress # (.makecode(24'h00E074), .breakcode(24'hE0F074)) key_right (.keycode(keycode), .oflag(flag), .key_status(right_arrow_status));

// enter key
keypress # (.makecode(24'h00005A), .breakcode(24'h00F05A)) key_enter (.keycode(keycode), .oflag(flag), .key_status(enter_status));

// lshift
keypress # (.makecode(24'h000012), .breakcode(24'h00F012)) key_lshift (.keycode(keycode), .oflag(flag), .key_status(lshift_status));

// space
keypress # (.makecode(24'h000029), .breakcode(24'h00F029)) key_space (.keycode(keycode), .oflag(flag), .key_status(space_status));

endmodule