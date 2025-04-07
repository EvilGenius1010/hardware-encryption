`timescale 1ns / 1ps
`include "CONSTANTS.vh"

module tb_inv_shiftrows;

    // Parameter for ROUND_KEYS_LEN
    parameter ROUND_KEYS_LEN = `ROUND_KEYS_LEN;

    // Inputs
    logic [ROUND_KEYS_LEN-1:0] fourteenth_rnd_key;
    logic [ROUND_KEYS_LEN-1:0] ciphertext;

    // Output
    logic [ROUND_KEYS_LEN-1:0] inv_shifted_rows;

    // Instantiate the module
    inv_shiftrows uut (
        .fourteenth_rnd_key(fourteenth_rnd_key),
        .ciphertext(ciphertext),
        .inv_shifted_rows(inv_shifted_rows)
    );

    // Task to print the output for clarity
    task print_bytes(string label, logic [ROUND_KEYS_LEN-1:0] data);
        $write("%s: ", label);
        for (int i = ROUND_KEYS_LEN/8 - 1; i >= 0; i--) begin
            $write("%02x ", data[i*8 +: 8]);
        end
        $display("");
    endtask

    // Initial block for stimulus
    initial begin
        $display("Starting inv_shiftrows Testbench...");

        // Test Case 1
        fourteenth_rnd_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        ciphertext = 128'h3243f6a8885a308d313198a2e0370734;

        #10; // Wait for combinational logic to settle

        print_bytes("Input  (Ciphertext)", ciphertext);
        print_bytes("Key    (14th Round)", fourteenth_rnd_key);
        print_bytes("Output (Shifted Rows)", inv_shifted_rows);

        // Test Case 2 - Edge case with all zeros
        fourteenth_rnd_key = 128'h00000000000000000000000000000000;
        ciphertext = 128'h00000000000000000000000000000000;

        #10;

        print_bytes("Input  (Ciphertext)", ciphertext);
        print_bytes("Key    (14th Round)", fourteenth_rnd_key);
        print_bytes("Output (Shifted Rows)", inv_shifted_rows);

        // Test Case 3 - Random values
        fourteenth_rnd_key = 128'h5b7d8a3c1d2e9f4b0a8b1c3d5e7f9a4;
        ciphertext = 128'h9a0f8e2d7b3c6a1d4e5f9b3c7d1e2f9;

        #10;

        print_bytes("Input  (Ciphertext)", ciphertext);
        print_bytes("Key    (14th Round)", fourteenth_rnd_key);
        print_bytes("Output (Shifted Rows)", inv_shifted_rows);

        $display("Testbench complete.");
        $finish;
    end

endmodule
