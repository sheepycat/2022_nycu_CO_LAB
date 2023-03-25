//109550134
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

//Main function
always@(*)begin
    case(instr_op_i)
        'b000000:begin//R -format
            ALU_op_o <= 'b000;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b1;
            Branch_o <= 'b0;
        end
        'b001000:begin//addi
            ALU_op_o <= 'b100;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b0;
            Branch_o <= 'b0;
        end
        'b001010:begin//slti
            ALU_op_o <= 'b101;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b0;
            Branch_o <= 'b0;
        end
        'b000100:begin//beq
            ALU_op_o <= 'b010;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b0;
            RegDst_o <= 'b0;
            Branch_o <= 'b1;
        end
        
    endcase
end
endmodule





                    
                    