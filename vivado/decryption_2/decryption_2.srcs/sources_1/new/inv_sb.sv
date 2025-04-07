`timescale 1ns / 1ps

/////



/////

//input with correct values 



/////



///////

package inv_sbox_pkg;

    // Inverse S-Box Lookup Table (Rijndael standard)
    localparam bit [7:0] inv_sbox [16][16] = '{
        '{8'h52, 8'h09, 8'h6a, 8'hd5, 8'h30, 8'h36, 8'ha5, 8'h38, 8'hbf, 8'h40, 8'ha3, 8'h9e, 8'h81, 8'hf3, 8'hd7, 8'hfb},
        '{8'h7c, 8'he3, 8'h39, 8'h82, 8'h9b, 8'he0, 8'h46, 8'h0c, 8'h8e, 8'h2e, 8'ha1, 8'h66, 8'h28, 8'hd9, 8'h24, 8'hb2},
        '{8'h76, 8'h5b, 8'ha2, 8'h49, 8'h6d, 8'h8b, 8'd1, 8'h25, 8'h72, 8'hf8, 8'hf6, 8'h64, 8'h86, 8'h68, 8'h98, 8'h16},
        '{8'hd4, 8'ha4, 8'h5c, 8'hcc, 8'h5d, 8'h65, 8'hb6, 8'h92, 8'h6c, 8'h70, 8'h48, 8'h50, 8'hfd, 8'hed, 8'hb9, 8'hda},
        '{8'h5e, 8'h15, 8'h46, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84, 8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a},
        '{8'hf7, 8'he2, 8'hfb, 8'h0e, 8'h61, 8'h3c, 8'h7d, 8'hd0, 8'hb5, 8'h6a, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf},
        '{8'hbd, 8'h03, 8'h01, 8'h67, 8'h2b, 8'hf0, 8'h3b, 8'h69, 8'hd9, 8'h8e, 8'h9a, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84},
        '{8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a, 8'hf7, 8'he2, 8'hfb, 8'h0e, 8'h61, 8'h3c, 8'h7d, 8'hd0},
        '{8'hb5, 8'h6a, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf, 8'hbd, 8'h03, 8'h01, 8'h67, 8'h2b, 8'hf0, 8'h3b, 8'h69},
        '{8'hd9, 8'h8e, 8'h9a, 8'h57, 8'ha7, 8'h8d, 8'h46, 8'h47, 8'hf1, 8'h3c, 8'h6e, 8'h8a, 8'h7a, 8'hf3, 8'hd2, 8'h8b},
        '{8'h1c, 8'hd1, 8'h85, 8'h4c, 8'ha9, 8'h9c, 8'hc5, 8'h8d, 8'h5d, 8'hd7, 8'h5a, 8'ha2, 8'h6f, 8'h49, 8'h4a, 8'h6c},
        '{8'h8d, 8'h4b, 8'h6d, 8'h5c, 8'h9d, 8'h1a, 8'hf8, 8'h86, 8'h6e, 8'h47, 8'h87, 8'hc9, 8'hba, 8'hd4, 8'hde, 8'h94},
        '{8'h61, 8'h99, 8'h9c, 8'hd2, 8'h5d, 8'h69, 8'h47, 8'hfd, 8'h50, 8'h83, 8'h3e, 8'h7b, 8'hf8, 8'h40, 8'hb5, 8'h62},
        '{8'h0d, 8'h0a, 8'h7d, 8'hf1, 8'h43, 8'hfd, 8'h10, 8'h15, 8'h39, 8'hdc, 8'h24, 8'h90, 8'hb8, 8'h0d, 8'h69, 8'h9e}
    };

  

endpackage
