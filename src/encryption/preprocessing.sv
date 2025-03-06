


module preprocessing(
input logic [127:0] plaintext,
output [127:0] processed_text,
input clk,
input logic[127:0] master_key 
);

  logic [31:0] first_four_words [0:3]; //select first 4 words

    // Instantiate cache memory
    cache_memory cache_inst (
        .clk(clk),
        .addr(6'd0),  // We're only reading, so keep address at 0
        .data_in(32'd0),  // We're only reading, so no input data
        .write_en(1'b0),  // We're only reading, so no writing
        .data_out(first_four_words[0])
    );

    // Read next 3 words
    always_ff @(posedge clk) begin
        first_four_words[1] <= cache_inst.cache[1];
        first_four_words[2] <= cache_inst.cache[2];
        first_four_words[3] <= cache_inst.cache[3];
    end

    logic[127:0] initial_key;
    
    
//first 4 words are the initial 
    assign initial_key = first_four_words[0]+first_four_words[1]+first_four_words[2]+first_four_words[3];


    assign processed_text = initial_key ^ initial_key;
    

