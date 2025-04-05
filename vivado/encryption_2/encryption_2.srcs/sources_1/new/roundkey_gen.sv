import sbox_pkg::*;
import rcon_pkg::*;
`include "CONSTANTS.vh"

module calculate_round_keys(
    input logic[`KEY_WIDTH-1:0] key256,
    output logic [`ROUND_KEYS_LEN-1:0] round_keys [`ROUND_KEYS_GEN-1:0]
);
    logic [31:0] words[`WORDS-1:0];
    logic [7:0] temp[0:3];
    
    always_comb begin
        // First 8 words directly from key (column by column)
        for (int i = 0; i < 8; i = i + 1) begin 
            // Extract bytes from key256 using indexing
            words[i][31:24] = key256[255 - i * 32 +: 8]; // Byte 0 (MSB)
            words[i][23:16] = key256[247 - i * 32 +: 8]; // Byte 1
            words[i][15:8]  = key256[239 - i * 32 +: 8]; // Byte 2
            words[i][7:0]   = key256[231 - i * 32 +: 8]; // Byte 3 (LSB)
        end
        
        // Key Expansion Process
        for (int i = 8; i < `WORDS; i = i + 1) begin
            // Copy previous word
            temp[0] = words[i-1][31:24];
            temp[1] = words[i-1][23:16];
            temp[2] = words[i-1][15:8];
            temp[3] = words[i-1][7:0];
            
            if (i % 8 == 0) begin
                // RotWord: Circular left shift by 1 byte
                logic [7:0] t = temp[0];
                temp[0] = temp[1];
                temp[1] = temp[2];
                temp[2] = temp[3];
                temp[3] = t;
                
                // SubWord: Apply S-Box to each byte
                temp[0] = sbox[temp[0][7:4]][temp[0][3:0]];
                temp[1] = sbox[temp[1][7:4]][temp[1][3:0]];
                temp[2] = sbox[temp[2][7:4]][temp[2][3:0]];
                temp[3] = sbox[temp[3][7:4]][temp[3][3:0]];
                
                // XOR with round constant - FIX: use i/8 instead of (i/8)-1
                temp[0] = temp[0] ^ rcon[i/8];
            end
            else if (i % 8 == 4) begin
                // SubWord for AES-256 (special case)
                temp[0] = sbox[temp[0][7:4]][temp[0][3:0]];
                temp[1] = sbox[temp[1][7:4]][temp[1][3:0]];
                temp[2] = sbox[temp[2][7:4]][temp[2][3:0]];
                temp[3] = sbox[temp[3][7:4]][temp[3][3:0]];
            end
            
            // XOR with word from 8 positions back
            words[i][31:24] = temp[0] ^ words[i-8][31:24];
            words[i][23:16] = temp[1] ^ words[i-8][23:16];
            words[i][15:8] = temp[2] ^ words[i-8][15:8];
            words[i][7:0] = temp[3] ^ words[i-8][7:0];
        end
        
        // Assign round keys
        for (int i = 0; i < `ROUND_KEYS_GEN; i = i + 1) begin
            for (int j = 0; j < 4; j = j + 1) begin
                round_keys[i][127-j*32 -: 32] = words[i*4+j];
            end
        end
    end
endmodule
