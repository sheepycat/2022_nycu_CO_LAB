//Subject:     CO project 2 - Decoder
//109550134
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    function_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	
	Branch_o,
	MemToReg_o,
	MemRead_o,
	MemWrite,
	Branchtype_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i,function_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output  RegDst_o;//[2-1:0]
output         Branch_o;

output [2-1:0] Branchtype_o;

output  MemToReg_o;//[2-1:0]
output         MemRead_o;
output         MemWrite;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    RegDst_o;// [2-1:0]
reg            Branch_o;

reg [2-1:0] Branchtype_o;

reg  MemToReg_o;//[2-1:0]
reg         MemRead_o;
reg         MemWrite;

//Parameter


//Main function



always @* begin
    case(instr_op_i)
     'b000101: Branchtype_o <= 'b01;//bne
     'b000001: Branchtype_o <= 'b10;//bge
     'b000111: Branchtype_o <= 'b11;//bgt
     default: Branchtype_o <= 'b00;//beq&other
    endcase
    case(instr_op_i)
     'b000000:begin//R -format
        {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b000_0_1_1_0;
        { MemToReg_o ,MemRead_o, MemWrite} <= (function_i=='b001000)? 'b0_0_0 : 'b0_0_0;
  
      end
      'b001000:begin//addi
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b100_1_1_0_0;
       { MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;

      end
      'b001010:begin//slti
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b101_1_1_0_0;
       { MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
     
      end
       'b000100:begin//beq
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b010_0_0_1_1;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
       
      end
       'b100011:begin//lw
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b100_1_1_0_0;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b1_1_0;
       
      end
       'b101011: begin//sw
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b100_1_0_0_0;//reg dst
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_1;
      end
      'b000101:begin//bne
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b010_0_0_1_1;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
      end
      'b000001:begin//bge
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b010_0_0_1_1;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
      end
      'b000111:begin//bgt
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b010_0_0_1_1;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
      end
    /*  'b000010:begin//jump
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b100_0_0_01_0;
       {Jump_o, MemToReg_o ,MemRead_o, MemWrite} <= 'b00_00_0_0;
      BranchType_o <= 'b01;
      end
       'b000011:begin//jal
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b100_0_1_10_0;
       {Jump_o, MemToReg_o ,MemRead_o, MemWrite} <= 'b00_11_0_1;//mem write?
       BranchType_o <= 'b01;
       end*/
       default:begin
       {ALU_op_o,ALUSrc_o,RegWrite_o,RegDst_o, Branch_o} <= 'b000_0_0_1_0;
       {MemToReg_o ,MemRead_o, MemWrite} <= 'b0_0_0;
       end
    endcase
end

endmodule





                    
                    