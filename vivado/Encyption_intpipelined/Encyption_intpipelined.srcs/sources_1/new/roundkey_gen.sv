`timescale 1ns / 1ps

`include "CONSTANTS.vh"
import rcon_pkg::*;
import sbox_pkg::*; 

module calculate_round_keys(
    input logic [`KEY_WIDTH-1:0] key256,
    output logic [`ROUND_KEYS_LEN-1:0] round_keys [`ROUND_KEYS_GEN-1:0]
);
    logic [`WORDS_LEN-1:0] words[`WORDS-1:0];
    integer i, j;
    logic [7:0] result;

    always_comb begin
        // Initialize first 8 words from key - FIXED BYTE ORDER
        for (i = 0; i < 8; i++) begin 
            words[i] = key256[(`KEY_WIDTH-1-i*32) -: 32];
        end

        // Key expansion for i >= 8
        for (i = 8; i < 60; i++) begin
            $display("i is %d",i);
            if (i % 8 == 0) begin
    // RotWord and SubWord
    logic [31:0] temp;
    logic[31:0] result2;
    temp = {words[i-1] << 8} | {words[i-1] >> 24};
//    $display("shifted value is %h and word is %h",temp,words[i-1]);

    for (j = 0; j < 4; j++) begin
    
        result= sbox[temp[(31-j*8) -:4]][temp[(31-(j*8+4)) -:4]];
        result2[(31-j*8) -:8]=result;
//        $display("%h is row and %h is col and op is %h",temp[31-j*8 -:4],temp[(31-(j*8+4)) -:4],result);
        
        // Store result in the same position it was extracted from
//        result = temp[(31-j*8) -:8] ;
    end
//    $display("word after substn is %h",result2);
                
//                $display("rcon value is %h",rcon[(i/8)-1]);
                result2[31:24] = result2[31:24]^rcon[(i/8)-1];
//                $display("result2 is %h and is xor1",result2);
                 words[i] = result2^ words[i-8];
//                $display("result2 is %h and is after xor2",words[i]);
                
//                words[i] = words[1-8]^temp;
                
            end 
            else if (i % 8 == 4) begin
            
            logic[31:0] result2;
               for (j = 0; j < 4; j++) begin
    
        result= sbox[words[i-1][(31-j*8) -:4]][words[i-1][(31-(j*8+4)) -:4]];
        result2[(31-j*8) -:8]=result;
        $display("%h is row and %h is col and op is %h",words[i-1][31-j*8 -:4],words[i-1][(31-(j*8+4)) -:4],result);
        
        // Store result in the same position it was extracted from
//        result = temp[(31-j*8) -:8] ;
    end
    $display("word after substn is %h",result2);
                // XOR RCON (first byte)
//                result = result ^ words[i-8];
//                words[i] = {rcon[i/8],24'b000000000000000000000000} ^ result;
                
                
                $display("result2 is %h and is xor1",result2);
                 words[i] = result2^ words[i-8];
                $display("result2 is %h and is after xor2",words[i]);
                
//                words[i] = words[1-8]^temp;
            end 
            else begin
                // XOR with previous and 8th prior
                words[i] = words[i-1] ^ words[i-8];
            end
        end

        // Assign round keys - FIXED WORD ORDER
        for (i = 0; i < `ROUND_KEYS_GEN; i++) begin
            round_keys[i] = {words[i*4], words[i*4+1], words[i*4+2], words[i*4+3]};
        end
    end
endmodule
