`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 23:30:21
// Design Name: 
// Module Name: mixcolumns
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


////Unrolled Part

//`include "CONSTANTS.vh"
////`include "RCONSTANTS.vh"
//import rcon_pkg::*;

//module mixcolumns(
//input logic [7:0] shiftedrows[15:0],
//input [`WORDS_LEN:0] words[3:0],
//output logic [7:0] mixedcolumns[15:0]
//    );

//always_comb begin
//    // Initialize all elements to zero
//    for (integer i = 0; i < 16; i = i + 1) begin
//        mixedcolumns[i] = 8'b0;
//    end
//end
     
//always_comb begin
//for(integer i=0;i<4;i=i+1) begin
//mixedcolumns[i] = (2 * shiftedrows[i])^(3*shiftedrows[i+4])^shiftedrows[i+8]^shiftedrows[i+12];
//mixedcolumns[i+4] =  shiftedrows[i]^(2*shiftedrows[i+4])^(3*shiftedrows[i+8])^shiftedrows[i+12];
//mixedcolumns[i+8] = shiftedrows[i]^shiftedrows[i+4]^(2*shiftedrows[i+8])^(3*shiftedrows[i+12]);
//mixedcolumns[i+12] = (3 * shiftedrows[i])^shiftedrows[i+4]^shiftedrows[i+8]^(2*shiftedrows[i+12]);
//end
//end

////always_comb begin
////for(integer i=0;i<4;i=i+1) begin
////mixedcolumns[i+:4] = mixedcolumns[i+:4]^words[i];
////end
////end

//always_comb begin
//    for (integer i = 0; i < 4; i = i + 1) begin
//        for (integer j = 0; j < 4; j = j + 1) begin
//            mixedcolumns[4*i + j] = mixedcolumns[4*i + j] ^ words[i][8*(3-j) +: 8]; // Proper bit slicing
//        end
//    end
//end

   
//endmodule

////Unrolled Part ends here

`include "CONSTANTS.vh"
//`include "RCONSTANTS.vh"
import rcon_pkg::*;

module mixcolumns(
    input logic [7:0] shiftedrows[15:0],
    input [`WORDS_LEN:0] words[3:0],
    output logic [7:0] mixedcolumns[15:0]
);

// Initialize all elements to zero
always_comb begin
    mixedcolumns[0]  = 8'b0;
    mixedcolumns[1]  = 8'b0;
    mixedcolumns[2]  = 8'b0;
    mixedcolumns[3]  = 8'b0;
    mixedcolumns[4]  = 8'b0;
    mixedcolumns[5]  = 8'b0;
    mixedcolumns[6]  = 8'b0;
    mixedcolumns[7]  = 8'b0;
    mixedcolumns[8]  = 8'b0;
    mixedcolumns[9]  = 8'b0;
    mixedcolumns[10] = 8'b0;
    mixedcolumns[11] = 8'b0;
    mixedcolumns[12] = 8'b0;
    mixedcolumns[13] = 8'b0;
    mixedcolumns[14] = 8'b0;
    mixedcolumns[15] = 8'b0;
end

// MixColumns Transformation
always_comb begin
    mixedcolumns[0]  = (2 * shiftedrows[0])  ^ (3 * shiftedrows[4])  ^ shiftedrows[8]  ^ shiftedrows[12];
    mixedcolumns[1]  = (2 * shiftedrows[1])  ^ (3 * shiftedrows[5])  ^ shiftedrows[9]  ^ shiftedrows[13];
    mixedcolumns[2]  = (2 * shiftedrows[2])  ^ (3 * shiftedrows[6])  ^ shiftedrows[10] ^ shiftedrows[14];
    mixedcolumns[3]  = (2 * shiftedrows[3])  ^ (3 * shiftedrows[7])  ^ shiftedrows[11] ^ shiftedrows[15];

    mixedcolumns[4]  = shiftedrows[0]  ^ (2 * shiftedrows[4])  ^ (3 * shiftedrows[8])  ^ shiftedrows[12];
    mixedcolumns[5]  = shiftedrows[1]  ^ (2 * shiftedrows[5])  ^ (3 * shiftedrows[9])  ^ shiftedrows[13];
    mixedcolumns[6]  = shiftedrows[2]  ^ (2 * shiftedrows[6])  ^ (3 * shiftedrows[10]) ^ shiftedrows[14];
    mixedcolumns[7]  = shiftedrows[3]  ^ (2 * shiftedrows[7])  ^ (3 * shiftedrows[11]) ^ shiftedrows[15];

    mixedcolumns[8]  = shiftedrows[0]  ^ shiftedrows[4]  ^ (2 * shiftedrows[8])  ^ (3 * shiftedrows[12]);
    mixedcolumns[9]  = shiftedrows[1]  ^ shiftedrows[5]  ^ (2 * shiftedrows[9])  ^ (3 * shiftedrows[13]);
    mixedcolumns[10] = shiftedrows[2]  ^ shiftedrows[6]  ^ (2 * shiftedrows[10]) ^ (3 * shiftedrows[14]);
    mixedcolumns[11] = shiftedrows[3]  ^ shiftedrows[7]  ^ (2 * shiftedrows[11]) ^ (3 * shiftedrows[15]);

    mixedcolumns[12] = (3 * shiftedrows[0])  ^ shiftedrows[4]  ^ shiftedrows[8]  ^ (2 * shiftedrows[12]);
    mixedcolumns[13] = (3 * shiftedrows[1])  ^ shiftedrows[5]  ^ shiftedrows[9]  ^ (2 * shiftedrows[13]);
    mixedcolumns[14] = (3 * shiftedrows[2])  ^ shiftedrows[6]  ^ shiftedrows[10] ^ (2 * shiftedrows[14]);
    mixedcolumns[15] = (3 * shiftedrows[3])  ^ shiftedrows[7]  ^ shiftedrows[11] ^ (2 * shiftedrows[15]);
end

// XOR operation with words
always_comb begin
    mixedcolumns[0]  = mixedcolumns[0]  ^ words[0][24 +: 8];
    mixedcolumns[1]  = mixedcolumns[1]  ^ words[0][16 +: 8];
    mixedcolumns[2]  = mixedcolumns[2]  ^ words[0][8  +: 8];
    mixedcolumns[3]  = mixedcolumns[3]  ^ words[0][0  +: 8];

    mixedcolumns[4]  = mixedcolumns[4]  ^ words[1][24 +: 8];
    mixedcolumns[5]  = mixedcolumns[5]  ^ words[1][16 +: 8];
    mixedcolumns[6]  = mixedcolumns[6]  ^ words[1][8  +: 8];
    mixedcolumns[7]  = mixedcolumns[7]  ^ words[1][0  +: 8];

    mixedcolumns[8]  = mixedcolumns[8]  ^ words[2][24 +: 8];
    mixedcolumns[9]  = mixedcolumns[9]  ^ words[2][16 +: 8];
    mixedcolumns[10] = mixedcolumns[10] ^ words[2][8  +: 8];
    mixedcolumns[11] = mixedcolumns[11] ^ words[2][0  +: 8];

    mixedcolumns[12] = mixedcolumns[12] ^ words[3][24 +: 8];
    mixedcolumns[13] = mixedcolumns[13] ^ words[3][16 +: 8];
    mixedcolumns[14] = mixedcolumns[14] ^ words[3][8  +: 8];
    mixedcolumns[15] = mixedcolumns[15] ^ words[3][0  +: 8];
end

endmodule

