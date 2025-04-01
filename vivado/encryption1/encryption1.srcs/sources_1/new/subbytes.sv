`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 19:33:50
// Design Name: 
// Module Name: subbytes
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

//input logic [127:0] plaintext,
//output [127:0] processed_text,
//input clk,
//input logic[127:0] master_key 

`include "sbox.sv"

module subbytes(
input logic [127:0] plaintext,

input clk,
input logic[127:0] master_key 

    );
endmodule

//the preprocessed text
logic [127:0] processed_text,

//`include "sbox.vh"
//`include "sbox.sv"

//instantiate preprocessed module
preprocessing preprocessed_data(
.plaintext(plaintext),
.clk(clk),
.master_key(master_key),
.processed_text(processed_text)
)

always_comb begin
for(i=0;i<16;i++)begin
logic [3:0] row, col;
row = state_in[i*8 +: 4];
col = state_in[i*8+4 +: 4];
processed_text[i*8 +: 8] = sbox[row][col];
end
end
