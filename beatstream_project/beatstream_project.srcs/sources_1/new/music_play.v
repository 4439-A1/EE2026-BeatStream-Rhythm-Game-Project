//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2024/11/02 00:23:22
//// Design Name: 
//// Module Name: top_module
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module music_play # (parameter one_min = 30 * 1000)(
//    input clk,           
//    input play,         
//    output audio_out,    
//    output amp_enable    
//);

//parameter CLOCK_FREQ = 100000000;
//parameter NOTE_C4 = 261;
//parameter NOTE_D4 = 293;
//parameter NOTE_E4 = 329;
//parameter NOTE_F4 = 349;
//parameter NOTE_G4 = 392;
//parameter NOTE_A4 = 440;
//parameter NOTE_B4 = 493;
//parameter NOTE_C5 = 523;

//reg [31:0] song [0:41]; 
//initial begin
//    song[0]  = NOTE_C4; 
//    song[1]  = NOTE_C4; 
//    song[2]  = NOTE_G4; 
//    song[3]  = NOTE_G4; 
//    song[4]  = NOTE_A4; 
//    song[5]  = NOTE_A4; 
//    song[6]  = NOTE_G4; 

//    song[7]  = NOTE_F4; 
//    song[8]  = NOTE_F4; 
//    song[9]  = NOTE_E4; 
//    song[10] = NOTE_E4; 
//    song[11] = NOTE_D4; 
//    song[12] = NOTE_D4; 
//    song[13] = NOTE_C4;

//    song[14] = NOTE_G4; 
//    song[15] = NOTE_G4; 
//    song[16] = NOTE_F4; 
//    song[17] = NOTE_F4; 
//    song[18] = NOTE_E4; 
//    song[19] = NOTE_E4; 
//    song[20] = NOTE_D4; 

//    song[21] = NOTE_G4; 
//    song[22] = NOTE_G4;
//    song[23] = NOTE_F4;
//    song[24] = NOTE_F4; 
//    song[25] = NOTE_E4; 
//    song[26] = NOTE_E4;
//    song[27] = NOTE_D4; 

//    song[28] = NOTE_C4; 
//    song[29] = NOTE_C4; 
//    song[30] = NOTE_G4; 
//    song[31] = NOTE_G4; 
//    song[32] = NOTE_A4; 
//    song[33] = NOTE_A4;
//    song[34] = NOTE_G4; 

//    song[35] = NOTE_F4; 
//    song[36] = NOTE_F4; 
//    song[37] = NOTE_E4; 
//    song[38] = NOTE_E4; 
//    song[39] = NOTE_D4;
//    song[40] = NOTE_D4; 
//    song[41] = NOTE_C4; 
//end

//wire slow_clk;
//parameter M = 49999;
//parameter NOTE_DURATION = 500;  
////parameter one_min = 30 * 1000;  //slow clk = 1000Hz        

//reg [31:0] tone_freq;      
//reg [5:0] note_index;      
//reg [31:0] duration_counter;             
//reg [31:0] timer_counter;
//reg playing = 0; 


//flexible_clock clk_divider(
//    clk,
//    M,
//    slow_clk
//);

//single_note tone_gen(
//    .clk(clk),
//    .tone_freq(tone_freq),
//    .audio_out(audio_out),
//    .amp_enable(amp_enable)
//);

////always @(posedge clk) begin
////    if (!play) begin
////        note_index <= 0;          
////        duration_counter <= 0;     
////    end else begin
////        if (duration_counter >= NOTE_DURATION) begin
////            duration_counter <= 0; 
////            note_index <= note_index + 1;
////            if (note_index >= 8) begin
////                note_index <= 0; 
////            end
////        end else begin
////            duration_counter <= duration_counter + 1;
////        end
////    end


//always @(posedge slow_clk) begin
//    if (!playing && play) begin
//        playing <= 1;
//        timer_counter <= 0;
//        note_index <= 0;
//        duration_counter <= 0;
//    end else if (playing) begin
//        if (timer_counter < one_min) begin
//            timer_counter <= timer_counter + 1;

//            if (duration_counter >= NOTE_DURATION) begin
//                duration_counter <= 0; 
//                note_index <= note_index + 1;
                
//                if (note_index >= 42) begin 
//                    note_index <= 0; 
//                end
//                tone_freq <= song[note_index]; 
//            end else begin
//                duration_counter <= duration_counter + 1;
//            end
//        end else begin
//            playing <= 0;
//            note_index <= 0;
//            duration_counter <= 0;
//            tone_freq <= 0;
//        end
//    end else begin
//        tone_freq <= 0;       
//    end
//end


//endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 00:23:22
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

