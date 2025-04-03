`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2025 19:03:34
// Design Name: 
// Module Name: tb_shiftrows
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

module tb_shiftrows;

    // Define input and output signals
    logic [7:0] subbytesop[15:0];   // Input array
    logic [7:0] shiftedrows[15:0];  // Output array

    // Instantiate the shiftrows module
    shiftrows uut (
        .subbytesop(subbytesop),
        .shiftedrows(shiftedrows)
    );

    initial begin
        // Apply test input
        subbytesop[0]  = 8'h00; subbytesop[1]  = 8'h01; subbytesop[2]  = 8'h02; subbytesop[3]  = 8'h03;
        subbytesop[4]  = 8'h10; subbytesop[5]  = 8'h11; subbytesop[6]  = 8'h12; subbytesop[7]  = 8'h13;
        subbytesop[8]  = 8'h20; subbytesop[9]  = 8'h21; subbytesop[10] = 8'h22; subbytesop[11] = 8'h23;
        subbytesop[12] = 8'h30; subbytesop[13] = 8'h31; subbytesop[14] = 8'h32; subbytesop[15] = 8'h33;
        
        // Wait for combinational logic to update
        #10;

        // Display input matrix
        $display("Input Matrix (After SubBytes):");
        for (int i = 0; i < 4; i++) begin
            $display("%h  %h  %h  %h", subbytesop[i*4], subbytesop[i*4+1], subbytesop[i*4+2], subbytesop[i*4+3]);
        end

        // Display output matrix (After ShiftRows)
        $display("\nOutput Matrix (After ShiftRows):");
        for (int i = 0; i < 4; i++) begin
            $display("%h  %h  %h  %h", shiftedrows[i*4], shiftedrows[i*4+1], shiftedrows[i*4+2], shiftedrows[i*4+3]);
        end

        // End simulation
        #10;
        $finish;
    end

endmodule