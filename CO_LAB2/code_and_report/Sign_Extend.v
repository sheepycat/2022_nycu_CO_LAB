//109550134
//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
reg     msb;

//Sign extended
always@(*)begin
    msb <= data_i[15];
    data_o <= { msb,msb,msb,msb,msb, msb,msb,msb,msb,msb,
                msb,msb,msb,msb,msb, msb,data_i};
end
endmodule      
     