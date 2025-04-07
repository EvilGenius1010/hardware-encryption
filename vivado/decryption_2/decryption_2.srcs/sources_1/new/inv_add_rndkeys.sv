`timescale 1ns / 1ps


//note that only one roundkey is passed and which one will be passed depends on the round
//rounds start from 0 but rndkeys start from 15 ie first round will have 15th round key 

`include "CONSTANTS.vh";

module inv_add_rndkeys(
input logic[`ROUND_KEYS_LEN-1:0] inv_subbytes,
output logic[`ROUND_KEYS_LEN-1:0] inv_rndkeys,
input logic[`ROUND_KEYS_LEN-1:0] rndkey
);

assign inv_rndkeys = rndkey ^ inv_subbytes;

endmodule