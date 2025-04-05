`timescale 1ns / 1ps

module tb_roundkeygen;
    
    // Include the constants file
    `include "CONSTANTS.vh"
    
    // Wires to store outputs
    logic [`ROUND_KEYS_LEN-1:0] round_keys_tb [`ROUND_KEYS_GEN-1:0];

    logic [255:0] key256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

    // Instantiate the module under test
    calculate_round_keys uut (.round_keys(round_keys_tb),.key256(key256));

    integer i;
    
    // Test procedure
    initial begin
        // Display the initial message
        $display("Starting Round Key Generation Test");

        // Wait for the key expansion process to complete
        #200; // Ensure computation is done

        // Display the generated round keys
        for (i = 0; i < 15; i = i + 1) begin
            $display("Round Key %0d: %h", i, round_keys_tb[i]); 
        end
        
        // End simulation
        $stop;
    end
    
endmodule

