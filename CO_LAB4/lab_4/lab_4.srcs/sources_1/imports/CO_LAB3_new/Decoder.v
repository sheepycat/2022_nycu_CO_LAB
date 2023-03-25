//Subject:     CO project 2 - Decoder
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
	
	BranchType_o,
	Branch_o,
	Jump_o,
	MemToReg_o,
	MemRead_o,
	MemWrite
	);
     
//I/O ports
input  [6-1:0] instr_op_i,function_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;

//output [3-1:0] Branch_type_o;
output [2-1:0] Jump_o;
output [2-1:0] MemToReg_o, BranchType_o;
output         MemRead_o;
output         MemWrite;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;

//reg [3-1:0] Branch_type_o;
reg  [2-1:0]  Jump_o;
reg [2-1:0] MemToReg_o, BranchType_o;
reg         MemRead_o;
reg         MemWrite;

//Parameter


//Main function

always @* begin
	BranchType_o <=  instr_op_i[5:1] == 5'b00010
		? (instr_op_i[0] ? 2'b11 : 2'b00)
		: (instr_op_i[1] ? 2'b01 : 2'b10);

end

always@(*)begin
    case(instr_op_i)
        'b000000:begin//R -format
            ALU_op_o <= 'b000;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b01;
            Branch_o <= 'b0;
            
            //Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b0;
            MemRead_o <= 'b0;
            MemWrite <= 'b0;
        end
        'b001000:begin//addi
            ALU_op_o <= 'b100;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b00;
            Branch_o <= 'b0;
            
           // Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b0;
            MemRead_o <= 'b0;
            MemWrite <= 'b0;
        end
        'b001010:begin//slti
            ALU_op_o <= 'b101;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b00;
            Branch_o <= 'b0;
            
         //  Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b0;
            MemRead_o <= 'b0;
            MemWrite <= 'b0;
        end
        'b000100:begin//beq
            ALU_op_o <= 'b010;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b0;
            RegDst_o <= 'b00;
            Branch_o <= 'b1;
            
           // Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b0;
            MemRead_o <= 'b0;
            MemWrite <= 'b0;
        end
        'b100011:begin//lw
            ALU_op_o <= 'b100;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b00;
            Branch_o <= 'b0;
            
          //  Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b01;
            MemRead_o <= 'b1;
            MemWrite <= 'b0;
        end
        'b101011:begin//sw
            ALU_op_o <= 'b100;
            ALUSrc_o <= 'b1;
            RegWrite_o <= 'b0;
            RegDst_o <= 'b00;
            Branch_o <= 'b0;
            
        //    Branch_type_o <='b0;
            Jump_o <= 'b0;
            MemToReg_o <= 'b00;
            MemRead_o <= 'b0;
            MemWrite <= 'b1;
        end
        'b000010:begin//jump
            ALU_op_o <= 'b000;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b0;
            RegDst_o <= 'b00;
            Branch_o <= 'b0;
            
         //   Branch_type_o <='b0;
            Jump_o <= 'b1;
            MemToReg_o <= 'b00;
            MemRead_o <= 'b0;
            MemWrite <= 'b0;
        end
        'b000011:begin//jal
            ALU_op_o <= 'b000;
            ALUSrc_o <= 'b0;
            RegWrite_o <= 'b1;
            RegDst_o <= 'b10;
            Branch_o <= 'b0;
            
       //     Branch_type_o <='b0;
            Jump_o <= 'b1;
            MemToReg_o <= 'b10;
            MemRead_o <= 'b10;
            MemWrite <= 'b0;
        end
    endcase
end
endmodule





                    
                    