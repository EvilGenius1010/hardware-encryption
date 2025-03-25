`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2025 18:21:01
// Design Name: 
// Module Name: tb_mixcolumns
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

`include "CONSTANTS.vh"
//`include "RCONSTANTS.vh"

module tb_mixcolumns;

    logic [7:0] shiftedrows[15:0];
    logic [`WORDS_LEN:0] words[3:0];
    logic [7:0] mixedcolumns[15:0];

    mixcolumns uut(
        .shiftedrows(shiftedrows),
        .words(words),
        .mixedcolumns(mixedcolumns)
    );

    initial begin
        // Initialize inputs
        for (int i = 0; i < 16; i++) begin
            shiftedrows[i] = 8'h00;
        end
        for (int i = 0; i < 4; i++) begin
            words[i] = {`WORDS_LEN{1'b0}};
        end

//        // Test case 1: All zeros
//        #10;
//        $display("Test case 1: All zeros");
//        for (int i = 0; i < 16; i++) begin
//            $display("mixedcolumns[%d] = %h", i, mixedcolumns[i]);
//        end

        // Test case 2: Non-zero values
        for (int i = 0; i < 16; i++) begin
            shiftedrows[i] = 8'h10;
        end
        for (int i = 0; i < 4; i++) begin
            words[i] = {`WORDS_LEN{1'b1}};
        end
        #10;
        $display("Test case 2: Non-zero values");
        for (int i = 0; i < 16; i++) begin
            $display("mixedcolumns[%d] = %h", i, mixedcolumns[i]);
        end

//        // Test case 3: Random values
//        for (int i = 0; i < 16; i++) begin
//            shiftedrows[i] = random_range(0, 255);
//        end
//        for (int i = 0; i < 4; i++) begin
//            words[i] = {`WORDS_LEN{1'b0}};
//            for (int j = 0; j <= `WORDS_LEN; j++) begin
//                words[i][j] = $random_range(0, 1);
//            end
//        end
//        #10;
//        $display("Test case 3: Random values");
//        for (int i = 0; i < 16; i++) begin
//            $display("mixedcolumns[%d] = %h", i, mixedcolumns[i]);
//        end

        // Finish the simulation
        #10;
        $finish;
    end

endmodule
