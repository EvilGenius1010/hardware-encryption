`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2025 23:19:25
// Design Name: 
// Module Name: tb_roundkeygen
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


`timescale 1ns / 1ps

module tb_roundkeygen;
    
    // Include the constants file
    `include "CONSTANTS.vh"
    
    // Wires to store outputs
    wire [`ROUND_KEYS_LEN-1:0] round_keys_tb [`ROUND_KEYS_GEN-1:0];

    // Instantiate the module under test
    calculate_round_keys uut (.round_keys(round_keys_tb));

    integer i;
    
    // Test procedure
    initial begin
        // Display the initial message
        $display("Starting Round Key Generation Test");

        // Wait for the key expansion process to complete
        #200; // Ensure computation is done

        // Display the generated round keys
        for (i = 0; i < `ROUND_KEYS_GEN; i = i + 1) begin
            $display("Round Key %0d: %h", i, round_keys_tb[i]); 
        end
        
        // End simulation
        $stop;
    end
    
endmodule

