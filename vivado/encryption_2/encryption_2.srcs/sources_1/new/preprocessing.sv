`timescale 1ns / 1ps

`include "CONSTANTS.vh"


module preprocessing(
input logic [127:0] plaintext,
output [127:0] processed_text,
input clk,
input logic[`KEY_WIDTH-1:0] master_key 
);

//  logic [31:0] first_four_words [0:3]; //select first 4 words

//    // Instantiate cache memory
//    cache_memory cache_inst (
//        .clk(clk),
//        .addr(6'd0),  // We're only reading, so keep address at 0
//        .data_in(32'd0),  // We're only reading, so no input data
//        .write_en(1'b0),  // We're only reading, so no writing
//        .data_out(first_four_words[0])
//    );

// Extract the four 32-bit words directly from plaintext
//    assign first_four_words[0] = plaintext[127:96];
//    assign first_four_words[1] = plaintext[95:64];
//    assign first_four_words[2] = plaintext[63:32];
//    assign first_four_words[3] = plaintext[31:0];


//    logic[127:0] initial_key;
    
    
//first 4 words are the initial 
//    assign initial_key = first_four_words[0]+first_four_words[1]+first_four_words[2]+first_four_words[3];
 
    assign processed_text = plaintext[127:0] ^ master_key[`KEY_WIDTH-1:`KEY_WIDTH-128];

  initial
    begin
$monitor("%h is plaintext and %h is mkey", plaintext[127:0], master_key[`KEY_WIDTH-1:`KEY_WIDTH-128]);

    end

endmodule