module music_play # (parameter M = 49999) (
    input clk,           
    input play,         
    input reset,    
    input pause,    
    output audio_out,    
    output amp_enable    
);

reg pause_int = 0;
reg pause_prev = 0;
reg pcount = 0;
always @ (posedge clk) begin
    if (pause && !pause_prev) begin
        pause_int <= 1;
    end
    else if (pause_int) begin
        if (pcount < 1000000) begin
            pcount <= pcount + 1;
        end
        else begin
            pause_int <= 0;
            pcount <= 0;
        end
    end
    pause_prev <= pause;
end

parameter CLOCK_FREQ = 100000000;
parameter NOTE_C4 = 261;
parameter NOTE_D4 = 293;
parameter NOTE_E4 = 329;
parameter NOTE_F4 = 349;
parameter NOTE_G4 = 392;
parameter NOTE_A4 = 440;
parameter NOTE_B4 = 493;
parameter NOTE_C5 = 523;

reg [31:0] song [0:41]; 
initial begin
    song[0]  = NOTE_C4; 
    song[1]  = NOTE_C4; 
    song[2]  = NOTE_G4; 
    song[3]  = NOTE_G4; 
    song[4]  = NOTE_A4; 
    song[5]  = NOTE_A4; 
    song[6]  = NOTE_G4; 

    song[7]  = NOTE_F4; 
    song[8]  = NOTE_F4; 
    song[9]  = NOTE_E4; 
    song[10] = NOTE_E4; 
    song[11] = NOTE_D4; 
    song[12] = NOTE_D4; 
    song[13] = NOTE_C4;

    song[14] = NOTE_G4; 
    song[15] = NOTE_G4; 
    song[16] = NOTE_F4; 
    song[17] = NOTE_F4; 
    song[18] = NOTE_E4; 
    song[19] = NOTE_E4; 
    song[20] = NOTE_D4; 

    song[21] = NOTE_G4; 
    song[22] = NOTE_G4;
    song[23] = NOTE_F4;
    song[24] = NOTE_F4; 
    song[25] = NOTE_E4; 
    song[26] = NOTE_E4;
    song[27] = NOTE_D4; 

    song[28] = NOTE_C4; 
    song[29] = NOTE_C4; 
    song[30] = NOTE_G4; 
    song[31] = NOTE_G4; 
    song[32] = NOTE_A4; 
    song[33] = NOTE_A4;
    song[34] = NOTE_G4; 

    song[35] = NOTE_F4; 
    song[36] = NOTE_F4; 
    song[37] = NOTE_E4; 
    song[38] = NOTE_E4; 
    song[39] = NOTE_D4;
    song[40] = NOTE_D4; 
    song[41] = NOTE_C4; 
end

wire slow_clk;
wire debounced_pause;
parameter NOTE_DURATION = 500;  
parameter one_min = 60 * 1000;  // slow clk = 1000Hz

reg [31:0] tone_freq;      
reg [5:0] note_index;      
reg [31:0] duration_counter;             
reg [31:0] timer_counter;
reg playing = 0; 
reg paused = 0; 

flexible_clock clk_divider(
    clk,
    M,
    slow_clk
);

single_note tone_gen(
    .clk(clk),
    .tone_freq(tone_freq),
    .audio_out(audio_out),
    .amp_enable(amp_enable)
);

debounce debounce_pause(
    .clk(clk),           
    .button(pause_int),      
    .button_out(debounced_pause) 
);
reg reset_prev = 0;
always @(posedge slow_clk) begin
    if (~reset && reset_prev) begin
        playing <= 0;
        paused <= 0;
        timer_counter <= 0;
        note_index <= 0;
        duration_counter <= 0;
        tone_freq <= 0;
        
    end else if (!playing && play && !paused) begin
        playing <= 1;
        timer_counter <= 0;
        note_index <= 0;
        duration_counter <= 0;
        
    end else if (pause && playing) begin
        paused <= !paused;
        tone_freq <= 0; // added it
//        playing <= !paused;
    end else if (!pause && paused) begin
        paused <= !paused;
    end else if (playing && !paused) begin
        if (timer_counter < one_min) begin
            timer_counter <= timer_counter + 1;

            if (duration_counter >= NOTE_DURATION) begin
                duration_counter <= 0; 
                note_index <= note_index + 1;
                
                if (note_index >= 42) begin 
                    note_index <= 0; 
                end
                tone_freq <= song[note_index]; 
            end else begin
                duration_counter <= duration_counter + 1;
            end
        end else begin
            playing <= 0;
            note_index <= 0;
            duration_counter <= 0;
            tone_freq <= 0;
        end
    end else begin
        tone_freq <= 0;       
    end
    reset_prev <= reset;
end

endmodule
