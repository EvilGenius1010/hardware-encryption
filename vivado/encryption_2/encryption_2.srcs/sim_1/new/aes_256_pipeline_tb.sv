`timescale 1ns / 1ps

`include "CONSTANTS.vh"

module aes_256_pipeline_tb();
    // Test signals
    logic clk;
    logic rst;
    logic [`PTEXT_INPUT_LEN-1:0] plaintext;
    logic [`KEY_WIDTH-1:0] key;
    logic valid_in;
    logic [`PTEXT_INPUT_LEN-1:0] ciphertext;
    logic valid_out;
    
    // Expected output for verification
    localparam [`PTEXT_INPUT_LEN-1:0] EXPECTED_CIPHERTEXT = 128'h8ea2b7ca516745bfeafc49904b496089;
    logic encryption_done;
    
    // Instantiate the AES module
    aes_256_pipeline dut (
        .clk(clk),
        .rst(rst),
        .plaintext(plaintext),
        .key(key),
        .valid_in(valid_in),
        .ciphertext(ciphertext),
        .valid_out(valid_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize
        rst = 1;
        valid_in = 0;
        encryption_done = 0;
        
        // NIST test vector - ensure correct byte order
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        
        // Release reset
        #20 rst = 0;
        
        // Start encryption
        #10 valid_in = 1;
        
        // Wait one cycle
        #10 valid_in = 0;
        
        // Wait for the encryption to complete - now we wait for valid_out instead of a fixed time
        while (!encryption_done) begin
            @(posedge clk);
            if (valid_out) begin
                encryption_done = 1;
                $display("Encryption complete! Ciphertext: %h", ciphertext);
                if (ciphertext == EXPECTED_CIPHERTEXT)
                    $display("SUCCESS! Ciphertext matches expected value.");
                else
                    $display("ERROR! Expected: %h, Got: %h", EXPECTED_CIPHERTEXT, ciphertext);
            end
        end
        
        // Wait a bit more
        #50;
        
        // End simulation
        $finish;
    end
    logic [3:0] packed_valid_pipe;
    logic reduced_valid_pipe;
    // Monitor pipeline stages
    initial begin
    $display("Pipeline stages monitoring:");
    forever @(posedge clk) begin
        // Explicitly cast the streaming concatenation result to a packed vector
        packed_valid_pipe = logic'({<< {dut.valid_pipe}}); // Cast to packed vector
        reduced_valid_pipe = |packed_valid_pipe; // Reduction OR

        if (valid_in || reduced_valid_pipe || valid_out)
            $display("Time: %t, valid_in: %b, valid_pipes: %p, valid_out: %b", 
                     $time, dut.valid_in, dut.valid_pipe, dut.valid_out);
    end
end
endmodule