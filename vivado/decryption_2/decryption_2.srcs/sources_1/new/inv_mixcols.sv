`timescale 1ns / 1ps

`include "CONSTANTS.vh";

module inv_mixcols(
input logic[`ROUND_KEYS_LEN-1:0] inv_rndkey,
output logic[`ROUND_KEYS_LEN-1:0] inv_mixcols
);



always_comb begin

inv_mixcols[127:120]= (8'h0E & inv_rndkey[127:120]) ^
(8'h0B & inv_rndkey[99:92]) ^
(8'h0D & inv_rndkey[71:64]) ^ 
(8'h09 & inv_rndkey[43:36]);

  // Inverse MixColumns for the second column
    inv_mixcols[99:92] = (8'h09 & inv_rndkey[127:120]) ^ 
                           (8'h0E & inv_rndkey[99:92]) ^ 
                           (8'h0B & inv_rndkey[71:64]) ^ 
                           (8'h0D & inv_rndkey[43:36]);

    // Inverse MixColumns for the third column
    inv_mixcols[71:64] = (8'h0D & inv_rndkey[127:120]) ^ 
                           (8'h09 & inv_rndkey[99:92]) ^ 
                           (8'h0E & inv_rndkey[71:64]) ^ 
                           (8'h0B & inv_rndkey[43:36]);

    // Inverse MixColumns for the fourth column
    inv_mixcols[43:36] = (8'h0B & inv_rndkey[127:120]) ^ 
                          (8'h0D & inv_rndkey[99:92]) ^ 
                          (8'h09 & inv_rndkey[71:64]) ^ 
                          (8'h0E & inv_rndkey[43:36]);
                          
                          
                          
inv_mixcols[119:112]= (8'h0E & inv_rndkey[119:112]) ^
(8'h0B & inv_rndkey[91:84]) ^
(8'h0D & inv_rndkey[83:76]) ^ 
(8'h09 & inv_rndkey[35:28]);

  // Inverse MixColumns for the second column
    inv_mixcols[91:84] = (8'h09 & inv_rndkey[119:112]) ^ 
                           (8'h0E & inv_rndkey[91:84]) ^ 
                           (8'h0B & inv_rndkey[83:76]) ^ 
                           (8'h0D & inv_rndkey[35:28]);

    // Inverse MixColumns for the third column
    inv_mixcols[83:76] = (8'h0D & inv_rndkey[119:112]) ^ 
                           (8'h09 & inv_rndkey[91:84]) ^ 
                           (8'h0E & inv_rndkey[83:76]) ^ 
                           (8'h0B & inv_rndkey[35:28]);

    // Inverse MixColumns for the fourth column
    inv_mixcols[43:36] = (8'h0B & inv_rndkey[127:120]) ^ 
                          (8'h0D & inv_rndkey[99:92]) ^ 
                          (8'h09 & inv_rndkey[71:64]) ^ 
                          (8'h0E & inv_rndkey[43:36]);

end


endmodule