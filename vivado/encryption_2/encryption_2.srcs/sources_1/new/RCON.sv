`timescale 1ns / 1ps

package rcon_pkg;

(* rom_style = "block" *) parameter [7:0] rcon [0:9] = '{
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
