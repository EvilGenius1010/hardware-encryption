`timescale 1ns / 1ps

module tb_aes_key_generator();

    // TestBench signals
    logic clk;
    logic reset_n;
    logic generate_key;
    logic [255:0] aes_key;
    logic key_valid;
    
    // Test statistics
    int successful_keys;
    int failed_keys;
    real entropy_estimate;
    int ones_count;
    real ratio;
    // Instantiate DUT
    aes_key_generator #(
        .PUF_STAGES(64),
        .KEY_BITS(256)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .generate_key(generate_key),
        .aes_key(aes_key),
        .key_valid(key_valid)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset_n = 0;
        generate_key = 0;
        successful_keys = 0;
        failed_keys = 0;
        entropy_estimate = 0.0;
        
        // Reset
        #100;
        reset_n = 1;
        #100;
        
        // Run 10 key generation cycles
        for (int i = 0; i < 10; i++) begin
            // Request key generation
            generate_key = 1;
            
            // Wait for key validity
            wait(key_valid);
            #10;
            
            // Verify key is not all zeros or all ones
            if (aes_key != 256'h0 && aes_key != {256{1'b1}}) begin
                $display("Key %0d generated successfully: %h", i, aes_key);
                successful_keys++;
                
                // Estimate entropy (simplified)
                ones_count = $countones(aes_key);
                ratio = real'(ones_count) / 256.0;
                entropy_estimate += (ratio > 0.5) ? (1.0 - ratio) : ratio;
            end else begin
                $display("Key %0d generation failed: %h", i, aes_key);
                failed_keys++;
            end
            
            // Clear request and wait a bit
            generate_key = 0;
            #1000;
        end
        
        // Report results
        $display("Test Results:");
        $display("  Successful keys: %0d", successful_keys);
        $display("  Failed keys: %0d", failed_keys);
        $display("  Entropy estimate: %f", entropy_estimate/10.0);
        
        // End simulation
        #100;
        $finish;
    end
    
    // Monitor functionality
    initial begin
        $monitor("Time: %t, Reset: %b, Generate: %b, Valid: %b", 
                 $time, reset_n, generate_key, key_valid);
    end
    
    // Assertions
    // Check that key is generated within reasonable time
    property key_gen_timeout;
        @(posedge clk) 
        generate_key |-> ##[1:10000] key_valid;
    endproperty
    
    assert property (key_gen_timeout)
    else $error("Key generation timed out");
    
    // Key should stay valid until generate_key is deasserted
    property key_valid_stable;
        @(posedge clk)
        (key_valid && generate_key) |=> key_valid;
    endproperty
    
    assert property (key_valid_stable)
    else $error("Key validity unstable");

endmodule
