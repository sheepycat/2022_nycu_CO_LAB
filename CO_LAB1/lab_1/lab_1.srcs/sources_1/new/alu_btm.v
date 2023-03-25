`timescale 1ns/1ps
//109550134
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_btm(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               overflow,
               set
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;
output        overflow;
output        set;

reg           result;
reg          a,b;


wire fa_result;
full_adder FA (
        .In_A(a), 
        .In_B(b),
        .Cin(cin),
        .Sum(fa_result), 
        .Cout(cout)
    );

//B_invert || a || b|| fa_result
assign overflow = ((operation == 2'b10)||(operation == 2'b11))? (cin != cout):'b0;
assign set = fa_result;
always@(*)
begin
    a = (A_invert)? ~src1 : src1; //A inverter active? -> a value
    b = (B_invert)? ~src2 : src2; //B inverter active? -> b value
    case(operation)
        2'b00: result <= (a==1 && b==1);
        2'b01: result <= (a==1 || b==1);
        2'b10: result <= fa_result;
        2'b11: result <= less;
    endcase
end

endmodule
