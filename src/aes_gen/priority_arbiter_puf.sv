module priority_arbiter_puf #(
    parameter int STAGES = 64,       // Number of challenge stages
    parameter int RESPONSE_BITS = 128 // Number of response bits
)(
    input  logic                    clk,
    input  logic                    reset_n,
    input  logic [STAGES-1:0]       challenge,
    output logic [RESPONSE_BITS-1:0] response,
    output logic                    response_valid
);

    // Internal signals
    typedef enum logic [1:0] {
        IDLE,
        GENERATE,
        COMPLETE
    } puf_state_t;
    
    puf_state_t state, next_state;
    logic [7:0] bit_counter;
    logic [STAGES:0] top_path, center_path, bottom_path;
    logic priority_out;
    logic [RESPONSE_BITS-1:0] response_reg;
    
    
    // PUF stage module instantiation
    genvar i;
    generate
        for (i = 0; i < STAGES; i++) begin : puf_stage
            // Switch block implementation - controlled by challenge bit
            always_comb begin
                if (challenge[i]) begin
                    // Crossed configuration
                    top_path[i+1] = center_path[i];
                    center_path[i+1] = bottom_path[i];
                    bottom_path[i+1] = top_path[i];
                end else begin
                    // Straight configuration
                    top_path[i+1] = top_path[i];
                    center_path[i+1] = center_path[i];
                    bottom_path[i+1] = bottom_path[i];
                end
            end
        end
    endgenerate
    
    // Priority arbiter implementation
    always_comb begin
        // Determine signal arrival order and generate response
        if (top_path[STAGES] && !center_path[STAGES] && !bottom_path[STAGES])
            priority_out = 1'b1; // T arrives first
        else if (center_path[STAGES] && !bottom_path[STAGES])
            priority_out = 1'b0; // C arrives before B
        else if (bottom_path[STAGES])
            priority_out = 1'b1; // B arrives first
        else
            priority_out = 1'b0; // Default case
    end
    
    // State machine for response generation
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            bit_counter <= 8'h0;
            response_reg <= '0;
            response_valid <= 1'b0;
            $display("PUF RESET");
        end else begin
            state <= next_state;
            $display("PUF State: %0d", state);
            case (state)
                GENERATE: begin
                    if (bit_counter < RESPONSE_BITS) begin
                        // Capture PUF response bit
                        response_reg[bit_counter] <= priority_out;
                        bit_counter <= bit_counter + 1'b1;
                    end
                end
                
                COMPLETE: begin
                    response <= response_reg;
                    response_valid <= 1'b1;
                end
                
                default: begin
                    bit_counter <= 8'h0;
                    response_valid <= 1'b0;
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: 
                next_state = GENERATE;
                
            GENERATE: 
                if (bit_counter >= RESPONSE_BITS-1)
                    next_state = COMPLETE;
                    
            COMPLETE:
                next_state = IDLE;
                
            default:
                next_state = IDLE;
        endcase
    end
    
    // Initialize paths at the start
    always_comb begin
        if (state == GENERATE) begin
            top_path[0] = 1'b1;
            center_path[0] = 1'b1;
            bottom_path[0] = 1'b1;
        end else begin
            top_path[0] = 1'b0;
            center_path[0] = 1'b0;
            bottom_path[0] = 1'b0;
        end
    end

endmodule
