`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 22:21:53
// Design Name: 
// Module Name: inv_subbytes
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

import inv_sbox_pkg::*;
`include "CONSTANTS.vh"

module inv_subbytes(
    input logic[`ROUND_KEYS_LEN-1:0] inv_shiftedrows,
    output logic[`ROUND_KEYS_LEN-1:0] inv_subbytes
    );
    
        // Declare loop variables outside the loop
    logic [3:0] row, col;
    
    integer i;
       always_comb begin
        for(i = 0; i < 16; i++) begin

            row = inv_shiftedrows[i*8 +: 4];
            col = inv_shiftedrows[i*8+4 +: 4];
            inv_subbytes[i*8 +: 8] =inv_sbox[row][col];
        end
    end

    
    
    
    
endmodule
