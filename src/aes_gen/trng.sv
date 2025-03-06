module trng #(
    parameter int PUF_STAGES = 64,
    parameter int TRNG_BITS = 256  // AES-256 key size
)(
    input  logic        clk,
    input  logic        reset_n,
    input  logic        enable,
    output logic [TRNG_BITS-1:0] random_number,
    output logic        trng_valid
);

    // Internal signals
    logic [PUF_STAGES-1:0] challenge;
    logic [127:0] puf_response;
    logic response_valid;
    logic [TRNG_BITS-1:0] entropy_pool;
    logic [7:0] entropy_count;
    
    typedef enum logic [1:0] {
        IDLE,
        COLLECT,
        POST_PROCESS,
        COMPLETE
    } trng_state_t;
    
    trng_state_t state, next_state;
    
    // LFSR for challenge generation
    logic [63:0] lfsr;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lfsr <= 64'hFEDCBA9876543210; // Non-zero seed
        end else if (state == COLLECT || state == IDLE) begin
            // LFSR update polynomial: x^64 + x^63 + x^61 + x^60 + 1
            lfsr <= {lfsr[62:0], lfsr[63] ^ lfsr[62] ^ lfsr[60] ^ lfsr[59]};
        end
    end
    
    // Challenge generation
    assign challenge = {lfsr[31:0], lfsr[63:32]};
    
    // Instantiate PUF core
    priority_arbiter_puf #(
        .STAGES(PUF_STAGES),
        .RESPONSE_BITS(128)
    ) puf_core (
        .clk(clk),
        .reset_n(reset_n),
        .challenge(challenge),
        .response(puf_response),
        .response_valid(response_valid)
    );
    
    // TRNG state machine
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            entropy_pool <= '0;
            entropy_count <= 8'h0;
            trng_valid <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                COLLECT: begin
                    if (response_valid) begin
                        // Von Neumann debiasing - process bits pairwise (01->0, 10->1)
                        for (int i = 0; i < 64; i++) begin
                            if (puf_response[2*i] != puf_response[2*i+1] && entropy_count < TRNG_BITS) begin
                                entropy_pool[entropy_count] <= puf_response[2*i];
                                entropy_count <= entropy_count + 1'b1;
                            end
                        end
                    end
                end
                
                POST_PROCESS: begin
                    // XOR adjacent bits for additional randomness
                    for (int i = 0; i < TRNG_BITS-1; i++) begin
                        entropy_pool[i] <= entropy_pool[i] ^ entropy_pool[i+1];
                    end
                end
                
                COMPLETE: begin
                    random_number <= entropy_pool;
                    trng_valid <= 1'b1;
                end
                
                default: begin
                    trng_valid <= 1'b0;
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: 
                if (enable)
                    next_state = COLLECT;
                    
            COLLECT: 
                if (entropy_count >= TRNG_BITS) // || (entropy_count > 0 && !enable))
                    next_state = POST_PROCESS;
                    
            POST_PROCESS:
                next_state = COMPLETE;
                
            COMPLETE:
                next_state = IDLE;
                
            default:
                next_state = IDLE;
        endcase
    end

endmodule
