`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2025 23:00:39
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
    
    // Instantiate the module under test
    calculate_round_keys uut();
    
    // Testbench signals
    reg clk;
    integer i;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test procedure
    initial begin
        // Display the initial message
        $display("Starting Round Key Generation Test");
        
        // Wait for a few clock cycles to let the module generate round keys
        #20;
        
        // Check if the round keys are generated correctly
        for (i = 0; i < `ROUND_KEYS_GEN; i = i + 1) begin
            $display("Round Key %0d: %h", i, uut.round_keys[i]);
        end
        
        // End simulation
        $stop;
    end
    
endmodule
