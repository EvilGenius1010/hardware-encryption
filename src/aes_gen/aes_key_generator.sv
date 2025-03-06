module aes_key_generator #(
    parameter int PUF_STAGES = 64,
    parameter int KEY_BITS = 256  // AES-256 key size
)(
    input  logic        clk,
    input  logic        reset_n,
    input  logic        generate_key,
    output logic [KEY_BITS-1:0] aes_key,
    output logic        key_valid
);

    // Internal signals
    logic trng_enable;
    logic [KEY_BITS-1:0] random_number;
    logic trng_valid;
    
    // Main AES key generation control
    typedef enum logic [1:0] {
        IDLE,
        GENERATE,
        READY
    } keygen_state_t;
    
    keygen_state_t state, next_state;
    
    // TRNG module for key generation
    trng #(
        .PUF_STAGES(PUF_STAGES),
        .TRNG_BITS(KEY_BITS)
    ) trng_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(trng_enable),
        .random_number(random_number),
        .trng_valid(trng_valid)
    );
    
    // Key generation state machine
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            aes_key <= '0;
            key_valid <= 1'b0;
            trng_enable <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                GENERATE: begin
                    trng_enable <= 1'b1;
                    if (trng_valid) begin
                        aes_key <= random_number;
                        key_valid <= 1'b1;
                    end
                end
                
                READY: begin
                    trng_enable <= 1'b0;
                end
                
                default: begin
                    aes_key <= '0;
                    key_valid <= 1'b0;
                    trng_enable <= 1'b0;
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: 
                if (generate_key)
                    next_state = GENERATE;
                    
            GENERATE: 
                if (trng_valid)
                    next_state = READY;
                    
            READY:
                if (!generate_key)
                    next_state = IDLE;
                
            default:
                next_state = IDLE;
        endcase
    end
    
    // Health checks and statistical monitors could be added here
    // For NIST compliance

endmodule
    