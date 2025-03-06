`ifndef RCON_INIT_VH
`define RCON_INIT_VH

(* rom_style = "block" *) reg [7:0] rcon [9:0];

initial begin
  rcon[0]  = 8'h01;  
  rcon[1]  = 8'h02;  
  rcon[2]  = 8'h04;  
  rcon[3]  = 8'h08;  
  rcon[4]  = 8'h10;  
  rcon[5]  = 8'h20;  
  rcon[6]  = 8'h40;  
  rcon[7]  = 8'h80;  
  rcon[8]  = 8'h1B;  
  rcon[9]  = 8'h36; 
end

`endif 