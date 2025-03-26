`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 22:45:39
// Design Name: 
// Module Name: sbox
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

//module sbox;

//// (* rom_style = "block" *) 
//  logic [7:0] sbox [0:15][0:15];

//always_comb begin
//  sbox[0][0] = 8'h63; sbox[0][1] = 8'h7c; sbox[0][2] = 8'h77; sbox[0][3] = 8'h7b;
//    sbox[0][4] = 8'hf2; sbox[0][5] = 8'h6b; sbox[0][6] = 8'h6f; sbox[0][7] = 8'hc5;
//    sbox[0][8] = 8'h30; sbox[0][9] = 8'h01; sbox[0][10] = 8'h67; sbox[0][11] = 8'h2b;
//    sbox[0][12] = 8'hfe; sbox[0][13] = 8'hd7; sbox[0][14] = 8'hab; sbox[0][15] = 8'h76;
    
//    sbox[1][0] = 8'hca; sbox[1][1] = 8'h82; sbox[1][2] = 8'hc9; sbox[1][3] = 8'h7d;
//    sbox[1][4] = 8'hfa; sbox[1][5] = 8'h59; sbox[1][6] = 8'h47; sbox[1][7] = 8'hf0;
//    sbox[1][8] = 8'had; sbox[1][9] = 8'hd4; sbox[1][10] = 8'ha2; sbox[1][11] = 8'haf;
//    sbox[1][12] = 8'h9c; sbox[1][13] = 8'ha4; sbox[1][14] = 8'h72; sbox[1][15] = 8'hc0;
    
//    sbox[2][0] = 8'hb7; sbox[2][1] = 8'hfd; sbox[2][2] = 8'h93; sbox[2][3] = 8'h26;
//    sbox[2][4] = 8'h36; sbox[2][5] = 8'h3f; sbox[2][6] = 8'hf7; sbox[2][7] = 8'hcc;
//    sbox[2][8] = 8'h34; sbox[2][9] = 8'ha5; sbox[2][10] = 8'he5; sbox[2][11] = 8'hf1;
//    sbox[2][12] = 8'h71; sbox[2][13] = 8'hd8; sbox[2][14] = 8'h31; sbox[2][15] = 8'h15;
    
//    sbox[3][0] = 8'h04; sbox[3][1] = 8'hc7; sbox[3][2] = 8'h23; sbox[3][3] = 8'hc3;
//    sbox[3][4] = 8'h18; sbox[3][5] = 8'h96; sbox[3][6] = 8'h05; sbox[3][7] = 8'h9a;
//    sbox[3][8] = 8'h07; sbox[3][9] = 8'h12; sbox[3][10] = 8'h80; sbox[3][11] = 8'he2;
//    sbox[3][12] = 8'heb; sbox[3][13] = 8'h27; sbox[3][14] = 8'hb2; sbox[3][15] = 8'h75;

//end

//// S-Box Lookup Function
//  function automatic  [7:0] sbox_lookup(input [3:0] row, input [3:0] col);
//    sbox_lookup = sbox[row][col];
//  endfunction
  
//endmodule

package sbox_pkg;

    // S-Box Lookup Table
    const logic [7:0] sbox [0:15][0:15] = '{
        '{8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76},
        '{8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0},
        '{8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15},
        '{8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75},
        '{8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84},
        '{8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf},
        '{8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8},
        '{8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2},
        '{8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73},
        '{8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb},
        '{8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79},
        '{8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08},
        '{8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a},
        '{8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e},
        '{8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf},
        '{8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16}
    };

    // S-Box Lookup Function
    function automatic [7:0] sbox_lookup(input [3:0] row, input [3:0] col);
        return sbox[row][col];
    endfunction

endpackage

