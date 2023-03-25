`timescale 1ns / 1ps
//109550134
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/02 19:43:59
// Design Name: 
// Module Name: half_adder
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


module half_adder(
    In_A, In_B, Sum, Cout
    );
    input In_A, In_B;
    output Sum, Cout;

    xor(Sum,In_A,In_B);
    and(Cout,In_A ,In_B );

endmodule

