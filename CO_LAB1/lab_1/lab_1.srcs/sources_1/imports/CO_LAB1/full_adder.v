`timescale 1ns / 1ps
//109550134
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/02 19:43:17
// Design Name: 
// Module Name: full_adder
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


module full_adder(
In_A, In_B, Cin, Sum, Cout
    );
    input In_A, In_B, Cin;
    output Sum, Cout;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    half_adder HA (
        .In_A(In_A), 
        .In_B(In_B), 
        .Sum(temp_sum), 
        .Cout(temp_cout)
    );
    wire temp_sum, temp_cout,two_cout;
    half_adder HA2 (
        .In_A(temp_sum), 
        .In_B(Cin), 
        .Sum(Sum), 
        .Cout(two_cout)
    );
    or(Cout,two_cout,temp_cout);
endmodule
