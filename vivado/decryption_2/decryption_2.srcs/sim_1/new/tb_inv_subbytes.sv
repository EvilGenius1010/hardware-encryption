`timescale 1ns / 1ps
`include "CONSTANTS.vh"
import inv_sbox_pkg::*;

module inv_subbytes_tb;

    parameter ROUND_KEYS_LEN = `ROUND_KEYS_LEN;

    // Inputs and outputs
    logic [ROUND_KEYS_LEN-1:0] inv_shiftedrows;
    logic [ROUND_KEYS_LEN-1:0] inv_subbytes;

    // Instantiate the module
    inv_subbytes uut (
        .inv_shiftedrows(inv_shiftedrows),
        .inv_subbytes(inv_subbytes)
    );

    // Convert flat 128-bit vector to 16 individual bytes for clarity
    function void print_bytes(string label, logic [127:0] data);
        $write("%s: ", label);
        for (int i = 15; i >= 0; i--)
            $write("%02x ", data[i*8 +: 8]);
        $display("");
    endfunction

    initial begin
        $display("Starting inv_subbytes testbench...");

        // Test Vector
        inv_shiftedrows = 128'h7a89f22b13cd7f532e4d3f8d8a1f5f8b;

        #10; // Allow time for always_comb

        print_bytes("Input  (inv_shiftedrows)", inv_shiftedrows);
        print_bytes("Output (inv_subbytes)   ", inv_subbytes);

        // Optional: Check specific values
        for (integer i = 0; i < 16; i++) begin
            logic [7:0] byte1 = inv_shiftedrows[i*8 +: 8];
            logic [3:0] row = byte1[7:4];
            logic [3:0] col = byte1[3:0];
            logic [7:0] expected = inv_sbox[row][col];

            if (inv_subbytes[i*8 +: 8] !== expected) begin
                $display("Byte %0d mismatch: expected %02x, got %02x", i, expected, inv_subbytes[i*8 +: 8]);
            end
        end

        $display("Test complete.");
        $finish;
    end

endmodule