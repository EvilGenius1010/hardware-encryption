//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 21.03.2025 23:54:44
//// Design Name: 
//// Module Name: roundkeygen
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


//module calculate_round_keys(

//    );
//`include "CONSTANTS.vh"  
//`include "RCONSTANTS.vh" 
//sbox_impl();


//reg [0:255] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; //remove once other code 
//reg [`ROUND_KEYS_LEN-1:0] round_keys[`ROUND_KEYS_GEN-1:0]; // 14 roundkeys generated each of length 128 

//reg [0:`WORDS_LEN-1] words[0:`WORDS-1];

//integer i,j;
//reg[7:0] result; 

////first 8 words are each 32 bits in order derived from the random key generated.
//initial begin
//for(i=0;i<7;i=i+1)begin
//words[i] = key256[i*32+:32]; //first parameter is start index and second is width.
//end
//end

////we fetch the previous word and perform left circular shift on the whole damn thing without dropping a bit.
//initial begin
//for(i=8;i<60;i=i+1)begin
//if(i%8 == 0)begin
//words[i] = words[i-1] << 1;
//for(j=0;j<4;j=j+1)begin
//result = sbox_impl.sbox_lookup(words[i][j*8+:4] , words[i][(j*8+4)+:4]);
//words[i][j*8+:8]=result;
//end
//words[i] = words[i]^ rcon[i/8];
//end
//if(i%4==0)begin
//for(j=0;j<4;j=j+1)begin
//result = sbox_impl.sbox_lookup(words[i][j*8+:4] , words[i][(j*8+4)+:4]);
//end
//end
//else begin
//words[i] = words[i]^ rcon[i/8];
//end
//end
//end
//endmodule
