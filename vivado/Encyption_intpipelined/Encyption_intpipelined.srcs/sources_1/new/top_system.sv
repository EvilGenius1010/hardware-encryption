`timescale 1ns / 1ps

`include "CONSTANTS.vh"

module top_system (
    input  logic clk,        // FPGA clock
    input  logic rst_n,      // Active low reset
    // UART interface
    input  logic uart_rx,    // UART receive line from laptop
    output logic uart_tx     // UART transmit line to laptop
);

    // Parameters
    localparam CLKS_PER_BIT = 434;  // For 115200 baud rate with 50 MHz clock
    
    // State machine states
    typedef enum logic [3:0] {
        IDLE,
        RECEIVE_COMMAND,
        RECEIVE_PLAINTEXT,
        RECEIVE_KEY,
        START_ENCRYPTION,
        WAIT_ENCRYPTION,
        SEND_CIPHERTEXT,
        COMPLETE
    } state_t;
    
    state_t state;
    
    // UART signals
    logic [7:0] uart_rx_data;
    logic       uart_rx_done;
    logic [7:0] uart_tx_data;
    logic       uart_tx_start;
    logic       uart_tx_done;
    
    // AES signals
    logic aes_start;
    logic aes_done;
    logic [`PTEXT_INPUT_LEN-1:0] plaintext;
    logic [`KEY_WIDTH-1:0] key;
    logic [`PTEXT_INPUT_LEN-1:0] ciphertext;  // Connected to AES core output
    logic [`PTEXT_INPUT_LEN-1:0] ciphertext_buffer;  // Added buffer for UART transmission
    // Byte counters and buffers
    logic [5:0] rx_byte_count;
    logic [5:0] tx_byte_count;
    logic [7:0] command;
    
    // UART module instance
    uart #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(uart_rx),
        .tx(uart_tx),
        .tx_data(uart_tx_data),
        .tx_start(uart_tx_start),
        .tx_done(uart_tx_done),
        .rx_data(uart_rx_data),
        .rx_done(uart_rx_done)
    );
    
    // AES-256 instance
//    aes_256_top aes_core (
//        .clk(clk),
//        .rst_n(rst_n),
//        .start(aes_start),
//        .plaintext_in(plaintext),
//        .key_in(key),
//        .done(aes_done),
//        .ciphertext_out(ciphertext)
//    );
    
    
    //AES-256 pipelone
    aes_256_pipeline aes_core (
        .clk(clk),
        .rst(rst),
        .plaintext(plaintext_reg),
        .key(key_reg),
        .valid_in(valid_in),
        .ciphertext(ciphertext),
        .valid_out(valid_out)
    );
    
    // Main state machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            rx_byte_count <= 0;
            tx_byte_count <= 0;
            plaintext <= '0;
            key <= '0;
            aes_start <= 0;
            uart_tx_start <= 0;
            uart_tx_data <= 0;
            command <= 0;
            ciphertext_buffer <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    rx_byte_count <= 0;
                    tx_byte_count <= 0;
                    aes_start <= 0;
                    uart_tx_start <= 0;
                    
                    // Wait for start command (0xAA)
                    if (uart_rx_done && uart_rx_data == 8'hAA) begin
                        state <= RECEIVE_COMMAND;
                    end
                end
                
                RECEIVE_COMMAND: begin
                    // Wait for command byte (e.g., 0x01 for encrypt)
                    if (uart_rx_done) begin
                        command <= uart_rx_data;
                        // If command is encrypt (0x01), proceed to receive plaintext
                        if (uart_rx_data == 8'h01) begin
                            state <= RECEIVE_PLAINTEXT;
                            rx_byte_count <= 0;
                        end else begin
                            // Unrecognized command, return to idle
                            state <= IDLE;
                        end
                    end
                end
                
                RECEIVE_PLAINTEXT: begin
                    if (uart_rx_done) begin
                        // Store each received byte in plaintext (MSB first)
                        plaintext <= {plaintext[`PTEXT_INPUT_LEN-9:0], uart_rx_data};
                        rx_byte_count <= rx_byte_count + 1;
                        
                        // After receiving all plaintext bytes, move to receiving key
                        if (rx_byte_count == (`PTEXT_INPUT_LEN/8) - 1) begin
                            state <= RECEIVE_KEY;
                            rx_byte_count <= 0;
                        end
                    end
                end
                
                RECEIVE_KEY: begin
                    if (uart_rx_done) begin
                        // Store each received byte in key (MSB first)
                        key <= {key[`KEY_WIDTH-9:0], uart_rx_data};
                        rx_byte_count <= rx_byte_count + 1;
                        
                        // After receiving all key bytes, start encryption
                        if (rx_byte_count == (`KEY_WIDTH/8) - 1) begin
                            state <= START_ENCRYPTION;
                        end
                    end
                end
                
                START_ENCRYPTION: begin
                    // Start AES encryption
                    aes_start <= 1;
                    state <= WAIT_ENCRYPTION;
                end
                
                WAIT_ENCRYPTION: begin
                    aes_start <= 0;
                    if (aes_done) begin
                        // Copy AES output to buffer
                        ciphertext_buffer <= ciphertext;
                        state <= SEND_CIPHERTEXT;
                    end
                end
                
               SEND_CIPHERTEXT: begin
                    if (!uart_tx_start || uart_tx_done) begin
                        // Use the buffer for UART transmission
                        uart_tx_data <= ciphertext_buffer[`PTEXT_INPUT_LEN-1:`PTEXT_INPUT_LEN-8];
                        
                        // Shift the buffer, not the original ciphertext
                        ciphertext_buffer <= {ciphertext_buffer[`PTEXT_INPUT_LEN-9:0], 8'h00};
                                 
                        // Start UART transmission
                        uart_tx_start <= 1;
                        tx_byte_count <= tx_byte_count + 1;
                        
                        // Check if all bytes are sent
                        if (tx_byte_count == `PTEXT_INPUT_LEN/8) begin
                            state <= COMPLETE;
                        end
                    end
                    else begin
                        // Clear start signal after transmission begins
                        uart_tx_start <= 0;
                    end
                end
                
                COMPLETE: begin
                    // Transmission complete, return to idle
                    uart_tx_start <= 0;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule

