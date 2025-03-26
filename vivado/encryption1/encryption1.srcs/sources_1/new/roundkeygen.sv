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
////`include "RCONSTANTS.vh" 
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

//module calculate_round_keys;
//    `include "CONSTANTS.vh"

//      function automatic [7:0] sbox_lookup(input [3:0] row, input [3:0] col);
//    sbox_lookup = sbox[row][col];
//  endfunction  

//    reg [0:255] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
//    reg [`ROUND_KEYS_LEN-1:0] round_keys[`ROUND_KEYS_GEN-1:0]; // 14 round keys of 128 bits each
//    reg [0:`WORDS_LEN-1] words[0:`WORDS-1];

//    integer i, j;
//    reg [7:0] result;
    
//    // Declare and initialize rcon if not already done
//    reg [31:0] rcon [0:9] = '{
//        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 
//        32'h10000000, 32'h20000000, 32'h40000000, 32'h80000000, 
//        32'h1B000000, 32'h36000000
//    };

//    // First 8 words initialization
//    initial begin
//        for (i = 0; i < 8; i = i + 1) begin // Changed i < 7 to i < 8
//            words[i] = key256[i*32 +: 32];
//        end
//    end

//    // Key Expansion Process
//    initial begin
//        for (i = 8; i < 60; i = i + 1) begin
//            if (i % 8 == 0) begin
//                // RotWord - Circular Left Shift of 32-bit word
//                words[i] = {words[i-1][23:0], words[i-1][31:24]}; // Proper RotWord
                
//                // Apply S-Box Substitution
//                for (j = 0; j < 4; j = j + 1) begin
//                    result = sbox_inst.sbox_lookup(words[i][j*8 +: 4], words[i][(j*8+4) +: 4]); 
//                    words[i][j*8 +: 8] = result;
//                end
                
//                // XOR with RCON
//                words[i] = words[i] ^ rcon[i/8];
//            end 
//            else if (i % 4 == 0) begin
//                // Apply S-Box substitution for every 4th word
//                for (j = 0; j < 4; j = j + 1) begin
//                    result = sbox_inst.sbox_lookup(words[i-1][j*8 +: 4], words[i-1][(j*8+4) +: 4]); 
//                    words[i][j*8 +: 8] = result; // Store the substituted value
//                end
//            end 
//            else begin
//                // Normal XOR for other words
//                words[i] = words[i-1] ^ words[i-8];
//            end
//        end
//    end

//endmodule
`include "CONSTANTS.vh"
module calculate_round_keys(output reg [`ROUND_KEYS_LEN-1:0] round_keys [`ROUND_KEYS_GEN-1:0]);
    

    `include "sbox_pkg.sv"
    import sbox_pkg::*; 

    reg [0:255] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    reg [0:`WORDS_LEN-1] words[0:`WORDS-1];

    integer i, j;
    reg [7:0] result;
    
    // Declare and initialize RCON
    reg [31:0] rcon [0:9] = '{
        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 
        32'h10000000, 32'h20000000, 32'h40000000, 32'h80000000, 
        32'h1B000000, 32'h36000000
    };

    // First 8 words initialization
    initial begin
        for (i = 0; i < 8; i = i + 1) begin 
            words[i] = key256[i*32 +: 32];
        end
    end

    // Key Expansion Process
    initial begin
        for (i = 8; i < 60; i = i + 1) begin
            if (i % 8 == 0) begin
                // RotWord - Circular Left Shift of 32-bit word
                words[i] = {words[i-1][23:0], words[i-1][31:24]}; // Proper RotWord
                
                // Apply S-Box Substitution
                for (j = 0; j < 4; j = j + 1) begin
                    result = sbox_lookup(words[i][j*8 +: 4], words[i][(j*8+4) +: 4]); 
                    words[i][j*8 +: 8] = result;
                end
                
                // XOR with RCON (only the first byte)
                words[i][31:24] = words[i][31:24] ^ rcon[i/8][31:24];
            end 
            else if (i % 4 == 0) begin
                // Apply S-Box substitution for every 4th word
                for (j = 0; j < 4; j = j + 1) begin
                    result = sbox_lookup(words[i-1][j*8 +: 4], words[i-1][(j*8+4) +: 4]); 
                    words[i][j*8 +: 8] = result;
                end
            end 
            else begin
                // Normal XOR for other words
                words[i] = words[i-1] ^ words[i-8];
            end
        end
    end

    // Assign words to round keys
    initial begin
        for (i = 0; i < `ROUND_KEYS_GEN; i = i + 1) begin
            round_keys[i] = {words[i*4], words[i*4+1], words[i*4+2], words[i*4+3]};
        end
    end

endmodule




//module calculate_round_keys;
//    `include "CONSTANTS.vh"

//    logic [3:0] sbox_row, sbox_col;
//    logic [7:0] sbox_value;
    
//    // Ensure sbox is correctly instantiated
//    sbox sbox_inst (
//        .index_row(sbox_row), 
//        .index_col(sbox_col), 
//        .sbox_out(sbox_value)
//    );  

//    reg [0:255] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
//    reg [`ROUND_KEYS_LEN-1:0] round_keys[`ROUND_KEYS_GEN-1:0]; // 14 round keys of 128 bits each
//    reg [0:`WORDS_LEN-1] words[0:`WORDS-1];

//    integer i, j;
    
//    // Declare and initialize rcon if not already done
//    reg [31:0] rcon [0:9] = '{
//        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 
//        32'h10000000, 32'h20000000, 32'h40000000, 32'h80000000, 
//        32'h1B000000, 32'h36000000
//    };

//    // First 8 words initialization
//    initial begin
//        for (i = 0; i < 8; i = i + 1) begin
//            words[i] = key256[i*32 +: 32];
//        end
//    end

//    // Key Expansion Process
//    initial begin
//        for (i = 8; i < 60; i = i + 1) begin
//            if (i % 8 == 0) begin
//                // RotWord - Circular Left Shift of 32-bit word
//                words[i] = {words[i-1][23:0], words[i-1][31:24]};
                
//                // Apply S-Box Substitution
//                for (j = 0; j < 4; j = j + 1) begin
//                    sbox_row = words[i][j*8+:4];  
//                    sbox_col = words[i][(j*8+4)+:4];  
//                    #1; // Allow time for sbox_value to update
//                    words[i][j*8+:8] = sbox_value;
//                end
                
//                // XOR with RCON
//                words[i] = words[i] ^ rcon[i/8];
//            end 
//            else if (i % 4 == 0) begin
//                // Apply S-Box substitution for every 4th word
//                for (j = 0; j < 4; j = j + 1) begin
//                    sbox_row = words[i-1][j*8+:4];  
//                    sbox_col = words[i-1][(j*8+4)+:4];  
//                    #1; 
//                    words[i][j*8+:8] = sbox_value;
//                end
//            end 
//            else begin
//                // Normal XOR for other words
//                words[i] = words[i-1] ^ words[i-8];
//            end
//        end
//    end

//endmodule

