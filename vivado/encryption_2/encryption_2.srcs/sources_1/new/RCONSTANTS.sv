`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2025 18:47:01
// Design Name: 
// Module Name: rcon_pkg
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
package rcon_pkg;

(* rom_style = "block" *) parameter [7:0] rcon [9:0] = {
  8'h01,  
  8'h02,  
  8'h04,  
  8'h08,  
  8'h10,  
  8'h20,  
  8'h40,  
  8'h80,  
  8'h1B,
  8'h36 
};
endpackage
