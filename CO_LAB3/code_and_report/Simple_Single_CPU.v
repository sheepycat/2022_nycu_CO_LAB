//Subject:     CO project 2 - Simple Single CPU
//109550134
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i,
		mux_pc_input,
        pc_out_o,adder1_o,instr_o,
        mux_write_o,
        rs_data,rd_data,
        dm_readData,
        ALU_op_o,RegWrite_o,ALUSrc_o,RegDst_o, Branch_o,Jump_o,MemToReg_o, BranchType_o,MemRead_o, MemWrite,
        ALUCtrl_o,
        se_o,
         sl2,
         adder2_o,
         mux_alu_o,
          mux_pc_o,
          alu_result,zero,
          Branch_mux,s_jump,pc_jump,dm_result
		);
		
//I/O port
input         clk_i;
input         rst_i;
////////////////////////////////////////////////////

//Internal Signles
//pc choose
output wire [32-1:0] mux_pc_input;
//pc
output wire [32-1:0] pc_out_o;
//adder1
output wire [32-1:0] adder1_o;
//im
output wire [32-1:0] instr_o;
//mux write reg
output wire [5-1:0] mux_write_o;
//rf
output wire [32-1:0] rs_data;
output wire [32-1:0] rd_data;
//dm
output wire [32-1:0]dm_readData;
//decoder
output wire [3-1:0]ALU_op_o;
output wire RegWrite_o;   
output wire ALUSrc_o; 
output wire [2-1:0]RegDst_o;  
output wire Branch_o;
output wire  [2-1:0] Jump_o;
output wire [2-1:0] MemToReg_o, BranchType_o;
output wire         MemRead_o;
output wire         MemWrite;
//alu ctrl
output wire [4-1:0] ALUCtrl_o;
//se
output wire [32-1:0] se_o;
//shift left 2
output wire [32-1:0] sl2;
//arrer2
output wire [32-1:0] adder2_o;
//mux alu src
output wire [32-1:0] mux_alu_o;
//mux pc src
output wire [32-1:0] mux_pc_o;
//alu
output wire [32-1:0] alu_result;
output wire zero;
//new
output wire Branch_mux;
output wire [32-1:0]s_jump;
output wire [32-1:0]pc_jump;
output wire [32-1:0]dm_result;
//Greate componentes
//MUX_2to1  #(.size(32)) PC_choose(
   //     .data0_i(pc_jump),
     //   .data1_i(rs_data),
     //   .select_i((instr_o[5:0]==6'b001000)&(instr_o[31:26]==6'b000000)),
     //   .data_o(mux_pc_input)
//);
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),    
	    .pc_in_i(pc_jump) ,   
	    .pc_out_o(pc_out_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_out_o),     
	    .src2_i(32'd4),     
	    .sum_o(adder1_o)  
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o) 
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst_o),
        .data_o(mux_write_o)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(mux_write_o) ,  
        .RDdata_i(dm_result)  , 
        .RegWrite_i (RegWrite_o),
        .RSdata_o(rs_data) ,  
        .RTdata_o(rd_data) 
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
        .function_i(instr_o[5:0]),
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),  
	    .BranchType_o(BranchType_o), 
		.Branch_o(Branch_o),
		.Jump_o(Jump_o),
	    .MemToReg_o(MemToReg_o),
	    .MemRead_o(MemRead_o),
	    .MemWrite(MemWrite)    
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(se_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rd_data),
        .data1_i(se_o),
        .select_i(ALUSrc_o),
        .data_o(mux_alu_o)
        );	
		
ALU ALU(
        .src1_i(rs_data),
	    .src2_i(mux_alu_o),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(alu_result),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),  
	.addr_i(alu_result),
	.data_i(rd_data),
	.MemRead_i(MemRead_o),
	.MemWrite_i(MemWrite),
	.data_o(dm_readData)
	);
	
Adder Adder2(
        .src1_i(adder1_o),     
	    .src2_i(sl2),     
	    .sum_o(adder2_o)     
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se_o),
        .data_o(sl2)
        ); 		
/////////////////////////////////////////////////////////////////////////////		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(adder1_o),
        .data1_i(adder2_o),
        .select_i(Branch_mux& Branch_o),
        //.select_i(zero & Branch_o),
        .data_o(mux_pc_o)
        );	
//new added
MUX_4to1 #(.size(1)) Mux_Branch(
	.data0_i(zero),
	.data1_i(~(alu_result[31] | zero)),
	.data2_i(~alu_result[31]),
	.data3_i(~zero),
	.select_i(BranchType_o),
	.data_o(Branch_mux)
);
MUX_3to1 #(.size(32)) Mux_jump(
        .data0_i({adder1_o[31:28],instr_o[25:0],2'b00}),
        .data1_i(mux_pc_o),
        .data2_i(rs_data),
        .select_i(Jump_o),
        .data_o(pc_jump)
        );	
MUX_4to1 #(.size(32)) dm_read(
        .data0_i(alu_result),
        .data1_i(dm_readData),
        .data2_i(se_o),
        .data3_i(adder1_o),
        .select_i(MemToReg_o),
        .data_o(dm_result)
        );	
        


endmodule
		  


