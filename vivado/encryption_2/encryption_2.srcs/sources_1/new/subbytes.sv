`timescale 1ns / 1ps

import sbox_pkg::*;

module subbytes(
    input logic [`PTEXT_INPUT_LEN-1:0] plaintext,
    input clk,
    input logic [`KEY_WIDTH-1:0] master_key,
    output logic [`PTEXT_INPUT_LEN-1:0] processed_text
);

    // The preprocessed text
    logic [127:0] preprocessed_text;

    // Instantiate preprocessed module
    preprocessing preprocessed_data(
        .plaintext(plaintext),
        .clk(clk),
        .master_key(master_key),
        .processed_text(preprocessed_text)
    );

    // Declare loop variables outside the loop
    logic [3:0] row, col;
    integer i;

    always_comb begin
        for(i = 0; i < 16; i++) begin
//        $display("test");
            row = preprocessed_text[i*8 +: 4];
            col = preprocessed_text[i*8+4 +: 4];
            processed_text[i*8 +: 8] = sbox[row][col];
        end
    end

endmodule
