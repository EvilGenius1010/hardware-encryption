`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 21:44:45
// Design Name: 
// Module Name: inv_shiftrows
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

`include "CONSTANTS.vh"

module inv_shiftrows(
    input logic[`ROUND_KEYS_LEN-1:0] fourteenth_rnd_key,
    input logic[`ROUND_KEYS_LEN-1:0] ciphertext,
    output  logic[`ROUND_KEYS_LEN-1:0] inv_shifted_rows
    );
    
    logic[`ROUND_KEYS_LEN-1:0] xor_with_rndkey;
    
    
    //xoring ciphertext with 14th round 
    assign xor_with_rndkey = fourteenth_rnd_key ^ ciphertext;
    
    always_comb begin
      // Row 0: No shift
        inv_shifted_rows[0] = xor_with_rndkey[0];
        inv_shifted_rows[1] = xor_with_rndkey[1];
        inv_shifted_rows[2] = xor_with_rndkey[2];
        inv_shifted_rows[3] = xor_with_rndkey[3];
        
       //Row 1:Shift One to right

        inv_shifted_rows[7] = xor_with_rndkey[4];
        inv_shifted_rows[4] = xor_with_rndkey[5];
        inv_shifted_rows[5] = xor_with_rndkey[6];
        inv_shifted_rows[6] = xor_with_rndkey[7];
        
        
       //Row 2:Shift two bytes to right
        inv_shifted_rows[8] = xor_with_rndkey[10];
        inv_shifted_rows[9] = xor_with_rndkey[11];
        inv_shifted_rows[10] = xor_with_rndkey[8];
        inv_shifted_rows[11] = xor_with_rndkey[9];
        
        
       //Row 2:Shift three bytes to right
        inv_shifted_rows[12] = xor_with_rndkey[15];
        inv_shifted_rows[13] = xor_with_rndkey[12];
        inv_shifted_rows[14] = xor_with_rndkey[13];
        inv_shifted_rows[15] = xor_with_rndkey[14];
        
        
        
        
    end
    
    
endmodule
