`timescale 1ns / 1ps

`include "CONSTANTS.vh"
import sbox_pkg::*;
import rcon_pkg::*;

module aes_256_pipeline (
    input  logic clk,
    input  logic rst,
    input  logic [`PTEXT_INPUT_LEN-1:0] plaintext,
    input  logic [`KEY_WIDTH-1:0] key,
    input  logic valid_in,
    output logic [`PTEXT_INPUT_LEN-1:0] ciphertext,
    output logic valid_out
);
    // Define constants
    localparam ROUNDS = 14;
    
    // State storage for each pipeline stage
    logic [`PTEXT_INPUT_LEN-1:0] state_pipe [ROUNDS:0];
    logic valid_pipe [ROUNDS:0];
    
    // Round keys storage
    logic [`ROUND_KEYS_LEN-1:0] round_keys [`ROUND_KEYS_GEN-1:0];
    
    // Generate all round keys
    calculate_round_keys round_key_gen (
        .key256(key),
        .round_keys(round_keys)
    );
    
    // Helper functions for state manipulation
    function automatic [7:0] get_byte(input [`PTEXT_INPUT_LEN-1:0] state, int row, int col);
        return state[127-((col*4+row)*8) -: 8];
    endfunction
    
    function automatic [`PTEXT_INPUT_LEN-1:0] set_byte(
        input [`PTEXT_INPUT_LEN-1:0] state, 
        int row, int col, 
        input [7:0] value
    );
        logic [`PTEXT_INPUT_LEN-1:0] result = state;
        result[127-((col*4+row)*8) -: 8] = value;
        return result;
    endfunction
    
    // Initial round (just AddRoundKey)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state_pipe[0] <= 'b0;
            valid_pipe[0] <= 1'b0;
        end
        else begin
            valid_pipe[0] <= valid_in;
            if (valid_in) begin
                // Initial AddRoundKey
                state_pipe[0] <= plaintext ^ round_keys[0];
            end
        end
    end
    
    // Generate pipeline stages for each round
    genvar r;
    generate
        for (r = 1; r <= ROUNDS; r++) begin : round_pipeline
            // Intermediate transformation results
            logic [7:0] sub_bytes [0:3][0:3];
            logic [7:0] shift_rows [0:3][0:3];
            logic [7:0] mix_columns [0:3][0:3];
            logic [`PTEXT_INPUT_LEN-1:0] next_state;
            
            // SubBytes transformation
            always_comb begin
                // Process each byte in the state matrix
                for (int row = 0; row < 4; row++) begin
                    for (int col = 0; col < 4; col++) begin
                        logic [7:0] byte_val = get_byte(state_pipe[r-1], row, col);
                        sub_bytes[row][col] = sbox[byte_val[7:4]][byte_val[3:0]];
                    end
                end
            end
            
            // ShiftRows transformation 
            always_comb begin
                // Row 0: No shift
                shift_rows[0][0] = sub_bytes[0][0];
                shift_rows[0][1] = sub_bytes[0][1];
                shift_rows[0][2] = sub_bytes[0][2];
                shift_rows[0][3] = sub_bytes[0][3];
                
                // Row 1: Shift left by 1
                shift_rows[1][0] = sub_bytes[1][1];
                shift_rows[1][1] = sub_bytes[1][2];
                shift_rows[1][2] = sub_bytes[1][3];
                shift_rows[1][3] = sub_bytes[1][0];
                
                // Row 2: Shift left by 2
                shift_rows[2][0] = sub_bytes[2][2];
                shift_rows[2][1] = sub_bytes[2][3];
                shift_rows[2][2] = sub_bytes[2][0];
                shift_rows[2][3] = sub_bytes[2][1];
                
                // Row 3: Shift left by 3
                shift_rows[3][0] = sub_bytes[3][3];
                shift_rows[3][1] = sub_bytes[3][0];
                shift_rows[3][2] = sub_bytes[3][1];
                shift_rows[3][3] = sub_bytes[3][2];
            end
            
            // MixColumns (skip for final round)
            if (r < ROUNDS) begin
                always_comb begin
                    for (int col = 0; col < 4; col++) begin
                        mix_columns[0][col] = 
                            gmul(2, shift_rows[0][col]) ^ 
                            gmul(3, shift_rows[1][col]) ^ 
                            shift_rows[2][col] ^ 
                            shift_rows[3][col];
                            
                        mix_columns[1][col] = 
                            shift_rows[0][col] ^ 
                            gmul(2, shift_rows[1][col]) ^ 
                            gmul(3, shift_rows[2][col]) ^ 
                            shift_rows[3][col];
                            
                        mix_columns[2][col] = 
                            shift_rows[0][col] ^ 
                            shift_rows[1][col] ^ 
                            gmul(2, shift_rows[2][col]) ^ 
                            gmul(3, shift_rows[3][col]);
                            
                        mix_columns[3][col] = 
                            gmul(3, shift_rows[0][col]) ^ 
                            shift_rows[1][col] ^ 
                            shift_rows[2][col] ^ 
                            gmul(2, shift_rows[3][col]);
                    end
                end
            end
            
            // Construct next state
            always_comb begin
                next_state = 'b0;
                for (int row = 0; row < 4; row++) begin
                    for (int col = 0; col < 4; col++) begin
                        logic [7:0] value;
                        if (r == ROUNDS) // Final round: no MixColumns
                            value = shift_rows[row][col] ^ get_byte(round_keys[r], row, col);
                        else // Regular round: includes MixColumns
                            value = mix_columns[row][col] ^ get_byte(round_keys[r], row, col);
                            
                        next_state = set_byte(next_state, row, col, value);
                    end
                end
            end
            
            // Register next state
            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    state_pipe[r] <= 'b0;
                    valid_pipe[r] <= 1'b0;
                end
                else begin
                    valid_pipe[r] <= valid_pipe[r-1];
                    if (valid_pipe[r-1]) begin
                        state_pipe[r] <= next_state;
                    end
                end
            end
        end
    endgenerate
    
    // Output assignment
    assign ciphertext = state_pipe[ROUNDS];
    assign valid_out = valid_pipe[ROUNDS];
    
    // Galois Field multiplication
    function automatic [7:0] gmul(input [7:0] a, input [7:0] b);
        logic [7:0] p = 0;
        logic [7:0] high_bit;
        logic [7:0] temp_a = a;
        logic [7:0] temp_b = b;
        
        for (int i = 0; i < 8; i++) begin
            if ((temp_b & 8'h01) != 0) 
                p = p ^ temp_a;
                
            high_bit = temp_a & 8'h80;
            temp_a = temp_a << 1;
            if (high_bit != 0) 
                temp_a = temp_a ^ 8'h1b;
                
            temp_b = temp_b >> 1;
        end
        
        return p;
    endfunction
endmodule