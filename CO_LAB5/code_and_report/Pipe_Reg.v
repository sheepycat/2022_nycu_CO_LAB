`timescale 1ns / 1ps
//109550134
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_i,
    flush,
    new,
    data_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   flush,new;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else
        data_o <= (flush)? 0:(new)? data_i:data_o;
end

endmodule	