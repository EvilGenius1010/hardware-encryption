module shiftrows(
    input logic [7:0] subbytesop[15:0],
    output logic [7:0] shiftedrows[15:0]    
);
    
    always_comb begin
        // Row 0: No shift
        shiftedrows[0] = subbytesop[0];
        shiftedrows[1] = subbytesop[1];
        shiftedrows[2] = subbytesop[2];
        shiftedrows[3] = subbytesop[3];
        
        // Row 1: Shift left by 1
        shiftedrows[4] = subbytesop[7];
        shiftedrows[5] = subbytesop[4];
        shiftedrows[6] = subbytesop[5];
        shiftedrows[7] = subbytesop[6];
        
        // Row 2: Shift left by 2
        shiftedrows[8] = subbytesop[10];
        shiftedrows[9] = subbytesop[11];
        shiftedrows[10] = subbytesop[8];
        shiftedrows[11] = subbytesop[9];
        
        // Row 3: Shift left by 3
        shiftedrows[12] = subbytesop[13];
        shiftedrows[13] = subbytesop[14];
        shiftedrows[14] = subbytesop[15];
        shiftedrows[15] = subbytesop[12];
    end
    
endmodule
