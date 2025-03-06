 (* rom_style = "block" *)  reg [7:0] sbox [0:15][0:15];
 
 
 

 
 function [7:0] sbox_lookup(input [3:0] row, input [3:0] col);
    begin
      sbox_lookup = sbox[row][col];
    end
  endfunction
 


initial begin
    sbox[0][0] = 8'h63; sbox[0][1] = 8'h7c; sbox[0][2] = 8'h77; sbox[0][3] = 8'h7b;
    sbox[0][4] = 8'hf2; sbox[0][5] = 8'h6b; sbox[0][6] = 8'h6f; sbox[0][7] = 8'hc5;
    sbox[0][8] = 8'h30; sbox[0][9] = 8'h01; sbox[0][10] = 8'h67; sbox[0][11] = 8'h2b;
    sbox[0][12] = 8'hfe; sbox[0][13] = 8'hd7; sbox[0][14] = 8'hab; sbox[0][15] = 8'h76;
    
    sbox[1][0] = 8'hca; sbox[1][1] = 8'h82; sbox[1][2] = 8'hc9; sbox[1][3] = 8'h7d;
    sbox[1][4] = 8'hfa; sbox[1][5] = 8'h59; sbox[1][6] = 8'h47; sbox[1][7] = 8'hf0;
    sbox[1][8] = 8'had; sbox[1][9] = 8'hd4; sbox[1][10] = 8'ha2; sbox[1][11] = 8'haf;
    sbox[1][12] = 8'h9c; sbox[1][13] = 8'ha4; sbox[1][14] = 8'h72; sbox[1][15] = 8'hc0;
    
    sbox[2][0] = 8'hb7; sbox[2][1] = 8'hfd; sbox[2][2] = 8'h93; sbox[2][3] = 8'h26;
    sbox[2][4] = 8'h36; sbox[2][5] = 8'h3f; sbox[2][6] = 8'hf7; sbox[2][7] = 8'hcc;
    sbox[2][8] = 8'h34; sbox[2][9] = 8'ha5; sbox[2][10] = 8'he5; sbox[2][11] = 8'hf1;
    sbox[2][12] = 8'h71; sbox[2][13] = 8'hd8; sbox[2][14] = 8'h31; sbox[2][15] = 8'h15;
    
    sbox[3][0] = 8'h04; sbox[3][1] = 8'hc7; sbox[3][2] = 8'h23; sbox[3][3] = 8'hc3;
    sbox[3][4] = 8'h18; sbox[3][5] = 8'h96; sbox[3][6] = 8'h05; sbox[3][7] = 8'h9a;
    sbox[3][8] = 8'h07; sbox[3][9] = 8'h12; sbox[3][10] = 8'h80; sbox[3][11] = 8'he2;
    sbox[3][12] = 8'heb; sbox[3][13] = 8'h27; sbox[3][14] = 8'hb2; sbox[3][15] = 8'h75;
     // AND IT continues
end
endmodule
