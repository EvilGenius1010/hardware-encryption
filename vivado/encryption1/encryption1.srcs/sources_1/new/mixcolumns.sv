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
`include "CONSTANTS.vh"
`include "RCONSTANTS.vh"

module mixcolumns(
input logic [7:0] shiftedrows[15:0],
input [`WORDS_LEN:0] words[3:0],
output logic [7:0] mixedcolumns[15:0]
    );

always_comb begin
    // Initialize all elements to zero
    for (integer i = 0; i < 16; i = i + 1) begin
        mixedcolumns[i] = 8'b0;
    end
end
     
always_comb begin
for(integer i=0;i<4;i=i+1) begin
mixedcolumns[i] = (2 * shiftedrows[i])^(3*shiftedrows[i+4])^shiftedrows[i+8]^shiftedrows[i+12];
mixedcolumns[i+4] =  shiftedrows[i]^(2*shiftedrows[i+4])^(3*shiftedrows[i+8])^shiftedrows[i+12];
mixedcolumns[i+8] = shiftedrows[i]^shiftedrows[i+4]^(2*shiftedrows[i+8])^(3*shiftedrows[i+12]);
mixedcolumns[i+12] = (3 * shiftedrows[i])^shiftedrows[i+4]^shiftedrows[i+8]^(2*shiftedrows[i+12]);
end
end

always_comb begin
for(integer i=0;i<4;i=i+1) begin
mixedcolumns[i+:4] = mixedcolumns[i+:4]^words[i];
end
end

   
endmodule
