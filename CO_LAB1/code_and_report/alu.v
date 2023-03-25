`timescale 1ns/1ps
//109550134
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire    set;
wire    [32-1:0] cin_store;
wire    [32-1:0] result_store;
wire             overflow_store;
wire             cin1;

assign cin1 = ((ALU_control=='b0111)||(ALU_control == 'b0110))? 'b1:'b0 ;

alu_top A0 (src1[0], src2[0], set , ALU_control[3], ALU_control[2], cin1, ALU_control[1:0], result_store[0], cin_store[0]);
alu_top A1 (src1[1], src2[1], 'b0 , ALU_control[3], ALU_control[2], cin_store[0], ALU_control[1:0], result_store[1], cin_store[1]);
alu_top A2 (src1[2], src2[2], 'b0 , ALU_control[3], ALU_control[2], cin_store[1], ALU_control[1:0], result_store[2], cin_store[2]);
alu_top A3 (src1[3], src2[3], 'b0 , ALU_control[3], ALU_control[2], cin_store[2], ALU_control[1:0], result_store[3], cin_store[3]);
alu_top A4 (src1[4], src2[4], 'b0 , ALU_control[3], ALU_control[2], cin_store[3], ALU_control[1:0], result_store[4], cin_store[4]);

alu_top A5 (src1[5], src2[5], 'b0 , ALU_control[3], ALU_control[2], cin_store[4], ALU_control[1:0], result_store[5], cin_store[5]);
alu_top A6 (src1[6], src2[6], 'b0 , ALU_control[3], ALU_control[2], cin_store[5], ALU_control[1:0], result_store[6], cin_store[6]);
alu_top A7 (src1[7], src2[7], 'b0 , ALU_control[3], ALU_control[2], cin_store[6], ALU_control[1:0], result_store[7], cin_store[7]);
alu_top A8 (src1[8], src2[8], 'b0 , ALU_control[3], ALU_control[2], cin_store[7], ALU_control[1:0], result_store[8], cin_store[8]);
alu_top A9 (src1[9], src2[9], 'b0 , ALU_control[3], ALU_control[2], cin_store[8], ALU_control[1:0], result_store[9], cin_store[9]);

alu_top A10 (src1[10], src2[10], 'b0 , ALU_control[3], ALU_control[2], cin_store[9], ALU_control[1:0], result_store[10], cin_store[10]);
alu_top A11 (src1[11], src2[11], 'b0 , ALU_control[3], ALU_control[2], cin_store[10], ALU_control[1:0], result_store[11], cin_store[11]);
alu_top A12 (src1[12], src2[12], 'b0 , ALU_control[3], ALU_control[2], cin_store[11], ALU_control[1:0], result_store[12], cin_store[12]);
alu_top A13 (src1[13], src2[13], 'b0 , ALU_control[3], ALU_control[2], cin_store[12], ALU_control[1:0], result_store[13], cin_store[13]);
alu_top A14 (src1[14], src2[14], 'b0 , ALU_control[3], ALU_control[2], cin_store[13], ALU_control[1:0], result_store[14], cin_store[14]);

alu_top A15 (src1[15], src2[15], 'b0 , ALU_control[3], ALU_control[2], cin_store[14], ALU_control[1:0], result_store[15], cin_store[15]);
alu_top A16 (src1[16], src2[16], 'b0 , ALU_control[3], ALU_control[2], cin_store[15], ALU_control[1:0], result_store[16], cin_store[16]);
alu_top A17 (src1[17], src2[17], 'b0 , ALU_control[3], ALU_control[2], cin_store[16], ALU_control[1:0], result_store[17], cin_store[17]);
alu_top A18 (src1[18], src2[18], 'b0 , ALU_control[3], ALU_control[2], cin_store[17], ALU_control[1:0], result_store[18], cin_store[18]);
alu_top A19 (src1[19], src2[19], 'b0 , ALU_control[3], ALU_control[2], cin_store[18], ALU_control[1:0], result_store[19], cin_store[19]);

alu_top A20 (src1[20], src2[20], 'b0 , ALU_control[3], ALU_control[2], cin_store[19], ALU_control[1:0], result_store[20], cin_store[20]);
alu_top A21 (src1[21], src2[21], 'b0 , ALU_control[3], ALU_control[2], cin_store[20], ALU_control[1:0], result_store[21], cin_store[21]);
alu_top A22 (src1[22], src2[22], 'b0 , ALU_control[3], ALU_control[2], cin_store[21], ALU_control[1:0], result_store[22], cin_store[22]);
alu_top A23 (src1[23], src2[23], 'b0 , ALU_control[3], ALU_control[2], cin_store[22], ALU_control[1:0], result_store[23], cin_store[23]);
alu_top A24 (src1[24], src2[24], 'b0 , ALU_control[3], ALU_control[2], cin_store[23], ALU_control[1:0], result_store[24], cin_store[24]);

alu_top A25 (src1[25], src2[25], 'b0 , ALU_control[3], ALU_control[2], cin_store[24], ALU_control[1:0], result_store[25], cin_store[25]);
alu_top A26 (src1[26], src2[26], 'b0 , ALU_control[3], ALU_control[2], cin_store[25], ALU_control[1:0], result_store[26], cin_store[26]);
alu_top A27 (src1[27], src2[27], 'b0 , ALU_control[3], ALU_control[2], cin_store[26], ALU_control[1:0], result_store[27], cin_store[27]);
alu_top A28 (src1[28], src2[28], 'b0 , ALU_control[3], ALU_control[2], cin_store[27], ALU_control[1:0], result_store[28], cin_store[28]);
alu_top A29 (src1[29], src2[29], 'b0 , ALU_control[3], ALU_control[2], cin_store[28], ALU_control[1:0], result_store[29], cin_store[29]);

alu_top A30 (src1[30], src2[30], 'b0 , ALU_control[3], ALU_control[2], cin_store[29], ALU_control[1:0], result_store[30], cin_store[30]);
alu_btm A31(src1[31], src2[31], 'b0, ALU_control[3], ALU_control[2], cin_store[30], ALU_control[1:0], result_store[31], cin_store[31], overflow_store, set);
always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
        result <= 0;
        overflow <= 0;
        zero <= 0;
        cout <= 0;
	end
	else begin
        result <= result_store;
        overflow <= overflow_store;
        zero <= (result_store==32'b0)? 'b1:'b0;
        cout <= ((ALU_control=='b0010)||(ALU_control == 'b0110))?  cin_store[31] :'b0;
	end
end

endmodule
