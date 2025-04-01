`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 22:50:50
// Design Name: 
// Module Name: shiftrows
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


module shiftrows(
input logic [7:0] subbytesop[15:0],
output logic [7:0] shiftedrows[15:0]    
    );
    
logic [7:0] tempshift[3:0];

//assigning values to variables
//for(integer i=0;i<16;i=i+1)initial 
//begin
//tempshift[0] = (subbytesop[i],subbytesop[i+1],subbytesop[i]);
//tempshift[1] = subbytesop[4+:4];
//tempshift[2] = subbytesop[8+:4];
//tempshift[3] = subbytesop[12+:4];
//end

always_comb begin
    tempshift[0] = {subbytesop[0], subbytesop[1], subbytesop[2], subbytesop[3]};
    tempshift[1] = {subbytesop[4], subbytesop[5], subbytesop[6], subbytesop[7]};
    tempshift[2] = {subbytesop[8], subbytesop[9], subbytesop[10], subbytesop[11]};
    tempshift[3] = {subbytesop[12], subbytesop[13], subbytesop[14], subbytesop[15]};
end

always_comb begin
for(integer i=0;i<4;i=i+1)
begin
tempshift[i] = tempshift[i]<<(i*8);
end
end

// Appending tempshift values to shiftedrows
always_comb begin
    shiftedrows[0]  = tempshift[0];
    shiftedrows[1]  = tempshift[1];
    shiftedrows[2]  = tempshift[2];
    shiftedrows[3]  = tempshift[3];
    
    shiftedrows[4]  = tempshift[0];
    shiftedrows[5]  = tempshift[1];
    shiftedrows[6]  = tempshift[2];
    shiftedrows[7]  = tempshift[3];
    
    shiftedrows[8]  = tempshift[0];
    shiftedrows[9]  = tempshift[1];
    shiftedrows[10] = tempshift[2];
    shiftedrows[11] = tempshift[3];
    
    shiftedrows[12] = tempshift[0];
    shiftedrows[13] = tempshift[1];
    shiftedrows[14] = tempshift[2];
    shiftedrows[15] = tempshift[3];
end







endmodule
