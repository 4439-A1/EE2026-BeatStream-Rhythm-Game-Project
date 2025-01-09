`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 21:27:43
// Design Name: 
// Module Name: Characters
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


module char (
    input [7:0] char,         
    input [2:0] row,           
    input [2:0] col,           
    output reg pixel           
);
    always @(*) begin
    case (char)
        8'h50: // 'P'
            case (row)
                3'd4: pixel = (col >= 0 && col <= 5);
                3'd5: pixel = (col == 0 || col == 5);
                3'd6: pixel = (col == 0 || col == 5);
                3'd7: pixel = (col >= 0 && col <= 5);
                3'd0: pixel = (col == 0);
                3'd1: pixel = (col == 0);
                3'd2: pixel = (col == 0);
                3'd3: pixel = (col == 0);
                default: pixel = 0;
            endcase

        8'h45: //  'E'
            case (row)
                3'd4: pixel = (col >= 0 && col <= 5);
                3'd5: pixel = (col == 0);
                3'd6: pixel = (col == 0);
                3'd7: pixel = (col >= 0 && col <= 4);
                3'd0: pixel = (col == 0);
                3'd1: pixel = (col == 0);
                3'd2: pixel = (col >= 0 && col <= 5);
                3'd3: pixel = 0;
                default: pixel = 0;
            endcase

        8'h52: // 'R'
            case (row)
                3'd4: pixel = (col >= 0 && col <= 5);
                3'd5: pixel = (col == 0 || col == 5);
                3'd6: pixel = (col == 0 || col == 5);
                3'd7: pixel = (col >= 0 && col <= 4);
                3'd0: pixel = (col == 0 || col == 3);
                3'd1: pixel = (col == 0 || col == 4);
                3'd2: pixel = (col == 0 || col == 5);
                3'd3: pixel = 0;
                default: pixel = 0;
            endcase

        8'h46: // 'F'
            case (row)
                3'd4: pixel = (col >= 0 && col <= 5);
                3'd5: pixel = (col == 0);
                3'd6: pixel = (col == 0);
                3'd7: pixel = (col >= 0 && col <= 4);
                3'd0: pixel = (col == 0);
                3'd1: pixel = (col == 0);
                3'd2: pixel = (col == 0);
                3'd3: pixel = 0;
                default: pixel = 0;
            endcase

        8'h43: // 'C'
            case (row)
                3'd4: pixel = (col >= 1 && col <= 5);
                3'd5: pixel = (col == 0 || col == 5);
                3'd6: pixel = (col == 0);
                3'd7: pixel = (col == 0);
                3'd0: pixel = (col == 0);
                3'd1: pixel = (col == 0 || col == 5);
                3'd2: pixel = (col >= 1 && col <= 5);
                3'd3: pixel = 0;
                default: pixel = 0;
            endcase

        8'h54: // 'T'
            case (row)
                3'd4: pixel = (col >= 0 && col <= 6);
                3'd5: pixel = (col == 3);
                3'd6: pixel = (col == 3);
                3'd7: pixel = (col == 3);
                3'd0: pixel = (col == 3);
                3'd1: pixel = (col == 3);
                3'd2: pixel = (col == 3);
                3'd3: pixel = 0;
                default: pixel = 0;
            endcase

            8'h47: //'G'
                case (row)
                    3'd4: pixel = (col >= 1 && col <= 5);
                    3'd5: pixel = (col == 0 || col == 6);
                    3'd6: pixel = (col == 0);
                    3'd7: pixel = (col == 0 || col >= 4);
                    3'd0: pixel = (col == 0 || col == 6);
                    3'd1: pixel = (col == 0 || col == 6);
                    3'd2: pixel = (col >= 1 && col <= 5);
                    3'd3: pixel = 0;
                    default: pixel = 1;
                endcase

            8'h4F: // 'O'
                case (row)
                    3'd4: pixel = (col >= 1 && col <= 5);
                    3'd5: pixel = (col == 0 || col == 6);
                    3'd6: pixel = (col == 0 || col == 6);
                    3'd7: pixel = (col == 0 || col == 6);
                    3'd0: pixel = (col == 0 || col == 6);
                    3'd1: pixel = (col == 0 || col == 6);
                    3'd2: pixel = (col >= 1 && col <= 5);
                    3'd3: pixel = 0;
                    default: pixel = 1;
                endcase
                

            8'h44: // 'D'
                case (row)
                    3'd4: pixel = (col >= 0 && col <= 4);
                    3'd5: pixel = (col == 0 || col == 5);
                    3'd6: pixel = (col == 0 || col == 6);
                    3'd7: pixel = (col == 0 || col == 6);
                    3'd0: pixel = (col == 0 || col == 6);
                    3'd1: pixel = (col == 0 || col == 6);
                    3'd2: pixel = (col == 0 || col == 5);
                    3'd3: pixel = (col >= 0 && col <= 4);
                    default: pixel = 1;
                endcase
                
                8'h42: // 'B'
                    case (row)
                        3'd4: pixel = (col >= 0 && col <= 5);
                        3'd5: pixel = (col == 0 || col == 5);
                        3'd6: pixel = (col == 0 || col == 5);
                        3'd7: pixel = (col >= 0 && col <= 5);
                        3'd0: pixel = (col == 0 || col == 5);
                        3'd1: pixel = (col == 0 || col == 5);
                        3'd2: pixel = (col >= 0 && col <= 5);
                        3'd3: pixel = 0;
                        default: pixel = 0;
                    endcase
  
                8'h41: // 'A'
                    case (row)
                        3'd4: pixel = (col >= 1 && col <= 5);
                        3'd5: pixel = (col == 0 || col == 6);
                        3'd6: pixel = (col == 0 || col == 6);
                        3'd7: pixel = (col >= 0 && col <= 6);
                        3'd0: pixel = (col == 0 || col == 6);
                        3'd1: pixel = (col == 0 || col == 6);
                        3'd2: pixel = (col == 0 || col == 6);
                        3'd3: pixel = 0;
                        default: pixel = 0;
                    endcase
                
                8'h44: // 'D'
                    case (row)
                        3'd4: pixel = (col >= 0 && col <= 4);
                        3'd5: pixel = (col == 0 || col == 5);
                        3'd6: pixel = (col == 0 || col == 6);
                        3'd7: pixel = (col == 0 || col == 6);
                        3'd0: pixel = (col == 0 || col == 6);
                        3'd1: pixel = (col == 0 || col == 6);
                        3'd2: pixel = (col == 0 || col == 5);
                        3'd3: pixel = (col >= 0 && col <= 4);
                        default: pixel = 0;
                    endcase

             8'h4D: // 'M'
                 case (row)
                        3'd4: pixel = (col == 0 || col == 6);
                        3'd5: pixel = (col == 0 || col == 1 || col == 5 || col == 6);
                        3'd6: pixel = (col == 0 || col == 2 || col == 4 || col == 6);
                        3'd7: pixel = (col == 0 || col == 3 || col == 6);
                        3'd0: pixel = (col == 0 || col == 6);
                        3'd1: pixel = (col == 0 || col == 6);
                        3'd2: pixel = (col == 0 || col == 6);
                        3'd3: pixel = 0;
                        default: pixel = 0;
                   endcase

              8'h49: // 'I'
                   case (row)
                        3'd4: pixel = (col >= 2 && col <= 4);
                        3'd5: pixel = (col == 3);
                        3'd6: pixel = (col == 3);
                        3'd7: pixel = (col == 3);
                        3'd0: pixel = (col == 3);
                        3'd1: pixel = (col == 3);
                        3'd2: pixel = (col >= 2 && col <= 4);
                        3'd3: pixel = 0;
                        default: pixel = 0;
                   endcase

              8'h53: //'S'
                  case (row)
                      3'd4: pixel = (col >= 1 && col <= 5);
                      3'd5: pixel = (col == 0);
                      3'd6: pixel = (col >= 1 && col <= 5);
                      3'd7: pixel = (col == 6);
                      3'd0: pixel = (col >= 1 && col <= 5);
                      3'd1: pixel = (col == 6);
                      3'd2: pixel = (col >= 1 && col <= 5);
                      3'd3: pixel = 0;
                       default: pixel = 0;
                 endcase
                
            default: pixel = 0;
        endcase
    end
endmodule
