`include "CONSTANTS.vh"

module aes_256_top (
    input  logic clk,              // FPGA clock
    input  logic rst_n,            // Active low reset
    input  logic start,            // Start signal
    input  logic [`PTEXT_INPUT_LEN-1:0] plaintext_in,  // Input plaintext
    input  logic [`KEY_WIDTH-1:0] key_in,              // Input key
    output logic done,             // Done signal
    output logic [`PTEXT_INPUT_LEN-1:0] ciphertext_out // Output ciphertext
);

    // Internal signals
    logic rst;
    logic valid_in;
    logic valid_out;
    logic [`PTEXT_INPUT_LEN-1:0] plaintext_reg;
    logic [`KEY_WIDTH-1:0] key_reg;
    logic [`PTEXT_INPUT_LEN-1:0] ciphertext;
    
    // Invert reset signal (FPGA reset is typically active low)
    assign rst = ~rst_n;
    
    // Register inputs when start signal is received
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            plaintext_reg <= '0;
            key_reg <= '0;
            valid_in <= 1'b0;
        end
        else begin
            valid_in <= start;
            if (start) begin
                plaintext_reg <= plaintext_in;
                key_reg <= key_in;
            end
        end
    end
    
    // Instantiate the AES core
    aes_256_pipeline aes_core (
        .clk(clk),
        .rst(rst),
        .plaintext(plaintext_reg),
        .key(key_reg),
        .valid_in(valid_in),
        .ciphertext(ciphertext),
        .valid_out(valid_out)
    );
    
    // Register outputs
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext_out <= '0;
            done <= 1'b0;
        end
        else begin
            done <= valid_out;
            if (valid_out) begin
                ciphertext_out <= ciphertext;
            end
        end
    end

endmodule