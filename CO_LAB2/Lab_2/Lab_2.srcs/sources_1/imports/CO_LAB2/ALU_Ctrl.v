//109550134
//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(*)begin
    case(ALUOp_i)
        'b000:begin//R -format 
            case(funct_i)
                'b100000:  ALUCtrl_o <= 'b0010;//add
                'b100010:  ALUCtrl_o <= 'b0110;//sub
                'b100100:  ALUCtrl_o <= 'b0000;//and
                'b100101:  ALUCtrl_o <= 'b0001;//or
                'b101010:  ALUCtrl_o <= 'b0111;//slt
            endcase
        end
        'b100:begin//addi
            ALUCtrl_o <= 'b0010;
        end
        'b101:begin//slti
            ALUCtrl_o <= 'b0111;
        end
        'b010:begin//beq
            ALUCtrl_o <= 'b0110;
        end
    endcase
end
endmodule     





                    
                    