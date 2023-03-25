// 0516244 TAY CHUN KEAT
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] mux_pc_input, pc_out_o, instr_o, pc_add_four;
wire [32-1:0] pc_add_four_id, instr_o_id;

/**** ID stage ****/
wire [32-1:0] rs_data, rd_data, se_o;
wire RegDst_o, MemToReg_o;
wire [3-1:0] ALU_op_o;
wire RegWrite_o, ALUSrc_o, Branch_o, MemRead_o, MemWrite;
//control signal
wire [32-1:0] rs_data_ex, rd_data_ex, se_o_ex, pc_add_four_ex;
wire [21-1:0] instr_ex;
wire RegDst_o_ex, MemToReg_o_ex;
wire [3-1:0] ALU_op_o_ex;
wire RegWrite_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex;

/**** EX stage ****/
wire [32-1:0] sl2, mux_alu, alu_result, sl2_add_pc4;
wire [5-1:0] mux_write_reg;
wire [4-1:0] ALUCtrl_o;
wire zero;
//control signal
wire [32-1:0] alu_result_mem, sl2_add_pc4_mem, rd_data_mem;
wire [5-1:0] mux_write_reg_mem;
wire MemToReg_o_mem;
wire RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem, zero_mem;

/**** MEM stage ****/
wire [32-1:0] dm_readData;
//control signal
wire [32-1:0] dm_readData_wb, alu_result_wb;
wire [5-1:0] mux_write_reg_wb;
wire MemToReg_o_wb;
wire RegWrite_o_wb;

/**** WB stage ****/
wire [32-1:0] write_data_reg;
//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(pc_add_four),
        .data1_i(sl2_add_pc4_mem),
        .select_i(Branch_o_mem & zero_mem),
        .data_o(mux_pc_input)
);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(mux_pc_input),   
	.pc_out_o(pc_out_o)
);

Instruction_Memory IM(
	.addr_i(pc_out_o),  
	.instr_o(instr_o)
);
			
Adder Add_pc(
	.src1_i(pc_out_o),     
	.src2_i(32'd4),
	.sum_o(pc_add_four)
);
		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({pc_add_four, instr_o}),
    	.data_o({pc_add_four_id, instr_o_id})
);


//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr_o_id[25:21]),  
        .RTaddr_i(instr_o_id[20:16]),  
        .RDaddr_i(mux_write_reg_wb),  
        .RDdata_i(write_data_reg), 
        .RegWrite_i(RegWrite_o_wb),
        .RSdata_o(rs_data),  
        .RTdata_o(rd_data)
);

Decoder Control(
	.instr_op_i(instr_o_id[31:26]), 
	.RegWrite_o(RegWrite_o), 
	.ALU_op_o(ALU_op_o),   
	.ALUSrc_o(ALUSrc_o),   
	.RegDst_o(RegDst_o),
	.Branch_o(Branch_o),
	.MemRead_o(MemRead_o), 
	.MemWrite(MemWrite), 
	.MemToReg_o(MemToReg_o)
);

Sign_Extend Sign_Extend(
	.data_i(instr_o_id[15:0]),
        .data_o(se_o)
);	

Pipe_Reg #(.size(159)) ID_EX(
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({rs_data, rd_data, instr_o_id[20:0], pc_add_four_id, RegWrite_o, 
		RegDst_o, ALUSrc_o, Branch_o, MemRead_o, MemWrite, MemToReg_o, ALU_op_o, se_o}),
    	.data_o({rs_data_ex, rd_data_ex, instr_ex, pc_add_four_ex, RegWrite_o_ex, 
		RegDst_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex, MemToReg_o_ex, ALU_op_o_ex, se_o_ex})
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
	.data_i(se_o_ex),
    	.data_o(sl2)
);

ALU ALU(
	.src1_i(rs_data_ex),
	    .src2_i(mux_alu),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(alu_result),
		.zero_o(zero)
);
		
ALU_Control ALU_Control(
	.funct_i(instr_ex[5:0]),   
        .ALUOp_i(ALU_op_o_ex),   
        .ALUCtrl_o(ALUCtrl_o)
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(rd_data_ex),
        .data1_i(se_o_ex),
        .select_i(ALUSrc_o_ex),
        .data_o(mux_alu)
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(instr_ex[20:16]),
        .data1_i(instr_ex[15:11]),
        .select_i(RegDst_o_ex),
        .data_o(mux_write_reg)
);

Adder Add_pc_branch(
	.src1_i(pc_add_four_ex),     
	.src2_i(sl2),
	.sum_o(sl2_add_pc4)    
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({alu_result, sl2_add_pc4, mux_write_reg, rd_data_ex, 
		 RegWrite_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex, MemToReg_o_ex, zero}),
    	.data_o({alu_result_mem, sl2_add_pc4_mem, mux_write_reg_mem, rd_data_mem, 
		 RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem, MemToReg_o_mem, zero_mem})
);


//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(alu_result_mem), 
	.data_i(rd_data_mem), 
	.MemRead_i(MemRead_o_mem), 
	.MemWrite_i(MemWrite_mem), 
	.data_o(dm_readData)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
    	.rst_i(rst_i),
	.data_i({dm_readData, alu_result_mem, mux_write_reg_mem, MemToReg_o_mem, RegWrite_o_mem}),
    	.data_o({dm_readData_wb, alu_result_wb, mux_write_reg_wb, MemToReg_o_wb, RegWrite_o_wb})
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(alu_result_wb),
        .data1_i(dm_readData_wb),
        .select_i(MemToReg_o_wb),
        .data_o(write_data_reg)
);

/****************************************
signal assignment
****************************************/

endmodule

